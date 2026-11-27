import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/realtime/realtime_service.dart';
import '../../data/notifications_repository.dart';
import '../../domain/notifications_feed.dart';

/// The bell (HU-16): the analyst's notifications and unread count from `notifications`,
/// reloaded when Realtime announces new ones. Lives while the shell is on screen.
final notificationsProvider =
    AsyncNotifierProvider.autoDispose<
      NotificationsController,
      NotificationsFeed
    >(NotificationsController.new, name: 'notificationsProvider');

class NotificationsController extends AsyncNotifier<NotificationsFeed> {
  @override
  Future<NotificationsFeed> build() async {
    final subscription = ref
        .watch(realtimeServiceProvider)
        .notificationsInserted
        .listen(_onInserted);
    ref.onDispose(subscription.cancel);
    return _load(ref.watch(notificationsRepositoryProvider));
  }

  /// Marks one notification as read in the database. The panel updates at once; if the
  /// write fails, the feed reloads from the database.
  Future<void> markAsRead(String id) async {
    final feed = _feed;
    if (feed == null || !feed.items.any((item) => item.id == id && !item.read)) {
      return;
    }
    state = AsyncData(feed.markRead(id));
    await _write((repository) => repository.markAsRead(id));
  }

  Future<void> markAllAsRead() async {
    final feed = _feed;
    if (feed == null || feed.unread == 0) return;
    state = AsyncData(feed.markAllRead());
    await _write((repository) => repository.markAllAsRead());
  }

  NotificationsFeed? get _feed => state.hasValue ? state.requireValue : null;

  Future<NotificationsFeed> _load(
    NotificationsRepository repository, {
    Set<String> arrived = const {},
  }) async {
    final items = await repository.fetchRecent();
    final unread = await repository.countUnread();
    return NotificationsFeed(
      items: items,
      unread: unread,
      arrived: [
        for (final item in items)
          if (arrived.contains(item.id)) item,
      ],
    );
  }

  Future<void> _onInserted(Set<String> ids) async {
    try {
      final feed = await _load(
        ref.read(notificationsRepositoryProvider),
        arrived: ids,
      );
      if (ref.mounted) state = AsyncData(feed);
    } on Failure {
      // The bell keeps its list; the next notification or a retry reloads it.
    }
  }

  Future<void> _write(
    Future<void> Function(NotificationsRepository repository) write,
  ) async {
    try {
      await write(ref.read(notificationsRepositoryProvider));
    } on Failure {
      if (ref.mounted) ref.invalidateSelf();
    }
  }
}
