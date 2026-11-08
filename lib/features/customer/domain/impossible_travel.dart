import 'dart:math' as math;

import 'map_point.dart';

/// Mean radius of the Earth, the same one the seed uses (`seed.km`).
const earthRadiusKm = 6371.0;

/// Great-circle distance in kilometres between two points in degrees (Haversine).
double haversineKm(
  double latitude1,
  double longitude1,
  double latitude2,
  double longitude2,
) {
  double radians(double degrees) => degrees * math.pi / 180;
  final dLatitude = radians(latitude2 - latitude1);
  final dLongitude = radians(longitude2 - longitude1);
  final a =
      math.pow(math.sin(dLatitude / 2), 2) +
      math.cos(radians(latitude1)) *
          math.cos(radians(latitude2)) *
          math.pow(math.sin(dLongitude / 2), 2);
  return 2 * earthRadiusKm * math.asin(math.min(1, math.sqrt(a)));
}

/// The pairs of consecutive [points] that would need to travel faster than
/// [maxSpeedKmh] (about a commercial plane) to go from one to the other (HU-11).
///
/// Pairs closer than [minDistanceKm] never count: the coordinates of two operations in
/// the same city can be a few kilometres apart and seconds apart, which is not a trip.
/// The points do not need to be sorted.
List<ImpossibleTravel> detectImpossibleTravel(
  List<MapPoint> points, {
  double maxSpeedKmh = 900,
  double minDistanceKm = 100,
}) {
  final sorted = [...points]
    ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
  final trips = <ImpossibleTravel>[];
  for (var i = 1; i < sorted.length; i++) {
    final from = sorted[i - 1];
    final to = sorted[i];
    final distance = haversineKm(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
    if (distance < minDistanceKm) continue;
    final elapsed = to.occurredAt.difference(from.occurredAt);
    final hours = elapsed.inMicroseconds / Duration.microsecondsPerHour;
    final speed = hours == 0 ? double.infinity : distance / hours;
    if (speed > maxSpeedKmh) {
      trips.add(
        ImpossibleTravel(
          from: from,
          to: to,
          distanceKm: distance,
          elapsed: elapsed,
          speedKmh: speed,
        ),
      );
    }
  }
  return trips;
}
