import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/date_range.dart';

/// Days the customer view shows when it opens.
const defaultRangeDays = 30;

/// The date range of a customer, shared by the customer view (A-02, HU-03) and the tabs
/// of the customer report (C-08…C-12, HU-09): a range chosen in one is the range of
/// the other.
///
/// Lives while any of those screens is open, and starts over (the last
/// [defaultRangeDays] days) the next time the customer is opened.
final customerDateRangeProvider = NotifierProvider.autoDispose
    .family<CustomerDateRangeNotifier, DateRange, String>(
      CustomerDateRangeNotifier.new,
      name: 'customerDateRangeProvider',
    );

class CustomerDateRangeNotifier extends Notifier<DateRange> {
  CustomerDateRangeNotifier(this.customerId);

  final String customerId;

  @override
  DateRange build() =>
      DateRange.lastDays(defaultRangeDays, until: DateTime.now());

  void setRange(DateRange range) => state = range;

  /// Moves the range, keeping its length, so that it ends on the day of [instant] when
  /// that day is outside it. Used to show the transaction of `?tx=`.
  void show(DateTime instant) {
    if (!state.contains(instant)) state = state.endingAt(instant);
  }
}
