import 'package:flutter/material.dart';

import '../../../../core/domain/transaction_type.dart';
import '../../../../core/formatting/account_mask.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/formatting/money.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/classification_target.dart';

/// Top of the N-02 panel (HU-04): amount, basic data, the current label with «Ver
/// historial» (HU-15) and the AI alert box.
class ClassificationSummary extends StatelessWidget {
  const ClassificationSummary({
    required this.target,
    required this.onOpenHistory,
    super.key,
  });

  final ClassificationTarget target;

  /// Opens the label history (N-03). Null disables «Ver historial».
  final VoidCallback? onOpenHistory;

  @override
  Widget build(BuildContext context) {
    final isCredit = target.type == TransactionType.credit;
    final amount = isCredit
        ? formatSignedMoney(target.amount, target.currency)
        : formatMoney(target.amount, target.currency);
    final account = target.accountLast4;
    final label = target.label;
    final alert = target.alert;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          amount,
          style: AppText.h2.copyWith(
            color: isCredit ? StatusTone.success.text : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpace.xs),
        Text(
          [
            formatDateTime(target.occurredAt),
            target.type.label,
            target.channel.label,
          ].join(' · '),
          style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
        ),
        if (target.merchantName != null || account != null)
          Text(
            [
              ?target.merchantName,
              if (account != null)
                '${target.accountType?.abbreviation ?? 'Cuenta'} ${maskAccount(account)}',
            ].join(' · '),
            style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
          ),
        if (label != null) ...[
          const SizedBox(height: AppSpace.sm),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpace.sm,
            children: [
              Text(
                'Etiquetada por ${label.analystName} · '
                '${formatDateTime(label.updatedAt)}',
                style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
              ),
              AppButton(
                label: 'Ver historial',
                variant: AppButtonVariant.tertiary,
                size: AppButtonSize.s,
                onPressed: onOpenHistory,
              ),
            ],
          ),
        ],
        if (alert != null) ...[
          const SizedBox(height: AppSpace.sm),
          InlineBanner(
            title:
                'Alerta IA ${alert.code} · sugiere ${alert.suggestedType.label}',
            message: alert.summary,
            tone: StatusTone.info,
            icon: AppIcons.ai,
            action: ScoreBadge(score: alert.score),
          ),
        ],
      ],
    );
  }
}
