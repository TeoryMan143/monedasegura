// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlertMetric _$AlertMetricFromJson(Map<String, dynamic> json) => _AlertMetric(
  observed: (json['observed'] as num).toDouble(),
  baseline: (json['baseline'] as num).toDouble(),
  unit: json['unit'] as String?,
);

Map<String, dynamic> _$AlertMetricToJson(_AlertMetric instance) =>
    <String, dynamic>{
      'observed': instance.observed,
      'baseline': instance.baseline,
      'unit': instance.unit,
    };
