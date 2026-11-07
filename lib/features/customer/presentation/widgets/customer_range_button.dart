import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatting/date_time.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/date_range.dart';
import '../controllers/customer_range_controller.dart';

/// The date range of the customer view, top right of A-02 (HU-03): «1–15 mar 2026».
/// Opens the date range picker; the range also applies to the customer report.
class CustomerRangeButton extends ConsumerWidget {
  const CustomerRangeButton({required this.customerId, super.key});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(customerDateRangeProvider(customerId));
    return AppButton(
      label: formatDateRange(range.from, range.to),
      icon: AppIcons.calendar,
      variant: AppButtonVariant.secondary,
      onPressed: () async {
        final now = DateTime.now();
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(now.year + 1, 12, 31),
          initialDateRange: DateTimeRange(start: range.from, end: range.to),
          helpText: 'Rango de fechas',
          saveText: 'Aplicar',
        );
        if (picked == null) return;
        ref
            .read(customerDateRangeProvider(customerId).notifier)
            .setRange(DateRange(from: picked.start, to: picked.end));
      },
    );
  }
}
