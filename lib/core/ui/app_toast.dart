import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_button.dart';
import 'app_icon.dart';
import 'app_icon_button.dart';
import 'score_badge.dart';

/// Kind of [showAppToast] message, with its tone and icon.
enum AppToastType {
  success(StatusTone.success, AppIcons.check),
  error(StatusTone.danger, AppIcons.error),
  info(StatusTone.brand, AppIcons.info),
  warning(StatusTone.warning, AppIcons.warning),

  /// New AI alert: shows the score badge and usually an «Abrir» action.
  aiAlert(StatusTone.info, AppIcons.ai);

  const AppToastType(this.tone, this.icon);

  final StatusTone tone;
  final AppIcons icon;
}

/// Toast (DESIGN.md · AppToast): bottom right, 380 px, `menu` shadow, closes by itself
/// after 5 s (or with ×), optional action such as «Abrir».
///
/// Toasts stack from the bottom. Use them for the result of an action (saved, resolved,
/// failed) and for the realtime «nueva alerta» notice; persistent notices go in an
/// `InlineBanner` instead.
///
/// ```dart
/// showAppToast(context, title: 'Alerta resuelta', type: AppToastType.success);
/// showAppToast(context, title: 'Nueva alerta AL-1042', message: 'Juan Pérez',
///     type: AppToastType.aiAlert, score: 92, actionLabel: 'Abrir', onAction: open);
/// ```
void showAppToast(
  BuildContext context, {
  required String title,
  String? message,
  AppToastType type = AppToastType.info,
  String? actionLabel,
  VoidCallback? onAction,
  int? score,
  Duration duration = const Duration(seconds: 5),
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  final host = _ToastHost.of(overlay);
  host.add(
    _ToastData(
      id: Object(),
      title: title,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      score: score,
      duration: duration,
    ),
  );
}

class _ToastData {
  const _ToastData({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.actionLabel,
    required this.onAction,
    required this.score,
    required this.duration,
  });

  final Object id;
  final String title;
  final String? message;
  final AppToastType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final int? score;
  final Duration duration;
}

/// One overlay entry per [OverlayState] that lays out every visible toast.
class _ToastHost {
  _ToastHost._(this._overlay);

  static final _hosts = Expando<_ToastHost>('toastHosts');

  static _ToastHost of(OverlayState overlay) =>
      _hosts[overlay] ??= _ToastHost._(overlay);

  final OverlayState _overlay;
  final _toasts = ValueNotifier<List<_ToastData>>(const []);
  OverlayEntry? _entry;

  // Keep at most three on screen; older ones leave first.
  static const _maxVisible = 3;

  void add(_ToastData toast) {
    final next = [..._toasts.value, toast];
    _toasts.value = next.length > _maxVisible
        ? next.sublist(next.length - _maxVisible)
        : next;
    if (_entry == null) {
      _entry = OverlayEntry(builder: _build);
      _overlay.insert(_entry!);
    }
  }

  void remove(Object id) {
    _toasts.value = [
      for (final toast in _toasts.value)
        if (toast.id != id) toast,
    ];
    if (_toasts.value.isEmpty) {
      _entry?.remove();
      _entry = null;
    }
  }

  Widget _build(BuildContext context) {
    return Positioned(
      right: AppSpace.xxl,
      bottom: AppSpace.xxl,
      child: ValueListenableBuilder<List<_ToastData>>(
        valueListenable: _toasts,
        builder: (context, toasts, _) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final toast in toasts)
              Padding(
                padding: const EdgeInsets.only(top: AppSpace.sm),
                child: _ToastCard(
                  key: ObjectKey(toast.id),
                  data: toast,
                  onClose: () => remove(toast.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ToastCard extends StatefulWidget {
  const _ToastCard({required this.data, required this.onClose, super.key});

  final _ToastData data;
  final VoidCallback onClose;

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.data.duration, widget.onClose);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final tone = data.type.tone;
    final score = data.score;
    final onAction = data.onAction;

    return Semantics(
      liveRegion: true,
      container: true,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: AppSizes.toastWidth,
          padding: const EdgeInsets.fromLTRB(
            AppSpace.lg,
            AppSpace.md,
            AppSpace.sm,
            AppSpace.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.borderSubtle),
            boxShadow: AppShadows.menu,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.type == AppToastType.aiAlert && score != null)
                ScoreBadge(score: score)
              else
                Container(
                  width: AppSizes.kpiIconTile,
                  height: AppSizes.kpiIconTile,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tone.background,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: AppIcon(
                    data.type.icon,
                    size: AppIconSize.sm,
                    color: tone.text,
                  ),
                ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title, style: AppText.bodyMSemiBold),
                    if (data.message != null)
                      Text(
                        data.message!,
                        style: AppText.bodyS.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (data.actionLabel != null && onAction != null) ...[
                const SizedBox(width: AppSpace.sm),
                AppButton(
                  label: data.actionLabel!,
                  size: AppButtonSize.s,
                  variant: AppButtonVariant.tertiary,
                  onPressed: () {
                    widget.onClose();
                    onAction();
                  },
                ),
              ],
              const SizedBox(width: AppSpace.xs),
              AppIconButton(
                icon: AppIcons.close,
                tooltip: 'Cerrar aviso',
                small: true,
                onPressed: widget.onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
