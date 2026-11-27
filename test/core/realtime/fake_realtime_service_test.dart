import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/realtime/connection_status.dart';
import 'package:monedasegura/core/realtime/fake_realtime_service.dart';

void main() {
  test('start and stop follow the analyst', () {
    final service = FakeRealtimeService();
    addTearDown(service.dispose);

    service.start('analyst-1');
    expect(service.analystId, 'analyst-1');

    service.stop();
    expect(service.analystId, isNull);
  });

  test('the simulate methods push one change each', () async {
    final service = FakeRealtimeService();
    addTearDown(service.dispose);

    final alerts = service.alertsChanged.first;
    final labels = service.labelsChanged.first;
    final notifications = service.notificationsInserted.first;
    service
      ..simulateAlertChange('a1')
      ..simulateLabelChange(7)
      ..simulateNotification('n1');

    expect(await alerts, {'a1'});
    expect(await labels, {7});
    expect(await notifications, {'n1'});
  });

  test('the reconnect test mode drops and restores the connection', () async {
    final service = FakeRealtimeService(
      simulateReconnect: true,
      reconnectEvery: const Duration(milliseconds: 20),
      reconnectFor: const Duration(milliseconds: 20),
    );
    addTearDown(service.dispose);

    final statuses = service.connectionStatus().take(3).toList();
    service.start('analyst-1');

    expect(await statuses, [
      ConnectionStatus.connected,
      ConnectionStatus.reconnecting,
      ConnectionStatus.connected,
    ]);
  });
}
