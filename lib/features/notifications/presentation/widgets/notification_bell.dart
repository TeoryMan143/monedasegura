import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/app_notification.dart';
import '../controllers/notifications_controller.dart';

/// C-04 / C-06 · bell of the top bar with the unread counter and the notifications panel
/// (HU-16).
///
/// When the realtime service announces a new alert, a toast with its score and «Abrir»
/// appears. Opening a notification marks it as read and calls [onOpenAlert]; the shell
/// passes the navigation, so this feature does not depend on the router.
class NotificationBell extends ConsumerStatefulWidget {
  const NotificationBell({required this.onOpenAlert, super.key});

  /// Opens the A-05 alert detail.
  final ValueChanged<String> onOpenAlert;

  @override
  ConsumerState<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends ConsumerState<NotificationBell> {
  final _menu = MenuController();

  void _open(AppNotification notification) {
    ref.read(notificationsProvider.notifier).markAsRead(notification.id);
    _menu.close();
    widget.onOpenAlert(notification.alertId);
  }

  void _toastNewAlerts(
    AsyncValue<List<AppNotification>>? previous,
    AsyncValue<List<AppNotification>> next,
  ) {
    final before = previous != null && previous.hasValue
        ? previous.requireValue
        : const <AppNotification>[];
    if (!next.hasValue) return;
    for (final notification in next.requireValue) {
      if (!notification.live || before.any((n) => n.id == notification.id)) {
        continue;
      }
      showAppToast(
        context,
        type: AppToastType.aiAlert,
        score: notification.score,
        title: notification.alertCode == null
            ? notification.title
            : 'Nueva alerta ${notification.alertCode}',
        message: notification.body,
        actionLabel: 'Abrir',
        onAction: () => _open(notification),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(notificationsProvider, _toastNewAlerts);
    final notifications = ref.watch(notificationsProvider);
    final items = notifications.hasValue
        ? notifications.requireValue
        : const <AppNotification>[];
    final unread = items.where((item) => !item.read).length;

    return MenuAnchor(
      controller: _menu,
      alignmentOffset: const Offset(0, AppSpace.xs),
      style: AppMenu.menuStyle(minWidth: AppSizes.toastWidth),
      menuChildren: [
        _Panel(
          notifications: notifications,
          unread: unread,
          onOpen: _open,
          onMarkAllRead: () =>
              ref.read(notificationsProvider.notifier).markAllAsRead(),
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
      ],
      builder: (context, controller, child) => Stack(
        clipBehavior: Clip.none,
        children: [
          AppIconButton(
            icon: AppIcons.bell,
            tooltip: unread == 0
                ? 'Notificaciones'
                : 'Notificaciones, $unread sin leer',
            onPressed: () =>
                controller.isOpen ? controller.close() : controller.open(),
          ),
          if (unread > 0)
            Positioned(
              right: AppSpace.xxs,
              top: AppSpace.xxs,
              child: IgnorePointer(child: _Counter(count: unread)),
            ),
        ],
      ),
    );
  }
}

/// Danger counter on the bell.
class _Counter extends StatelessWidget {
  const _Counter({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    const tone = StatusTone.danger;
    return Container(
      constraints: const BoxConstraints(minWidth: AppSizes.badgeS),
      height: AppSizes.badgeS,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs),
      decoration: BoxDecoration(
        color: tone.solid,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.bgSurface, width: AppSpace.xxs),
      ),
      child: Align(
        widthFactor: 1,
        child: Text(
          count > 99 ? '99+' : '$count',
          style: AppText.label.copyWith(color: tone.onSolid),
        ),
      ),
    );
  }
}

/// C-06 · notifications panel.
class _Panel extends StatelessWidget {
  const _Panel({
    required this.notifications,
    required this.unread,
    required this.onOpen,
    required this.onMarkAllRead,
    required this.onRetry,
  });

  final AsyncValue<List<AppNotification>> notifications;
  final int unread;
  final ValueChanged<AppNotification> onOpen;
  final VoidCallback onMarkAllRead;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.toastWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.md,
              AppSpace.sm,
              AppSpace.xs,
              AppSpace.sm,
            ),
            child: Row(
              children: [
                Expanded(child: Text('Notificaciones', style: AppText.h3)),
                AppButton(
                  label: 'Marcar todas como leídas',
                  size: AppButtonSize.s,
                  variant: AppButtonVariant.tertiary,
                  onPressed: unread == 0 ? null : onMarkAllRead,
                ),
              ],
            ),
          ),
          const Divider(),
          ScreenState<List<AppNotification>>(
            value: notifications,
            onRetry: onRetry,
            loading: const Padding(
              padding: EdgeInsets.all(AppSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: AppSizes.progressBar),
                  SizedBox(height: AppSpace.sm),
                  SkeletonBox(width: AppSizes.menuMinWidth),
                ],
              ),
            ),
            isEmpty: (items) => items.isEmpty,
            empty: const Padding(
              padding: EdgeInsets.all(AppSpace.lg),
              child: EmptyState(
                icon: AppIcons.bell,
                title: 'Sin notificaciones',
                message: 'Te avisaremos aquí cuando la IA genere alertas nuevas.',
              ),
            ),
            builder: (context, items) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in items)
                  NotificationItem(
                    title: item.title,
                    subtitle: item.body,
                    timeLabel: _relativeTime(item.createdAt),
                    unread: !item.read,
                    onTap: () => onOpen(item),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// «ahora», «hace 5 min», «hace 3 h», «hace 2 d», then the date.
///
/// Swap for the relative time of `core/formatting` once it is merged.
String _relativeTime(DateTime date) {
  final elapsed = DateTime.now().difference(date);
  if (elapsed.inMinutes < 1) return 'ahora';
  if (elapsed.inHours < 1) return 'hace ${elapsed.inMinutes} min';
  if (elapsed.inDays < 1) return 'hace ${elapsed.inHours} h';
  if (elapsed.inDays < 7) return 'hace ${elapsed.inDays} d';
  return DateFormat('d MMM yyyy', 'es').format(date);
}
