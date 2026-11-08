import 'package:flutter/material.dart';

import '../../../domain/activity_analysis.dart';
import '../../../domain/timeline_point.dart';
import 'timeline_layout.dart';
import 'timeline_painter.dart';

/// C-11 · The two lanes of the customer timeline (HU-10) for the time [window]: hover a
/// mark for its tooltip, click it to select it ([onSelect]). In a dense window the
/// transactions are bars per slice of time; clicking one zooms in on it ([onZoomTo]).
///
/// One [CustomPaint] draws every mark, so thousands of transactions cost one paint and
/// no widgets. Hover is local, ephemeral state of this widget.
class ActivityTimeline extends StatefulWidget {
  const ActivityTimeline({
    required this.analysis,
    required this.window,
    required this.selected,
    required this.onSelect,
    required this.onZoomTo,
    super.key,
  });

  final ActivityAnalysis analysis;
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

  ActivityAnalysis? _analysis;

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
