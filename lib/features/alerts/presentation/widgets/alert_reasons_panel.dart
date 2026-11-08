import 'package:flutter/widgets.dart';

import '../../../../core/domain/reason_weight.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/alert_reason.dart';

/// «Razones del modelo» of A-05 (HU-07): why the AI raised the alert, from the heaviest
/// reason to the lightest, each with the data behind it and its weight.
class AlertReasonsPanel extends StatelessWidget {
  const AlertReasonsPanel({required this.reasons, super.key});

  final List<AlertReason> reasons;

  @override
  Widget build(BuildContext context) {
    final sorted = [...reasons]..sort((a, b) => b.weight.compareTo(a.weight));
    final count = sorted.length;

    return AppPanel(
      title: 'Razones del modelo',
      subtitle: count == 0
          ? null
          : '${count == 1 ? '1 razón' : '$count razones'} · ordenadas por peso',
      padding: EdgeInsets.zero,
      child: count == 0
          ? Padding(
              padding: const EdgeInsets.all(AppSpace.xl),
              child: Text(
                'El modelo no registró razones para esta alerta.',
                style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [for (final reason in sorted) _ReasonRow(reason)],
            ),
    );
  }
}

class _ReasonRow extends StatelessWidget {
  const _ReasonRow(this.reason);

  final AlertReason reason;

  @override
  Widget build(BuildContext context) {
    final weight = ReasonWeight.of(reason.weight);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.xl,
        vertical: AppSpace.md,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.controlM,
            height: AppSizes.controlM,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: StatusTone.info.background,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: AppIcon(AppIcons.ai, color: StatusTone.info.text),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reason.title, style: AppText.bodyMSemiBold),
                const SizedBox(height: AppSpace.xxs),
                Text(
                  reason.evidence,
                  style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.md),
          StatusBadge(
            label: weight.label,
            tone: weight.tone,
            icon: weight.icon,
            small: true,
          ),
        ],
      ),
    );
  }
}
