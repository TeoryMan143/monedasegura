import 'package:flutter/material.dart';

import '../../../../core/domain/label_status.dart';
import '../../../../core/domain/verdict.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/activity_anomalies.dart';
import '../../domain/timeline_point.dart';
import 'activity_style.dart';

enum _Shape { circle, diamond, band, bar, ring, line }

/// «05:00».
String _hour(int hour) => '${hour.toString().padLeft(2, '0')}:00';

/// Legend of the timeline ([timeline] true) or the map: every item is a shape and a
/// text, never a colour alone (DESIGN.md · Data visualisation). Marks are coloured by
/// label, else by AI alert.
class ActivityLegend extends StatelessWidget {
  const ActivityLegend({required this.timeline, super.key});

  final bool timeline;

  @override
  Widget build(BuildContext context) {
    final labels = [
      for (final verdict in Verdict.values)
        (_Shape.circle, verdict.tone.solid, verdict.label),
      (_Shape.circle, StatusTone.info.solid, 'Alerta IA sin etiquetar'),
      (
        _Shape.circle,
        LabelStatus.unlabeled.tone.solid,
        LabelStatus.unlabeled.label,
      ),
    ];
    final items = timeline
        ? [
            ...labels,
            (_Shape.diamond, StatusTone.high.solid, 'Evento de seguridad'),
            (
              _Shape.band,
              ActivityAnomaly.burst.tone.background,
              ActivityAnomaly.burst.label,
            ),
            (
              _Shape.bar,
              ActivityAnomaly.unusualHour.tone.solid,
              ActivityAnomaly.unusualHour.label,
            ),
            (
              _Shape.ring,
              ActivityAnomaly.amountSpike.tone.solid,
              ActivityAnomaly.amountSpike.label,
            ),
            (
              _Shape.band,
              AppColors.bgSurfaceSubtle,
              'Madrugada del cliente (${_hour(defaultNightStartHour)}–'
                  '${_hour(defaultNightEndHour)})',
            ),
          ]
        : [
            ...labels,
            (_Shape.line, AppColors.azul300, 'Recorrido'),
            (_Shape.line, StatusTone.danger.solid, 'Viaje imposible'),
          ];
    return Wrap(
      spacing: AppSpace.lg,
      runSpacing: AppSpace.xs,
      children: [
        for (final (shape, color, label) in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomPaint(
                size: const Size.square(AppIconSize.sm),
                painter: _ShapePainter(shape, color),
              ),
              const SizedBox(width: AppSpace.xs),
              Text(
                label,
                style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
      ],
    );
  }
}

class _ShapePainter extends CustomPainter {
  _ShapePainter(this.shape, this.color);

  final _Shape shape;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 3;
    final fill = Paint()..color = color;
    switch (shape) {
      case _Shape.circle:
        canvas.drawCircle(c, r, fill);
      case _Shape.diamond:
        canvas.drawPath(
          Path()
            ..moveTo(c.dx, c.dy - r)
            ..lineTo(c.dx + r, c.dy)
            ..lineTo(c.dx, c.dy + r)
            ..lineTo(c.dx - r, c.dy)
            ..close(),
          fill,
        );
      case _Shape.band:
        canvas.drawRect(Offset.zero & size, fill);
      case _Shape.bar:
        canvas.drawRect(
          Rect.fromCenter(center: c, width: size.width, height: 3),
          fill,
        );
      case _Shape.ring:
        canvas.drawCircle(
          c,
          r,
          fill
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      case _Shape.line:
        canvas.drawLine(
          Offset(0, c.dy),
          Offset(size.width, c.dy),
          fill..strokeWidth = 3,
        );
    }
  }

  @override
  bool shouldRepaint(_ShapePainter old) =>
      old.shape != shape || old.color != color;
}
