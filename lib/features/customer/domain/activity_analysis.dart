import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_anomalies.dart';
import 'customer_activity.dart';
import 'impossible_travel.dart';
import 'map_point.dart';
import 'timeline_point.dart';

part 'activity_analysis.freezed.dart';

// The rules of HU-10 and HU-11 over the [CustomerActivity] of a range. Each tab runs only
// its own analysis. Both are pure and sendable, so a long range can run them in
// `Isolate.run`.

/// A run of transactions flagged as [ActivityAnomaly.burst], drawn as one band on the
/// timeline (HU-10).
@freezed
abstract class BurstWindow with _$BurstWindow {
  const factory BurstWindow({
    required DateTime start,
    required DateTime end,
    required int count,
  }) = _BurstWindow;
}

/// What the C-11 timeline draws for a customer and a range (HU-10).
@freezed
abstract class TimelineAnalysis with _$TimelineAnalysis {
  const factory TimelineAnalysis({
    /// Transactions with their anomalies and security events, oldest first.
    required List<TimelinePoint> timeline,
    required List<BurstWindow> bursts,

    /// The range had more activity than was read (see [CustomerActivity.truncated]).
    @Default(false) bool truncated,
  }) = _TimelineAnalysis;

  const TimelineAnalysis._();

  bool get isEmpty => timeline.isEmpty;

  /// Transactions flagged with [anomaly], for the text summary of the highlights.
  int countOf(ActivityAnomaly anomaly) => timeline
      .where(
        (point) =>
            point is TransactionPoint && point.anomalies.contains(anomaly),
      )
      .length;

  int get securityEventCount => timeline.whereType<SecurityEventPoint>().length;
}

/// What the C-12 map draws for a customer and a range (HU-11).
@freezed
abstract class MapAnalysis with _$MapAnalysis {
  const factory MapAnalysis({
    /// The transactions with a place, oldest first.
    required List<MapPoint> points,
    required List<ImpossibleTravel> trips,

    /// Anomalies by transaction id, for the detail card. Ids without any are left out.
    required Map<int, Set<ActivityAnomaly>> anomalies,

    /// Transactions without a place, which the map cannot show.
    required int withoutPlace,

    /// The range had more activity than was read (see [CustomerActivity.truncated]).
    @Default(false) bool truncated,
  }) = _MapAnalysis;

  const MapAnalysis._();

  bool get isEmpty => points.isEmpty;

  Set<ActivityAnomaly> anomaliesOf(int id) => anomalies[id] ?? const {};
}

/// The timeline of [activity]: its marks, with anomalies, and the burst bands.
TimelineAnalysis analyzeTimeline(
  CustomerActivity activity, {
  required Set<String> customerAccounts,
}) {
  final timeline = buildTimeline(activity, customerAccounts: customerAccounts);
  return TimelineAnalysis(
    timeline: timeline,
    bursts: burstWindowsOf(timeline),
    truncated: activity.truncated,
  );
}

/// The map of [activity]: its markers, the impossible trips between consecutive ones
/// and the anomalies of each transaction.
MapAnalysis analyzeMap(
  CustomerActivity activity, {
  required Set<String> customerAccounts,
}) {
  final points = mapPointsOf(activity.transactions);
  return MapAnalysis(
    points: points,
    trips: detectImpossibleTravel(points),
    anomalies: detectActivityAnomalies(
      activity.transactions,
      customerAccounts: customerAccounts,
    ),
    withoutPlace: activity.transactions.length - points.length,
    truncated: activity.truncated,
  );
}

/// Groups the burst transactions of [timeline] (oldest first) into bands: two burst
/// transactions less than [gap] apart are in the same band.
List<BurstWindow> burstWindowsOf(
  List<TimelinePoint> timeline, {
  Duration gap = const Duration(minutes: 20),
}) {
  final windows = <BurstWindow>[];
  DateTime? start;
  DateTime? end;
  var count = 0;
  for (final point in timeline) {
    if (point is! TransactionPoint ||
        !point.anomalies.contains(ActivityAnomaly.burst)) {
      continue;
    }
    final at = point.occurredAt;
    if (end != null && at.difference(end) <= gap) {
      end = at;
      count++;
      continue;
    }
    if (start != null) {
      windows.add(BurstWindow(start: start, end: end!, count: count));
    }
    start = at;
    end = at;
    count = 1;
  }
  if (start != null) {
    windows.add(BurstWindow(start: start, end: end!, count: count));
  }
  return windows;
}
