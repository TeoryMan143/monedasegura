// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiAlert _$AiAlertFromJson(Map<String, dynamic> json) => _AiAlert(
  id: json['id'] as String,
  code: json['code'] as String,
  customerId: json['customer_id'] as String,
  customerName: json['customer_name'] as String,
  score: (json['score'] as num).toInt(),
  suggestedType: FraudType.fromDb(json['suggested_type'] as String),
  summary: json['summary'] as String,
  status: AlertStatus.fromDb(json['status'] as String),
  generatedAt: DateTime.parse(json['generated_at'] as String),
  resolvedBy: json['resolved_by'] as String?,
  resolvedByName: json['resolved_by_name'] as String?,
  resolvedAt: json['resolved_at'] == null
      ? null
      : DateTime.parse(json['resolved_at'] as String),
  finalType: _fraudTypeOrNull(json['final_type'] as String?),
);

Map<String, dynamic> _$AiAlertToJson(_AiAlert instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'customer_id': instance.customerId,
  'customer_name': instance.customerName,
  'score': instance.score,
  'suggested_type': _fraudTypeToJson(instance.suggestedType),
  'summary': instance.summary,
  'status': _statusToJson(instance.status),
  'generated_at': instance.generatedAt.toIso8601String(),
  'resolved_by': instance.resolvedBy,
  'resolved_by_name': instance.resolvedByName,
  'resolved_at': instance.resolvedAt?.toIso8601String(),
  'final_type': _fraudTypeOrNullToJson(instance.finalType),
};
