import 'package:flutter/widgets.dart';

import '../../../../core/domain/alert_status.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/ai_alert.dart';

/// Header of A-05 (HU-07): breadcrumbs, «Alerta AL-1042 · Juan Pérez» with its status,
/// and when the model generated it.
///
/// [onBack] goes back to the inbox, from the first breadcrumb. «Resolver alerta» calls
/// [onResolve] and is disabled when the alert is no longer pending or when [onResolve]
/// is null (A-06 does not exist yet).
class AlertDetailHeader extends StatelessWidget {
  const AlertDetailHeader({
    required this.alert,
    required this.onBack,
    this.onResolve,
    super.key,
  });

  final AiAlert alert;
  final VoidCallback onBack;
  final VoidCallback? onResolve;

  @override
  Widget build(BuildContext context) {
    final generated =
        'Generada el ${formatDateTime(alert.generatedAt)} por el modelo';
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Breadcrumbs(
          items: [
            Breadcrumb('Alertas IA', onTap: onBack),
            Breadcrumb(alert.code),
          ],
        ),
        const SizedBox(height: AppSpace.sm),
        Wrap(
          spacing: AppSpace.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Alerta ${alert.code} · ${alert.customerName}',
              style: AppText.h1,
            ),
            StatusBadge(
              label: alert.status.label,
              tone: alert.status.tone,
              icon: alert.status.icon,
              small: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpace.xs),
        Text(
          alert.status == AlertStatus.pending
              ? '$generated · Pendiente de verificación'
              : generated,
          style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: info),
        const SizedBox(width: AppSpace.lg),
        _ResolveButton(alert: alert, onResolve: onResolve),
      ],
    );
  }
}

/// «Resolver alerta», disabled once the alert is resolved. A disabled button says why on
/// hover, so it is not a dead end.
class _ResolveButton extends StatelessWidget {
  const _ResolveButton({required this.alert, required this.onResolve});

  final AiAlert alert;
  final VoidCallback? onResolve;

  @override
  Widget build(BuildContext context) {
    final pending = alert.status == AlertStatus.pending;
    final button = AppButton(
      label: 'Resolver alerta',
      icon: AppIcons.check,
      onPressed: pending ? onResolve : null,
    );
    return pending
        ? button
        : AppTooltip(message: 'Esta alerta ya fue resuelta', child: button);
  }
}
