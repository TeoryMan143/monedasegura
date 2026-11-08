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
import 'activity_style.dart';
import 'timeline/activity_timeline.dart';
import 'timeline/timeline_overview.dart';

/// How much time the timeline shows at once: a calendar day, week (from Monday) or
/// month, or the whole range.
enum TimelineZoom {
  day('Día', Duration(days: 1)),
  week('Semana', Duration(days: 7)),
  month('Mes', Duration(days: 30)),
  range('Rango completo', null);

  const TimelineZoom(this.label, this.length);

  final String label;

  /// About how long the window is. Null: the whole range.
  final Duration? length;

  /// The first instant of the window of this zoom that holds [instant].
  DateTime startOf(DateTime instant) {
    final local = instant.toLocal();
    return switch (this) {
      day || range => DateTime(local.year, local.month, local.day),
      week => DateTime(local.year, local.month, local.day - local.weekday + 1),
      month => DateTime(local.year, local.month),
    };
  }

  /// The window [count] windows after the one that starts on [start] (before, when
  /// negative), counted on the calendar so a month is a month.
  DateTime shift(DateTime start, int count) => switch (this) {
    day || range => DateTime(start.year, start.month, start.day + count),
    week => DateTime(start.year, start.month, start.day + 7 * count),
    month => DateTime(start.year, start.month + count),
  };

  /// The window that starts on [start].
  DateTimeRange windowFrom(DateTime start) =>
      DateTimeRange(start: start, end: shift(start, 1));

  /// The next zoom closer than a window of [shown], to look inside a part of it.
  static TimelineZoom closerThan(Duration shown) => [
    month,
    week,
  ].firstWhere((zoom) => zoom.length! * 4 < shown * 3, orElse: () => day);
}

/// C-11 · «Línea de tiempo» of the customer report (HU-10): transactions and security
/// events of the shared range on a time axis, with bursts, unusual hours (the customer's
/// nights shaded) and amount spikes highlighted and summed up in text, zoom by day,
/// week or month, and the detail of the clicked point.
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
  TimelineZoom _zoom = TimelineZoom.range;

  /// First instant of the calendar window of [_zoom]. Null for the whole range.
  DateTime? _windowStart;
  TimelinePoint? _selected;

  DateTimeRange _rangeOf() {
    final range = ref.watch(customerDateRangeProvider(widget.customerId));
    return DateTimeRange(start: range.start, end: range.end);
  }

  /// The window on screen: the calendar window of the zoom, cut to the range.
  DateTimeRange _windowOf(DateTimeRange range) {
    final start = _windowStart;
    if (_zoom == TimelineZoom.range || start == null) return range;
    final window = _zoom.windowFrom(start);
    if (!_overlaps(window, range)) return range;
    return DateTimeRange(
      start: window.start.isBefore(range.start) ? range.start : window.start,
      end: window.end.isAfter(range.end) ? range.end : window.end,
    );
  }

  static bool _overlaps(DateTimeRange a, DateTimeRange b) =>
      a.end.isAfter(b.start) && a.start.isBefore(b.end);

  /// Whether the window [direction] steps away still shows part of the range.
  bool _canMove(int direction, DateTimeRange range) {
    final start = _windowStart;
    if (_zoom == TimelineZoom.range || start == null) return false;
    return _overlaps(_zoom.windowFrom(_zoom.shift(start, direction)), range);
  }

  /// Where a closer zoom opens: the selected point, else the first anomaly, else the
  /// latest activity.
  DateTime _focusOf(TimelineAnalysis analysis) {
    if (_selected case final selected?) return selected.occurredAt;
    for (final point in analysis.timeline) {
      if (point case TransactionPoint(:final anomalies)
          when anomalies.isNotEmpty) {
        return point.occurredAt;
      }
    }
    return analysis.timeline.last.occurredAt;
  }

  void _setZoom(TimelineZoom zoom, TimelineAnalysis analysis) => setState(() {
    _zoom = zoom;
    _windowStart = zoom == TimelineZoom.range
        ? null
        : zoom.startOf(_focusOf(analysis));
  });

  void _move(int direction) => setState(() {
    _windowStart = _zoom.shift(_windowStart!, direction);
  });

  /// The overview strip: the same zoom (a day from the whole range) around [instant].
  void _jump(DateTime instant) => setState(() {
    if (_zoom == TimelineZoom.range) _zoom = TimelineZoom.day;
    _windowStart = _zoom.startOf(instant);
  });

  /// A bar of a dense window: a closer zoom around [instant].
  void _zoomIn(DateTime instant, DateTimeRange shown) => setState(() {
    _zoom = TimelineZoom.closerThan(shown.duration);
    _windowStart = _zoom.startOf(instant);
  });

  @override
  Widget build(BuildContext context) {
    ref.listen(customerDateRangeProvider(widget.customerId), (_, _) {
      setState(() {
        _zoom = TimelineZoom.range;
        _windowStart = null;
        _selected = null;
      });
    });
    final provider = customerTimelineProvider(widget.customerId);
    final range = _rangeOf();

    return ScreenState<TimelineAnalysis>(
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
                  subtitle:
                      'Transacciones por monto y estado, y eventos de seguridad '
                      '· clic en un punto para ver su detalle',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ZoomBar(
                        zoom: _zoom,
                        window: window,
                        onZoom: (zoom) => _setZoom(zoom, analysis),
                        onPrevious: _canMove(-1, range)
                            ? () => _move(-1)
                            : null,
                        onNext: _canMove(1, range) ? () => _move(1) : null,
                      ),
                      const SizedBox(height: AppSpace.md),
                      _Highlights(analysis: analysis),
                      const SizedBox(height: AppSpace.md),
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
                        onZoomTo: (instant) => _zoomIn(instant, window),
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

/// Día · Semana · Mes · Rango completo, and previous / next with the window on screen
/// for the closer zooms. Previous / next are disabled at the ends of the range.
class _ZoomBar extends StatelessWidget {
  const _ZoomBar({
    required this.zoom,
    required this.window,
    required this.onZoom,
    required this.onPrevious,
    required this.onNext,
  });

  final TimelineZoom zoom;
  final DateTimeRange window;
  final ValueChanged<TimelineZoom> onZoom;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  /// «8 nov 2026» for a day; «2–8 nov 2026» for a week or a month, cut to the range.
  String get _windowLabel {
    final lastDay = window.end.subtract(const Duration(microseconds: 1));
    return zoom == TimelineZoom.day
        ? formatDate(window.start)
        : formatDateRange(window.start, lastDay);
  }

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpace.sm,
    runSpacing: AppSpace.sm,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      AppSegmented<TimelineZoom>(
        small: true,
        expand: false,
        value: zoom,
        onChanged: onZoom,
        segments: [
          for (final zoom in TimelineZoom.values)
            AppSegment(value: zoom, label: zoom.label),
        ],
      ),
      if (zoom != TimelineZoom.range)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconButton(
              icon: AppIcons.chevronLeft,
              tooltip: 'Anterior',
              small: true,
              onPressed: onPrevious,
            ),
            Text(_windowLabel, style: AppText.bodyMSemiBold),
            AppIconButton(
              icon: AppIcons.chevronRight,
              tooltip: 'Siguiente',
              small: true,
              onPressed: onNext,
            ),
          ],
        ),
    ],
  );
}

/// What the timeline highlights in the range, in text: «Resaltados en el rango: 1
/// ráfaga · 2 picos de monto · 3 en horario inusual · 4 eventos de seguridad». Each
/// count is a badge with the icon and tone of its mark (HU-10).
class _Highlights extends StatelessWidget {
  const _Highlights({required this.analysis});

  final TimelineAnalysis analysis;

  static String _count(int count, String one, String many) =>
      '$count ${count == 1 ? one : many}';

  @override
  Widget build(BuildContext context) {
    final bursts = analysis.bursts.length;
    final spikes = analysis.countOf(ActivityAnomaly.amountSpike);
    final unusual = analysis.countOf(ActivityAnomaly.unusualHour);
    final events = analysis.securityEventCount;
    final badges = [
      if (bursts > 0)
        (ActivityAnomaly.burst, _count(bursts, 'ráfaga', 'ráfagas')),
      if (spikes > 0)
        (
          ActivityAnomaly.amountSpike,
          _count(spikes, 'pico de monto', 'picos de monto'),
        ),
      if (unusual > 0)
        (
          ActivityAnomaly.unusualHour,
          _count(unusual, 'en horario inusual', 'en horario inusual'),
        ),
    ];
    return Wrap(
      spacing: AppSpace.sm,
      runSpacing: AppSpace.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          badges.isEmpty
              ? 'Sin anomalías en el rango'
              : 'Resaltados en el rango:',
          style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
        ),
        for (final (anomaly, text) in badges)
          StatusBadge(
            label: text,
            tone: anomaly.tone,
            icon: anomaly.icon,
            small: true,
          ),
        if (events > 0)
          StatusBadge(
            label: _count(
              events,
              'evento de seguridad',
              'eventos de seguridad',
            ),
            tone: StatusTone.high,
            icon: AppIcons.shield,
            small: true,
          ),
      ],
    );
  }
}
