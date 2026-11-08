import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/catalogs/catalog_providers.dart';
import '../../../core/config/env.dart';
import '../../../core/domain/catalog_models.dart';
import '../../../core/errors/failure_mapper.dart';
import '../../../core/local_writes/local_writes_models.dart' as local;
import '../../../core/local_writes/local_writes_provider.dart';
import '../../../core/local_writes/local_writes_store.dart';
import '../../../core/supabase/supabase_client_provider.dart';
import '../domain/audit_entry.dart';
import 'fake_audit_repository.dart';

/// Reads the history of a transaction for N-03 (HU-15): the `audit_log` of its label and
/// of its alerts, plus the changes of this session that the database does not have.
class AuditRepository {
  AuditRepository(this._client, this._localWrites, {required this.fraudTypes});

  final SupabaseClient _client;
  final LocalWritesStore _localWrites;

  /// The `fraud_types` catalog, to turn the `final_type_id` of an alert into its code.
  final Future<List<CatalogFraudType>> Function() fraudTypes;

  static const _columns =
      'action, analyst_id, old_value, new_value, created_at, '
      'analyst:analysts(full_name)';

  /// Every change of [transactionId], newest first.
  Future<List<AuditEntry>> fetchLabelHistory(int transactionId) async {
    try {
      final links = await _client
          .from('ai_alert_transactions')
          .select('alert_id, ai_alerts(code)')
          .eq('transaction_id', transactionId);
      final alertCodes = {
        for (final link in links)
          link['alert_id'] as String:
              (link['ai_alerts'] as Map<String, dynamic>)['code'] as String,
      };
      final results = await Future.wait<List<Map<String, dynamic>>>([
        _client
            .from('audit_log')
            .select(_columns)
            .eq('transaction_id', transactionId),
        if (alertCodes.isNotEmpty)
          _client
              .from('audit_log')
              .select(_columns)
              .eq('entity', 'ai_alerts')
              .inFilter('entity_id', alertCodes.keys.toList()),
      ]);
      final catalog = results.length > 1
          ? await fraudTypes()
          : const <CatalogFraudType>[];
      final codes = {for (final type in catalog) type.id: type.code};
      return mergeAuditHistory([
        for (final rows in results)
          for (final row in rows)
            AuditEntry.fromJson(withFinalTypeCode(row, codes)),
      ], sessionHistory(_localWrites, transactionId, alertCodes));
    } catch (error) {
      throw mapToFailure(error);
    }
  }
}

/// An alert row keeps its `final_type_id`; [auditChanges] reads the type by its code.
Map<String, dynamic> withFinalTypeCode(
  Map<String, dynamic> row,
  Map<int, String> codes,
) {
  Map<String, dynamic>? convert(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    if (!value.containsKey('final_type_id')) return value;
    return {...value, 'final_type': codes[value['final_type_id']]};
  }

  return {
    ...row,
    'old_value': convert(row['old_value']),
    'new_value': convert(row['new_value']),
  };
}

/// The changes of this session to the label of [transactionId] and to its alerts,
/// [alertCodes] by alert id.
List<AuditEntry> sessionHistory(
  LocalWritesStore localWrites,
  int transactionId,
  Map<String, String> alertCodes,
) => [
  for (final entry in localWrites.auditFor(transactionId))
    fromSessionEntry(entry),
  for (final MapEntry(key: alertId, value: code) in alertCodes.entries)
    for (final entry in localWrites.auditForAlert(alertId))
      if (entry.transactionId == null) fromSessionEntry(entry, alertCode: code),
];

/// A change of the [LocalWritesStore] in the shape of the database ones.
AuditEntry fromSessionEntry(local.AuditEntry entry, {String? alertCode}) {
  Map<String, dynamic>? values(Map<String, Object?>? value) =>
      value == null ? null : {...value, 'code': ?alertCode};
  return AuditEntry(
    action: entry.action,
    analystId: entry.analystId,
    analystName: entry.analystName,
    createdAt: entry.createdAt,
    oldValue: values(entry.oldValue),
    newValue: values(entry.newValue),
    fromSession: true,
  );
}

/// The audit repository of the app. With `--dart-define=USE_FAKE_DATA=true` (no
/// backend) it is [FakeAuditRepository].
final auditRepositoryProvider = Provider<AuditRepository>((ref) {
  final localWrites = ref.watch(localWritesStoreProvider);
  return Env.useFakeData
      ? FakeAuditRepository(localWrites)
      : AuditRepository(
          ref.watch(supabaseClientProvider),
          localWrites,
          fraudTypes: () => ref.read(fraudTypesProvider.future),
        );
}, name: 'auditRepositoryProvider');
