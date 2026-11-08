// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlertTransaction _$AlertTransactionFromJson(Map<String, dynamic> json) =>
    _AlertTransaction(
      transactionId: (json['transaction_id'] as num).toInt(),
      code: json['code'] as String,
      isPrimary: json['is_primary'] as bool,
      amount: (json['amount'] as num).toDouble(),
      currencyCode: json['currency_code'] as String,
      isLabeled: json['is_labeled'] as bool? ?? false,
    );

Map<String, dynamic> _$AlertTransactionToJson(_AlertTransaction instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionId,
      'code': instance.code,
      'is_primary': instance.isPrimary,
      'amount': instance.amount,
      'currency_code': instance.currencyCode,
      'is_labeled': instance.isLabeled,
    };
