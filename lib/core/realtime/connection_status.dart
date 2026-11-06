import '../theme/app_icons.dart';
import '../theme/status_tone.dart';

/// State of the realtime connection (HU-16), with its Spanish label, tone and icon
/// (DESIGN.md · Status tones: Conectado / Reconectando / Sin conexión).
enum ConnectionStatus {
  connected('Conectado', StatusTone.success),
  reconnecting('Reconectando…', StatusTone.warning),
  offline('Sin conexión', StatusTone.danger);

  const ConnectionStatus(this.label, this.tone);

  final String label;
  final StatusTone tone;

  /// Señal, for every state.
  AppIcons get icon => AppIcons.signal;
}
