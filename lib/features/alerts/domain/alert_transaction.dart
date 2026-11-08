import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_transaction.freezed.dart';
part 'alert_transaction.g.dart';

@freezed
abstract class AlertTransaction with _$AlertTransaction {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AlertTransaction({
    required int transactionId,

    required String code,
    required bool isPrimary,
    required double amount,
    required String currencyCode,

    /// Whether it already has a label, which resolving the alert would replace.
    @Default(false) bool isLabeled,
  }) = _AlertTransaction;

  factory AlertTransaction.fromJson(Map<String, dynamic> json) =>
      _$AlertTransactionFromJson(_flatten(json));
}

Map<String, dynamic> _flatten(Map<String, dynamic> row) {
  final transaction = row['transactions'] as Map<String, dynamic>;
  return {
    'is_primary': row['is_primary'],
    'transaction_id': transaction['id'],
    'code': transaction['code'],
    'amount': transaction['amount'],
    'currency_code': transaction['currency_code'],
    'is_labeled': transaction['is_labeled'],
  };
}
