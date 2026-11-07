import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_metric.freezed.dart';
part 'alert_metric.g.dart';

@freezed
abstract class AlertMetric with _$AlertMetric {
  const factory AlertMetric({
    /// What the transaction did, e.g. the amount.
    required double observed,

    /// What is usual for the customer, e.g. the 90-day average.
    required double baseline,

    /// Currency code, `x`, `min`… Null when the number has no unit.
    String? unit,
  }) = _AlertMetric;

  const AlertMetric._();

  factory AlertMetric.fromJson(Map<String, dynamic> json) =>
      _$AlertMetricFromJson(json);

  /// How many times [observed] exceeds [baseline] (8.2 for «8,2×»), or null if the
  /// baseline is zero.
  double? get ratio => baseline == 0 ? null : observed / baseline;
}
