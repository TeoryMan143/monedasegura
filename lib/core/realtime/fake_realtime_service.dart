import 'dart:async';

import 'connection_status.dart';
import 'realtime_service.dart';
import 'realtime_streams.dart';

/// [RealtimeService] for the app without a database (`USE_FAKE_DATA`) and for tests.
///
/// It opens no channel. Tests push changes with the `simulate…` methods. With
/// [simulateReconnect] the connection drops every [reconnectEvery] for [reconnectFor],
/// so the top bar can show «Reconectando…».
class FakeRealtimeService with RealtimeStreams implements RealtimeService {
  FakeRealtimeService({
    this.simulateReconnect = false,
    this.reconnectEvery = const Duration(seconds: 60),
    this.reconnectFor = const Duration(seconds: 6),
  });

  final bool simulateReconnect;
  final Duration reconnectEvery;
  final Duration reconnectFor;

  Timer? _dropTimer;
  Timer? _restoreTimer;
  String? _analystId;

  /// The analyst whose channels are «open», or null when stopped.
  String? get analystId => _analystId;

  @override
  void start(String analystId) {
    stop();
    _analystId = analystId;
    if (simulateReconnect) {
      _dropTimer = Timer.periodic(reconnectEvery, (_) {
        setStatus(ConnectionStatus.reconnecting);
        _restoreTimer = Timer(
          reconnectFor,
          () => setStatus(ConnectionStatus.connected),
        );
      });
    }
  }

  @override
  void stop() {
    _analystId = null;
    _dropTimer?.cancel();
    _restoreTimer?.cancel();
    setStatus(ConnectionStatus.connected);
  }

  @override
  void dispose() {
    stop();
    closeStreams();
  }

  void simulateAlertChange(String alertId) => emitAlertsChanged({alertId});

  void simulateLabelChange(int transactionId) =>
      emitLabelsChanged({transactionId});

  void simulateNotification(String notificationId) =>
      emitNotificationsInserted({notificationId});
}
