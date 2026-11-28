import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/realtime/realtime_service.dart';
import '../features/auth/presentation/controllers/session_controller.dart';

/// Opens the realtime channels when an analyst signs in and closes them when they sign
/// out (HU-16, F-12). Watched by the root widget, so it lives as long as the app.
final realtimeSessionProvider = Provider<void>((ref) {
  final analystId = ref.watch(sessionProvider.select((analyst) => analyst?.id));
  if (analystId == null) return;
  final service = ref.watch(realtimeServiceProvider)..start(analystId);
  ref.onDispose(service.stop);
}, name: 'realtimeSessionProvider');
