import 'dart:ui';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:monedasegura/features/customer/presentation/widgets/world_camera_constraint.dart';

MapCamera _camera({
  required double zoom,
  LatLng center = const LatLng(4.7, -74.07),
  Size size = const Size(1024, 440),
}) => MapCamera(
  crs: const Epsg3857(),
  center: center,
  zoom: zoom,
  rotation: 0,
  nonRotatedSize: size,
);

void main() {
  const constraint = WorldCameraConstraint();

  test('the limit is the zoom where the world just covers the map', () {
    // The world is 256 px wide at zoom 0: 1,024 px is zoom 2.
    expect(
      WorldCameraConstraint.minZoomFor(_camera(zoom: 5)),
      closeTo(2, 0.01),
    );
    expect(
      WorldCameraConstraint.minZoomFor(
        _camera(zoom: 5, size: const Size(512, 1024)),
      ),
      closeTo(2, 0.01),
    );
  });

  test(
    'zooming out past the limit stops at it instead of repeating the world',
    () {
      final constrained = constraint.constrain(_camera(zoom: 0.5))!;

      expect(constrained.zoom, closeTo(2, 0.01));
      expect(_showsOnlyTheWorld(constrained), isTrue);
    },
  );

  test('panning past an edge stops at the edge', () {
    final constrained = constraint.constrain(
      _camera(zoom: 3, center: const LatLng(80, 175)),
    )!;

    expect(constrained.zoom, 3);
    expect(_showsOnlyTheWorld(constrained), isTrue);
  });

  test('a camera inside the world is left as it is', () {
    final camera = _camera(zoom: 6);

    expect(constraint.constrain(camera), same(camera));
  });

  test('before the first layout there is nothing to constrain', () {
    final camera = MapCamera.initialCamera(
      const MapOptions(initialZoom: 0, cameraConstraint: constraint),
    );

    expect(constraint.constrain(camera), same(camera));
  });
}

/// Whether the four corners of the visible map are inside the Web Mercator world.
bool _showsOnlyTheWorld(MapCamera camera) {
  final bounds = camera.visibleBounds;
  const tolerance = 1e-6;
  return bounds.north <= WorldCameraConstraint.maxLatitude + tolerance &&
      bounds.south >= -WorldCameraConstraint.maxLatitude - tolerance &&
      bounds.west >= -180 - tolerance &&
      bounds.east <= 180 + tolerance;
}
