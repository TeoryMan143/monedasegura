import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/core/realtime/realtime_service.dart';
import 'package:monedasegura/features/notifications/data/notifications_repository.dart';
import 'package:monedasegura/features/notifications/domain/app_notification.dart';
import 'package:monedasegura/features/transactions/data/fake_transactions_repository.dart';
import 'package:monedasegura/features/transactions/data/transactions_repository.dart';

/// In-memory notifications for widget tests (no Supabase).
class FakeNotificationsRepository implements NotificationsRepository {
  FakeNotificationsRepository({this.items = const [], this.pending});

  final List<AppNotification> items;

  /// What the realtime announcement returns.
  final AppNotification? pending;

  @override
  Future<List<AppNotification>> fetchRecent({int limit = 20}) async => items;

  @override
  Future<AppNotification?> fetchPendingAlertAsNew() async => pending;
}

/// Overrides that let the shell (bell + realtime) and its first screen, the transaction
/// list (A-01), build in tests without a backend.
List<Override> shellOverrides({
  FakeNotificationsRepository? notifications,
  Duration newAlertDelay = const Duration(hours: 1),
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
    final service = FakeRealtimeService(newAlertDelay: newAlertDelay);
    ref.onDispose(service.dispose);
    return service;
  }),
];
