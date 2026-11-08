import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/audit_action.dart';

part 'audit_entry.freezed.dart';
part 'audit_entry.g.dart';

/// One change to the label of a transaction or to one of its alerts, as `audit_log`
/// holds it (HU-15). Read only: the app never edits or deletes it.
///
/// [oldValue] and [newValue] hold database values:
/// - A label: `verdict`, `confidence`, `severity`, `justification` and, for the changes
///   of the session, `fraud_types` (a list of codes).
/// - An alert: `code`, `status` and `final_type` (a fraud type code).
///
/// `auditChanges` turns them into the «antes → después» of each field.
@Freezed(toJson: false)
abstract class AuditEntry with _$AuditEntry {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AuditEntry({
    @JsonKey(fromJson: AuditAction.fromDb) required AuditAction action,
    required String analystId,

    /// From the embedded `analyst:analysts(full_name)`.
    @JsonKey(readValue: _readAnalystName) required String analystName,
    required DateTime createdAt,

    /// Null when the label was created.
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,

    /// True for a change made in this session that the database does not have yet.
    @JsonKey(includeFromJson: false) @Default(false) bool fromSession,
  }) = _AuditEntry;

  const AuditEntry._();

  /// Reads a row of `audit_log` with `analyst:analysts(full_name)` embedded.
  factory AuditEntry.fromJson(Map<String, dynamic> json) =>
      _$AuditEntryFromJson(json);

  /// Whether the change is to an alert and not to the label.
  bool get isAlert =>
      action == AuditAction.confirmAlert ||
      action == AuditAction.rejectAlert ||
      action == AuditAction.reclassifyAlert;

  /// The code of the alert, «AL-1042», when [isAlert].
  String? get alertCode => (newValue?['code'] ?? oldValue?['code']) as String?;
}

Object? _readAnalystName(Map<dynamic, dynamic> json, String key) =>
    (json['analyst'] as Map<String, dynamic>?)?['full_name'] ?? '';

/// The changes of the [database] and of the [session] in one list, newest first.
List<AuditEntry> mergeAuditHistory(
  Iterable<AuditEntry> database,
  Iterable<AuditEntry> session,
) =>
    [...database, ...session]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
