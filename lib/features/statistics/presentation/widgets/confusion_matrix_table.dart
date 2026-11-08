import 'package:flutter/material.dart';

import '../../../../core/domain/fraud_type.dart';
import '../../../../core/formatting/numbers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/chart_transforms.dart';
import '../../domain/confusion_matrix.dart';
import '../chart_presentation.dart';
import '../stats_labels.dart';

/// N-04 · The grid of the confusion matrix: suggested type by row, final result by column
/// (including «No fraude», the rejected alerts).
///
/// Every cell prints its count, zero included. Its blue comes from `cellIntensity`, and the
/// text turns white on the dark ones. The diagonal (final type equals suggested) carries a
/// border and a check icon, and each cell has a description for screen readers. The grid
/// scrolls sideways inside its parent when it does not fit.
class ConfusionMatrixTable extends StatelessWidget {
  const ConfusionMatrixTable({required this.matrix, super.key});

  final ConfusionMatrix matrix;

  static const _gap = AppSpace.xs;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderRow(matrix: matrix),
          for (var row = 0; row < matrix.rows.length; row++) ...[
            const SizedBox(height: _gap),
            _MatrixRow(matrix: matrix, row: row),
          ],
        ],
      ),
    );
  }
}

/// «ATO» for a type, «No fraude» for the rejected column.
String _axisLabel(String key) =>
    key == ConfusionMatrix.noFraudKey ? 'No fraude' : key;

/// The full name that goes with an axis [key], for tooltips and screen readers.
String _axisName(String key) =>
    key == ConfusionMatrix.noFraudKey ? 'No fraude' : fraudTypeLabel(key);

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.matrix});

  final ConfusionMatrix matrix;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSizes.matrixLabelWidth,
          child: Text(
            'Sugerida\nFinal',
            style: AppText.bodyS.copyWith(color: AppColors.textTertiary),
          ),
        ),
        for (final column in matrix.columns) ...[
          const SizedBox(width: ConfusionMatrixTable._gap),
          _AxisLabel(
            key: ValueKey('column-$column'),
            axisKey: column,
            width: AppSizes.matrixCellWidth,
            alignment: Alignment.center,
          ),
        ],
      ],
    );
  }
}

class _MatrixRow extends StatelessWidget {
  const _MatrixRow({required this.matrix, required this.row});

  final ConfusionMatrix matrix;
  final int row;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AxisLabel(
          key: ValueKey('row-${matrix.rows[row]}'),
          axisKey: matrix.rows[row],
          width: AppSizes.matrixLabelWidth,
          alignment: Alignment.centerLeft,
        ),
        for (var column = 0; column < matrix.columns.length; column++) ...[
          const SizedBox(width: ConfusionMatrixTable._gap),
          _Cell(matrix: matrix, row: row, column: column),
        ],
      ],
    );
  }
}

class _AxisLabel extends StatelessWidget {
  const _AxisLabel({
    required this.axisKey,
    required this.width,
    required this.alignment,
    super.key,
  });

  final String axisKey;
  final double width;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return AppTooltip(
      message: _axisName(axisKey),
      child: SizedBox(
        width: width,
        child: Align(
          alignment: alignment,
          child: Text(
            _axisLabel(axisKey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.bodySSemiBold.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.matrix, required this.row, required this.column});

  final ConfusionMatrix matrix;
  final int row;
  final int column;

  @override
  Widget build(BuildContext context) {
    final count = matrix.count(row, column);
    final isHit = matrix.isHit(row, column);
    final intensity = cellIntensity(count, matrix);
    final isZero = count == 0;
    final background = isZero
        ? AppColors.bgSurfaceSubtle
        : matrixCellColor(intensity);
    final textColor = isZero
        ? AppColors.textTertiary
        : matrixCellTextColor(intensity);

    final description =
        'Sugerida ${_axisLabel(matrix.rows[row])}, '
        'final ${_axisLabel(matrix.columns[column])}: '
        '${formatCount(count)} ${count == 1 ? 'alerta' : 'alertas'}'
        '${isHit ? '. Acierto' : ''}';

    return Semantics(
      label: description,
      excludeSemantics: true,
      child: Container(
        key: ValueKey('cell-$row-$column'),
        width: AppSizes.matrixCellWidth,
        height: AppSizes.matrixCellHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isHit
              ? Border.all(color: AppColors.azul900, width: AppSpace.xxs)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isHit) ...[
              AppIcon(AppIcons.check, size: AppIconSize.xs, color: textColor),
              const SizedBox(width: AppSpace.xxs),
            ],
            Text(
              formatCount(count),
              style: (isZero ? AppText.bodyS : AppText.bodySSemiBold).copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Legend of the matrix: the blue ramp and what the marks mean, in text and not only
/// colour.
class ConfusionMatrixLegend extends StatelessWidget {
  const ConfusionMatrixLegend({super.key});

  static const _steps = 6;

  @override
  Widget build(BuildContext context) {
    final style = AppText.bodyS.copyWith(color: AppColors.textSecondary);
    return Wrap(
      spacing: AppSpace.xl,
      runSpacing: AppSpace.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Menos', style: style),
            const SizedBox(width: AppSpace.sm),
            for (var step = 0; step <= _steps; step++)
              Container(
                width: AppSpace.lg,
                height: AppSpace.lg,
                margin: const EdgeInsets.only(right: AppSpace.xxs),
                decoration: BoxDecoration(
                  color: matrixCellColor(step / _steps),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
            const SizedBox(width: AppSpace.xs),
            Text('Más alertas', style: style),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSpace.lg,
              height: AppSpace.lg,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: AppColors.azul900,
                  width: AppSpace.xxs,
                ),
              ),
              child: const AppIcon(
                AppIcons.check,
                size: AppIconSize.xs,
                color: AppColors.azul900,
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            Text(
              'Acierto: el tipo final coincide con el sugerido',
              style: style,
            ),
          ],
        ),
        Text('Columna «No fraude»: alertas rechazadas', style: style),
      ],
    );
  }
}

/// How many fraud types there are: the rows of the skeleton, which cannot know the real
/// ones before the data arrives.
final matrixSkeletonRows = FraudType.values.length;
