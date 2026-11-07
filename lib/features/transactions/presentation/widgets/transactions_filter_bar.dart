import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/catalogs/catalog_providers.dart';
import '../../../../core/domain/label_status.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/transactions_query.dart';
import '../controllers/transactions_page_controller.dart';
import '../controllers/transactions_query_controller.dart';
import 'transactions_filter_panel.dart';

/// Toolbar of the A-01 table (HU-02): «Filtros», one removable chip per active filter,
/// «Limpiar filtros» when there are several, and the count.
class TransactionsFilterBar extends ConsumerWidget {
  const TransactionsFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(transactionsQueryProvider);
    final notifier = ref.read(transactionsQueryProvider.notifier);
    final filters = query.activeFilters
        .where((filter) => filter != TransactionsFilter.search)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(AppSpace.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppButton(
            label: 'Filtros',
            icon: AppIcons.filter,
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.s,
            onPressed: () => showTransactionsFilterPanel(context),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final filter in filters)
                  _FilterChip(
                    filter: filter,
                    query: query,
                    onRemove: () => notifier.removeFilter(filter),
                  ),
                if (filters.length > 1)
                  AppButton(
                    label: 'Limpiar filtros',
                    variant: AppButtonVariant.tertiary,
                    size: AppButtonSize.s,
                    onPressed: notifier.clearFilters,
                  ),
                SizedBox(
                  height: AppSizes.controlS,
                  child: Align(widthFactor: 1, child: _CountText(query: query)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends ConsumerWidget {
  const _FilterChip({
    required this.filter,
    required this.query,
    required this.onRemove,
  });

  final TransactionsFilter filter;
  final TransactionsQuery query;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (label, value) = switch (filter) {
      TransactionsFilter.search => ('Búsqueda', query.search),
      TransactionsFilter.dateRange => (
        'Fecha',
        formatDateRange(query.dateFrom, query.dateTo),
      ),
      TransactionsFilter.country => ('País', _countryName(ref)),
      TransactionsFilter.channel => ('Canal', _channelNames(ref)),
      TransactionsFilter.labelStatus => (
        'Etiqueta',
        query.labelStatus?.label ?? '',
      ),
      TransactionsFilter.aiAlert => ('Alerta IA', 'Con alerta'),
    };
    return AppFilterChip(label: label, value: value, onRemove: onRemove);
  }

  String _countryName(WidgetRef ref) {
    final code = query.countryCode;
    final countries = ref.watch(countriesProvider).value ?? const [];
    return countries
            .where((country) => country.code == code)
            .firstOrNull
            ?.name ??
        code ??
        '';
  }

  String _channelNames(WidgetRef ref) {
    final codes = query.channelCodes;
    if (codes.length > 2) return '${codes.length} canales';
    final channels = ref.watch(channelsProvider).value ?? const [];
    return [
      for (final code in codes)
        channels.where((channel) => channel.code == code).firstOrNull?.name ??
            code,
    ].join(', ');
  }
}

/// «50.312 transacciones · 3.906 sin etiquetar», or what is happening meanwhile.
class _CountText extends ConsumerWidget {
  const _CountText({required this.query});

  final TransactionsQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(transactionsPageProvider(query));
    final unlabeled = ref.watch(
      transactionsUnlabeledCountProvider(query.filtersOnly),
    );
    final numbers = NumberFormat.decimalPattern('es');

    final String text;
    if (page.hasError) {
      text = '';
    } else if (!page.hasValue) {
      text = 'Cargando transacciones…';
    } else {
      final total = page.requireValue.total;
      final pending = unlabeled.value;
      text = switch (total) {
        0 => '0 resultados',
        1 => '1 transacción',
        _ => '${numbers.format(total)} transacciones',
      };
      if (total > 0 &&
          pending != null &&
          query.labelStatus != LabelStatus.labeled) {
        return _text('$text · ${numbers.format(pending)} sin etiquetar');
      }
    }
    return _text(text);
  }

  Widget _text(String text) =>
      Text(text, style: AppText.bodyS.copyWith(color: AppColors.textSecondary));
}
