import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_series_point.freezed.dart';
part 'time_series_point.g.dart';

@freezed
abstract class TimeSeriesPoint with _$TimeSeriesPoint {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TimeSeriesPoint({
    required DateTime periodStart,

    required int fraudCount,
  }) = _TimeSeriesPoint;

  factory TimeSeriesPoint.fromJson(Map<String, dynamic> json) =>
      _$TimeSeriesPointFromJson(json);
}
