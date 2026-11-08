import 'package:flutter/material.dart';

import '../../../../core/domain/currency.dart';
import '../../../../core/formatting/money.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/alert_transaction.dart';

class ResolveTransactionsList extends StatelessWidget {
  const ResolveTransactionsList({
    required this.transactions,
    required this.excluded,
    required this.onToggle,
    this.summary,
    this.error,
    this.enabled = true,
    super.key,
  });

  final List<AlertTransaction> transactions;
  final Set<int> excluded;
  final ValueChanged<int> onToggle;
  final String? summary;
  final String? error;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FieldLabel('Transacciones a etiquetar'),
        const SizedBox(height: AppSpace.xs),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            border: Border.all(color: AppColors.borderDefault),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            children: [
              for (final (index, transaction) in transactions.indexed) ...[
                if (index > 0)
                  const Divider(height: 1, color: AppColors.borderDefault),
                _TransactionRow(
                  transaction: transaction,
                  checked: !excluded.contains(transaction.transactionId),
                  onChanged: enabled
                      ? (_) => onToggle(transaction.transactionId)
                      : null,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpace.xs),
        if (error != null)
          FieldMessage(error!, isError: true)
        else ...[
          const FieldMessage(
            'Desmarca las transacciones que no correspondan; conservarán su '
            'etiqueta actual.',
          ),
          if (summary != null) ...[
            const SizedBox(height: AppSpace.xs),
            Text(
              summary!,
              style: AppText.bodySSemiBold.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.transaction,
    required this.checked,
    required this.onChanged,
  });

  final AlertTransaction transaction;
  final bool checked;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    const tone = StatusTone.warning;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.md,
        vertical: AppSpace.sm,
      ),
      child: Row(
        children: [
          AppCheckbox(
            value: checked,
            onChanged: onChanged,
            semanticLabel: 'Etiquetar ${transaction.code}',
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.code, style: AppText.bodyMSemiBold),
                Row(
                  children: [
                    Text(
                      transaction.isPrimary ? 'Principal' : 'Relacionada',
                      style: AppText.bodyS.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (transaction.isLabeled) ...[
                      const SizedBox(width: AppSpace.sm),
                      AppIcon(
                        AppIcons.warning,
                        size: AppIconSize.sm,
                        color: tone.text,
                      ),
                      const SizedBox(width: AppSpace.xs),
                      Flexible(
                        child: Text(
                          'Ya tiene etiqueta · '
                          '${checked ? 'se reemplazará' : 'se conserva'}',
                          style: AppText.bodyS.copyWith(color: tone.text),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            formatMoney(
              transaction.amount,
              Currency.fromDb(transaction.currencyCode),
            ),
            style: AppText.bodyMSemiBold,
          ),
        ],
      ),
    );
  }
}
