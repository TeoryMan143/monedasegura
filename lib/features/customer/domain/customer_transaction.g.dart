// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerTransaction _$CustomerTransactionFromJson(Map<String, dynamic> json) =>
    _CustomerTransaction(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      occurredAt: DateTime.parse(json['occurred_at'] as String),
      type: TransactionType.fromDb(json['type'] as String),
      channel: Channel.fromDb(json['channel_code'] as String),
      amount: json['amount'] as num,
      currency: Currency.fromDb(json['currency_code'] as String),
      sourceAccountId: json['source_account_id'] as String?,
      destinationAccountId: json['destination_account_id'] as String?,
      merchantName: json['merchant_name'] as String?,
      alertScore: (json['alert_score'] as num?)?.toInt(),
      isLabeled: json['is_labeled'] as bool,
      verdict: _verdictOrNull(json['verdict'] as String?),
    );
