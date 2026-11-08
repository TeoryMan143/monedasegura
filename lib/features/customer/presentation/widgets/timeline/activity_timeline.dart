import 'package:flutter/material.dart';

import '../../../domain/activity_analysis.dart';
import '../../../domain/timeline_point.dart';
import 'timeline_layout.dart';
import 'timeline_painter.dart';

/// C-11 · The two lanes of the customer timeline (HU-10) for the time [window]: hover a
/// mark for its tooltip, click it to select it ([onSelect]).
///
/// One [CustomPaint] draws every mark, so thousands of transactions cost one paint and
/// no widgets. Hover is local, ephemeral state of this widget.
class ActivityTimeline extends StatefulWidget {
  const ActivityTimeline({
    required this.analysis,
    required this.window,
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final ActivityAnalysis analysis;
  final DateTimeRange window;
  final TimelinePoint? selected;
  final ValueChanged<TimelinePoint> onSelect;

  @override
  State<ActivityTimeline> createState() => _ActivityTimelineState();
}

class _ActivityTimelineState extends State<ActivityTimeline> {
  PlacedMark? _hovered;
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

  ActivityAnalysis? _analysis;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final layout = _layoutFor(constraints.maxWidth);
      final hovered = _hovered != null && layout.marks.contains(_hovered)
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
            final mark = layout.hit(details.localPosition);
            if (mark != null) widget.onSelect(mark.point);
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
              Positioned.fill(
                child: CustomPaint(
                  painter: TimelineHoverPainter(hovered: hovered),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
