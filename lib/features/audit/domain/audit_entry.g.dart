// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditEntry _$AuditEntryFromJson(Map<String, dynamic> json) => _AuditEntry(
  action: AuditAction.fromDb(json['action'] as String),
  analystId: json['analyst_id'] as String,
  analystName: _readAnalystName(json, 'analyst_name') as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  oldValue: json['old_value'] as Map<String, dynamic>?,
  newValue: json['new_value'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AuditEntryToJson(_AuditEntry instance) =>
    <String, dynamic>{
      'action': _$AuditActionEnumMap[instance.action]!,
      'analyst_id': instance.analystId,
      'analyst_name': instance.analystName,
      'created_at': instance.createdAt.toIso8601String(),
      'old_value': instance.oldValue,
      'new_value': instance.newValue,
    };

const _$AuditActionEnumMap = {
  AuditAction.createLabel: 'createLabel',
  AuditAction.updateLabel: 'updateLabel',
  AuditAction.confirmAlert: 'confirmAlert',
  AuditAction.rejectAlert: 'rejectAlert',
  AuditAction.reclassifyAlert: 'reclassifyAlert',
};
