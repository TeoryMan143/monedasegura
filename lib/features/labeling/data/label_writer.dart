import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/catalogs/catalog_providers.dart';
import '../../../core/config/env.dart';
import '../../../core/demo/demo_cases.dart';
import '../../../core/domain/catalog_models.dart';
import '../../../core/domain/confidence_level.dart';
import '../../../core/domain/fraud_type.dart';
import '../../../core/domain/severity.dart';
import '../../../core/domain/verdict.dart';
import '../../../core/errors/failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../../../core/local_writes/local_writes_models.dart';
import '../../../core/local_writes/local_writes_provider.dart';
import '../../../core/local_writes/local_writes_store.dart';
import '../../../core/supabase/supabase_client_provider.dart';
import '../domain/classification_target.dart';
import '../domain/label_form.dart';
import 'labeling_repository.dart';

/// Where a label is saved (HU-04). The panel and [LabelingRepository] only see this
/// interface, so moving from memory to the database is changing [labelWriterProvider].
abstract interface class LabelWriter {
  /// Saves [form], which must already pass `validateLabel`, as the given analyst.
  Future<SavedLabel> save({
    required int transactionId,
    required LabelForm form,
    required String analystId,
    required String analystName,
  });

  /// Saves the same [form], which must already pass `validateLabel`, on every
  /// transaction (HU-05). All of them are saved or none. Returns how many already had
  /// a label.
  Future<int> saveMany({
    required Set<int> transactionIds,
    required LabelForm form,
    required String analystId,
    required String analystName,
  });

  /// A label this writer holds that the database does not have yet, to show over the
  /// database's one. Always null once labels are written to the database.
  SavedLabel? pendingLabelFor(int transactionId);
}

/// The prototype: labels stay in the [LocalWritesStore] while the app is open, for every
/// analyst who signs in. The store also keeps the audit entry.
class LocalLabelWriter implements LabelWriter {
  LocalLabelWriter(this._store);

  final LocalWritesStore _store;

  @override
  Future<SavedLabel> save({
    required int transactionId,
    required LabelForm form,
    required String analystId,
    required String analystName,
  }) async {
    final saved = await _store.saveLabel(
      transactionId: transactionId,
      values: _values(form),
      analystId: analystId,
      analystName: analystName,
    );
    return savedLabelFromLocal(saved);
  }

  @override
  Future<int> saveMany({
    required Set<int> transactionIds,
    required LabelForm form,
    required String analystId,
    required String analystName,
  }) => _store.saveLabels(
    transactionIds: transactionIds,
    values: _values(form),
    analystId: analystId,
    analystName: analystName,
  );

  LabelValues _values(LabelForm form) {
    final (:verdict, :confidence) = _required(form);
    return LabelValues(
      verdict: verdict,
      confidence: confidence,
      severity: _severity(form),
      justification: _justification(form),
      fraudTypes: _fraudTypes(form),
    );
  }

  @override
  SavedLabel? pendingLabelFor(int transactionId) =>
      switch (_store.labelFor(transactionId)) {
        final local? => savedLabelFromLocal(local),
        null => null,
      };
}

/// Saves in Supabase through the `label_transactions` RPC, which writes `labels`,
/// `label_fraud_types` and, by trigger, `audit_log` and `is_labeled`. Then it reads the
/// label back for the analyst's name and the date.
///
/// Off until [useDatabase] is true. It has not been tried against the database yet.
class SupabaseLabelWriter implements LabelWriter {
  SupabaseLabelWriter(this._client, {required this.fraudTypes});

  final SupabaseClient _client;

  /// The `fraud_types` catalog, which turns each type into the id the RPC takes.
  final Future<List<CatalogFraudType>> Function() fraudTypes;

  @override
  Future<SavedLabel> save({
    required int transactionId,
    required LabelForm form,
    required String analystId,
    required String analystName,
  }) async {
    // E-03 stays reproducible with the demo case.
    if (transactionId == DemoCases.failingTransactionId) {
      throw Failure.unknown(message: 'Simulated save error: $transactionId');
    }
    try {
      await _labelTransactions({transactionId}, form);
      final row = await _client
          .from('labels')
          .select(LabelingRepository.labelColumns)
          .eq('transaction_id', transactionId)
          .single();
      return savedLabelFromRow(row);
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  @override
  Future<int> saveMany({
    required Set<int> transactionIds,
    required LabelForm form,
    required String analystId,
    required String analystName,
  }) async {
    // As the store does: the failing demo case rejects the whole bulk save.
    if (transactionIds.contains(DemoCases.failingTransactionId)) {
      throw const Failure.unknown(message: 'Simulated bulk save error');
    }
    try {
      return await _labelTransactions(transactionIds, form);
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  @override
  SavedLabel? pendingLabelFor(int transactionId) => null;

  /// Calls `label_transactions`, which returns how many already had a label.
  Future<int> _labelTransactions(
    Set<int> transactionIds,
    LabelForm form,
  ) async {
    final (:verdict, :confidence) = _required(form);
    final catalog = await fraudTypes();
    final ids = {for (final type in catalog) type.code: type.id};
    return _client.rpc<int>(
      'label_transactions',
      params: {
        'p_transaction_ids': transactionIds.toList(),
        'p_verdict': verdict.dbValue,
        'p_confidence': confidence.dbValue,
        'p_fraud_type_ids': [
          for (final type in _fraudTypes(form)) ids[type.dbValue],
        ],
        'p_severity': _severity(form)?.dbValue,
        'p_justification': _justification(form),
      },
    );
  }
}

/// Where the app saves labels: in memory for the prototype.
///
/// To write to Supabase, set [useDatabase] to true. Nothing else changes.
final labelWriterProvider = Provider<LabelWriter>(
  (ref) => useDatabase && !Env.useFakeData
      ? SupabaseLabelWriter(
          ref.watch(supabaseClientProvider),
          fraudTypes: () => ref.read(fraudTypesProvider.future),
        )
      : LocalLabelWriter(ref.watch(localWritesStoreProvider)),
  name: 'labelWriterProvider',
);

/// False while the prototype keeps labels in memory ([LocalLabelWriter]).
const useDatabase = false;

({Verdict verdict, ConfidenceLevel confidence}) _required(LabelForm form) {
  final verdict = form.verdict;
  final confidence = form.confidence;
  if (verdict == null || confidence == null) {
    throw const Failure.validation(key: 'label_incomplete');
  }
  return (verdict: verdict, confidence: confidence);
}

/// No fraude never carries a severity or fraud types, even if the form still has them.
Severity? _severity(LabelForm form) =>
    form.verdict == Verdict.notFraud ? null : form.severity;

List<FraudType> _fraudTypes(LabelForm form) =>
    form.verdict == Verdict.notFraud ? const [] : form.fraudTypes;

String? _justification(LabelForm form) {
  final text = form.justification.trim();
  return text.isEmpty ? null : text;
}
