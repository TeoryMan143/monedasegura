import 'package:freezed_annotation/freezed_annotation.dart';

import 'alert_metric.dart';

part 'alert_reason.freezed.dart';
part 'alert_reason.g.dart';

@freezed
abstract class AlertReason with _$AlertReason {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory AlertReason({
    required String id,
    required String alertId,

    required int position,

    required double weight,

    required String title,

    required String evidence,

    AlertMetric? metric,
  }) = _AlertReason;

  factory AlertReason.fromJson(Map<String, dynamic> json) =>
      _$AlertReasonFromJson(json);
}
