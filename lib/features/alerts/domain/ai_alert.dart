import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/alert_status.dart';
import '../../../core/domain/fraud_type.dart';

part 'ai_alert.freezed.dart';
part 'ai_alert.g.dart';

@freezed
abstract class AiAlert with _$AiAlert {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AiAlert({
    required String id,

    /// The readable code, e.g. `AL-1042`.
    required String code,
    required String customerId,
    required String customerName,

    /// 0 to 100.
    required int score,
    @JsonKey(fromJson: FraudType.fromDb, toJson: _fraudTypeToJson)
    required FraudType suggestedType,
    required String summary,
    @JsonKey(fromJson: AlertStatus.fromDb, toJson: _statusToJson)
    required AlertStatus status,
    required DateTime generatedAt,

    /// The analyst who resolved it. Null while the alert is pending.
    String? resolvedBy,
    String? resolvedByName,
    DateTime? resolvedAt,

    /// The type decided on resolution. Null while pending and when it was rejected.
    @JsonKey(fromJson: _fraudTypeOrNull, toJson: _fraudTypeOrNullToJson)
    FraudType? finalType,
  }) = _AiAlert;

  const AiAlert._();

  /// Reads the row with its embedded tables (see the class documentation).
  factory AiAlert.fromJson(Map<String, dynamic> json) =>
      _$AiAlertFromJson(_flatten(json));

  /// Whether an analyst already resolved it (confirmed, rejected or reclassified).
  bool get isResolved => status.isResolved;
}

FraudType? _fraudTypeOrNull(String? code) =>
    code == null ? null : FraudType.fromDb(code);

/// Turns the embedded tables of PostgREST into the flat keys of [AiAlert].
Map<String, dynamic> _flatten(Map<String, dynamic> row) {
  final customer = row['customers'] as Map<String, dynamic>;
  final suggested = row['suggested_type'] as Map<String, dynamic>;
  final finalType = row['final_type'] as Map<String, dynamic>?;
  final resolver = row['resolver'] as Map<String, dynamic>?;
  return {
    ...row,
    'customer_name': '${customer['first_names']} ${customer['last_names']}',
    'suggested_type': suggested['code'],
    'final_type': finalType?['code'],
    'resolved_by_name': resolver?['full_name'],
  };
}

String _fraudTypeToJson(FraudType type) => type.dbValue;

String? _fraudTypeOrNullToJson(FraudType? type) => type?.dbValue;

String _statusToJson(AlertStatus status) => status.dbValue;
