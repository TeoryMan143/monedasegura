import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/impossible_travel.dart';
import '../../domain/map_point.dart';
import 'activity_style.dart';
import 'map_cluster_layer.dart';
import 'world_camera_constraint.dart';

/// OpenStreetMap tiles: free and without an API key. Their usage policy asks for a
/// real User-Agent, the attribution on the map and no bulk downloads; flutter_map keeps
/// the tiles in its disk cache, so a report seen twice does not download them again.
const _tilesUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const _userAgentPackage = 'co.edu.icesi.monedasegura';

/// A leg longer than this gets a label with the time between both transactions.
const _labelledLegKm = 100.0;

/// With more markers than this, nearby ones join in clusters ([MapClusterLayer]): one
/// widget per transaction made panning drop to about 8 fps with 5,000 in the load test.
/// Real customers have about a hundred at most, so they see every pin.
const _maxPinWidgets = 300;

/// Zoom of a map with a single place, the closest zoom of a fit and of the + button.
const _singlePlaceZoom = 12.0;
const _maxFitZoom = 13.0;
const _maxZoom = 18.0;

/// Leg labels only while they can be read: more trips than this are counted in the
/// banner above the map instead.
const _maxTripLabels = 10;
const _maxLegLabels = 50;

/// C-12 · The map of the customer report (HU-11): one marker per transaction with a
/// place, coloured by its label with its icon, a line joining them in time order, and
/// the impossible trips in danger with their elapsed time and speed.
///
/// The camera fits every marker when the data changes, and «Encuadrar transacciones»
/// fits them again. Zooming out stops when the world fills the map
/// ([WorldCameraConstraint]). [onSelect] receives the clicked marker; the one of
/// [selectedId] gets an azul outline.
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
  static const _markerSize = 24.0;
  static const _selectedSize = 32.0;

  final _controller = MapController();

  /// Built once: new options on every build would make flutter_map check the camera
  /// against the constraint in the middle of a resize. New points refit through
  /// [_controller] instead.
  late final MapOptions _options = MapOptions(
    initialCameraFit: _fitOf(widget.points),
    initialCenter: _latLng(widget.points.first),
    initialZoom: _singlePlaceZoom,
    maxZoom: _maxZoom,
    cameraConstraint: const WorldCameraConstraint(),
    interactionOptions: const InteractionOptions(
      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
    ),
    onMapEvent: _onMapEvent,
  );

  @override
  void didUpdateWidget(CustomerMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.points, widget.points)) {
      // After the build: moving the camera notifies the map's layers.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fitAll();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// A fit around every place, or null when there is only one place.
  static CameraFit? _fitOf(List<MapPoint> points) {
    final coordinates = [for (final point in points) _latLng(point)];
    if (coordinates.toSet().length < 2) return null;
    return CameraFit.coordinates(
      coordinates: coordinates,
      padding: const EdgeInsets.all(AppSpace.x5l),
      maxZoom: _maxFitZoom,
    );
  }

  void _fitAll() {
    final fit = _fitOf(widget.points);
    if (fit == null) {
      _controller.move(_latLng(widget.points.first), _singlePlaceZoom);
    } else {
      _controller.fitCamera(fit);
    }
  }

  void _zoomBy(double delta) {
    final camera = _controller.camera;
    _controller.move(camera.center, camera.zoom + delta);
  }

  /// A bigger map can show past the edge of the world at the old zoom: the constraint
  /// runs again when the size changes.
  void _onMapEvent(MapEvent event) {
    if (event is MapEventNonRotatedSizeChange) {
      _controller.move(event.camera.center, event.camera.zoom);
    }
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
      mapController: _controller,
      options: _options,
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
          MapClusterLayer(
            points: points,
            selectedId: widget.selectedId,
            pinBuilder: _pin,
          ),
        MarkerLayer(
          markers: [
            ..._legLabels(impossibleIds),
            if (!dense) ...points.map(_pin),
          ],
        ),
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
        // A child of the map: it rebuilds with every camera change.
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.md),
            child: _MapControls(
              onZoomIn: () => _zoomBy(1),
              onZoomOut: () => _zoomBy(-1),
              onFit: _fitAll,
            ),
          ),
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

  Marker _pin(MapPoint point) {
    final selected = point.transaction.id == widget.selectedId;
    return Marker(
      point: _latLng(point),
      width: selected ? _selectedSize : _markerSize,
      height: selected ? _selectedSize : _markerSize,
      child: _Pin(
        point: point,
        selected: selected,
        onTap: () => widget.onSelect(point),
      ),
    );
  }

  static LatLng _latLng(MapPoint point) =>
      LatLng(point.latitude, point.longitude);
}

/// + and − (C-12) and «Encuadrar transacciones». − is disabled once the world fills
/// the map, + at the closest zoom.
class _MapControls extends StatelessWidget {
  const _MapControls({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onFit,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onFit;

  /// How close to a limit a zoom counts as being on it.
  static const _tolerance = 0.01;

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.of(context);
    final sized = camera.nonRotatedSize != MapCamera.kImpossibleSize;
    final canZoomOut =
        !sized ||
        camera.zoom > WorldCameraConstraint.minZoomFor(camera) + _tolerance;
    final canZoomIn = camera.zoom < _maxZoom - _tolerance;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(
          icon: AppIcons.plus,
          tooltip: 'Acercar',
          variant: AppIconButtonVariant.secondary,
          onPressed: canZoomIn ? onZoomIn : null,
        ),
        const SizedBox(height: AppSpace.xs),
        AppIconButton(
          icon: AppIcons.minus,
          tooltip: 'Alejar',
          variant: AppIconButtonVariant.secondary,
          onPressed: canZoomOut ? onZoomOut : null,
        ),
        const SizedBox(height: AppSpace.xs),
        AppIconButton(
          icon: AppIcons.location,
          tooltip: 'Encuadrar transacciones',
          variant: AppIconButtonVariant.secondary,
          onPressed: onFit,
        ),
      ],
    );
  }
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
    final tone = transaction.statusTone;
    return AppTooltip(
      message:
          '${transaction.code} · ${transaction.statusText}'
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
                transaction.statusIcon,
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
