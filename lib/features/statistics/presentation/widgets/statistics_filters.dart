import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/catalogs/catalog_providers.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../controllers/statistics_providers.dart';

/// Global filters of the statistics page (HU-13): date range and country.
///
/// They write to [statisticsFilterProvider], so both tabs read the same values.
class StatisticsFilters extends ConsumerWidget {
  const StatisticsFilters({super.key});

  static const _countryWidth = 220.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(statisticsFilterProvider);
    final notifier = ref.read(statisticsFilterProvider.notifier);
    final countries = ref.watch(countriesProvider).value ?? const [];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          label: filter.fromDate == null && filter.toDate == null
              ? 'Todo el periodo'
              : formatDateRange(filter.fromDate, filter.toDate),
          icon: AppIcons.calendar,
          variant: AppButtonVariant.secondary,
          onPressed: () => _pickRange(context, ref),
        ),
        const SizedBox(width: AppSpace.md),
        AppDropdown<String?>(
          width: _countryWidth,
          prefix: 'País:',
          semanticLabel: 'País',
          value: filter.countryCode,
          onChanged: notifier.setCountry,
          items: [
            const AppDropdownItem(value: null, label: 'Todos los países'),
            for (final country in countries)
              AppDropdownItem(value: country.code, label: country.name),
          ],
        ),
      ],
    );
  }

  Future<void> _pickRange(BuildContext context, WidgetRef ref) async {
    final filter = ref.read(statisticsFilterProvider);
    final from = filter.fromDate;
    final to = filter.toDate;
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: from != null && to != null
          ? DateTimeRange(start: from, end: to)
          : null,
      helpText: 'Rango de fechas',
      saveText: 'Aplicar',
    );
    if (picked == null) return;
    ref
        .read(statisticsFilterProvider.notifier)
        .setRange(picked.start, picked.end);
  }
}
