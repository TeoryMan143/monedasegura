import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monedasegura/core/realtime/realtime_service.dart';
import 'package:monedasegura/features/notifications/data/notifications_repository.dart';
import 'package:monedasegura/features/notifications/domain/app_notification.dart';

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

/// Overrides that let the shell (bell + realtime) build in tests without a backend.
List<Override> shellOverrides({
  FakeNotificationsRepository? notifications,
  Duration newAlertDelay = const Duration(hours: 1),
}) => [
  notificationsRepositoryProvider.overrideWithValue(
    notifications ?? FakeNotificationsRepository(),
  ),
  realtimeServiceProvider.overrideWith((ref) {
    final service = FakeRealtimeService(newAlertDelay: newAlertDelay);
    ref.onDispose(service.dispose);
    return service;
  }),
];
