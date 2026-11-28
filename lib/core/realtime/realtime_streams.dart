import 'dart:async';

import 'connection_status.dart';

/// The streams shared by every [RealtimeService] implementation.
///
/// Implementations call the `emit…` methods and [setStatus]; features only see the
/// streams through the `RealtimeService` interface.
mixin RealtimeStreams {
  final _alerts = StreamController<Set<String>>.broadcast();
  final _labels = StreamController<Set<int>>.broadcast();
  final _notifications = StreamController<Set<String>>.broadcast();
  final _status = StreamController<ConnectionStatus>.broadcast();
  ConnectionStatus _current = ConnectionStatus.connected;

  Stream<Set<String>> get alertsChanged => _alerts.stream;
  Stream<Set<int>> get labelsChanged => _labels.stream;
  Stream<Set<String>> get notificationsInserted => _notifications.stream;

  ConnectionStatus get currentStatus => _current;

  Stream<ConnectionStatus> connectionStatus() async* {
    yield _current;
    yield* _status.stream;
  }

  void emitAlertsChanged(Set<String> ids) => _emit(_alerts, ids);
  void emitLabelsChanged(Set<int> transactionIds) =>
      _emit(_labels, transactionIds);
  void emitNotificationsInserted(Set<String> ids) =>
      _emit(_notifications, ids);

  void setStatus(ConnectionStatus status) {
    if (status == _current || _status.isClosed) return;
    _current = status;
    _status.add(status);
  }

  void closeStreams() {
    _alerts.close();
    _labels.close();
    _notifications.close();
    _status.close();
  }

  static void _emit<T>(StreamController<Set<T>> controller, Set<T> ids) {
    if (ids.isEmpty || controller.isClosed) return;
    controller.add(ids);
  }
}

/// Groups a burst of realtime changes: what arrives within [window] after the first
/// change is delivered once, as a set (duplicates collapse).
class BurstBuffer<T> {
  BurstBuffer({required this.onFlush, this.window = defaultWindow});

  static const defaultWindow = Duration(milliseconds: 500);

  final Duration window;
  final void Function(Set<T> items) onFlush;

  final _pending = <T>{};
  Timer? _timer;

  void add(T item) {
    _pending.add(item);
    _timer ??= Timer(window, flush);
  }

  /// Delivers what is pending now.
  void flush() {
    _timer?.cancel();
    _timer = null;
    if (_pending.isEmpty) return;
    final items = Set<T>.unmodifiable(_pending);
    _pending.clear();
    onFlush(items);
  }

  /// Drops what is pending without delivering it.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _pending.clear();
  }
}
