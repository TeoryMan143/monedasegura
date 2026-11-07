// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_reason.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlertReason _$AlertReasonFromJson(Map<String, dynamic> json) => _AlertReason(
  id: json['id'] as String,
  alertId: json['alert_id'] as String,
  position: (json['position'] as num).toInt(),
  weight: (json['weight'] as num).toDouble(),
  title: json['title'] as String,
  evidence: json['evidence'] as String,
  metric: json['metric'] == null
      ? null
      : AlertMetric.fromJson(json['metric'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AlertReasonToJson(_AlertReason instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alert_id': instance.alertId,
      'position': instance.position,
      'weight': instance.weight,
      'title': instance.title,
      'evidence': instance.evidence,
      'metric': instance.metric?.toJson(),
    };
