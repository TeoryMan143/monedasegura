import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/failure_mapper.dart';
import '../../../core/supabase/supabase_client_provider.dart';
import '../domain/app_notification.dart';

/// Reads the analyst's notifications and the alert announced by the simulated realtime
/// service (HU-16). Read only: in the prototype «mark as read» lives in memory.
class NotificationsRepository {
  NotificationsRepository(this._client);

  final SupabaseClient _client;

  /// Latest notifications of the signed-in analyst (RLS filters by `analyst_id`).
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

  /// The newest pending alert, shaped as a fresh «Nueva alerta» notification. The
  /// simulated realtime service announces it about 30 s after the analyst enters.
  Future<AppNotification?> fetchPendingAlertAsNew() async {
    try {
      final rows = await _client
          .from('ai_alerts')
          .select(
            'id, code, score, customers(first_names, last_names), '
            'fraud_types!suggested_type_id(name)',
          )
          .eq('status', 'pending')
          .order('generated_at', ascending: false)
          .limit(1);
      if (rows.isEmpty) return null;
      final row = rows.first;
      final score = (row['score'] as num).toInt();
      final customer = _map(row['customers']);
      final body = [
        row['code'],
        [
          customer['first_names'],
          customer['last_names'],
        ].whereType<String>().join(' '),
        _map(row['fraud_types'])['name'],
      ].whereType<String>().where((part) => part.isNotEmpty).join(' · ');
      return AppNotification(
        id: 'live-${row['id']}',
        alertId: row['id'] as String,
        alertCode: row['code'] as String,
        title: 'Nueva alerta · score $score',
        body: body,
        score: score,
        createdAt: DateTime.now(),
        read: false,
        live: true,
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  static Map<String, dynamic> _map(Object? value) =>
      value is Map<String, dynamic> ? value : const {};
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.watch(supabaseClientProvider)),
  name: 'notificationsRepositoryProvider',
);
