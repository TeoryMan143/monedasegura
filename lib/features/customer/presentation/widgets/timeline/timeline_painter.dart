import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/domain/label_status.dart';
import '../../../../../core/domain/verdict.dart';
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
    if (layout.dense) _paintBins(canvas);
    // In a dense window the marks are only the security events.
    for (final mark in layout.marks) {
      switch (mark.point) {
        case TransactionPoint(:final transaction, :final anomalies):
          _paintTransaction(canvas, mark, transaction.labelTone, anomalies);
        case SecurityEventPoint():
          _paintEvent(canvas, mark);
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

  /// A dense window: one bar per slice of time, stacked by label, with a high-tone cap
  /// on the slices that hold an anomaly. Clicking a bar zooms in.
  void _paintBins(Canvas canvas) {
    final cap = Paint()..color = StatusTone.high.solid;
    for (final bin in layout.bins) {
      if (bin.total == 0) continue;
      var top = layout.barBaseline;
      for (final tone in DensityBin.order) {
        final count = bin.counts[tone] ?? 0;
        if (count == 0) continue;
        final height = layout.barHeight(count);
        canvas.drawRect(
          Rect.fromLTRB(
            bin.bounds.left + 0.5,
            top - height,
            bin.bounds.right - 0.5,
            top,
          ),
          Paint()..color = tone.solid,
        );
        top -= height;
      }
      if (bin.withAnomalies > 0) {
        canvas.drawRect(
          Rect.fromLTRB(
            bin.bounds.left + 0.5,
            top - 4,
            bin.bounds.right - 0.5,
            top - 1,
          ),
          cap,
        );
      }
    }
    _text(
      canvas,
      'Transacciones por franja · clic para acercar',
      _axisStyle,
      Offset(layout.plotRight, TimelineLayout.transactionsTop + 2),
      anchor: Alignment.topRight,
    );
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

/// The tooltip of what is under the mouse: a transaction (code, amount, date, label,
/// customer's clock, anomalies), a security event (type, date, result) or a slice of a
/// dense timeline (its counts) (DESIGN.md · tooltip).
class TimelineHoverPainter extends CustomPainter {
  TimelineHoverPainter({required this.hovered, required this.layout});

  /// A [PlacedMark], a [DensityBin] or null.
  final Object? hovered;
  final TimelineLayout layout;

  @override
  void paint(Canvas canvas, Size size) {
    switch (hovered) {
      case final PlacedMark mark:
        _paintTooltip(canvas, _markLines(mark), mark.center, mark.radius, size);
      case final DensityBin bin:
        final top = layout.barBaseline - layout.barHeight(bin.total);
        _paintTooltip(
          canvas,
          _binLines(bin),
          Offset(bin.bounds.center.dx, top),
          0,
          size,
        );
    }
  }

  static List<String> _markLines(PlacedMark mark) => switch (mark.point) {
    TransactionPoint(:final transaction, :final anomalies) => [
      '${transaction.code} · '
          '${formatMoney(transaction.amount, transaction.currency)}',
      '${formatDateTime(transaction.occurredAt)} · ${transaction.labelText}',
      if (transaction.customerClock case final clock?)
        'Hora del cliente: $clock',
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

  static List<String> _binLines(DensityBin bin) {
    final sameDay = formatDate(bin.start) == formatDate(bin.end);
    final labels = {
      StatusTone.danger: Verdict.fraud.label,
      StatusTone.warning: Verdict.uncertain.label,
      StatusTone.success: Verdict.notFraud.label,
      StatusTone.neutral: LabelStatus.unlabeled.label,
    };
    return [
      sameDay
          ? '${formatDateTime(bin.start)}–${formatTime(bin.end)}'
          : '${formatDateTime(bin.start)} – ${formatDateTime(bin.end)}',
      bin.total == 1 ? '1 transacción' : '${bin.total} transacciones',
      [
        for (final tone in DensityBin.order)
          if ((bin.counts[tone] ?? 0) > 0)
            '${labels[tone]} ${bin.counts[tone]}',
      ].join(' · '),
      if (bin.withAnomalies > 0) '${bin.withAnomalies} con anomalías',
      'Clic para acercar',
    ];
  }

  void _paintTooltip(
    Canvas canvas,
    List<String> lines,
    Offset anchor,
    double radius,
    Size size,
  ) {
    final text = TextPainter(
      text: TextSpan(
        text: lines.join('\n'),
        style: AppText.bodyS.copyWith(color: AppColors.textOnBrand),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: AppSizes.tooltipMaxWidth);
    const pad = AppSpace.sm;
    final boxSize = Size(text.width + 2 * pad, text.height + 2 * pad);
    final above = anchor.dy - radius - AppSpace.sm - boxSize.height;
    final top = above >= 0 ? above : anchor.dy + radius + AppSpace.sm;
    final left = (anchor.dx - boxSize.width / 2)
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
  bool shouldRepaint(TimelineHoverPainter old) =>
      old.hovered != hovered || old.layout != layout;
}
