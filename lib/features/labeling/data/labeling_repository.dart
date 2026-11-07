import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../../core/domain/account_type.dart';
import '../../../core/domain/channel.dart';
import '../../../core/domain/confidence_level.dart';
import '../../../core/domain/currency.dart';
import '../../../core/domain/fraud_type.dart';
import '../../../core/domain/severity.dart';
import '../../../core/domain/transaction_type.dart';
import '../../../core/domain/verdict.dart';
import '../../../core/errors/failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../../../core/local_writes/local_writes_models.dart';
import '../../../core/local_writes/local_writes_provider.dart';
import '../../../core/local_writes/local_writes_store.dart';
import '../../../core/supabase/supabase_client_provider.dart';
import '../domain/classification_target.dart';
import '../domain/label_form.dart';
import 'fake_labeling_repository.dart';

/// Reads the transaction of the N-02 panel and saves its label (HU-04).
///
/// The prototype does not write to the database: [saveLabel] goes to the
/// [LocalWritesStore], which also keeps the session's audit entry. Reads merge that
/// label over the one in the database.
class LabelingRepository {
  LabelingRepository(this._client, this._localWrites);

  final SupabaseClient _client;
  final LocalWritesStore _localWrites;

  static const _transactionColumns =
      'id, code, occurred_at, type, channel_code, amount, currency_code, '
      'merchant_name, account_last4, account_type';
  static const _labelColumns =
      'verdict, confidence, severity, justification, updated_at, '
      'analysts(full_name), label_fraud_types(fraud_types(code))';
  static const _alertColumns =
      'ai_alerts(code, score, summary, '
      'suggested_type:fraud_types!ai_alerts_suggested_type_id_fkey(code))';

  Future<ClassificationTarget> fetchTarget(int transactionId) async {
    try {
      final results = await Future.wait<Object?>([
        _client
            .from('v_transactions_list')
            .select(_transactionColumns)
            .eq('id', transactionId)
            .maybeSingle(),
        _client
            .from('labels')
            .select(_labelColumns)
            .eq('transaction_id', transactionId)
            .maybeSingle(),
        _client
            .from('ai_alert_transactions')
            .select(_alertColumns)
            .eq('transaction_id', transactionId),
      ]);
      final row = results[0] as Map<String, dynamic>?;
      if (row == null) throw const Failure.notFound();
      final label = results[1] as Map<String, dynamic>?;
      final alerts = results[2]! as List<dynamic>;
      return withLocalLabel(
        targetFromRow(
          row,
          label: label == null ? null : savedLabelFromRow(label),
          alert: strongestAlert(alerts),
        ),
        _localWrites,
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Saves [form], which must already pass `validateLabel`, as the current analyst.
  Future<SavedLabel> saveLabel({
    required int transactionId,
    required LabelForm form,
    required String analystId,
    required String analystName,
  }) => saveToLocalWrites(
    _localWrites,
    transactionId: transactionId,
    form: form,
    analystId: analystId,
    analystName: analystName,
  );
}

/// Writes [form] in [localWrites] and returns it as the transaction's current label.
Future<SavedLabel> saveToLocalWrites(
  LocalWritesStore localWrites, {
  required int transactionId,
  required LabelForm form,
  required String analystId,
  required String analystName,
}) async {
  final verdict = form.verdict;
  final confidence = form.confidence;
  if (verdict == null || confidence == null) {
    throw const Failure.validation(key: 'label_incomplete');
  }
  final justification = form.justification.trim();
  final saved = await localWrites.saveLabel(
    transactionId: transactionId,
    values: LabelValues(
      verdict: verdict,
      confidence: confidence,
      severity: verdict == Verdict.notFraud ? null : form.severity,
      justification: justification.isEmpty ? null : justification,
      fraudTypes: verdict == Verdict.notFraud ? const [] : form.fraudTypes,
    ),
    analystId: analystId,
    analystName: analystName,
  );
  return savedLabelFromLocal(saved);
}

/// [target] with the label saved in this session, which the database does not have yet.
ClassificationTarget withLocalLabel(
  ClassificationTarget target,
  LocalWritesStore localWrites,
) => switch (localWrites.labelFor(target.id)) {
  final local? => target.copyWith(label: savedLabelFromLocal(local)),
  null => target,
};

SavedLabel savedLabelFromLocal(LocalLabel local) => SavedLabel(
  verdict: local.values.verdict,
  confidence: local.values.confidence,
  severity: local.values.severity,
  justification: local.values.justification,
  fraudTypes: local.values.fraudTypes,
  analystName: local.analystName,
  updatedAt: local.updatedAt,
);

/// A row of `v_transactions_list` with the columns of the panel.
ClassificationTarget targetFromRow(
  Map<String, dynamic> row, {
  SavedLabel? label,
  TargetAlert? alert,
}) {
  final accountType = row['account_type'] as String?;
  return ClassificationTarget(
    id: row['id'] as int,
    code: row['code'] as String,
    occurredAt: DateTime.parse(row['occurred_at'] as String).toLocal(),
    type: TransactionType.fromDb(row['type'] as String),
    channel: Channel.fromDb(row['channel_code'] as String),
    amount: (row['amount'] as num).toDouble(),
    currency: Currency.fromDb(row['currency_code'] as String),
    merchantName: row['merchant_name'] as String?,
    accountLast4: row['account_last4'] as String?,
    accountType: accountType == null ? null : AccountType.fromDb(accountType),
    alert: alert,
    label: label,
  );
}

/// A row of `labels` with its analyst and fraud types embedded.
SavedLabel savedLabelFromRow(Map<String, dynamic> row) {
  final severity = row['severity'] as String?;
  final analyst = row['analysts'] as Map<String, dynamic>?;
  final types = row['label_fraud_types'] as List<dynamic>? ?? const [];
  return SavedLabel(
    verdict: Verdict.fromDb(row['verdict'] as String),
    confidence: ConfidenceLevel.fromDb(row['confidence'] as int),
    severity: severity == null ? null : Severity.fromDb(severity),
    justification: row['justification'] as String?,
    fraudTypes: [
      for (final type in types)
        FraudType.fromDb(
          ((type as Map<String, dynamic>)['fraud_types']
                  as Map<String, dynamic>)['code']
              as String,
        ),
    ],
    analystName: analyst?['full_name'] as String? ?? 'Otro analista',
    updatedAt: DateTime.parse(row['updated_at'] as String).toLocal(),
  );
}

/// The alert with the highest score among the rows of `ai_alert_transactions`.
TargetAlert? strongestAlert(List<dynamic> rows) {
  TargetAlert? strongest;
  for (final row in rows) {
    final alert =
        (row as Map<String, dynamic>)['ai_alerts'] as Map<String, dynamic>?;
    if (alert == null) continue;
    final score = alert['score'] as int;
    if (strongest != null && strongest.score >= score) continue;
    strongest = TargetAlert(
      code: alert['code'] as String,
      score: score,
      summary: alert['summary'] as String,
      suggestedType: FraudType.fromDb(
        (alert['suggested_type'] as Map<String, dynamic>)['code'] as String,
      ),
    );
  }
  return strongest;
}

/// The labeling repository of the app. With `--dart-define=USE_FAKE_DATA=true` (no
/// backend) it is [FakeLabelingRepository].
final labelingRepositoryProvider = Provider<LabelingRepository>((ref) {
  final localWrites = ref.watch(localWritesStoreProvider);
  return Env.useFakeData
      ? FakeLabelingRepository(localWrites)
      : LabelingRepository(ref.watch(supabaseClientProvider), localWrites);
}, name: 'labelingRepositoryProvider');
