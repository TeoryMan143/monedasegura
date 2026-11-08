import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/activity_analysis.dart';
import '../../domain/map_point.dart';
import '../../domain/timeline_point.dart';
import '../controllers/customer_activity_controller.dart';
import '../controllers/customer_range_controller.dart';
import 'activity_detail_card.dart';
import 'activity_legend.dart';
import 'activity_style.dart';
import 'customer_map.dart';

/// C-12 · «Mapa» of the customer report (HU-11): the transactions of the shared range
/// with a place, joined in time order, with the impossible trips highlighted and
/// explained above the map.
///
/// The selected marker is view state of this tab and starts over with a new range.
class ReportMapTab extends ConsumerStatefulWidget {
  const ReportMapTab({
    required this.customerId,
    required this.onOpenTransaction,
    super.key,
  });

  final String customerId;
  final ValueChanged<int> onOpenTransaction;

  @override
  ConsumerState<ReportMapTab> createState() => _ReportMapTabState();
}

class _ReportMapTabState extends ConsumerState<ReportMapTab> {
  MapPoint? _selected;

  static const _mapHeight = 440.0;

  @override
  Widget build(BuildContext context) {
    ref.listen(
      customerDateRangeProvider(widget.customerId),
      (_, _) => setState(() => _selected = null),
    );
    final provider = customerActivityProvider(widget.customerId);

    return ScreenState<ActivityAnalysis>(
      value: ref.watch(provider),
      onRetry: () => ref.invalidate(provider),
      isEmpty: (analysis) => analysis.mapPoints.isEmpty,
      empty: const EmptyState(
        title: 'Sin ubicaciones en el rango',
        message: 'Ninguna transacción de estas fechas tiene una ubicación.',
        icon: AppIcons.location,
      ),
      builder: (context, analysis) {
        final selected = _selected;
        return SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (analysis.trips.isNotEmpty) ...[
                      _TripBanner(
                        trips: analysis.trips,
                        onShow: (point) => setState(() => _selected = point),
                      ),
                      const SizedBox(height: AppSpace.lg),
                    ],
                    AppPanel(
                      title: 'Mapa de transacciones',
                      subtitle: 'Transacciones con ubicación, unidas en orden de tiempo',
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: _mapHeight,
                            child: CustomerMap(
                              points: analysis.mapPoints,
                              trips: analysis.trips,
                              selectedId: selected?.transaction.id,
                              onSelect: (point) =>
                                  setState(() => _selected = point),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppSpace.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ActivityLegend(timeline: false),
                                if (analysis.withoutPlace > 0) ...[
                                  const SizedBox(height: AppSpace.sm),
                                  Text(
                                    analysis.withoutPlace == 1
                                        ? '1 transacción sin ubicación no '
                                              'aparece en el mapa.'
                                        : '${analysis.withoutPlace} '
                                              'transacciones sin ubicación no '
                                              'aparecen en el mapa.',
                                    style: AppText.bodyS.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.lg),
              SizedBox(
                width: AppLayout.detailAsideWidth,
                child: ActivityDetailCard(
                  point: selected == null
                      ? null
                      : TimelinePoint.transaction(
                          selected.transaction,
                          anomalies: analysis.anomaliesOf(
                            selected.transaction.id,
                          ),
                        ),
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

/// Explains the first impossible trip: where, how far, how fast. [onShow] selects its
/// arrival on the map.
class _TripBanner extends StatelessWidget {
  const _TripBanner({required this.trips, required this.onShow});

  final List<ImpossibleTravel> trips;
  final ValueChanged<MapPoint> onShow;

  @override
  Widget build(BuildContext context) {
    final trip = trips.first;
    final from = trip.from.transaction;
    final to = trip.to.transaction;
    final speed = trip.speedKmh.isInfinite
        ? 'en el mismo instante'
        : 'a ${formatWhole(trip.speedKmh)} km/h';
    final others = trips.length - 1;
    return InlineBanner(
      title: 'Viaje imposible',
      message:
          '${from.code} en ${from.cityName ?? 'una ubicación'} y ${to.code} en '
          '${to.cityName ?? 'otra'}: ${formatWhole(trip.distanceKm)} km en '
          '${formatElapsed(trip.elapsed)}, $speed. Ningún viaje real es tan '
          'rápido.${others == 0 ? '' : ' Hay $others más en el rango.'}',
      tone: StatusTone.danger,
      icon: AppIcons.location,
      action: AppButton(
        label: 'Ver transacción',
        variant: AppButtonVariant.secondary,
        size: AppButtonSize.s,
        onPressed: () => onShow(trip.to),
      ),
    );
  }
}
