import 'app_notification.dart';

/// What the bell shows (HU-16): the latest notifications, the unread count of the
/// whole table and the notifications that just arrived through Realtime.
class NotificationsFeed {
  const NotificationsFeed({
    required this.items,
    required this.unread,
    this.arrived = const [],
  });

  /// Latest notifications of the analyst, newest first (the panel).
  final List<AppNotification> items;

  /// Unread notifications of the analyst in `notifications`, not only in [items].
  final int unread;

  /// Inserted since the previous feed: each one gets a «Nueva alerta» toast.
  final List<AppNotification> arrived;

  NotificationsFeed markRead(String id) {
    final wasUnread = items.any((item) => item.id == id && !item.read);
    return NotificationsFeed(
      items: [for (final item in items) item.id == id ? item.markRead() : item],
      unread: wasUnread && unread > 0 ? unread - 1 : unread,
    );
  }

  NotificationsFeed markAllRead() => NotificationsFeed(
    items: [for (final item in items) item.markRead()],
    unread: 0,
  );
}
