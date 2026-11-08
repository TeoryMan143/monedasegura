import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart' show DateTimeRange;
import 'package:intl/intl.dart';

import '../../../../../core/domain/currency.dart';
import '../../../domain/activity_analysis.dart';
import '../../../domain/timeline_point.dart';

/// A mark of the timeline already placed in pixels.
class PlacedMark {
  const PlacedMark(this.point, this.center, this.radius);

  final TimelinePoint point;
  final Offset center;
  final double radius;
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
/// Pure geometry, apart from the painter, so hit testing uses the same positions that
/// were drawn.
class TimelineLayout {
  TimelineLayout({
    required ActivityAnalysis analysis,
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
    dense = visible.length > (plotRight - plotLeft) / _pixelsPerMark;
    for (final point in visible) {
      final x = xOf(point.occurredAt);
      marks.add(switch (point) {
        TransactionPoint(:final transaction) => PlacedMark(
          point,
          Offset(x, transactionsCenter),
          dense
              ? minRadius
              : minRadius +
                    (maxRadius - minRadius) *
                        math.sqrt(
                          transaction.amount / maxAmount[transaction.currency]!,
                        ),
        ),
        SecurityEventPoint() => PlacedMark(
          point,
          Offset(x, eventsCenter),
          eventRadius,
        ),
      });
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

  /// Below this many pixels per mark the window is [dense].
  static const _pixelsPerMark = 4.0;
  static const _minTickGap = 96.0;

  static double get eventsCenter => eventsTop + eventsHeight / 2;
  static double get transactionsCenter =>
      transactionsTop + transactionsHeight / 2;

  final DateTimeRange window;
  final double width;
  final marks = <PlacedMark>[];

  /// Too many marks for their sizes to mean anything (thousands in a month): they are
  /// all small and drawn in batches. Zooming in brings the sizes back.
  late final bool dense;
  final bursts = <({double left, double right, BurstWindow burst})>[];

  double get plotLeft => gutter;
  double get plotRight => width - rightPadding;

  /// Whether the window is a day or shorter: then the marks have room for text.
  bool get isZoomedIn => window.duration <= const Duration(days: 1);

  double xOf(DateTime instant) {
    final span = window.duration.inMilliseconds;
    final offset = instant.difference(window.start).inMilliseconds;
    return plotLeft + (plotRight - plotLeft) * (span == 0 ? 0 : offset / span);
  }

  /// The mark under [position], the top one when several overlap.
  PlacedMark? hit(Offset position) {
    for (final mark in marks.reversed) {
      if ((mark.center - position).distance <= mark.radius + _hitSlop) {
        return mark;
      }
    }
    return null;
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
