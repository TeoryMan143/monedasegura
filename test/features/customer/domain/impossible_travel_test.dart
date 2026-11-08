import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/transaction_type.dart';
import 'package:monedasegura/features/customer/domain/customer_transaction.dart';
import 'package:monedasegura/features/customer/domain/impossible_travel.dart';
import 'package:monedasegura/features/customer/domain/map_point.dart';

const _saoPaulo = (-23.574341, -46.606940);
const _cartagena = (10.409404, -75.494469);
const _medellin = (6.2442, -75.5812);
const _bogota = (4.7110, -74.0721);

CustomerTransaction _tx(int id, DateTime at, [(double, double)? place]) =>
    CustomerTransaction(
      id: id,
      code: 'TX-$id',
      occurredAt: at,
      type: TransactionType.purchase,
      channel: Channel.pos,
      amount: 100,
      currency: Currency.brl,
      sourceAccountId: 'a1',
      isLabeled: false,
      latitude: place?.$1,
      longitude: place?.$2,
    );

MapPoint _point(int id, DateTime at, (double, double) place) =>
    mapPointsOf([_tx(id, at, place)]).single;

DateTime _utc(int day, int hour, int minute) =>
    DateTime.utc(2026, 9, day, hour, minute);

void main() {
  group('haversineKm', () {
    test('the same point is 0 km away', () {
      expect(haversineKm(6.2442, -75.5812, 6.2442, -75.5812), 0);
    });

    test('one degree along the equator is about 111 km', () {
      expect(haversineKm(0, 0, 0, 1), closeTo(111.19, 0.01));
    });

    test('Medellín to Bogotá is about 240 km, both ways', () {
      final there = haversineKm(
        _medellin.$1,
        _medellin.$2,
        _bogota.$1,
        _bogota.$2,
      );
      final back = haversineKm(
        _bogota.$1,
        _bogota.$2,
        _medellin.$1,
        _medellin.$2,
      );

      expect(there, closeTo(240, 5));
      expect(back, closeTo(there, 1e-9));
    });

    test('opposite points are half the circumference apart', () {
      expect(haversineKm(0, 0, 0, 180), closeTo(20015.1, 0.1));
    });
  });

  group('mapPointsOf', () {
    test('keeps only the transactions with a place, oldest first', () {
      final points = mapPointsOf([
        _tx(3, _utc(3, 12, 0), _bogota),
        _tx(2, _utc(2, 12, 0)),
        _tx(1, _utc(1, 12, 0), _medellin),
      ]);

      expect(points.map((point) => point.transaction.id), [1, 3]);
      expect(points.first.latitude, _medellin.$1);
    });
  });

  group('detectImpossibleTravel', () {
    test('São Paulo to Cartagena in 95 minutes is impossible (AL-1829)', () {
      final from = _point(47295, _utc(3, 19, 53), _saoPaulo);
      final to = _point(47326, _utc(3, 21, 28), _cartagena);

      final trip = detectImpossibleTravel([from, to]).single;

      expect(trip.from, from);
      expect(trip.to, to);
      expect(trip.distanceKm, closeTo(4907, 15));
      expect(trip.elapsed, const Duration(minutes: 95));
      expect(trip.speedKmh, closeTo(3099, 15));
    });

    test('the same trip a day later is possible', () {
      final trips = detectImpossibleTravel([
        _point(1, _utc(3, 19, 53), _saoPaulo),
        _point(2, _utc(4, 19, 53), _cartagena),
      ]);

      expect(trips, isEmpty);
    });

    test('the limit is 900 km/h', () {
      // Medellín to Bogotá at about 900 km/h takes about 16 minutes.
      final distance = haversineKm(
        _medellin.$1,
        _medellin.$2,
        _bogota.$1,
        _bogota.$2,
      );
      final atLimit = Duration(seconds: (distance / 900 * 3600).ceil());
      final start = _utc(1, 10, 0);

      expect(
        detectImpossibleTravel([
          _point(1, start, _medellin),
          _point(2, start.add(atLimit), _bogota),
        ]),
        isEmpty,
      );
      expect(
        detectImpossibleTravel([
          _point(1, start, _medellin),
          _point(2, start.add(atLimit - const Duration(minutes: 1)), _bogota),
        ]),
        hasLength(1),
      );
    });

    test('two places in the same city never count, even seconds apart', () {
      final trips = detectImpossibleTravel([
        _point(1, _utc(3, 21, 28), (10.409404, -75.494469)),
        _point(2, _utc(3, 21, 28), (10.363491, -75.445966)),
      ]);

      expect(trips, isEmpty);
    });

    test('two far places at the same instant have infinite speed', () {
      final trip = detectImpossibleTravel([
        _point(1, _utc(1, 10, 0), _medellin),
        _point(2, _utc(1, 10, 0), _bogota),
      ]).single;

      expect(trip.speedKmh, double.infinity);
    });

    test('only consecutive points are compared, whatever the input order', () {
      final trips = detectImpossibleTravel([
        _point(3, _utc(3, 21, 28), _cartagena),
        _point(1, _utc(1, 9, 0), _saoPaulo),
        _point(2, _utc(3, 19, 53), _saoPaulo),
        _point(4, _utc(4, 15, 34), _saoPaulo),
      ]);

      expect(
        trips.map((trip) => (trip.from.transaction.id, trip.to.transaction.id)),
        [(2, 3)],
      );
    });
  });
}
