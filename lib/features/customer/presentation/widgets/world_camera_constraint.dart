import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Keeps the map camera inside one copy of the world (HU-11).
///
/// Zooming out stops once the world fills the map, so OpenStreetMap is never repeated
/// side by side and no grey band shows above or below it. Panning stops at its edges.
///
/// Unlike [CameraConstraint.contain], a camera that is too far out is not rejected but
/// raised to the closest zoom that fits: a pinch, the − button or a fit around points on
/// several continents end on that zoom instead of not moving at all.
class WorldCameraConstraint extends CameraConstraint {
  const WorldCameraConstraint();

  /// The edge of the square Web Mercator world of the OpenStreetMap tiles.
  static const maxLatitude = 85.0511287798;

  static final _world = LatLngBounds(
    const LatLng(-maxLatitude, -180),
    const LatLng(maxLatitude, 180),
  );

  static final _contain = CameraConstraint.contain(bounds: _world);

  /// A little above the exact zoom, so rounding never leaves the world a hair narrower
  /// than the map.
  static const _zoomMargin = 0.001;

  /// The zoom at which the world just covers a map of the camera's size.
  static double minZoomFor(MapCamera camera) {
    final northWest = camera.projectAtZoom(_world.northWest, 0);
    final southEast = camera.projectAtZoom(_world.southEast, 0);
    final world = southEast - northWest;
    final size = camera.nonRotatedSize;
    final scale = math.max(size.width / world.dx, size.height / world.dy);
    return math.log(scale) / math.ln2 + _zoomMargin;
  }

  @override
  MapCamera? constrain(MapCamera camera) {
    // Before the first layout the map has no size yet.
    if (camera.nonRotatedSize == MapCamera.kImpossibleSize) return camera;
    final minZoom = minZoomFor(camera);
    final maxZoom = camera.maxZoom;
    final zoomed =
        camera.zoom < minZoom && (maxZoom == null || minZoom <= maxZoom)
        ? camera.withPosition(zoom: minZoom)
        : camera;
    return _contain.constrain(zoomed) ?? zoomed;
  }

  @override
  bool operator ==(Object other) => other is WorldCameraConstraint;

  @override
  int get hashCode => (WorldCameraConstraint).hashCode;
}
