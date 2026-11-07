import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_result.freezed.dart';

/// One page of a server-side list: its rows and the total that match the query.
@freezed
abstract class PageResult<T> with _$PageResult<T> {
  const factory PageResult({required List<T> items, required int total}) =
      _PageResult<T>;
}
