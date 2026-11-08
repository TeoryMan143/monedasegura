import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../domain/timeline_point.dart';
import 'timeline_layout.dart';

/// The overview strip under the timeline (DESIGN.md · Timeline): transactions per slice
/// of the whole range as azul-200 bars, the visible [window] in azul-500. Clicking it
/// moves the window to that instant ([onJump]).
class TimelineOverview extends StatelessWidget {
  const TimelineOverview({
    required this.timeline,
    required this.range,
    required this.window,
    required this.onJump,
    super.key,
  });

  final List<TimelinePoint> timeline;
  final DateTimeRange range;
  final DateTimeRange window;
  final ValueChanged<DateTime> onJump;

  static const height = 40.0;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      const left = TimelineLayout.gutter;
      final right = width - TimelineLayout.rightPadding;
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapUp: (details) {
            final x = details.localPosition.dx.clamp(left, right);
            final ratio = (x - left) / (right - left);
            onJump(
              range.start.add(
                Duration(
                  milliseconds: (range.duration.inMilliseconds * ratio).round(),
                ),
              ),
            );
          },
          child: CustomPaint(
            size: Size(width, height),
            painter: _OverviewPainter(
              timeline: timeline,
              range: range,
              window: window,
              left: left,
              right: right,
            ),
          ),
        ),
      );
    },
  );
}

class _OverviewPainter extends CustomPainter {
  _OverviewPainter({
    required this.timeline,
    required this.range,
    required this.window,
    required this.left,
    required this.right,
  });

  final List<TimelinePoint> timeline;
  final DateTimeRange range;
  final DateTimeRange window;
  final double left;
  final double right;

  static const _barGap = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    final label = TextPainter(
      text: TextSpan(
        text: 'Todo el rango',
        style: AppText.bodyS.copyWith(color: AppColors.textTertiary),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    label.paint(canvas, Offset(0, (size.height - label.height) / 2));

    // One slice per day, at most one per 4 px.
    final slices = math.max(
      1,
      math.min(range.duration.inDays, ((right - left) / 4).floor()),
    );
    final counts = List.filled(slices, 0);
    final span = range.duration.inMilliseconds;
    for (final point in timeline) {
      if (point is! TransactionPoint) continue;
      final offset = point.occurredAt.difference(range.start).inMilliseconds;
      final slice = (offset / span * slices).floor();
      if (slice >= 0 && slice < slices) counts[slice]++;
    }
    final most = counts.fold(0, math.max);
    final sliceWidth = (right - left) / slices;
    for (var i = 0; i < slices; i++) {
      if (counts[i] == 0) continue;
      final sliceStart = range.start.add(
        Duration(milliseconds: span * i ~/ slices),
      );
      final sliceEnd = range.start.add(
        Duration(milliseconds: span * (i + 1) ~/ slices),
      );
      final inWindow =
          sliceEnd.isAfter(window.start) && sliceStart.isBefore(window.end);
      final barHeight = math.max(2, size.height * counts[i] / most).toDouble();
      canvas.drawRect(
        Rect.fromLTWH(
          left + i * sliceWidth,
          size.height - barHeight,
          math.max(1, sliceWidth - _barGap).toDouble(),
          barHeight,
        ),
        Paint()..color = inWindow ? AppColors.azul500 : AppColors.azul200,
      );
    }

    // The visible window, at least 2 px wide so a one-hour window still shows.
    double xOf(DateTime instant) =>
        left +
        (right - left) *
            instant.difference(range.start).inMilliseconds /
            math.max(1, span);
    final windowLeft = xOf(window.start).clamp(left, right);
    final windowRight = math.max(
      windowLeft + 2,
      xOf(window.end).clamp(left, right),
    );
    canvas.drawRect(
      Rect.fromLTRB(windowLeft, 0, windowRight, size.height),
      Paint()
        ..color = AppColors.azul500
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_OverviewPainter old) =>
      !identical(old.timeline, timeline) ||
      old.range != range ||
      old.window != window ||
      old.right != right;
}
