import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';
import 'app_dropdown.dart';
import 'app_icon_button.dart';

/// Pagination footer of a table (DESIGN.md · Pagination), 52 px.
///
/// Left: «Mostrando 1–25 de 50.312 transacciones». Right: «Filas por página» (25 / 50 /
/// 100) and the page controls. [page] is 1-based. It only reports changes: the query
/// Notifier owns the page and resets it to 1 when a filter changes.
class Pagination extends StatelessWidget {
  const Pagination({
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    this.itemLabel = 'resultados',
    this.pageSizes = const [25, 50, 100],
    super.key,
  });

  final int page;
  final int pageSize;

  /// Total rows that match the filters (the `count` of the query).
  final int totalCount;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  /// Plural noun after the total: «transacciones», «alertas».
  final String itemLabel;
  final List<int> pageSizes;

  static const _pageSizeWidth = 88.0;

  int get pageCount => totalCount == 0 ? 1 : (totalCount / pageSize).ceil();

  @override
  Widget build(BuildContext context) {
    final numbers = NumberFormat.decimalPattern('es');
    final from = totalCount == 0 ? 0 : (page - 1) * pageSize + 1;
    final to = (page * pageSize).clamp(0, totalCount);
    final summary = totalCount == 0
        ? 'Sin $itemLabel'
        : 'Mostrando ${numbers.format(from)}–${numbers.format(to)} '
              'de ${numbers.format(totalCount)} $itemLabel';
    final pages = pageCount;

    return Container(
      height: AppSizes.paginationBar,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              summary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Text(
            'Filas por página',
            style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(width: AppSpace.sm),
          AppDropdown<int>(
            value: pageSize,
            width: _pageSizeWidth,
            small: true,
            semanticLabel: 'Filas por página',
            items: [
              for (final size in pageSizes)
                AppDropdownItem(value: size, label: '$size'),
            ],
            onChanged: onPageSizeChanged,
          ),
          const SizedBox(width: AppSpace.lg),
          AppIconButton(
            icon: AppIcons.chevronLeft,
            tooltip: 'Página anterior',
            small: true,
            onPressed: page > 1 ? () => onPageChanged(page - 1) : null,
          ),
          const SizedBox(width: AppSpace.xs),
          Text(
            'Página ${numbers.format(page)} de ${numbers.format(pages)}',
            style: AppText.bodySSemiBold.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: AppSpace.xs),
          AppIconButton(
            icon: AppIcons.chevronRight,
            tooltip: 'Página siguiente',
            small: true,
            onPressed: page < pages ? () => onPageChanged(page + 1) : null,
          ),
        ],
      ),
    );
  }
}
