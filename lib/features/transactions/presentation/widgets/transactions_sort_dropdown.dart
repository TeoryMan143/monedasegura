import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/transactions_query.dart';
import '../controllers/transactions_query_controller.dart';

const _width = 240.0;

/// The orders of the «Ordenar por» dropdown: a column and its direction.
enum _SortOption {
  newest(TransactionsSort.date, false, 'Fecha (más recientes)'),
  oldest(TransactionsSort.date, true, 'Fecha (más antiguas)'),
  highestAmount(TransactionsSort.amount, false, 'Monto (mayor a menor)'),
  lowestAmount(TransactionsSort.amount, true, 'Monto (menor a mayor)'),
  highestScore(TransactionsSort.score, false, 'Score IA (mayor a menor)');

  const _SortOption(this.sort, this.ascending, this.label);

  final TransactionsSort sort;
  final bool ascending;
  final String label;
}

/// «Ordenar por» of A-01 (HU-02), always visible next to the search.
///
/// The Fecha and Monto headers of the table sort too; both read the same query.
class TransactionsSortDropdown extends ConsumerWidget {
  const TransactionsSortDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (sort, ascending) = ref.watch(
      transactionsQueryProvider.select(
        (query) => (query.sort, query.ascending),
      ),
    );
    final current = _SortOption.values.firstWhere(
      (option) => option.sort == sort && option.ascending == ascending,
      orElse: () => _SortOption.newest,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Ordenar por',
          style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(width: AppSpace.sm),
        AppDropdown<_SortOption>(
          value: current,
          width: _width,
          semanticLabel: 'Ordenar por',
          items: [
            for (final option in _SortOption.values)
              AppDropdownItem(value: option, label: option.label),
          ],
          onChanged: (option) => ref
              .read(transactionsQueryProvider.notifier)
              .setSort(option.sort, ascending: option.ascending),
        ),
      ],
    );
  }
}
