import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/alert_status.dart';
import '../domain/audit_action.dart';
import '../domain/confidence_level.dart';
import '../domain/fraud_type.dart';
import '../domain/severity.dart';
import '../domain/verdict.dart';

part 'local_writes_models.freezed.dart';

/// What the analyst chose for a transaction, in one form or in a bulk one.
@freezed
abstract class LabelValues with _$LabelValues {
  const factory LabelValues({
    required Verdict verdict,
    required ConfidenceLevel confidence,
    Severity? severity,
    String? justification,
    @Default(<FraudType>[]) List<FraudType> fraudTypes,
  }) = _LabelValues;
}

/// The current label of a transaction in the prototype, as `labels` would hold it.
@freezed
abstract class LocalLabel with _$LocalLabel {
  const factory LocalLabel({
    required int transactionId,
    required LabelValues values,

    /// The alert that produced the label. Null for a manual label.
    String? alertId,

    /// The last analyst who saved it.
    required String analystId,
    required String analystName,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// 1 when created, plus one per edit.
    required int version,
  }) = _LocalLabel;
}

/// How an alert was resolved in the prototype.
@freezed
abstract class AlertResolution with _$AlertResolution {
  const factory AlertResolution({
    required String alertId,
    required AlertStatus status,
    required String analystId,
    required String analystName,
    required DateTime resolvedAt,

    /// Null when the alert was rejected.
    FraudType? finalType,
  }) = _AlertResolution;
}

/// One change, as `audit_log` would hold it. [oldValue] and [newValue] use database values.
@freezed
abstract class AuditEntry with _$AuditEntry {
  const factory AuditEntry({
    required AuditAction action,
    required String analystId,
    required String analystName,
    required DateTime createdAt,

    /// Null in the entry of the alert itself.
    int? transactionId,

    /// Null for a manual label.
    String? alertId,

    /// Null when the label is created.
    Map<String, Object?>? oldValue,
    required Map<String, Object?> newValue,
  }) = _AuditEntry;
}
