import 'package:flutter/widgets.dart';

import '../../../../core/formatting/date_time.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/ai_alert.dart';

/// Tells who resolved an alert that is no longer pending, and how (HU-07).
///
/// Its status badge is in the header; this adds the analyst, the date and the type the
/// alert was resolved with. It draws nothing for a pending alert.
class AlertResolutionBanner extends StatelessWidget {
  const AlertResolutionBanner({required this.alert, super.key});

  final AiAlert alert;

  @override
  Widget build(BuildContext context) {
    if (!alert.isResolved) return const SizedBox.shrink();
    final resolvedAt = alert.resolvedAt;
    final finalType = alert.finalType;
    final message = [
      '${alert.status.label}${resolvedAt == null ? '' : ' el ${formatDateTime(resolvedAt)}'}',
      if (finalType != null)
        'Tipo final: ${finalType.code} · ${finalType.label}',
    ].join(' · ');

    return InlineBanner(
      title: 'Resuelta por ${alert.resolvedByName ?? 'otro analista'}',
      message: message,
      tone: alert.status.tone,
      icon: alert.status.icon,
    );
  }
}
