import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'connection_status.dart';
import 'realtime_service.dart';
import 'realtime_streams.dart';

/// One Postgres change a channel listens to.
class TableChange {
  const TableChange(this.table, this.event, {this.filter});

  final String table;
  final PostgresChangeEvent event;
  final PostgresChangeFilter? filter;
}

/// Closes a channel opened by a [RealtimeGateway].
typedef CloseChannel = Future<void> Function();

/// Opens Supabase Realtime channels. [SupabaseRealtimeGateway] is the real one; tests
/// pass a simulated gateway that pushes rows and statuses by hand.
abstract interface class RealtimeGateway {
  /// Opens channel [name] with every change in [changes]. [onChange] receives the new
  /// row of each change, [onStatus] every status of the channel.
  CloseChannel open(
    String name, {
    required List<TableChange> changes,
    required void Function(TableChange change, Map<String, dynamic> row)
    onChange,
    required void Function(RealtimeSubscribeStatus status, Object? error)
    onStatus,
  });
}

/// [RealtimeGateway] over the app's [SupabaseClient]. Realtime applies the RLS of each
/// table, so the analyst only receives rows they can read.
class SupabaseRealtimeGateway implements RealtimeGateway {
  SupabaseRealtimeGateway(this._client);

  final SupabaseClient _client;

  @override
  CloseChannel open(
    String name, {
    required List<TableChange> changes,
    required void Function(TableChange change, Map<String, dynamic> row)
    onChange,
    required void Function(RealtimeSubscribeStatus status, Object? error)
    onStatus,
  }) {
    final channel = _client.channel(name);
    for (final change in changes) {
      channel.onPostgresChanges(
        event: change.event,
        schema: 'public',
        table: change.table,
        filter: change.filter,
        callback: (payload) => onChange(change, payload.newRecord),
      );
    }
    channel.subscribe(onStatus);
    return () async {
      await _client.removeChannel(channel);
    };
  }
}

/// [RealtimeService] over Supabase Realtime (HU-16, F-12).
///
/// One channel per session with the changes of ARCHITECTURAL_SPINE.md · Realtime:
/// `ai_alerts` and `labels` (insert / update), `transactions` (update of `is_labeled`)
/// and `notifications` (insert for the signed-in analyst). Each stream groups a burst
/// of changes within [burstWindow].
///
/// The status follows the channel: `subscribed` is «Conectado»; an error, a timeout or
/// a closed channel is «Reconectando…» while the client rejoins by itself, and
/// «Sin conexión» when it has not come back after [offlineAfter].
class SupabaseRealtimeService with RealtimeStreams implements RealtimeService {
  SupabaseRealtimeService(
    this._gateway, {
    this.burstWindow = BurstBuffer.defaultWindow,
    this.offlineAfter = const Duration(seconds: 15),
  }) {
    _alerts = BurstBuffer(window: burstWindow, onFlush: emitAlertsChanged);
    _labels = BurstBuffer(window: burstWindow, onFlush: emitLabelsChanged);
    _notifications = BurstBuffer(
      window: burstWindow,
      onFlush: emitNotificationsInserted,
    );
  }

  final RealtimeGateway _gateway;
  final Duration burstWindow;
  final Duration offlineAfter;

  late final BurstBuffer<String> _alerts;
  late final BurstBuffer<int> _labels;
  late final BurstBuffer<String> _notifications;
  CloseChannel? _close;
  Timer? _offlineTimer;

  /// Grows on every [start] and [stop], so callbacks of a closed channel are ignored.
  int _session = 0;

  static List<TableChange> changesFor(String analystId) => [
    const TableChange('ai_alerts', PostgresChangeEvent.insert),
    const TableChange('ai_alerts', PostgresChangeEvent.update),
    const TableChange('labels', PostgresChangeEvent.insert),
    const TableChange('labels', PostgresChangeEvent.update),
    const TableChange('transactions', PostgresChangeEvent.update),
    TableChange(
      'notifications',
      PostgresChangeEvent.insert,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'analyst_id',
        value: analystId,
      ),
    ),
  ];

  @override
  void start(String analystId) {
    stop();
    final session = _session;
    _close = _gateway.open(
      'moneda-segura-$analystId',
      changes: changesFor(analystId),
      onChange: (change, row) {
        if (session == _session) _route(change.table, row);
      },
      onStatus: (status, _) {
        if (session == _session) _onStatus(status);
      },
    );
  }

  @override
  void stop() {
    _session++;
    _alerts.cancel();
    _labels.cancel();
    _notifications.cancel();
    _offlineTimer?.cancel();
    _offlineTimer = null;
    final close = _close;
    _close = null;
    if (close != null) unawaited(close());
    setStatus(ConnectionStatus.connected);
  }

  @override
  void dispose() {
    stop();
    closeStreams();
  }

  void _route(String table, Map<String, dynamic> row) {
    switch (table) {
      case 'ai_alerts':
        if (row['id'] case final String id) _alerts.add(id);
      case 'labels':
        if (row['transaction_id'] case final num id) _labels.add(id.toInt());
      case 'transactions':
        if (row['id'] case final num id) _labels.add(id.toInt());
      case 'notifications':
        if (row['id'] case final String id) _notifications.add(id);
    }
  }

  void _onStatus(RealtimeSubscribeStatus status) {
    if (status == RealtimeSubscribeStatus.subscribed) {
      _offlineTimer?.cancel();
      _offlineTimer = null;
      setStatus(ConnectionStatus.connected);
      return;
    }
    if (currentStatus == ConnectionStatus.connected) {
      setStatus(ConnectionStatus.reconnecting);
    }
    _offlineTimer ??= Timer(
      offlineAfter,
      () => setStatus(ConnectionStatus.offline),
    );
  }
}
