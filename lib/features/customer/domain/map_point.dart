import 'package:freezed_annotation/freezed_annotation.dart';

import 'customer_transaction.dart';

part 'map_point.freezed.dart';

/// A transaction with a place, as a marker of the C-12 map (HU-11).
///
/// Plain degrees instead of a `LatLng`, so the domain does not depend on the map package.
@freezed
abstract class MapPoint with _$MapPoint {
  const factory MapPoint({
    required CustomerTransaction transaction,
    required double latitude,
    required double longitude,
  }) = _MapPoint;

  const MapPoint._();

  DateTime get occurredAt => transaction.occurredAt;
}

/// Two consecutive [MapPoint]s too far apart for the time between them (HU-11). The map
/// draws the line between them highlighted.
@freezed
abstract class ImpossibleTravel with _$ImpossibleTravel {
  const factory ImpossibleTravel({
    required MapPoint from,
    required MapPoint to,
    required double distanceKm,
    required Duration elapsed,

    /// Kilometres per hour. Infinite when both happened at the same instant.
    required double speedKmh,
  }) = _ImpossibleTravel;
}

/// The transactions of [transactions] that have a place, oldest first: the markers of the
/// map, in the order the lines join them.
List<MapPoint> mapPointsOf(Iterable<CustomerTransaction> transactions) {
  final points = [
    for (final transaction in transactions)
      if (transaction.latitude case final latitude?)
        if (transaction.longitude case final longitude?)
          MapPoint(
            transaction: transaction,
            latitude: latitude,
            longitude: longitude,
          ),
  ];
  return points..sort(_byTime);
}

int _byTime(MapPoint a, MapPoint b) {
  final order = a.occurredAt.compareTo(b.occurredAt);
  return order != 0 ? order : a.transaction.id.compareTo(b.transaction.id);
}
