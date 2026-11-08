import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart'
    show DateTimeRange, TextPainter, TextSpan;
import 'package:intl/intl.dart' show DateFormat;

import '../../../../../core/domain/currency.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/activity_analysis.dart';
import '../../../domain/activity_anomalies.dart';
import '../../../domain/timeline_point.dart';
import '../activity_style.dart';

/// A mark of the timeline already placed in pixels.
class PlacedMark {
  const PlacedMark(this.point, this.center, this.radius);

  final TimelinePoint point;
  final Offset center;
  final double radius;
}

/// One slice of time of a dense timeline: how many transactions it has, per label, drawn
/// as a stacked bar (DESIGN.md · Timeline, dense ranges).
class DensityBin {
  DensityBin({required this.bounds, required this.start, required this.end});

  /// The whole column of the slice in the transactions lane, for hit testing.
  final Rect bounds;
  final DateTime start;
  final DateTime end;

  /// Transactions per label tone, in [DensityBin.order].
  final counts = <StatusTone, int>{};
  int total = 0;

  /// Transactions of the slice with at least one anomaly.
  int withAnomalies = 0;

  /// Stacking order, bottom to top: Fraude, Incierto, Alerta IA, No fraude, Sin
  /// etiquetar.
  static const order = [
    StatusTone.danger,
    StatusTone.warning,
    StatusTone.info,
    StatusTone.success,
    StatusTone.neutral,
  ];
}

/// The icon and name of a security event, above or below its diamond (HU-10). Only the
/// ones that fit without overlapping get one; the tooltip names the rest.
class EventLabel {
  const EventLabel(this.mark, this.bounds);

  final PlacedMark mark;
  final Rect bounds;

  SecurityEventPoint get point => mark.point as SecurityEventPoint;
}

/// A tick of the time axis.
class TimelineTick {
  const TimelineTick(this.x, this.label);

  final double x;
  final String label;
}

/// Where every mark of the C-11 timeline goes for a [window] and a [width] (HU-10):
/// two lanes (security events on top, transactions below) and the time axis.
///
/// Transactions that would cover each other move up or down in their lane (a beeswarm),
/// so every one of a burst stays visible and clickable. Pure geometry, apart from the
/// painter, so hit testing uses the same positions that were drawn.
class TimelineLayout {
  TimelineLayout({
    required TimelineAnalysis analysis,
    required this.window,
    required this.width,
  }) {
    final maxAmount = <Currency, num>{};
    for (final point in analysis.timeline) {
      if (point case TransactionPoint(:final transaction)) {
        final max = maxAmount[transaction.currency] ?? 0;
        if (transaction.amount > max) {
          maxAmount[transaction.currency] = transaction.amount;
        }
      }
    }
    final visible = [
      for (final point in analysis.timeline)
        if (!point.occurredAt.isBefore(window.start) &&
            !point.occurredAt.isAfter(window.end))
          point,
    ];
    final transactions = visible.whereType<TransactionPoint>().length;
    dense = transactions > (plotRight - plotLeft) / _pixelsPerMark;
    if (dense) _buildBins(visible.whereType<TransactionPoint>());
    final placed = <PlacedMark>[];
    for (final point in visible) {
      final x = xOf(point.occurredAt);
      switch (point) {
        case TransactionPoint(:final transaction) when !dense:
          final radius =
              minRadius +
              (maxRadius - minRadius) *
                  math.sqrt(
                    transaction.amount / maxAmount[transaction.currency]!,
                  );
          final mark = PlacedMark(
            point,
            Offset(x, _swarmY(x, radius, placed)),
            radius,
          );
          placed.add(mark);
          marks.add(mark);
        case TransactionPoint():
          break;
        case SecurityEventPoint():
          marks.add(PlacedMark(point, Offset(x, eventsCenter), eventRadius));
      }
    }
    _placeEventLabels();
    if (window.duration <= _maxNightWindow) {
      final offset = customerClockOffsetOf(
        analysis.timeline.whereType<TransactionPoint>().map(
          (point) => point.transaction,
        ),
      );
      for (final night in customerNights(
        window.start,
        window.end,
        clockOffset: offset ?? Duration.zero,
      )) {
        nights.add((
          left: math.max(plotLeft, xOf(night.start)),
          right: math.min(plotRight, xOf(night.end)),
        ));
      }
    }
    for (final burst in analysis.bursts) {
      if (burst.end.isBefore(window.start) || burst.start.isAfter(window.end)) {
        continue;
      }
      bursts.add((
        left: math.max(plotLeft, xOf(burst.start) - bandPadding),
        right: math.min(plotRight, xOf(burst.end) + bandPadding),
        burst: burst,
      ));
    }
  }

  // Geometry of the chart, in logical pixels.
  static const height = 224.0;
  static const gutter = 136.0;
  static const rightPadding = 16.0;
  static const eventsTop = 8.0;
  static const eventsHeight = 48.0;
  static const transactionsTop = 64.0;
  static const transactionsHeight = 128.0;
  static const axisTop = 200.0;
  static const minRadius = 4.0;
  static const maxRadius = 14.0;
  static const eventRadius = 7.0;
  static const bandPadding = 10.0;
  static const _hitSlop = 4.0;

  /// Room kept at the top of the transactions lane for the burst text, and at the bottom
  /// for the unusual-hour bar.
  static const _laneTopRoom = 18.0;
  static const _laneBottomRoom = 8.0;

  /// Vertical step of the beeswarm and the space left between two marks (a spike ring
  /// is 3 px outside its circle).
  static const _swarmStep = 4.0;
  static const _swarmGap = 4.0;

  /// The customer's nights are shaded only up to a week: in a month they would be thin
  /// stripes.
  static const _maxNightWindow = Duration(days: 8);

  /// Height of an event label, its gap to the diamond and to the next label of its row.
  static const eventLabelHeight = 16.0;
  static const _eventLabelGap = 2.0;
  static const _eventLabelSpacing = 8.0;

  /// Below this many pixels per transaction the window is [dense].
  static const _pixelsPerMark = 4.0;

  /// Width of a slice of a dense timeline, and the room left above the tallest bar.
  static const binWidth = 6.0;
  static const _binHeadroom = 24.0;
  static const _minTickGap = 96.0;

  static double get eventsCenter => eventsTop + eventsHeight / 2;
  static double get transactionsCenter =>
      transactionsTop + transactionsHeight / 2;

  final DateTimeRange window;
  final double width;
  final marks = <PlacedMark>[];

  /// Too many transactions to draw one by one (thousands in a month): the lane shows
  /// [bins] instead, and clicking one zooms in. Security events stay as marks.
  late final bool dense;
  final bins = <DensityBin>[];
  final bursts = <({double left, double right, BurstWindow burst})>[];

  /// The customer's nights in the window, shaded (HU-10 · madrugada).
  final nights = <({double left, double right})>[];

  final eventLabels = <EventLabel>[];

  double get plotLeft => gutter;
  double get plotRight => width - rightPadding;

  /// Whether the window is a day or shorter: then the marks have room for text.
  bool get isZoomedIn => window.duration <= const Duration(days: 1);

  double xOf(DateTime instant) {
    final span = window.duration.inMilliseconds;
    final offset = instant.difference(window.start).inMilliseconds;
    return plotLeft + (plotRight - plotLeft) * (span == 0 ? 0 : offset / span);
  }

  /// The mark under [position] (the top one when several overlap), else the
  /// [DensityBin] under it. Null over nothing.
  Object? hit(Offset position) {
    for (final mark in marks.reversed) {
      if ((mark.center - position).distance <= mark.radius + _hitSlop) {
        return mark;
      }
    }
    for (final label in eventLabels) {
      if (label.bounds.contains(position)) return label.mark;
    }
    for (final bin in bins) {
      if (bin.total > 0 && bin.bounds.contains(position)) return bin;
    }
    return null;
  }

  /// Height in pixels of [count] transactions in a bar of the dense lane.
  double barHeight(int count) {
    final most = bins.fold(0, (most, bin) => math.max(most, bin.total));
    return most == 0 ? 0 : (transactionsHeight - _binHeadroom) * count / most;
  }

  double get barBaseline => transactionsTop + transactionsHeight;

  /// The height of the transactions lane closest to its middle where a circle of
  /// [radius] at [x] does not touch the circles already [placed] (left to right). With
  /// no free room left, the height where it overlaps the least.
  static double _swarmY(double x, double radius, List<PlacedMark> placed) {
    const reach = 2 * maxRadius + _swarmGap;
    final top = transactionsTop + _laneTopRoom + radius;
    final bottom =
        transactionsTop + transactionsHeight - _laneBottomRoom - radius;
    const tries = 2 * (transactionsHeight ~/ (2 * _swarmStep)) + 1;
    var best = transactionsCenter;
    var bestClearance = double.negativeInfinity;
    for (var k = 0; k < tries; k++) {
      // 0, -1, +1, -2, +2… steps from the middle.
      final steps = k.isEven ? k ~/ 2 : -(k + 1) ~/ 2;
      final y = transactionsCenter + steps * _swarmStep;
      if (y < top || y > bottom) continue;
      // Free space to the closest neighbour; negative when they overlap.
      var clearance = double.infinity;
      for (var i = placed.length - 1; i >= 0; i--) {
        final other = placed[i];
        if (x - other.center.dx > reach) break;
        clearance = math.min(
          clearance,
          (other.center - Offset(x, y)).distance -
              other.radius -
              radius -
              _swarmGap,
        );
      }
      if (clearance >= 0) return y;
      if (clearance > bestClearance) {
        best = y;
        bestClearance = clearance;
      }
    }
    return best;
  }

  /// Gives each security event its icon and name, above or below its diamond, where
  /// it does not overlap another. The ones that are not routine go first.
  void _placeEventLabels() {
    final events = marks.where((mark) => mark.point is SecurityEventPoint);
    final ordered = [
      ...events.where((mark) => !_isRoutine(mark)),
      ...events.where(_isRoutine),
    ];
    final aboveTop =
        eventsCenter - eventRadius - _eventLabelGap - eventLabelHeight;
    final belowTop = eventsCenter + eventRadius + _eventLabelGap;
    final rows = {aboveTop: <Rect>[], belowTop: <Rect>[]};
    for (final mark in ordered) {
      final event = (mark.point as SecurityEventPoint).event;
      final text = TextPainter(
        text: TextSpan(text: event.type.label, style: AppText.bodyS),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      final width = AppIconSize.xs + AppSpace.xs + text.width;
      text.dispose();
      final left = (mark.center.dx - width / 2)
          .clamp(plotLeft, math.max(plotLeft, plotRight - width))
          .toDouble();
      for (final MapEntry(key: top, value: taken) in rows.entries) {
        final bounds = Rect.fromLTWH(left, top, width, eventLabelHeight);
        final free = taken.every(
          (other) => !bounds
              .inflate(_eventLabelSpacing / 2)
              .overlaps(other.inflate(_eventLabelSpacing / 2)),
        );
        if (!free) continue;
        taken.add(bounds);
        eventLabels.add(EventLabel(mark, bounds));
        break;
      }
    }
  }

  /// A successful login or logout: shown, but named only when there is room left.
  static bool _isRoutine(PlacedMark mark) {
    final event = (mark.point as SecurityEventPoint).event;
    return event.succeeded && event.type.tone == StatusTone.neutral;
  }

  void _buildBins(Iterable<TransactionPoint> transactions) {
    final count = math.max(1, ((plotRight - plotLeft) / binWidth).floor());
    final width = (plotRight - plotLeft) / count;
    final span = window.duration.inMicroseconds;
    for (var i = 0; i < count; i++) {
      bins.add(
        DensityBin(
          bounds: Rect.fromLTWH(
            plotLeft + i * width,
            transactionsTop,
            width,
            transactionsHeight,
          ),
          start: window.start.add(Duration(microseconds: span * i ~/ count)),
          end: window.start.add(
            Duration(microseconds: span * (i + 1) ~/ count),
          ),
        ),
      );
    }
    for (final point in transactions) {
      final i = ((xOf(point.occurredAt) - plotLeft) / width).floor().clamp(
        0,
        count - 1,
      );
      final bin = bins[i];
      final tone = point.transaction.statusTone;
      bin.counts[tone] = (bin.counts[tone] ?? 0) + 1;
      bin.total++;
      if (point.anomalies.isNotEmpty) bin.withAnomalies++;
    }
  }

  /// Ticks of the axis at round times of the analyst's clock, at least
  /// [_minTickGap] apart.
  List<TimelineTick> ticks() {
    final maxTicks = math.max(2, (plotRight - plotLeft) ~/ _minTickGap);
    final span = window.duration;
    final step = _steps.firstWhere(
      (step) => span.inMinutes / step.inMinutes <= maxTicks,
      orElse: () => _steps.last,
    );
    final start = window.start.toLocal();
    final midnight = DateTime(start.year, start.month, start.day);
    final steps = (start.difference(midnight).inMinutes / step.inMinutes)
        .ceil();
    final hour = DateFormat('HH:mm', 'es');
    final day = DateFormat('d MMM', 'es');
    final ticks = <TimelineTick>[];
    for (
      var at = midnight.add(step * steps);
      !at.isAfter(window.end);
      at = at.add(step)
    ) {
      final isMidnight = at.hour == 0 && at.minute == 0;
      ticks.add(
        TimelineTick(
          xOf(at),
          step < const Duration(days: 1) && !isMidnight
              ? hour.format(at)
              : day.format(at),
        ),
      );
    }
    return ticks;
  }

  static const _steps = [
    Duration(minutes: 5),
    Duration(minutes: 10),
    Duration(minutes: 15),
    Duration(minutes: 30),
    Duration(hours: 1),
    Duration(hours: 2),
    Duration(hours: 3),
    Duration(hours: 6),
    Duration(hours: 12),
    Duration(days: 1),
    Duration(days: 2),
    Duration(days: 7),
    Duration(days: 14),
    Duration(days: 30),
  ];
}
