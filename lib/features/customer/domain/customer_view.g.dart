// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerAccount _$CustomerAccountFromJson(Map<String, dynamic> json) =>
    _CustomerAccount(
      id: json['id'] as String,
      last4: json['last4'] as String,
      type: AccountType.fromDb(json['type'] as String),
      currency: Currency.fromDb(json['currency_code'] as String),
    );
