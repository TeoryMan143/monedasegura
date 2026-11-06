import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/realtime/realtime_service.dart';
import '../../data/notifications_repository.dart';
import '../../domain/app_notification.dart';

/// Notifications of the bell (HU-16): the analyst's list, plus the alert announced by
/// the realtime service during the session. Lives while the shell is on screen.
final notificationsProvider =
    AsyncNotifierProvider.autoDispose<
      NotificationsController,
      List<AppNotification>
    >(NotificationsController.new, name: 'notificationsProvider');

class NotificationsController extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() async {
    final service = ref.watch(realtimeServiceProvider);
    final subscription = service.newAlerts.listen((_) => _announceNewAlert());
    service.start();
    ref.onDispose(() {
      subscription.cancel();
      service.stop();
    });
    return ref.watch(notificationsRepositoryProvider).fetchRecent();
  }

  /// Marks one notification as read. In memory only: the prototype does not write.
  void markAsRead(String id) {
    state = AsyncData([
      for (final item in _items) item.id == id ? item.markRead() : item,
    ]);
  }

  void markAllAsRead() {
    state = AsyncData([for (final item in _items) item.markRead()]);
  }

  List<AppNotification> get _items =>
      state.hasValue ? state.requireValue : const [];

  Future<void> _announceNewAlert() async {
    try {
      final notification = await ref
          .read(notificationsRepositoryProvider)
          .fetchPendingAlertAsNew();
      if (!ref.mounted || notification == null) return;
      state = AsyncData([
        notification,
        for (final item in _items)
          if (item.id != notification.id) item,
      ]);
    } on Failure {
      // The announcement is optional: the bell keeps its current list.
    }
  }
}
