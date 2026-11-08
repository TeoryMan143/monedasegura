import '../../../core/domain/alert_status.dart';
import '../../../core/domain/confidence_level.dart';
import '../../../core/domain/fraud_type.dart';
import '../../../core/domain/severity.dart';
import '../../../core/domain/verdict.dart';
import 'audit_entry.dart';

/// One field of an [AuditEntry], «antes → después», with the Spanish labels of
/// `core/domain`. [before] is null when the field had no value.
typedef AuditChange = ({String field, String? before, String? after});

/// The fields an [AuditEntry] changed, in form order. A created label lists every field
/// it has; an edit lists only the fields whose value changed.
///
/// The labels of the database store their fraud types in another table, so their
/// entries have no `fraud_types` and show no type change.
List<AuditChange> auditChanges(AuditEntry entry) {
  final before = entry.oldValue ?? const <String, dynamic>{};
  final after = entry.newValue ?? const <String, dynamic>{};
  final fields = entry.isAlert ? _alertFields : _labelFields;
  return [
    for (final MapEntry(key: key, value: (:label, :format)) in fields.entries)
      if (after.containsKey(key) || before.containsKey(key))
        if ((_text(before[key], format), _text(after[key], format))
            case (final old, final current) when old != current)
          (field: label, before: old, after: current),
  ];
}

typedef _Field = ({String label, String Function(Object value) format});

final Map<String, _Field> _labelFields = {
  'verdict': (
    label: 'Veredicto',
    format: (value) => Verdict.fromDb(value as String).label,
  ),
  'fraud_types': (
    label: 'Tipos de fraude',
    format: (value) => [
      for (final code in value as List<dynamic>)
        FraudType.fromDb(code as String).label,
    ].join(', '),
  ),
  'confidence': (
    label: 'Confianza',
    format: (value) => ConfidenceLevel.fromDb((value as num).toInt()).label,
  ),
  'severity': (
    label: 'Severidad',
    format: (value) => Severity.fromDb(value as String).label,
  ),
  'justification': (label: 'Justificación', format: (value) => '$value'),
};

final Map<String, _Field> _alertFields = {
  'status': (
    label: 'Estado',
    format: (value) => AlertStatus.fromDb(value as String).label,
  ),
  'final_type': (
    label: 'Tipo final',
    format: (value) => FraudType.fromDb(value as String).label,
  ),
};

/// The label of [value], or null when it is empty. An unknown value shows as it is.
String? _text(Object? value, String Function(Object value) format) {
  if (value == null || value == '' || (value is List && value.isEmpty)) {
    return null;
  }
  try {
    final text = format(value).trim();
    return text.isEmpty ? null : text;
  } on ArgumentError {
    return '$value';
  }
}
