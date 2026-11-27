import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/core/realtime/fake_realtime_service.dart';
import 'package:monedasegura/core/realtime/realtime_service.dart';
import 'package:monedasegura/features/notifications/data/notifications_repository.dart';
import 'package:monedasegura/features/notifications/domain/app_notification.dart';
import 'package:monedasegura/features/transactions/data/fake_transactions_repository.dart';
import 'package:monedasegura/features/transactions/data/transactions_repository.dart';

/// In-memory `notifications` table for widget tests (no Supabase).
class FakeNotificationsRepository implements NotificationsRepository {
  FakeNotificationsRepository({List<AppNotification> items = const []})
    : items = [...items];

  /// Newest first, like the table query.
  final List<AppNotification> items;

  /// Ids written with `read_at`, in order.
  final markedRead = <String>[];

  /// Adds a row, as the alert trigger would.
  void insert(AppNotification notification) => items.insert(0, notification);

  @override
  Future<List<AppNotification>> fetchRecent({int limit = 20}) async =>
      items.take(limit).toList();

  @override
  Future<int> countUnread() async => items.where((n) => !n.read).length;

  @override
  Future<void> markAsRead(String id) async {
    final index = items.indexWhere((n) => n.id == id && !n.read);
    if (index < 0) return;
    items[index] = items[index].markRead();
    markedRead.add(id);
  }

  @override
  Future<void> markAllAsRead() async {
    for (final (index, item) in items.indexed) {
      if (item.read) continue;
      items[index] = item.markRead();
      markedRead.add(item.id);
    }
  }
}

/// Overrides that let the shell (bell + realtime) and its first screen, the transaction
/// list (A-01), build in tests without a backend. Pass [realtime] to push changes.
List<Override> shellOverrides({
  FakeNotificationsRepository? notifications,
  FakeRealtimeService? realtime,
}) => [
  notificationsRepositoryProvider.overrideWithValue(
    notifications ?? FakeNotificationsRepository(),
  ),
  // An empty list: these tests check the shell, and table rows drawn with the wide test
  // font would not fit (the transactions tests load the real font).
  transactionsRepositoryProvider.overrideWithValue(
    FakeTransactionsRepository(LocalWritesStore(), rows: const []),
  ),
  catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
  realtimeServiceProvider.overrideWith((ref) {
    final service = realtime ?? FakeRealtimeService();
    ref.onDispose(service.dispose);
    return service;
  }),
];
