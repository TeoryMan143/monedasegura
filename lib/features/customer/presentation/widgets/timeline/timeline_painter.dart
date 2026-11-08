import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/formatting/date_time.dart';
import '../../../../../core/formatting/money.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/timeline_point.dart';
import '../activity_style.dart';
import 'timeline_layout.dart';

/// Paints the C-11 timeline from a [TimelineLayout] (DESIGN.md · Timeline): lane names,
/// grid and time axis, burst bands, transactions as circles sized by amount and coloured
/// by label, security events as diamonds and the selection outline.
///
/// The hover tooltip is [TimelineHoverPainter], on its own layer: moving the mouse must
/// not repaint thousands of marks (160 ms per frame in the load test).
class TimelinePainter extends CustomPainter {
  TimelinePainter({required this.layout, required this.selected});

  final TimelineLayout layout;
  final TimelinePoint? selected;

  static final _axisStyle = AppText.bodyS.copyWith(
    color: AppColors.textTertiary,
  );

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas);
    _paintBursts(canvas);
    if (layout.dense) {
      _paintDense(canvas);
    } else {
      for (final mark in layout.marks) {
        switch (mark.point) {
          case TransactionPoint(:final transaction, :final anomalies):
            _paintTransaction(canvas, mark, transaction.labelTone, anomalies);
          case SecurityEventPoint():
            _paintEvent(canvas, mark);
        }
      }
    }
    for (final mark in layout.marks) {
      if (mark.point == selected) {
        canvas.drawCircle(
          mark.center,
          mark.radius + 4,
          _stroke(AppColors.azul500, 3),
        );
      }
    }
  }

  /// Thousands of marks: one path per colour instead of a draw call per mark, no white
  /// outline, and the unusual-hour bars in one path too.
  void _paintDense(Canvas canvas) {
    final byColor = <Color, Path>{};
    final unusual = Path();
    final spikes = Path();
    for (final mark in layout.marks) {
      final c = mark.center;
      final r = mark.radius;
      switch (mark.point) {
        case TransactionPoint(:final transaction, :final anomalies):
          byColor
              .putIfAbsent(transaction.labelTone.solid, Path.new)
              .addOval(Rect.fromCircle(center: c, radius: r));
          if (anomalies.contains(ActivityAnomaly.unusualHour)) {
            unusual.addRect(Rect.fromLTWH(c.dx - r, c.dy + r + 4, 2 * r, 3));
          }
          if (anomalies.contains(ActivityAnomaly.amountSpike)) {
            spikes.addOval(Rect.fromCircle(center: c, radius: r + 3));
          }
        case SecurityEventPoint():
          byColor
              .putIfAbsent(StatusTone.high.solid, Path.new)
              .addPath(_diamond(c, r), Offset.zero);
      }
    }
    for (final MapEntry(key: color, value: path) in byColor.entries) {
      canvas.drawPath(path, Paint()..color = color);
    }
    canvas
      ..drawPath(
        unusual,
        Paint()..color = ActivityAnomaly.unusualHour.tone.solid,
      )
      ..drawPath(spikes, _stroke(ActivityAnomaly.amountSpike.tone.solid, 2));
  }

  void _paintGrid(Canvas canvas) {
    final line = Paint()
      ..color = AppColors.borderSubtle
      ..strokeWidth = 1;
    final lanes = [
      ('Eventos de seguridad', TimelineLayout.eventsCenter),
      ('Transacciones', TimelineLayout.transactionsCenter),
    ];
    for (final (name, y) in lanes) {
      _text(
        canvas,
        name,
        _axisStyle,
        Offset(0, y),
        anchor: Alignment.centerLeft,
      );
      canvas.drawLine(
        Offset(layout.plotLeft, y),
        Offset(layout.plotRight, y),
        line,
      );
    }
    const top = TimelineLayout.eventsTop;
    const bottom = TimelineLayout.axisTop;
    for (final tick in layout.ticks()) {
      canvas.drawLine(Offset(tick.x, top), Offset(tick.x, bottom), line);
      _text(
        canvas,
        tick.label,
        _axisStyle,
        Offset(tick.x, bottom + AppSpace.xs),
        anchor: Alignment.topCenter,
      );
    }
  }

  void _paintBursts(Canvas canvas) {
    const tone = StatusTone.danger;
    for (final (:left, :right, :burst) in layout.bursts) {
      canvas.drawRect(
        Rect.fromLTRB(
          left,
          TimelineLayout.transactionsTop,
          right,
          TimelineLayout.transactionsTop + TimelineLayout.transactionsHeight,
        ),
        Paint()..color = tone.background,
      );
      // The text only where it fits, so neighbour bands do not pile their labels.
      final label = _textPainter(
        'Ráfaga · ${burst.count}',
        AppText.bodySSemiBold.copyWith(color: tone.text),
      );
      final x = math.min(
        left + AppSpace.xs,
        layout.plotRight - label.width - AppSpace.xs,
      );
      if (label.width + 2 * AppSpace.xs <= right - left) {
        label.paint(canvas, Offset(x, TimelineLayout.transactionsTop + 2));
      }
    }
  }

  void _paintTransaction(
    Canvas canvas,
    PlacedMark mark,
    StatusTone tone,
    Set<ActivityAnomaly> anomalies,
  ) {
    final center = mark.center;
    final r = mark.radius;
    if (anomalies.contains(ActivityAnomaly.unusualHour)) {
      final tone = ActivityAnomaly.unusualHour.tone;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(center.dx - r, center.dy + r + 4, 2 * r, 3),
          const Radius.circular(2),
        ),
        Paint()..color = tone.solid,
      );
      if (layout.isZoomedIn) {
        _text(
          canvas,
          'Horario inusual',
          AppText.bodyS.copyWith(color: tone.text),
          Offset(center.dx, center.dy + r + 9),
          anchor: Alignment.topCenter,
        );
      }
    }
    canvas
      ..drawCircle(center, r, Paint()..color = tone.solid)
      ..drawCircle(center, r, _stroke(AppColors.bgSurface, 1.5));
    if (anomalies.contains(ActivityAnomaly.amountSpike)) {
      canvas.drawCircle(
        center,
        r + 3,
        _stroke(ActivityAnomaly.amountSpike.tone.solid, 2),
      );
    }
  }

  /// Every security event is a high-tone diamond; the tooltip and the card name it.
  void _paintEvent(Canvas canvas, PlacedMark mark) {
    final diamond = _diamond(mark.center, mark.radius);
    canvas
      ..drawPath(diamond, Paint()..color = StatusTone.high.solid)
      ..drawPath(diamond, _stroke(AppColors.bgSurface, 1.5));
  }

  static Path _diamond(Offset c, double r) => Path()
    ..moveTo(c.dx, c.dy - r)
    ..lineTo(c.dx + r, c.dy)
    ..lineTo(c.dx, c.dy + r)
    ..lineTo(c.dx - r, c.dy)
    ..close();

  static Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width;

  static TextPainter _textPainter(String text, TextStyle style) => TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout();

  /// Draws [text] with [anchor] of its box at [at].
  static void _text(
    Canvas canvas,
    String text,
    TextStyle style,
    Offset at, {
    required Alignment anchor,
  }) {
    final painter = _textPainter(text, style);
    painter.paint(canvas, at - anchor.alongSize(painter.size));
  }

  @override
  bool shouldRepaint(TimelinePainter old) =>
      old.layout != layout || old.selected != selected;
}

/// The tooltip of the hovered mark of the timeline: code, amount, date, label and
/// anomalies, or the event and its result (DESIGN.md · tooltip).
class TimelineHoverPainter extends CustomPainter {
  TimelineHoverPainter({required this.hovered});

  final PlacedMark? hovered;

  @override
  void paint(Canvas canvas, Size size) {
    if (hovered case final mark?) _paintTooltip(canvas, mark, size);
  }

  void _paintTooltip(Canvas canvas, PlacedMark mark, Size size) {
    final lines = switch (mark.point) {
      TransactionPoint(:final transaction, :final anomalies) => [
        '${transaction.code} · '
            '${formatMoney(transaction.amount, transaction.currency)}',
        '${formatDateTime(transaction.occurredAt)} · ${transaction.labelText}',
        if (anomalies.isNotEmpty)
          [
            for (final anomaly in ActivityAnomaly.values)
              if (anomalies.contains(anomaly)) anomaly.label,
          ].join(' · '),
      ],
      SecurityEventPoint(:final event) => [
        event.type.label,
        formatDateTime(event.occurredAt),
        if (!event.succeeded) 'Fallido',
      ],
    };
    final text = TextPainter(
      text: TextSpan(
        text: lines.join('\n'),
        style: AppText.bodyS.copyWith(color: AppColors.textOnBrand),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: AppSizes.tooltipMaxWidth);
    const pad = AppSpace.sm;
    final boxSize = Size(text.width + 2 * pad, text.height + 2 * pad);
    final above = mark.center.dy - mark.radius - AppSpace.sm - boxSize.height;
    final top = above >= 0 ? above : mark.center.dy + mark.radius + AppSpace.sm;
    final left = (mark.center.dx - boxSize.width / 2)
        .clamp(0, math.max(0, size.width - boxSize.width))
        .toDouble();
    final box = Offset(left, top) & boxSize;
    canvas.drawRRect(
      RRect.fromRectAndRadius(box, const Radius.circular(AppRadius.sm)),
      Paint()..color = AppColors.gris900,
    );
    text.paint(canvas, box.topLeft + const Offset(pad, pad));
  }

  @override
  bool shouldRepaint(TimelineHoverPainter old) => old.hovered != hovered;
}
