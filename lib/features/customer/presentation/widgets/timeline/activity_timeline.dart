import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/ui/kit.dart';
import '../../../domain/activity_analysis.dart';
import '../../../domain/timeline_point.dart';
import '../activity_style.dart';
import 'timeline_layout.dart';
import 'timeline_painter.dart';

/// C-11 · The two lanes of the customer timeline (HU-10) for the time [window]: hover a
/// mark for its tooltip, click it to select it ([onSelect]). In a dense window the
/// transactions are bars per slice of time; clicking one zooms in on it ([onZoomTo]).
///
/// One [CustomPaint] draws every mark, so thousands of transactions cost one paint. The
/// status icon of the marks big enough to hold it and the icon and name of the security
/// events are widgets above it: a window has at most a few hundred marks. Hover is
/// local, ephemeral state of this widget.
class ActivityTimeline extends StatefulWidget {
  const ActivityTimeline({
    required this.analysis,
    required this.window,
    required this.selected,
    required this.onSelect,
    required this.onZoomTo,
    super.key,
  });

  final TimelineAnalysis analysis;
  final DateTimeRange window;
  final TimelinePoint? selected;
  final ValueChanged<TimelinePoint> onSelect;

  /// Receives the middle of the clicked slice of a dense window.
  final ValueChanged<DateTime> onZoomTo;

  @override
  State<ActivityTimeline> createState() => _ActivityTimelineState();
}

class _ActivityTimelineState extends State<ActivityTimeline> {
  /// A [PlacedMark], a [DensityBin] or null.
  Object? _hovered;
  TimelineLayout? _layout;

  /// The layout only changes with the data, the window or the width; hovering reuses it.
  TimelineLayout _layoutFor(double width) {
    final layout = _layout;
    if (layout != null &&
        layout.width == width &&
        layout.window == widget.window &&
        identical(_analysis, widget.analysis)) {
      return layout;
    }
    _analysis = widget.analysis;
    return _layout = TimelineLayout(
      analysis: widget.analysis,
      window: widget.window,
      width: width,
    );
  }

  TimelineAnalysis? _analysis;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final layout = _layoutFor(constraints.maxWidth);
      final hovered =
          layout.marks.contains(_hovered) || layout.bins.contains(_hovered)
          ? _hovered
          : null;
      return MouseRegion(
        cursor: hovered == null ? MouseCursor.defer : SystemMouseCursors.click,
        onHover: (event) {
          final mark = layout.hit(event.localPosition);
          if (mark != _hovered) setState(() => _hovered = mark);
        },
        onExit: (_) => setState(() => _hovered = null),
        child: GestureDetector(
          onTapUp: (details) {
            switch (layout.hit(details.localPosition)) {
              case final PlacedMark mark:
                widget.onSelect(mark.point);
              case final DensityBin bin:
                widget.onZoomTo(
                  bin.start.add(bin.end.difference(bin.start) ~/ 2),
                );
            }
          },
          child: Stack(
            children: [
              // Its own layer: hovering repaints only the tooltip above it.
              RepaintBoundary(
                child: CustomPaint(
                  size: Size(constraints.maxWidth, TimelineLayout.height),
                  painter: TimelinePainter(
                    layout: layout,
                    selected: widget.selected,
                  ),
                ),
              ),
              for (final mark in layout.marks)
                if (mark.point case TransactionPoint(:final transaction)
                    when mark.radius >= _iconMarkRadius)
                  Positioned(
                    left: mark.center.dx - AppIconSize.xs / 2,
                    top: mark.center.dy - AppIconSize.xs / 2,
                    child: IgnorePointer(
                      child: AppIcon(
                        transaction.statusIcon,
                        size: AppIconSize.xs,
                        color: transaction.statusTone.onSolid,
                      ),
                    ),
                  ),
              for (final label in layout.eventLabels)
                Positioned.fromRect(
                  rect: label.bounds,
                  child: IgnorePointer(child: _EventName(label.point)),
                ),
              Positioned.fill(
                child: CustomPaint(
                  painter: TimelineHoverPainter(
                    hovered: hovered,
                    layout: layout,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Radius from which a transaction mark shows its status icon inside.
const _iconMarkRadius = 9.0;

/// The icon and name of a security event, in the tone of its type.
class _EventName extends StatelessWidget {
  const _EventName(this.point);

  final SecurityEventPoint point;

  @override
  Widget build(BuildContext context) {
    final type = point.event.type;
    final color = type.tone.text;
    return Row(
      children: [
        AppIcon(type.icon, size: AppIconSize.xs, color: color),
        const SizedBox(width: AppSpace.xs),
        Expanded(
          child: Text(
            type.label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.clip,
            style: AppText.bodyS.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
