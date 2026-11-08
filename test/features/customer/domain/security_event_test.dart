import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/security_event_type.dart';
import 'package:monedasegura/features/customer/domain/security_event.dart';

void main() {
  test('reads a row with its embedded city', () {
    final event = SecurityEvent.fromJson(const {
      'id': 'e1',
      'type': 'login_new_device',
      'occurred_at': '2026-10-25T11:10:38Z',
      'channel_code': 'APP',
      'succeeded': true,
      'latitude': 3.434543,
      'longitude': -76.5,
      'city': {'name': 'Cali'},
    });

    expect(event.type, SecurityEventType.loginNewDevice);
    expect(event.type.label, 'Dispositivo nuevo');
    expect(event.channel, Channel.app);
    expect(event.occurredAt, DateTime.utc(2026, 10, 25, 11, 10, 38));
    expect(event.cityName, 'Cali');
  });

  test('a failed attempt without a place or a channel', () {
    final event = SecurityEvent.fromJson(const {
      'id': 'e2',
      'type': 'login_failed',
      'occurred_at': '2026-10-25T11:10:38Z',
      'channel_code': null,
      'succeeded': false,
      'latitude': null,
      'longitude': null,
      'city': null,
    });

    expect(event.succeeded, isFalse);
    expect(event.channel, isNull);
    expect(event.cityName, isNull);
  });

  test('every database value has a type', () {
    const values = [
      'login', 'login_failed', 'login_new_device', 'password_change', //
      'phone_change', 'sim_change', 'email_change', 'logout',
    ];

    expect(values.map(SecurityEventType.fromDb), SecurityEventType.values);
  });
}
