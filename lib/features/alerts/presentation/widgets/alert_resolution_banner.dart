import 'package:flutter/widgets.dart';

import '../../../../core/domain/alert_status.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/ai_alert.dart';

/// Tells that an alert is no longer pending, who resolved it and how (HU-07, HU-08).
///
/// It depends only on the alert's status, so it shows up by itself if the alert changes
/// while it is open. With [resolvedByMe] it says «Resolviste esta alerta», so the analyst
/// who just resolved it is not told that «otro analista» did. It draws nothing for a
/// pending alert.
class AlertResolutionBanner extends StatelessWidget {
  const AlertResolutionBanner({
    required this.alert,
    this.resolvedByMe = false,
    super.key,
  });

  final AiAlert alert;

  /// The signed-in analyst is the one who resolved the alert.
  final bool resolvedByMe;

  @override
  Widget build(BuildContext context) {
    if (!alert.isResolved) return const SizedBox.shrink();
    return InlineBanner(
      title: resolvedByMe
          ? 'Resolviste esta alerta'
          : 'Esta alerta la resolvió otro analista',
      message: _message(),
      tone: StatusTone.info,
      icon: alert.status.icon,
    );
  }

  /// «Ana Ruiz la confirmó como Fraude · Robo de cuenta el 06 nov 2026, 14:32. Ya no se
  /// puede resolver.»
  String _message() {
    final who = resolvedByMe
        ? 'La'
        : '${alert.resolvedByName ?? 'Otro analista'} la';
    final verb = switch (alert.status) {
      AlertStatus.confirmed => resolvedByMe ? 'confirmaste' : 'confirmó',
      AlertStatus.rejected => resolvedByMe ? 'rechazaste' : 'rechazó',
      _ => resolvedByMe ? 'reclasificaste' : 'reclasificó',
    };
    final finalType = alert.finalType;
    final result = switch (alert.status) {
      AlertStatus.rejected => 'No fraude',
      _ => finalType == null ? 'Fraude' : 'Fraude · ${finalType.label}',
    };
    final at = alert.resolvedAt;
    final when = at == null ? '' : ' el ${formatDate(at)}, ${formatTime(at)}';
    return '$who $verb como $result$when. Ya no se puede resolver.';
  }
}
