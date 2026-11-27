import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import '../supabase/supabase_client_provider.dart';
import 'connection_status.dart';
import 'fake_realtime_service.dart';
import 'supabase_realtime_service.dart';

/// Realtime changes of the database (HU-16, ARCHITECTURAL_SPINE.md · Realtime).
///
/// One app-wide service opens the channels after sign in ([start]) and closes them on
/// sign out ([stop]); `realtimeSessionProvider` (lib/app) does both. Features never open
/// channels: they listen to these streams and invalidate their own providers.
///
/// Every stream groups a burst of changes (about 500 ms) into one event with the ids
/// that changed, so labeling 100 transactions refetches once, not 100 times.
abstract interface class RealtimeService {
  /// Ids of the AI alerts inserted or updated (`ai_alerts`): inbox, detail, counters.
  Stream<Set<String>> get alertsChanged;

  /// Ids of the transactions whose label changed (`labels` insert / update and
  /// `transactions.is_labeled`): lists, customer view, progress.
  Stream<Set<int>> get labelsChanged;

  /// Ids of the notifications inserted for the signed-in analyst (`notifications`):
  /// the bell counter and the «Nueva alerta» toast.
  Stream<Set<String>> get notificationsInserted;

  /// The current status first, then every change. The top bar shows it only when it
  /// is not [ConnectionStatus.connected].
  Stream<ConnectionStatus> connectionStatus();

  /// Opens the channels for [analystId]. Calling it again closes the previous ones.
  void start(String analystId);

  /// Closes the channels (sign out). Changes that arrive later are ignored.
  void stop();

  void dispose();
}

/// The realtime service: Supabase Realtime, or the simulated one when the app runs
/// without a database (`USE_FAKE_DATA`). Kept alive (app-wide).
final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  final RealtimeService service = Env.useFakeData
      ? FakeRealtimeService(simulateReconnect: Env.simulateReconnect)
      : SupabaseRealtimeService(
          SupabaseRealtimeGateway(ref.watch(supabaseClientProvider)),
        );
  ref.onDispose(service.dispose);
  return service;
}, name: 'realtimeServiceProvider');

/// Connection status for the top bar `ConnectionIndicator`, from the real channel.
final connectionStatusProvider = StreamProvider<ConnectionStatus>(
  (ref) => ref.watch(realtimeServiceProvider).connectionStatus(),
  name: 'connectionStatusProvider',
);
