import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/failure_mapper.dart';
import '../../../core/supabase/supabase_client_provider.dart';
import '../domain/app_notification.dart';

/// The analyst's notifications (HU-16). RLS limits every query to the signed-in
/// analyst, and the only column the app may write is `read_at`.
class NotificationsRepository {
  NotificationsRepository(this._client);

  final SupabaseClient _client;

  /// Latest notifications of the signed-in analyst, newest first.
  Future<List<AppNotification>> fetchRecent({int limit = 20}) async {
    try {
      final rows = await _client
          .from('notifications')
          .select(
            'id, alert_id, title, body, created_at, read_at, '
            'ai_alerts(code, score)',
          )
          .order('created_at', ascending: false)
          .limit(limit);
      return [
        for (final row in rows)
          AppNotification(
            id: row['id'] as String,
            alertId: row['alert_id'] as String,
            title: row['title'] as String,
            body: row['body'] as String?,
            alertCode: _map(row['ai_alerts'])['code'] as String?,
            score: (_map(row['ai_alerts'])['score'] as num?)?.toInt(),
            createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
            read: row['read_at'] != null,
          ),
      ];
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Unread notifications of the signed-in analyst (the bell counter).
  Future<int> countUnread() async {
    try {
      return await _client
          .from('notifications')
          .count()
          .isFilter('read_at', null);
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Sets `read_at` on one notification, if it is still unread.
  Future<void> markAsRead(String id) async {
    try {
      await _client
          .from('notifications')
          .update({'read_at': _now()})
          .eq('id', id)
          .isFilter('read_at', null);
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Sets `read_at` on every unread notification of the analyst.
  Future<void> markAllAsRead() async {
    try {
      await _client
          .from('notifications')
          .update({'read_at': _now()})
          .isFilter('read_at', null);
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  static String _now() => DateTime.now().toUtc().toIso8601String();

  static Map<String, dynamic> _map(Object? value) =>
      value is Map<String, dynamic> ? value : const {};
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.watch(supabaseClientProvider)),
  name: 'notificationsRepositoryProvider',
);
