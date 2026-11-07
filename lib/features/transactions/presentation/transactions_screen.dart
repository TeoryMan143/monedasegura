import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import 'widgets/transactions_filter_bar.dart';
import 'widgets/transactions_search_field.dart';
import 'widgets/transactions_sort_dropdown.dart';
import 'widgets/transactions_table.dart';

/// A-01 · Transaction list (HU-02): search, sort, filters (N-01), table and pagination.
///
/// [onOpen] opens a row in the customer view. The router passes it, so this feature does
/// not depend on the app's routes.
class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({required this.onOpen, super.key});

  final OpenTransaction onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppLayout.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Transacciones', style: AppText.h1),
          const SizedBox(height: AppSpace.xs),
          Text(
            'Todas las transacciones del banco. Filtra las sospechosas o '
            'pendientes y ábrelas para clasificarlas.',
            style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppLayout.blockGap),
          const Row(
            children: [
              TransactionsSearchField(),
              SizedBox(width: AppSpace.xxl),
              TransactionsSortDropdown(),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Expanded(
            child: AppPanel(
              expand: true,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TransactionsFilterBar(),
                  Expanded(child: TransactionsTable(onOpen: onOpen)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
