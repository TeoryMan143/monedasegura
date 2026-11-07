// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_series_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeSeriesPoint _$TimeSeriesPointFromJson(Map<String, dynamic> json) =>
    _TimeSeriesPoint(
      periodStart: DateTime.parse(json['period_start'] as String),
      fraudCount: (json['fraud_count'] as num).toInt(),
    );

Map<String, dynamic> _$TimeSeriesPointToJson(_TimeSeriesPoint instance) =>
    <String, dynamic>{
      'period_start': instance.periodStart.toIso8601String(),
      'fraud_count': instance.fraudCount,
    };
