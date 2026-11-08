import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/formatting/date_time.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import 'controllers/statistics_providers.dart';
import 'widgets/ai_tab.dart';
import 'widgets/fraud_tab.dart';
import 'widgets/statistics_filters.dart';

/// Tabs of the statistics page, as they appear in the route (`/statistics/:tab`).
enum StatisticsTab {
  fraud('Fraude'),
  ai('Desempeño de la IA');

  const StatisticsTab(this.label);

  /// Text of the tab.
  final String label;

  /// The tab for a route segment, falling back to [fraud] for unknown values.
  static StatisticsTab fromPath(String? value) =>
      values.asNameMap()[value] ?? fraud;
}

/// A-07 / A-08 · Statistics (HU-13): header with the global filters, the two tabs
/// and the body of the active one.
///
/// The tab lives in the route, and the filters in [statisticsFilterProvider], so
/// switching tabs keeps them.
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({required this.tab, super.key});

  final StatisticsTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(statisticsFilterProvider);
    final range = filter.fromDate == null && filter.toDate == null
        ? 'todo el periodo'
        : formatDateRange(filter.fromDate, filter.toDate);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppLayout.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estadísticas', style: AppText.h1),
                    Text(
                      'Fraude etiquetado y desempeño de la IA · $range',
                      style: AppText.bodyM.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.lg),
              const StatisticsFilters(),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          AppTabs(
            tabs: [
              for (final tab in StatisticsTab.values) AppTab(label: tab.label),
            ],
            selectedIndex: tab.index,
            onChanged: (index) => context.go(
              AppRoutes.statisticsTab(StatisticsTab.values[index]),
            ),
          ),
          const SizedBox(height: AppLayout.blockGap),
          switch (tab) {
            StatisticsTab.fraud => const FraudTab(),
            StatisticsTab.ai => const AiTab(),
          },
        ],
      ),
    );
  }
}
