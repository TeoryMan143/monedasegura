import '../../../core/domain/currency.dart';
import 'customer_activity.dart';
import 'customer_transaction.dart';
import 'timeline_point.dart';

// Pure rules that highlight transactions on the customer timeline (HU-10). They read only
// the transactions of the range, so the screen can run them in `Isolate.run`.
//
// The defaults were checked against the seed: the demo burst (AL-1773) is three purchases
// in 17 minutes at 02:45, and the injected bursts are 2 to 6 operations a few minutes
// apart.

/// Ids of the transactions whose amount is at least [factor] times the median of the
/// customer's transactions in the same currency and direction.
///
/// Money in and money out have their own median, so a monthly payroll is not a spike
/// next to small purchases. A group with fewer than [minSamples] transactions has no
/// "normal" to compare with and flags nothing.
Set<int> detectAmountSpikes(
  List<CustomerTransaction> transactions, {
  required Set<String> customerAccounts,
  double factor = 5,
  int minSamples = 4,
}) {
  final groups = <(Currency, bool), List<CustomerTransaction>>{};
  for (final transaction in transactions) {
    final key = (
      transaction.currency,
      transaction.isIncomingFor(customerAccounts),
    );
    groups.putIfAbsent(key, () => []).add(transaction);
  }

  final spikes = <int>{};
  for (final group in groups.values) {
    if (group.length < minSamples) continue;
    final limit = factor * _median([for (final row in group) row.amount]);
    for (final transaction in group) {
      if (transaction.amount >= limit) spikes.add(transaction.id);
    }
  }
  return spikes;
}

/// Ids of the transactions the customer made at night (from [nightStartHour] to
/// [nightEndHour], 00:00–05:00 by default) or outside their usual hours.
///
/// An hour is outside the pattern when no other transaction of the customer is within
/// [tolerance] of it on the clock, on any day. That needs at least [minHistory]
/// transactions; with fewer, only the night counts.
///
/// Only money the customer sends counts: they do not choose when a credit arrives.
/// Hours are read in the analyst's time zone, like the rest of the app.
Set<int> detectUnusualHours(
  List<CustomerTransaction> transactions, {
  required Set<String> customerAccounts,
  int nightStartHour = 0,
  int nightEndHour = 5,
  int minHistory = 10,
  Duration tolerance = const Duration(minutes: 90),
}) {
  final own = [
    for (final transaction in transactions)
      if (!transaction.isIncomingFor(customerAccounts)) transaction,
  ];
  final minutes = [for (final row in own) _minuteOfDay(row.occurredAt)];
  final checkPattern = own.length >= minHistory;

  bool atNight(int minute) {
    final hour = minute ~/ 60;
    return nightStartHour <= nightEndHour
        ? hour >= nightStartHour && hour < nightEndHour
        : hour >= nightStartHour || hour < nightEndHour;
  }

  bool outsidePattern(int index) {
    for (var other = 0; other < minutes.length; other++) {
      if (other == index) continue;
      if (_clockDistance(minutes[index], minutes[other]) <=
          tolerance.inMinutes) {
        return false;
      }
    }
    return true;
  }

  return {
    for (var i = 0; i < own.length; i++)
      if (atNight(minutes[i]) || (checkPattern && outsidePattern(i))) own[i].id,
  };
}

/// Ids of the transactions that belong to a run of at least [minCount] transactions
/// within [window], in either direction.
Set<int> detectBursts(
  List<CustomerTransaction> transactions, {
  int minCount = 3,
  Duration window = const Duration(minutes: 20),
}) {
  final sorted = [...transactions]
    ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
  final bursts = <int>{};
  var first = 0;
  for (var last = 0; last < sorted.length; last++) {
    while (sorted[last].occurredAt.difference(sorted[first].occurredAt) >
        window) {
      first++;
    }
    if (last - first + 1 >= minCount) {
      for (var i = first; i <= last; i++) {
        bursts.add(sorted[i].id);
      }
    }
  }
  return bursts;
}

/// Every anomaly of every transaction, by transaction id, with the default thresholds.
/// Transactions without anomalies are left out.
Map<int, Set<ActivityAnomaly>> detectActivityAnomalies(
  List<CustomerTransaction> transactions, {
  required Set<String> customerAccounts,
}) {
  final found = {
    ActivityAnomaly.amountSpike: detectAmountSpikes(
      transactions,
      customerAccounts: customerAccounts,
    ),
    ActivityAnomaly.unusualHour: detectUnusualHours(
      transactions,
      customerAccounts: customerAccounts,
    ),
    ActivityAnomaly.burst: detectBursts(transactions),
  };
  final anomalies = <int, Set<ActivityAnomaly>>{};
  for (final MapEntry(key: anomaly, value: ids) in found.entries) {
    for (final id in ids) {
      anomalies.putIfAbsent(id, () => {}).add(anomaly);
    }
  }
  return anomalies;
}

/// The marks of the C-11 timeline, oldest first: the transactions with their anomalies
/// and the security events.
List<TimelinePoint> buildTimeline(
  CustomerActivity activity, {
  required Set<String> customerAccounts,
}) {
  final anomalies = detectActivityAnomalies(
    activity.transactions,
    customerAccounts: customerAccounts,
  );
  return [
    for (final transaction in activity.transactions)
      TimelinePoint.transaction(
        transaction,
        anomalies: anomalies[transaction.id] ?? const {},
      ),
    for (final event in activity.securityEvents)
      TimelinePoint.securityEvent(event),
  ]..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
}

num _median(List<num> values) {
  final sorted = [...values]..sort();
  final middle = sorted.length ~/ 2;
  return sorted.length.isOdd
      ? sorted[middle]
      : (sorted[middle - 1] + sorted[middle]) / 2;
}

const _minutesPerDay = 24 * 60;

int _minuteOfDay(DateTime instant) {
  final local = instant.toLocal();
  return local.hour * 60 + local.minute;
}

/// Minutes between two times of day, going round midnight: 23:30 and 00:30 are 60 apart.
int _clockDistance(int a, int b) {
  final distance = (a - b).abs();
  return distance < _minutesPerDay - distance
      ? distance
      : _minutesPerDay - distance;
}
