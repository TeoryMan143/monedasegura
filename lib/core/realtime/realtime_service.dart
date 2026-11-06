import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import 'connection_status.dart';

/// Simulated realtime service of the prototype (HU-16).
///
/// The prototype does not open Supabase Realtime channels. Instead, [start] schedules
/// one «new alert» signal [newAlertDelay] after the analyst enters (about 30 s). The
/// notifications feature reacts by taking a real pending alert from the database and
/// announcing it. With [simulateReconnect] the connection drops every [reconnectEvery]
/// for [reconnectFor], so the top bar can show «Reconectando…».
///
/// Features never create timers or channels themselves: they listen to [newAlerts] and
/// [connectionStatus]. After the prototype a `SupabaseRealtimeService` with the same
/// streams replaces this class.
class FakeRealtimeService {
  FakeRealtimeService({
    this.newAlertDelay = const Duration(seconds: 30),
    this.simulateReconnect = false,
    this.reconnectEvery = const Duration(seconds: 60),
    this.reconnectFor = const Duration(seconds: 6),
  });

  final Duration newAlertDelay;
  final bool simulateReconnect;
  final Duration reconnectEvery;
  final Duration reconnectFor;

  final _newAlerts = StreamController<void>.broadcast();
  final _status = StreamController<ConnectionStatus>.broadcast();
  ConnectionStatus _current = ConnectionStatus.connected;
  Timer? _alertTimer;
  Timer? _dropTimer;
  Timer? _restoreTimer;

  /// Emits once per [start], when a new alert should be announced.
  Stream<void> get newAlerts => _newAlerts.stream;

  /// The current status first, then every change.
  Stream<ConnectionStatus> connectionStatus() async* {
    yield _current;
    yield* _status.stream;
  }

  /// Starts the simulation for the signed-in analyst. Calling it again restarts it.
  void start() {
    stop();
    _alertTimer = Timer(newAlertDelay, () {
      if (!_newAlerts.isClosed) _newAlerts.add(null);
    });
    if (simulateReconnect) {
      _dropTimer = Timer.periodic(reconnectEvery, (_) {
        _setStatus(ConnectionStatus.reconnecting);
        _restoreTimer = Timer(
          reconnectFor,
          () => _setStatus(ConnectionStatus.connected),
        );
      });
    }
  }

  /// Stops every timer, e.g. when the analyst signs out.
  void stop() {
    _alertTimer?.cancel();
    _dropTimer?.cancel();
    _restoreTimer?.cancel();
    _setStatus(ConnectionStatus.connected);
  }

  void dispose() {
    stop();
    _newAlerts.close();
    _status.close();
  }

  void _setStatus(ConnectionStatus status) {
    if (status == _current || _status.isClosed) return;
    _current = status;
    _status.add(status);
  }
}

/// The realtime service. Kept alive (app-wide); the notifications controller starts it
/// when the shell appears and stops it when the analyst leaves.
final realtimeServiceProvider = Provider<FakeRealtimeService>((ref) {
  final service = FakeRealtimeService(simulateReconnect: Env.simulateReconnect);
  ref.onDispose(service.dispose);
  return service;
}, name: 'realtimeServiceProvider');

/// Connection status for the top bar `ConnectionIndicator`.
final connectionStatusProvider = StreamProvider<ConnectionStatus>(
  (ref) => ref.watch(realtimeServiceProvider).connectionStatus(),
  name: 'connectionStatusProvider',
);
