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
import '../../../core/supabase/supabase_client_provider.dart';
import '../domain/classification_target.dart';
import '../domain/label_form.dart';
import 'fake_labeling_repository.dart';
import 'label_writer.dart';

/// Reads the transaction of the N-02 panel from the database and saves its label
/// through a [LabelWriter] (HU-04).
///
/// The repository does not know where labels go: [labelWriterProvider] decides it. A
/// label the writer holds and the database does not have yet shows over the database's.
class LabelingRepository {
  LabelingRepository(this._client, this._writer);

  final SupabaseClient _client;
  final LabelWriter _writer;

  static const _transactionColumns =
      'id, code, occurred_at, type, channel_code, amount, currency_code, '
      'merchant_name, account_last4, account_type';

  /// A label with what [savedLabelFromRow] reads: its analyst and fraud types.
  static const labelColumns =
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
            .select(labelColumns)
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
      return withPendingLabel(
        targetFromRow(
          row,
          label: label == null ? null : savedLabelFromRow(label),
          alert: strongestAlert(alerts),
        ),
        _writer,
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Saves [form], which must already pass `validateLabel`, as the given analyst.
  Future<SavedLabel> saveLabel({
    required int transactionId,
    required LabelForm form,
    required String analystId,
    required String analystName,
  }) => _writer.save(
    transactionId: transactionId,
    form: form,
    analystId: analystId,
    analystName: analystName,
  );
}

/// [target] with the label [writer] holds, if the database does not have it yet.
ClassificationTarget withPendingLabel(
  ClassificationTarget target,
  LabelWriter writer,
) => switch (writer.pendingLabelFor(target.id)) {
  final pending? => target.copyWith(label: pending),
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

/// A row of `labels` with its analyst and fraud types embedded ([LabelingRepository.labelColumns]).
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
/// backend) it is [FakeLabelingRepository]. Both save through [labelWriterProvider].
final labelingRepositoryProvider = Provider<LabelingRepository>((ref) {
  final writer = ref.watch(labelWriterProvider);
  return Env.useFakeData
      ? FakeLabelingRepository(writer)
      : LabelingRepository(ref.watch(supabaseClientProvider), writer);
}, name: 'labelingRepositoryProvider');
