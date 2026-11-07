import 'package:freezed_annotation/freezed_annotation.dart';

import 'ai_alert.dart';
import 'alert_reason.dart';
import 'alert_transaction.dart';

part 'alert_detail.freezed.dart';

/// An alert with everything the detail shows (HU-07, A-05): the header, the reasons of
/// the AI and the transactions involved.
///
/// It does not exist as a table: it joins `ai_alerts`, `ai_alert_reasons` and
/// `ai_alert_transactions` in one query with embedded tables:
///
/// ```dart
/// client.from('ai_alerts').select(
///   'id, code, customer_id, account_id, score, summary, model_version, status, '
///   'generated_at, resolved_by, resolved_at, '
///   'customers(first_names, last_names), '
///   'suggested_type:fraud_types!suggested_type_id(code), '
///   'final_type:fraud_types!final_type_id(code), '
///   'resolver:analysts!resolved_by(full_name), '
///   'ai_alert_reasons(id, position, weight, title, evidence, metric), '
///   'ai_alert_transactions(is_primary, transactions(id, code, amount, currency_code))',
/// ).eq('id', id).maybeSingle()
/// ```
@freezed
abstract class AlertDetail with _$AlertDetail {
  const factory AlertDetail({
    required AiAlert alert,

    /// The account the alert is about. Null when it is about the customer.
    String? accountId,
    required String modelVersion,

    /// Ordered by `position`.
    required List<AlertReason> reasons,

    /// The primary transaction first, then the rest by id.
    required List<AlertTransaction> transactions,
  }) = _AlertDetail;

  /// Reads the row of the query in the class documentation.
  factory AlertDetail.fromRow(Map<String, dynamic> row) {
    final alertId = row['id'] as String;
    final reasons = [
      for (final reason in row['ai_alert_reasons'] as List<dynamic>)
        AlertReason.fromJson({
          ...reason as Map<String, dynamic>,
          'alert_id': alertId,
        }),
    ]..sort((a, b) => a.position.compareTo(b.position));
    final transactions = [
      for (final transaction in row['ai_alert_transactions'] as List<dynamic>)
        AlertTransaction.fromJson(transaction as Map<String, dynamic>),
    ]..sort(_primaryFirst);

    return AlertDetail(
      alert: AiAlert.fromJson(row),
      accountId: row['account_id'] as String?,
      modelVersion: row['model_version'] as String,
      reasons: reasons,
      transactions: transactions,
    );
  }
}

int _primaryFirst(AlertTransaction a, AlertTransaction b) {
  if (a.isPrimary != b.isPrimary) return a.isPrimary ? -1 : 1;
  return a.transactionId.compareTo(b.transactionId);
}
