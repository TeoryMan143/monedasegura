import 'package:flutter/widgets.dart';

import '../realtime/connection_status.dart';
import 'status_badge.dart';

/// ConnectionIndicator (C-04 top bar, HU-16): Señal icon + «Reconectando…» or «Sin
/// conexión». Hidden while [status] is connected.
class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({required this.status, super.key});

  final ConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == ConnectionStatus.connected) return const SizedBox.shrink();
    return Semantics(
      liveRegion: true,
      child: StatusBadge(
        label: status.label,
        tone: status.tone,
        icon: status.icon,
      ),
    );
  }
}
