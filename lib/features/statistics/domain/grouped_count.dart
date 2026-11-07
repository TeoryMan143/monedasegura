import 'package:freezed_annotation/freezed_annotation.dart';

part 'grouped_count.freezed.dart';
part 'grouped_count.g.dart';

@freezed
abstract class GroupedCount with _$GroupedCount {
  const factory GroupedCount({required String key, required int count}) =
      _GroupedCount;

  factory GroupedCount.fromJson(Map<String, dynamic> json) =>
      _$GroupedCountFromJson(json);
}
