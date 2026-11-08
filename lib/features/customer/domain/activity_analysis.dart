import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_anomalies.dart';
import 'customer_activity.dart';
import 'impossible_travel.dart';
import 'map_point.dart';
import 'timeline_point.dart';

part 'activity_analysis.freezed.dart';

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

/// What the timeline and the map draw for a customer and a range (HU-10, HU-11), worked
/// out once from [CustomerActivity].
@freezed
abstract class ActivityAnalysis with _$ActivityAnalysis {
  const factory ActivityAnalysis({
    /// Oldest first.
    required List<TimelinePoint> timeline,
    required List<BurstWindow> bursts,

    /// The transactions with a place, oldest first.
    required List<MapPoint> mapPoints,
    required List<ImpossibleTravel> trips,

    /// Transactions without a place, which the map cannot show.
    required int withoutPlace,
    @Default(false) bool truncated,
  }) = _ActivityAnalysis;

  const ActivityAnalysis._();

  bool get isEmpty => timeline.isEmpty;

  /// The anomalies of the transaction [id], for the map's detail card.
  Set<ActivityAnomaly> anomaliesOf(int id) {
    for (final point in timeline) {
      if (point case TransactionPoint(:final transaction, :final anomalies)
          when transaction.id == id) {
        return anomalies;
      }
    }
    return const {};
  }
}

/// Every rule of HU-10 and HU-11 over [activity]. Pure and sendable, so a long range
/// can run it in `Isolate.run`.
ActivityAnalysis analyzeActivity(
  CustomerActivity activity, {
  required Set<String> customerAccounts,
}) {
  final timeline = buildTimeline(activity, customerAccounts: customerAccounts);
  final mapPoints = mapPointsOf(activity.transactions);
  return ActivityAnalysis(
    timeline: timeline,
    bursts: burstWindowsOf(timeline),
    mapPoints: mapPoints,
    trips: detectImpossibleTravel(mapPoints),
    withoutPlace: activity.transactions.length - mapPoints.length,
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
