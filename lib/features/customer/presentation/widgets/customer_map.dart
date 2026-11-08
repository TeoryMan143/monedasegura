import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/impossible_travel.dart';
import '../../domain/map_point.dart';
import 'activity_style.dart';

/// OpenStreetMap tiles: free and without an API key. Their usage policy asks for a
/// real User-Agent, the attribution on the map and no bulk downloads; flutter_map keeps
/// the tiles in its disk cache, so a report seen twice does not download them again.
const _tilesUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const _userAgentPackage = 'co.edu.icesi.monedasegura';

/// A leg longer than this gets a label with the time between both transactions.
const _labelledLegKm = 100.0;

/// With more markers than this, they are painted circles instead of widgets with an
/// icon: thousands of widgets made panning drop to about 8 fps in the load test. Real
/// customers have about a hundred at most, so they keep the icons.
const _maxPinWidgets = 300;

/// Leg labels only while they can be read: more trips than this are counted in the
/// banner above the map instead.
const _maxTripLabels = 10;
const _maxLegLabels = 50;

/// C-12 · The map of the customer report (HU-11): one marker per transaction with a
/// place, coloured by its label with its icon, a line joining them in time order, and
/// the impossible trips in danger with their elapsed time and speed.
///
/// The camera fits every marker when the data changes. [onSelect] receives the clicked
/// marker; the one of [selectedId] gets an azul outline.
class CustomerMap extends StatefulWidget {
  const CustomerMap({
    required this.points,
    required this.trips,
    required this.selectedId,
    required this.onSelect,
    super.key,
  });

  /// Oldest first.
  final List<MapPoint> points;
  final List<ImpossibleTravel> trips;
  final int? selectedId;
  final ValueChanged<MapPoint> onSelect;

  @override
  State<CustomerMap> createState() => _CustomerMapState();
}

class _CustomerMapState extends State<CustomerMap> {
  /// Which painted circle is under the pointer, for the dense map.
  final LayerHitNotifier<MapPoint> _hit = ValueNotifier(null);

  static const _markerSize = 24.0;
  static const _selectedSize = 32.0;
  static const _circleRadius = 5.0;

  @override
  void dispose() {
    _hit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final points = widget.points;
    final trips = widget.trips;
    final coordinates = [for (final point in points) _latLng(point)];
    final impossibleIds = {
      for (final trip in trips)
        (trip.from.transaction.id, trip.to.transaction.id),
    };
    final dense = points.length > _maxPinWidgets;

    return FlutterMap(
      // A new set of points is a new camera fit.
      key: ObjectKey(points),
      options: MapOptions(
        initialCameraFit: coordinates.toSet().length > 1
            ? CameraFit.coordinates(
                coordinates: coordinates,
                padding: const EdgeInsets.all(AppSpace.x5l),
                maxZoom: 13,
              )
            : null,
        initialCenter: coordinates.first,
        initialZoom: 12,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: _tilesUrl,
          userAgentPackageName: _userAgentPackage,
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: coordinates,
              color: AppColors.azul300,
              strokeWidth: 2,
            ),
            for (final trip in trips)
              Polyline(
                points: [_latLng(trip.from), _latLng(trip.to)],
                color: StatusTone.danger.solid,
                strokeWidth: 4,
              ),
          ],
        ),
        if (dense)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                if (_hit.value?.hitValues.firstOrNull case final point?) {
                  widget.onSelect(point);
                }
              },
              child: CircleLayer<MapPoint>(
                hitNotifier: _hit,
                circles: [
                  for (final point in points)
                    CircleMarker(
                      point: _latLng(point),
                      radius: _circleRadius,
                      color: point.transaction.labelTone.solid,
                      borderColor: point.transaction.id == widget.selectedId
                          ? AppColors.azul500
                          : AppColors.bgSurface,
                      borderStrokeWidth:
                          point.transaction.id == widget.selectedId ? 3 : 1,
                      hitValue: point,
                    ),
                ],
              ),
            ),
          ),
        MarkerLayer(
          markers: [
            ..._legLabels(impossibleIds),
            for (final point in points)
              if (!dense || point.transaction.id == widget.selectedId)
                Marker(
                  point: _latLng(point),
                  width: point.transaction.id == widget.selectedId
                      ? _selectedSize
                      : _markerSize,
                  height: point.transaction.id == widget.selectedId
                      ? _selectedSize
                      : _markerSize,
                  child: _Pin(
                    point: point,
                    selected: point.transaction.id == widget.selectedId,
                    onTap: () => widget.onSelect(point),
                  ),
                ),
          ],
        ),
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
      ],
    );
  }

  /// «1 h 35 min» on the impossible trips (at the middle of the leg) and, on a small
  /// map, on the long legs (at a third, so a return trip on the same line does not hide
  /// the label of the way there).
  Iterable<Marker> _legLabels(Set<(int, int)> impossibleIds) sync* {
    final points = widget.points;
    if (widget.trips.length <= _maxTripLabels) {
      for (final trip in widget.trips) {
        yield _legLabel(trip.from, trip.to, 0.5, trip);
      }
    }
    if (points.length > _maxLegLabels) return;
    for (var i = 1; i < points.length; i++) {
      final from = points[i - 1];
      final to = points[i];
      if (impossibleIds.contains((from.transaction.id, to.transaction.id))) {
        continue;
      }
      final km = haversineKm(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude,
      );
      if (km >= _labelledLegKm) yield _legLabel(from, to, 1 / 3, null);
    }
  }

  Marker _legLabel(
    MapPoint from,
    MapPoint to,
    double along,
    ImpossibleTravel? trip,
  ) => Marker(
    point: LatLng(
      from.latitude + (to.latitude - from.latitude) * along,
      from.longitude + (to.longitude - from.longitude) * along,
    ),
    width: 220,
    height: 28,
    child: Center(
      child: _LegLabel(
        trip: trip,
        elapsed: to.occurredAt.difference(from.occurredAt),
      ),
    ),
  );

  static LatLng _latLng(MapPoint point) =>
      LatLng(point.latitude, point.longitude);
}

/// A transaction on the map: its label as colour and icon, the code and label as
/// tooltip.
class _Pin extends StatelessWidget {
  const _Pin({
    required this.point,
    required this.selected,
    required this.onTap,
  });

  final MapPoint point;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final transaction = point.transaction;
    final tone = transaction.labelTone;
    return AppTooltip(
      message:
          '${transaction.code} · ${transaction.labelText}'
          '${transaction.cityName == null ? '' : ' · ${transaction.cityName}'}',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: tone.solid,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.azul500 : AppColors.bgSurface,
                width: selected ? 3 : 2,
              ),
              boxShadow: AppShadows.card,
            ),
            child: Center(
              child: AppIcon(
                transaction.labelIcon,
                size: AppIconSize.xs,
                color: tone.onSolid,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// «1 h 35 min» on a leg; on an impossible trip also the speed, in danger.
class _LegLabel extends StatelessWidget {
  const _LegLabel({required this.trip, required this.elapsed});

  final ImpossibleTravel? trip;
  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final tone = trip == null ? StatusTone.neutral : StatusTone.danger;
    final speed = trip?.speedKmh;
    final text = speed == null
        ? formatElapsed(elapsed)
        : speed.isInfinite
        ? '${formatElapsed(elapsed)} · mismo instante'
        : '${formatElapsed(elapsed)} · ${formatWhole(speed)} km/h';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.sm,
        vertical: AppSpace.xxs,
      ),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: tone.solid),
      ),
      child: Text(
        text,
        style: AppText.bodySSemiBold.copyWith(color: tone.text),
      ),
    );
  }
}
