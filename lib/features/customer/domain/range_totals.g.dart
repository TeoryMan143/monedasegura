// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'range_totals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RangeTotals _$RangeTotalsFromJson(Map<String, dynamic> json) => _RangeTotals(
  currency: Currency.fromDb(json['currency_code'] as String),
  totalIn: json['total_in'] as num,
  totalOut: json['total_out'] as num,
  net: json['net'] as num,
  transactionCount: (json['transaction_count'] as num).toInt(),
);
