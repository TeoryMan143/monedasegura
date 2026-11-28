import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/realtime/connection_status.dart';
import 'package:monedasegura/core/realtime/supabase_realtime_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A channel opened on the [_SimulatedGateway].
class _Channel {
  _Channel(this.name, this.changes, this.onChange, this.onStatus);

  final String name;
  final List<TableChange> changes;
  final void Function(TableChange change, Map<String, dynamic> row) onChange;
  final void Function(RealtimeSubscribeStatus status, Object? error) onStatus;
  bool closed = false;

  /// Pushes a row as Supabase would, for the first change on [table] / [event].
  void push(
    String table,
    Map<String, dynamic> row, {
    PostgresChangeEvent event = PostgresChangeEvent.insert,
  }) => onChange(
    changes.firstWhere((c) => c.table == table && c.event == event),
    row,
  );
}

/// Simulated Supabase client: records the channels and lets the test drive them.
class _SimulatedGateway implements RealtimeGateway {
  final channels = <_Channel>[];

  _Channel get last => channels.last;

  @override
  CloseChannel open(
    String name, {
    required List<TableChange> changes,
    required void Function(TableChange change, Map<String, dynamic> row)
    onChange,
    required void Function(RealtimeSubscribeStatus status, Object? error)
    onStatus,
  }) {
    final channel = _Channel(name, changes, onChange, onStatus);
    channels.add(channel);
    return () async => channel.closed = true;
  }
}

const _burst = Duration(milliseconds: 30);

Future<void> _afterBurst() => Future<void>.delayed(_burst * 3);

void main() {
  late _SimulatedGateway gateway;
  late SupabaseRealtimeService service;

  setUp(() {
    gateway = _SimulatedGateway();
    service = SupabaseRealtimeService(
      gateway,
      burstWindow: _burst,
      offlineAfter: const Duration(milliseconds: 80),
    );
  });

  tearDown(() => service.dispose());

  test('start opens one channel with every table of the spine', () {
    service.start('analyst-1');

    expect(gateway.channels, hasLength(1));
    final changes = [
      for (final c in gateway.last.changes) '${c.table}:${c.event.name}',
    ];
    expect(changes, [
      'ai_alerts:insert',
      'ai_alerts:update',
      'labels:insert',
      'labels:update',
      'transactions:update',
      'notifications:insert',
    ]);
    final notifications = gateway.last.changes.last.filter!;
    expect(notifications.column, 'analyst_id');
    expect(notifications.type, PostgresChangeFilterType.eq);
    expect(notifications.value, 'analyst-1');
  });

  test('a burst of alert changes arrives once, without duplicates', () async {
    final events = <Set<String>>[];
    final subscription = service.alertsChanged.listen(events.add);
    addTearDown(subscription.cancel);
    service.start('analyst-1');

    gateway.last
      ..push('ai_alerts', {'id': 'a1'})
      ..push('ai_alerts', {'id': 'a2'}, event: PostgresChangeEvent.update)
      ..push('ai_alerts', {'id': 'a1'}, event: PostgresChangeEvent.update);
    await _afterBurst();

    expect(events, [
      {'a1', 'a2'},
    ]);
  });

  test('labels and is_labeled become one labelsChanged per burst', () async {
    final events = <Set<int>>[];
    final subscription = service.labelsChanged.listen(events.add);
    addTearDown(subscription.cancel);
    service.start('analyst-1');

    for (var id = 1; id <= 100; id++) {
      gateway.last
        ..push('labels', {'transaction_id': id})
        ..push('transactions', {
          'id': id,
          'is_labeled': true,
        }, event: PostgresChangeEvent.update);
    }
    await _afterBurst();

    expect(events, hasLength(1));
    expect(events.single, hasLength(100));
  });

  test('inserted notifications are announced by id', () async {
    final inserted = service.notificationsInserted.first;
    service.start('analyst-1');

    gateway.last.push('notifications', {'id': 'n1', 'analyst_id': 'analyst-1'});

    expect(await inserted, {'n1'});
  });

  test('the status follows the channel: error, rejoin and offline', () async {
    final statuses = <ConnectionStatus>[];
    final subscription = service.connectionStatus().listen(statuses.add);
    addTearDown(subscription.cancel);
    service.start('analyst-1');
    await Future<void>.delayed(Duration.zero);

    gateway.last.onStatus(RealtimeSubscribeStatus.subscribed, null);
    gateway.last.onStatus(RealtimeSubscribeStatus.channelError, 'socket');
    await Future<void>.delayed(Duration.zero);
    expect(statuses.last, ConnectionStatus.reconnecting);

    gateway.last.onStatus(RealtimeSubscribeStatus.subscribed, null);
    await Future<void>.delayed(Duration.zero);
    expect(statuses.last, ConnectionStatus.connected);

    gateway.last.onStatus(RealtimeSubscribeStatus.timedOut, null);
    await Future<void>.delayed(const Duration(milliseconds: 150));
    expect(statuses.last, ConnectionStatus.offline);

    expect(statuses, [
      ConnectionStatus.connected,
      ConnectionStatus.reconnecting,
      ConnectionStatus.connected,
      ConnectionStatus.reconnecting,
      ConnectionStatus.offline,
    ]);
  });

  test('stop closes the channel and ignores late changes', () async {
    final events = <Set<String>>[];
    final subscription = service.alertsChanged.listen(events.add);
    addTearDown(subscription.cancel);
    service.start('analyst-1');
    final channel = gateway.last..push('ai_alerts', {'id': 'a1'});

    service.stop();
    channel.push('ai_alerts', {'id': 'a2'});
    channel.onStatus(RealtimeSubscribeStatus.closed, null);
    await _afterBurst();

    expect(channel.closed, isTrue);
    expect(events, isEmpty);
  });

  test('signing in as another analyst replaces the channel', () {
    service
      ..start('analyst-1')
      ..start('analyst-2');

    expect(gateway.channels.first.closed, isTrue);
    expect(gateway.last.closed, isFalse);
    expect(gateway.last.changes.last.filter!.value, 'analyst-2');
  });
}
