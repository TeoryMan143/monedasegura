import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';

/// One row of [HorizontalBars].
@immutable
class BarItem {
  const BarItem({
    required this.label,
    required this.value,
    required this.valueText,
    this.detail,
  });

  final String label;

  /// Length of the bar. Null draws no bar and shows [valueText] in its place («Sin datos»).
  final num? value;

  /// The number at the right end, already formatted.
  final String valueText;

  /// Extra context for the tooltip and screen readers, e.g. «120 alertas».
  final String? detail;
}

/// Horizontal bars (DESIGN.md · Data visualisation): label left, azul bar, value right.
///
/// The rows come in the order given: sort them before. Each bar is as long as its share of
/// [maxValue], which defaults to the highest value. Plain widgets rather than `fl_chart`,
/// which are simpler and more accessible than a chart forced to draw horizontally.
class HorizontalBars extends StatelessWidget {
  const HorizontalBars({required this.items, this.maxValue, super.key});

  final List<BarItem> items;
  final num? maxValue;

  @override
  Widget build(BuildContext context) {
    final max =
        maxValue ??
        items.fold<num>(
          0,
          (max, item) => (item.value ?? 0) > max ? item.value! : max,
        );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [for (final item in items) _BarRow(item: item, max: max)],
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({required this.item, required this.max});

  final BarItem item;
  final num max;

  @override
  Widget build(BuildContext context) {
    final value = item.value;
    final fraction = value == null || max <= 0
        ? 0.0
        : (value / max).clamp(0, 1).toDouble();
    final description = [
      '${item.label}: ${item.valueText}',
      if (item.detail != null) item.detail!,
    ].join(' · ');

    return Semantics(
      label: description,
      excludeSemantics: true,
      child: AppTooltip(
        message: description,
        child: SizedBox(
          height: AppSizes.barRow,
          child: Row(
            children: [
              SizedBox(
                width: AppSizes.barLabelWidth,
                child: Text(
                  item.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: value == null
                    ? const SizedBox.shrink()
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: fraction,
                          child: Container(
                            height: AppSizes.barThickness,
                            decoration: BoxDecoration(
                              color: AppColors.azul500,
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: AppSpace.sm),
              SizedBox(
                width: AppSizes.barValueWidth,
                child: Text(
                  item.valueText,
                  textAlign: TextAlign.right,
                  style: value == null
                      ? AppText.bodyS.copyWith(color: AppColors.textTertiary)
                      : AppText.bodySSemiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton of [HorizontalBars]: [rows] grey rows.
class HorizontalBarsSkeleton extends StatelessWidget {
  const HorizontalBarsSkeleton({this.rows = 6, super.key});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cargando',
      child: Column(
        children: [
          for (var i = 0; i < rows; i++)
            const SizedBox(
              height: AppSizes.barRow,
              child: Row(
                children: [
                  SkeletonBox(width: AppSizes.barLabelWidth),
                  SizedBox(width: AppSpace.sm),
                  Expanded(child: SkeletonBox(height: AppSizes.barThickness)),
                  SizedBox(width: AppSpace.sm),
                  SkeletonBox(width: AppSizes.barValueWidth),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
