import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/alert_status.dart';
import '../../../core/domain/confidence_level.dart';
import '../../../core/domain/severity.dart';

part 'resolve_alert_input.freezed.dart';

enum ResolveAlertAction {
  confirm(AlertStatus.confirmed),
  reject(AlertStatus.rejected),
  reclassify(AlertStatus.reclassified);

  const ResolveAlertAction(this.status);

  final AlertStatus status;
}

@freezed
abstract class ResolveAlertInput with _$ResolveAlertInput {
  const factory ResolveAlertInput({
    required String alertId,
    required ResolveAlertAction action,

    int? finalTypeId,
    ConfidenceLevel? confidence,

    Severity? severity,
    String? justification,

    @Default(<int>[]) List<int> excludedTransactionIds,
  }) = _ResolveAlertInput;
}
