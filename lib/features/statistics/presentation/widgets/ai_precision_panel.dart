import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/fraud_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/ai_performance.dart';
import '../controllers/statistics_providers.dart';
import '../precision_bars.dart';
import 'confusion_matrix_dialog.dart';
import 'horizontal_bars.dart';
import 'stats_async.dart';

/// A-08 · «Precisión por tipo»: how often the AI is right for each fraud type, with the
/// button that opens the confusion matrix (HU-13).
class AiPrecisionPanel extends ConsumerWidget {
  const AiPrecisionPanel({super.key});

  /// Precision is a share, so the bars are drawn on a 0–100 scale.
  static const _scale = 100;

  /// One row per fraud type.
  static final _rows = FraudType.values.length;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(statisticsFilterProvider);
    return AppPanel(
      title: 'Precisión por tipo',
      subtitle: 'Alertas sugeridas de ese tipo cuyo tipo final coincidió',
      action: AppButton(
        label: 'Ver matriz de confusión',
        icon: AppIcons.externalLink,
        variant: AppButtonVariant.secondary,
        size: AppButtonSize.s,
        onPressed: () => showConfusionMatrixDialog(context),
      ),
      child: StatsAsync<AiPerformance>(
        value: ref.watch(aiStatsProvider(filter)),
        onRetry: () => ref.invalidate(aiStatsProvider(filter)),
        stateHeight: _rows * AppSizes.barRow,
        isEmpty: (stats) => stats.resolvedCount == 0,
        loading: HorizontalBarsSkeleton(rows: _rows),
        builder: (context, stats) => HorizontalBars(
          items: precisionBars(stats.precisionByType),
          maxValue: _scale,
        ),
      ),
    );
  }
}
