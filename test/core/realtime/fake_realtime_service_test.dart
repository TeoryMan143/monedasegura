import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/realtime/connection_status.dart';
import 'package:monedasegura/core/realtime/realtime_service.dart';

void main() {
  test('announces one new alert after the delay', () async {
    final service = FakeRealtimeService(
      newAlertDelay: const Duration(milliseconds: 20),
    );
    addTearDown(service.dispose);

    final announced = service.newAlerts.first;
    service.start();

    await expectLater(announced, completes);
  });

  test('stop cancels the pending announcement', () async {
    final service = FakeRealtimeService(
      newAlertDelay: const Duration(milliseconds: 20),
    );
    addTearDown(service.dispose);
    var count = 0;
    final subscription = service.newAlerts.listen((_) => count++);
    addTearDown(subscription.cancel);

    service
      ..start()
      ..stop();
    await Future<void>.delayed(const Duration(milliseconds: 60));

    expect(count, 0);
  });

  test('the reconnect test mode drops and restores the connection', () async {
    final service = FakeRealtimeService(
      newAlertDelay: const Duration(hours: 1),
      simulateReconnect: true,
      reconnectEvery: const Duration(milliseconds: 20),
      reconnectFor: const Duration(milliseconds: 20),
    );
    addTearDown(service.dispose);

    final statuses = service.connectionStatus().take(3).toList();
    service.start();

    expect(await statuses, [
      ConnectionStatus.connected,
      ConnectionStatus.reconnecting,
      ConnectionStatus.connected,
    ]);
  });
}
