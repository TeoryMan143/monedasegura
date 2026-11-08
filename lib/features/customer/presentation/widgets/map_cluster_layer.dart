import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/domain/label_status.dart';
import '../../../../core/domain/verdict.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/map_point.dart';
import 'activity_style.dart';

/// Map points grouped by a cell of the screen at one zoom level.
class _Cluster {
  _Cluster(this.points);

  final List<MapPoint> points;

  LatLng get center => LatLng(
    points.map((p) => p.latitude).reduce((a, b) => a + b) / points.length,
    points.map((p) => p.longitude).reduce((a, b) => a + b) / points.length,
  );

  /// The most serious status inside: Fraude, then Incierto, Alerta IA, Sin etiquetar,
  /// No fraude.
  StatusTone get tone {
    const severity = [
      StatusTone.danger,
      StatusTone.warning,
      StatusTone.info,
      StatusTone.neutral,
      StatusTone.success,
    ];
    return severity.firstWhere(
      (tone) => points.any((p) => p.transaction.statusTone == tone),
      orElse: () => StatusTone.neutral,
    );
  }
}

/// The markers of a map with many transactions (C-12, HU-11): nearby points become one
/// bubble with their count, coloured by the most serious label inside; a lonely point
/// keeps its pin. Clicking a bubble zooms in on its points.
///
/// Clusters are worked out once per whole zoom level, so panning only moves them. The
/// widgets stay a few dozen whatever the number of transactions.
class MapClusterLayer extends StatefulWidget {
  const MapClusterLayer({
    required this.points,
    required this.selectedId,
    required this.pinBuilder,
    super.key,
  });

  final List<MapPoint> points;
  final int? selectedId;

  /// The pin of a single transaction, the same one the small map uses.
  final Marker Function(MapPoint point) pinBuilder;

  @override
  State<MapClusterLayer> createState() => _MapClusterLayerState();
}

class _MapClusterLayerState extends State<MapClusterLayer> {
  /// Side of the screen cell whose points join, in pixels.
  static const _cell = 56.0;
  static const _minBubble = 28.0;
  static const _maxBubble = 48.0;

  /// Past this zoom a bubble does not split any more: its points share a place.
  static const _maxZoom = 17.0;

  final _cache = <int, List<_Cluster>>{};
  List<MapPoint>? _cachedFor;

  List<_Cluster> _clustersAt(MapCamera camera) {
    if (!identical(_cachedFor, widget.points)) {
      _cache.clear();
      _cachedFor = widget.points;
    }
    final zoom = camera.zoom.floor();
    return _cache.putIfAbsent(zoom, () {
      final cells = <(int, int), List<MapPoint>>{};
      for (final point in widget.points) {
        final pixel = camera.projectAtZoom(
          LatLng(point.latitude, point.longitude),
          zoom.toDouble(),
        );
        cells
            .putIfAbsent((
              (pixel.dx / _cell).floor(),
              (pixel.dy / _cell).floor(),
            ), () => [])
            .add(point);
      }
      return _merged([
        for (final points in cells.values) _Cluster(points),
      ], (cluster) => camera.projectAtZoom(cluster.center, zoom.toDouble()));
    });
  }

  /// A city split by a cell border makes two bubbles on top of each other: joins every
  /// cluster closer than a cell to a bigger one. Few clusters, so a simple pass.
  static List<_Cluster> _merged(
    List<_Cluster> clusters,
    Offset Function(_Cluster) pixelOf,
  ) {
    clusters.sort((a, b) => b.points.length.compareTo(a.points.length));
    final kept = <(_Cluster, Offset)>[];
    for (final cluster in clusters) {
      final pixel = pixelOf(cluster);
      final near = kept
          .where((k) => (k.$2 - pixel).distance < _cell)
          .firstOrNull;
      if (near == null) {
        kept.add((cluster, pixel));
      } else {
        near.$1.points.addAll(cluster.points);
      }
    }
    return [for (final (cluster, _) in kept) cluster];
  }

  void _zoomInto(BuildContext context, _Cluster cluster, MapCamera camera) {
    final coordinates = [
      for (final p in cluster.points) LatLng(p.latitude, p.longitude),
    ];
    MapController.of(context).fitCamera(
      CameraFit.coordinates(
        coordinates: coordinates,
        padding: const EdgeInsets.all(AppSpace.x5l),
        // At least one level closer, so a click always does something.
        minZoom: math.min(camera.zoom + 1, _maxZoom),
        maxZoom: _maxZoom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.of(context);
    final clusters = _clustersAt(camera);
    final selected = widget.points
        .where((p) => p.transaction.id == widget.selectedId)
        .firstOrNull;
    return MarkerLayer(
      markers: [
        for (final cluster in clusters)
          if (cluster.points.length == 1)
            widget.pinBuilder(cluster.points.single)
          else
            _bubble(context, cluster, camera),
        // The selected transaction always shows its own pin, on top.
        if (selected != null) widget.pinBuilder(selected),
      ],
    );
  }

  Marker _bubble(BuildContext context, _Cluster cluster, MapCamera camera) {
    final count = cluster.points.length;
    final size = math.min(
      _maxBubble,
      _minBubble + 4 * math.log(count) / math.ln2,
    );
    final tone = cluster.tone;
    return Marker(
      point: cluster.center,
      width: size,
      height: size,
      child: AppTooltip(
        message: _summary(cluster),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _zoomInto(context, cluster, camera),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: tone.solid,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bgSurface, width: 2),
                boxShadow: AppShadows.card,
              ),
              child: Center(
                child: Text(
                  formatWhole(count),
                  style: AppText.bodySSemiBold.copyWith(color: tone.onSolid),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// «42 transacciones · Fraude 3 · Sin etiquetar 39 · Clic para acercar».
  static String _summary(_Cluster cluster) {
    final counts = <String, int>{};
    for (final point in cluster.points) {
      final label = point.transaction.statusText;
      counts[label] = (counts[label] ?? 0) + 1;
    }
    final order = [
      Verdict.fraud.label,
      Verdict.uncertain.label,
      LabelStatus.unlabeled.label,
      Verdict.notFraud.label,
    ];
    return [
      '${formatWhole(cluster.points.length)} transacciones',
      for (final label in order)
        if (counts[label] case final count?) '$label $count',
      'Clic para acercar',
    ].join(' · ');
  }
}
