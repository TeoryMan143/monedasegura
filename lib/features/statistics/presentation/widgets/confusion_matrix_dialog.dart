import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/country.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/formatting/numbers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/confusion_matrix.dart';
import '../../domain/statistics_filter.dart';
import '../controllers/statistics_providers.dart';
import 'confusion_matrix_table.dart';
import 'stats_async.dart';

/// Opens N-04 · the confusion matrix, for the filters the page has now (HU-13).
Future<void> showConfusionMatrixDialog(BuildContext context) =>
    showAppDialog<void>(
      context: context,
      builder: (context) => const ConfusionMatrixDialog(),
    );

/// N-04 · Matriz de confusión: the suggested type of the AI against the final result of
/// the analyst. It opens at once and shows its own skeleton while it loads, or an error
/// with «Reintentar».
class ConfusionMatrixDialog extends ConsumerWidget {
  const ConfusionMatrixDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(statisticsFilterProvider);
    final value = ref.watch(confusionMatrixProvider(filter));
    final close = Navigator.of(context).maybePop;

    return AppDialog(
      title: 'Matriz de confusión',
      subtitle: _scope(filter),
      size: AppDialogSize.l,
      onSubmit: () => close(),
      actions: [
        AppButton(
          label: 'Cerrar',
          variant: AppButtonVariant.secondary,
          onPressed: () => close(),
        ),
      ],
      body: StatsAsync<ConfusionMatrix>(
        value: value,
        onRetry: () => ref.invalidate(confusionMatrixProvider(filter)),
        stateHeight: _skeletonHeight,
        isEmpty: (matrix) => matrix.isEmpty,
        loading: const _MatrixSkeleton(),
        builder: (context, matrix) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Filas: tipo sugerido por la IA · Columnas: resultado final del '
              'analista · ${formatCount(_resolved(matrix))} alertas resueltas',
              style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpace.lg),
            ConfusionMatrixTable(matrix: matrix),
            const SizedBox(height: AppSpace.lg),
            const ConfusionMatrixLegend(),
          ],
        ),
      ),
    );
  }

  static int _resolved(ConfusionMatrix matrix) =>
      [for (var row = 0; row < matrix.rows.length; row++) matrix.rowTotal(row)]
          .fold(0, (sum, total) => sum + total);

  /// «1 ene – 20 mar 2026 · Todos los países»: what the matrix is about.
  static String _scope(StatisticsFilter filter) {
    final range = filter.fromDate == null && filter.toDate == null
        ? 'Todo el periodo'
        : formatDateRange(filter.fromDate, filter.toDate);
    final code = filter.countryCode;
    final country = code == null
        ? 'Todos los países'
        : Country.values.where((c) => c.dbValue == code).firstOrNull?.label ??
              code;
    return '$range · $country';
  }

  static final _skeletonHeight =
      (matrixSkeletonRows + 1) * (AppSizes.matrixCellHeight + AppSpace.xs);
}

class _MatrixSkeleton extends StatelessWidget {
  const _MatrixSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cargando',
      child: Column(
        children: [
          for (var row = 0; row <= matrixSkeletonRows; row++)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpace.xs),
              child: SkeletonBox(height: AppSizes.matrixCellHeight),
            ),
        ],
      ),
    );
  }
}
