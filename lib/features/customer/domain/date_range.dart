import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_range.freezed.dart';

/// A range of calendar days in the analyst's time zone, both ends inclusive.
///
/// The customer view and the customer report share it (HU-03, HU-09).
@freezed
abstract class DateRange with _$DateRange {
  const factory DateRange({required DateTime from, required DateTime to}) =
      _DateRange;

  const DateRange._();

  /// The [days] days that end on [until], [until] included.
  factory DateRange.lastDays(int days, {required DateTime until}) {
    final end = _day(until);
    return DateRange(
      from: DateTime(end.year, end.month, end.day - (days - 1)),
      to: end,
    );
  }

  /// Whether the calendar day of [instant] is in the range.
  bool contains(DateTime instant) {
    final day = _day(instant.toLocal());
    return !day.isBefore(_day(from)) && !day.isAfter(_day(to));
  }

  /// Days in the range.
  int get days => _day(to).difference(_day(from)).inDays + 1;

  /// A range as long as this one that ends on the day of [instant].
  DateRange endingAt(DateTime instant) =>
      DateRange.lastDays(days, until: instant.toLocal());

  /// The first instant of the range, for `>=`.
  DateTime get start => _day(from);

  /// The first instant after the range, for `<`.
  DateTime get end => DateTime(to.year, to.month, to.day + 1);
}

DateTime _day(DateTime date) => DateTime(date.year, date.month, date.day);
