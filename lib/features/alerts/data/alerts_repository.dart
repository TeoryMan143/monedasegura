import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/domain/alert_status.dart';
import '../../../core/domain/catalog_models.dart';
import '../../../core/domain/confidence_level.dart';
import '../../../core/domain/fraud_type.dart';
import '../../../core/domain/page_result.dart';
import '../../../core/domain/verdict.dart';
import '../../../core/errors/failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../../../core/local_writes/local_writes_models.dart';
import '../../../core/local_writes/local_writes_store.dart';
import '../domain/ai_alert.dart';
import '../domain/alert_detail.dart';
import '../domain/alerts_query.dart';
import '../domain/resolve_alert_input.dart';

/// Reads the alerts of the inbox and the detail from `ai_alerts` (HU-06, HU-07).
///
/// There is no alerts view, so the related rows come embedded by PostgREST. Filters, order
/// and pagination run in the database. Resolving an alert is not written there yet: the
/// [LocalWritesStore] keeps it, and every read merges that over what the database says.
class AlertsRepository {
  AlertsRepository(this._client, this._localWrites);

  final SupabaseClient _client;
  final LocalWritesStore _localWrites;

  static const _table = 'ai_alerts';

  // Without `suggested_type` and the embedded tables of the detail: see [_detailColumns].
  static const _listColumns =
      'id, code, customer_id, score, summary, status, generated_at, resolved_by, '
      'resolved_at, customers(first_names, last_names), '
      'final_type:fraud_types!final_type_id(code), '
      'resolver:analysts!resolved_by(full_name)';

  static const _detailColumns =
      '$_listColumns, account_id, model_version, '
      'suggested_type:fraud_types!suggested_type_id(code), '
      'ai_alert_reasons(id, position, weight, title, evidence, metric), '
      'ai_alert_transactions(is_primary, '
      'transactions(id, code, amount, currency_code))';

  /// One page of the inbox, highest score first.
  Future<PageResult<AiAlert>> list(AlertsQuery query) async {
    try {
      // Filtering by the suggested type needs the embedded row to be required (`!inner`).
      final suggested = query.suggestedType == null
          ? 'suggested_type:fraud_types!suggested_type_id(code)'
          : 'suggested_type:fraud_types!suggested_type_id!inner(code)';
      var request = _client.from(_table).select('$_listColumns, $suggested');

      request = _filterByStatus(request, query.status);
      final minScore = query.minScore;
      if (minScore != null) request = request.gte('score', minScore);
      final type = query.suggestedType;
      if (type != null) request = request.eq('suggested_type.code', type.code);

      final response = await request
          .order('score', ascending: false)
          // Rows with the same score keep their order from one page to the next.
          .order('generated_at', ascending: false)
          .order('id', ascending: false)
          .range(query.from, query.to)
          .count(CountOption.exact);
      return PageResult(
        items: [
          for (final row in response.data) _withSession(AiAlert.fromJson(row)),
        ],
        total: response.count,
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// The alert with its reasons and the transactions involved.
  ///
  /// Throws [Failure.notFound] when there is no alert with that [id].
  Future<AlertDetail> getById(String id) async {
    try {
      final row = await _client
          .from(_table)
          .select(_detailColumns)
          .eq('id', id)
          .maybeSingle();
      if (row == null) throw const Failure.notFound();
      final detail = AlertDetail.fromRow(row);
      return detail.copyWith(alert: _withSession(detail.alert));
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Resolves an alert (HU-08). Prototype: nothing is written to the database, the
  /// [LocalWritesStore] keeps it until the `resolve_alert` RPC is connected.
  ///
  /// It fails like the RPC would:
  /// - [Failure.conflict] `alert_already_resolved`, if the database or this session
  ///   already resolved it. The first analyst wins.
  /// - [Failure.notFound], if there is no such alert.
  /// - [Failure.validation] with the key of the rule the input breaks.
  ///
  /// [fraudTypes] (the `fraud_types` catalog) turns `finalTypeId` into a type.
  Future<void> resolve(
    ResolveAlertInput input, {
    required List<CatalogFraudType> fraudTypes,
    required String analystId,
    required String analystName,
  }) async {
    try {
      if (_localWrites.alertStatusFor(input.alertId) != null) {
        throw const Failure.conflict(key: 'alert_already_resolved');
      }
      final row = await _client
          .from(_table)
          .select(
            'status, suggested_type:fraud_types!suggested_type_id(code), '
            'ai_alert_transactions(transaction_id)',
          )
          .eq('id', input.alertId)
          .maybeSingle();
      if (row == null) throw const Failure.notFound();
      if (AlertStatus.fromDb(row['status'] as String).isResolved) {
        throw const Failure.conflict(key: 'alert_already_resolved');
      }

      final suggested = FraudType.fromDb(
        (row['suggested_type'] as Map<String, dynamic>)['code'] as String,
      );
      final finalType = _finalType(input, suggested, fraudTypes);
      final transactionIds = [
        for (final transaction in row['ai_alert_transactions'] as List<dynamic>)
          (transaction as Map<String, dynamic>)['transaction_id'] as int,
      ]..removeWhere(input.excludedTransactionIds.contains);

      await _localWrites.resolveAlert(
        alertId: input.alertId,
        status: input.action.status,
        transactionIds: transactionIds,
        values: _labelValues(input, finalType),
        analystId: analystId,
        analystName: analystName,
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// The type the alert ends in, or null if it is rejected. Applies the rules of
  /// `resolve_alert`: confirming keeps the suggested type, reclassifying needs another.
  FraudType? _finalType(
    ResolveAlertInput input,
    FraudType suggested,
    List<CatalogFraudType> fraudTypes,
  ) {
    switch (input.action) {
      case ResolveAlertAction.reject:
        if (input.severity != null) {
          throw const Failure.validation(key: 'severity_not_allowed');
        }
        return null;
      case ResolveAlertAction.confirm:
        _requireFraudFields(input);
        return suggested;
      case ResolveAlertAction.reclassify:
        final id = input.finalTypeId;
        final code = fraudTypes
            .where((type) => type.id == id)
            .firstOrNull
            ?.code;
        if (code == null) {
          throw const Failure.validation(key: 'fraud_type_required');
        }
        final type = FraudType.fromDb(code);
        if (type == suggested) {
          throw const Failure.validation(key: 'final_type_must_differ');
        }
        _requireFraudFields(input);
        return type;
    }
  }

  /// A confirmed or reclassified alert labels its transactions as fraud.
  void _requireFraudFields(ResolveAlertInput input) {
    if (input.severity == null) {
      throw const Failure.validation(key: 'severity_required');
    }
  }

  /// The label every involved transaction gets, as `resolve_alert` would write it.
  LabelValues _labelValues(ResolveAlertInput input, FraudType? finalType) {
    // The RPC defaults the confidence to «Alta».
    final confidence = input.confidence ?? ConfidenceLevel.high;
    final justification = input.justification?.trim();
    if (confidence.requiresJustification &&
        (justification == null || justification.isEmpty)) {
      throw const Failure.validation(key: 'justification_required');
    }
    return LabelValues(
      verdict: finalType == null ? Verdict.notFraud : Verdict.fraud,
      confidence: confidence,
      severity: finalType == null ? null : input.severity,
      justification: justification == null || justification.isEmpty
          ? null
          : justification,
      fraudTypes: [?finalType],
    );
  }

  /// The alerts resolved in this session are still pending in the database.
  ///
  /// - Pending: they are left out, by ID, so the total stays exact.
  /// - Resolved: the ones this session resolved to that status join the ones the database
  ///   already has in it.
  PostgrestFilterBuilder<T> _filterByStatus<T>(
    PostgrestFilterBuilder<T> request,
    AlertStatus status,
  ) {
    final session = _localWrites.alertResolutions;
    if (status == AlertStatus.pending) {
      if (session.isEmpty) return request.eq('status', status.dbValue);
      return request
          .eq('status', status.dbValue)
          .not('id', 'in', '(${session.keys.join(',')})');
    }
    final ids = [
      for (final MapEntry(:key, :value) in session.entries)
        if (value.status == status) key,
    ];
    if (ids.isEmpty) return request.eq('status', status.dbValue);
    return request.or('status.eq.${status.dbValue},id.in.(${ids.join(',')})');
  }

  /// [alert] with the resolution of this session, if the analyst resolved it.
  AiAlert _withSession(AiAlert alert) {
    final resolution = _localWrites.alertResolutionFor(alert.id);
    if (resolution == null) return alert;
    return alert.copyWith(
      status: resolution.status,
      resolvedBy: resolution.analystId,
      resolvedByName: resolution.analystName,
      resolvedAt: resolution.resolvedAt,
      finalType: resolution.finalType,
    );
  }
}
