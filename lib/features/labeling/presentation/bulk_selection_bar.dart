import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import 'bulk_label_dialog.dart';
import 'controllers/transaction_selection_controller.dart';

/// The bulk action bar of a table (DESIGN.md · Tables, HU-05): how many transactions
/// are checked, «Quitar selección» and «Clasificar N transacciones», which opens A-03.
///
/// Takes no space while nothing is checked. [scope] is a [SelectionScope].
class BulkSelectionBar extends ConsumerWidget {
  const BulkSelectionBar({required this.scope, super.key});

  final String scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = selectedTransactionsProvider(scope);
    final selection = ref.watch(provider);
    if (selection.isEmpty) return const SizedBox.shrink();

    final numbers = NumberFormat.decimalPattern('es');
    final count = selection.count;
    final labeled = selection.labeledCount;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.lg,
        vertical: AppSpace.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgSelected,
        border: Border(
          top: BorderSide(color: AppColors.borderSubtle),
          bottom: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          const AppIcon(
            AppIcons.check,
            size: AppIconSize.md,
            color: AppColors.iconBrand,
          ),
          const SizedBox(width: AppSpace.sm),
          Text(
            count == 1
                ? '1 seleccionada'
                : '${numbers.format(count)} seleccionadas',
            style: AppText.bodyMSemiBold,
          ),
          if (labeled > 0) ...[
            const SizedBox(width: AppSpace.sm),
            // Expanded, not Flexible + Spacer: those would split the free space in half
            // and leave the buttons away from the right edge.
            Expanded(
              child: Text(
                labeled == 1
                    ? '· 1 ya tiene etiqueta'
                    : '· ${numbers.format(labeled)} ya tienen etiqueta',
                style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ] else
            const Spacer(),
          AppButton(
            label: 'Quitar selección',
            icon: AppIcons.close,
            variant: AppButtonVariant.tertiary,
            size: AppButtonSize.s,
            onPressed: () => ref.read(provider.notifier).clear(),
          ),
          const SizedBox(width: AppSpace.sm),
          AppButton(
            label: bulkLabelTitle(count),
            size: AppButtonSize.s,
            onPressed: () =>
                showBulkLabelDialog(context: context, selection: selection),
          ),
        ],
      ),
    );
  }
}
