import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatting/date_time.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/activity_analysis.dart';
import '../../domain/timeline_point.dart';
import '../controllers/customer_activity_controller.dart';
import '../controllers/customer_range_controller.dart';
import 'activity_detail_card.dart';
import 'activity_legend.dart';
import 'timeline/activity_timeline.dart';
import 'timeline/timeline_overview.dart';

/// How much time the timeline shows at once.
enum _Zoom {
  range('Rango', null),
  day('Día', Duration(days: 1)),
  hour('1 hora', Duration(hours: 1));

  const _Zoom(this.label, this.length);

  final String label;

  /// Null: the whole range.
  final Duration? length;
}

/// C-11 · «Línea de tiempo» of the customer report (HU-10): transactions and security
/// events of the shared range on a time axis, with bursts, unusual hours and amount
/// spikes highlighted, zoom and the detail of the clicked point.
///
/// Zoom, window and selection are view state of this tab: they start over with a new
/// range.
class ReportTimelineTab extends ConsumerStatefulWidget {
  const ReportTimelineTab({
    required this.customerId,
    required this.onOpenTransaction,
    super.key,
  });

  final String customerId;
  final ValueChanged<int> onOpenTransaction;

  @override
  ConsumerState<ReportTimelineTab> createState() => _ReportTimelineTabState();
}

class _ReportTimelineTabState extends ConsumerState<ReportTimelineTab> {
  _Zoom _zoom = _Zoom.range;
  DateTime? _windowStart;
  TimelinePoint? _selected;

  DateTimeRange _rangeOf() {
    final range = ref.watch(customerDateRangeProvider(widget.customerId));
    return DateTimeRange(start: range.start, end: range.end);
  }

  DateTimeRange _windowOf(DateTimeRange range) {
    final length = _zoom.length;
    if (length == null) return range;
    final start = _clamp(_windowStart ?? range.end.subtract(length), range);
    return DateTimeRange(start: start, end: start.add(length));
  }

  /// Keeps a window of the current zoom inside [range].
  DateTime _clamp(DateTime start, DateTimeRange range) {
    final latest = range.end.subtract(_zoom.length ?? Duration.zero);
    if (start.isAfter(latest)) return latest;
    if (start.isBefore(range.start)) return range.start;
    return start;
  }

  /// The window of [zoom] that holds [instant]: its day, or its hour.
  DateTime _alignedStart(_Zoom zoom, DateTime instant) {
    final local = instant.toLocal();
    return zoom == _Zoom.day
        ? DateTime(local.year, local.month, local.day)
        : DateTime(local.year, local.month, local.day, local.hour);
  }

  /// Where a closer zoom opens: the selected point, else the first anomaly, else the
  /// latest activity.
  DateTime _focusOf(ActivityAnalysis analysis) {
    if (_selected case final selected?) return selected.occurredAt;
    for (final point in analysis.timeline) {
      if (point case TransactionPoint(:final anomalies)
          when anomalies.isNotEmpty) {
        return point.occurredAt;
      }
    }
    return analysis.timeline.last.occurredAt;
  }

  void _setZoom(_Zoom zoom, ActivityAnalysis analysis) => setState(() {
    _zoom = zoom;
    _windowStart = zoom.length == null
        ? null
        : _alignedStart(zoom, _focusOf(analysis));
  });

  void _move(int direction, DateTimeRange range) => setState(() {
    final length = _zoom.length!;
    _windowStart = _clamp(
      _windowOf(range).start.add(length * direction),
      range,
    );
  });

  /// The overview strip: the same zoom (a day from the whole range) around [instant].
  void _jump(DateTime instant) => setState(() {
    if (_zoom == _Zoom.range) _zoom = _Zoom.day;
    _windowStart = _alignedStart(_zoom, instant);
  });

  /// A bar of a dense window: one zoom level closer around [instant].
  void _zoomIn(DateTime instant) => setState(() {
    _zoom = _zoom == _Zoom.range ? _Zoom.day : _Zoom.hour;
    _windowStart = _alignedStart(_zoom, instant);
  });

  @override
  Widget build(BuildContext context) {
    ref.listen(customerDateRangeProvider(widget.customerId), (_, _) {
      setState(() {
        _zoom = _Zoom.range;
        _windowStart = null;
        _selected = null;
      });
    });
    final provider = customerActivityProvider(widget.customerId);
    final range = _rangeOf();

    return ScreenState<ActivityAnalysis>(
      value: ref.watch(provider),
      onRetry: () => ref.invalidate(provider),
      isEmpty: (analysis) => analysis.isEmpty,
      empty: const EmptyState(
        title: 'Sin actividad en el rango',
        message:
            'El cliente no tiene transacciones ni eventos en estas fechas.',
        icon: AppIcons.timeline,
      ),
      builder: (context, analysis) {
        final window = _windowOf(range);
        return SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppPanel(
                  title: 'Actividad en el tiempo',
                  subtitle: 'Transacciones por monto y etiqueta, y eventos de seguridad',
                  action: _ZoomBar(
                    zoom: _zoom,
                    window: window,
                    onZoom: (zoom) => _setZoom(zoom, analysis),
                    onMove: (direction) => _move(direction, range),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (analysis.truncated) ...[
                        const InlineBanner(
                          title: 'Solo se muestra la actividad más reciente',
                          message:
                              'El rango tiene demasiados registros. Elige un rango '
                              'más corto para verlos todos.',
                          tone: StatusTone.warning,
                          icon: AppIcons.warning,
                        ),
                        const SizedBox(height: AppSpace.md),
                      ],
                      ActivityTimeline(
                        analysis: analysis,
                        window: window,
                        selected: _selected,
                        onSelect: (point) => setState(() => _selected = point),
                        onZoomTo: _zoomIn,
                      ),
                      const SizedBox(height: AppSpace.md),
                      TimelineOverview(
                        timeline: analysis.timeline,
                        range: range,
                        window: window,
                        onJump: _jump,
                      ),
                      const SizedBox(height: AppSpace.lg),
                      const ActivityLegend(timeline: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.lg),
              SizedBox(
                width: AppLayout.detailAsideWidth,
                child: ActivityDetailCard(
                  point: _selected,
                  onOpenTransaction: widget.onOpenTransaction,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Rango · Día · 1 hora, with previous / next for the closer zooms.
class _ZoomBar extends StatelessWidget {
  const _ZoomBar({
    required this.zoom,
    required this.window,
    required this.onZoom,
    required this.onMove,
  });

  final _Zoom zoom;
  final DateTimeRange window;
  final ValueChanged<_Zoom> onZoom;
  final ValueChanged<int> onMove;

  @override
  Widget build(BuildContext context) {
    final canMove = zoom != _Zoom.range;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canMove) ...[
          AppIconButton(
            icon: AppIcons.chevronLeft,
            tooltip: 'Anterior',
            small: true,
            onPressed: () => onMove(-1),
          ),
          Text(
            zoom == _Zoom.day
                ? formatDate(window.start)
                : '${formatDate(window.start)} · ${formatTime(window.start)}',
            style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
          ),
          AppIconButton(
            icon: AppIcons.chevronRight,
            tooltip: 'Siguiente',
            small: true,
            onPressed: () => onMove(1),
          ),
          const SizedBox(width: AppSpace.sm),
        ],
        AppSegmented<_Zoom>(
          small: true,
          expand: false,
          value: zoom,
          onChanged: onZoom,
          segments: [
            for (final zoom in _Zoom.values)
              AppSegment(value: zoom, label: zoom.label),
          ],
        ),
      ],
    );
  }
}
