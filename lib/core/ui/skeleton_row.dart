import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'skeleton_box.dart';

/// E-01 · 48 px loading row of a table (DESIGN.md · Tables).
///
/// Draws one bar per column with the same widths as the real table, so the layout does
/// not jump when the data arrives. [AppDataTable] uses it while `loading`.
class SkeletonRow extends StatelessWidget {
  const SkeletonRow({
    required this.columnWidths,
    this.leadingWidth = 0,
    this.numericColumns = const {},
    super.key,
  });

  /// Width of every column, in order.
  final List<double> columnWidths;

  /// Width of the checkbox column (0 when the table has no selection).
  final double leadingWidth;

  /// Indexes of right-aligned (numeric) columns.
  final Set<int> numericColumns;

  // Bars take between 45 % and 75 % of their cell so rows do not look identical.
  static const _fractions = [0.7, 0.5, 0.6, 0.45, 0.75, 0.55];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.tableRow,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          if (leadingWidth > 0)
            SizedBox(
              width: leadingWidth,
              child: const Center(
                child: SkeletonBox(
                  width: AppSizes.checkbox,
                  height: AppSizes.checkbox,
                ),
              ),
            ),
          for (final (index, width) in columnWidths.indexed)
            SizedBox(
              width: width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
                child: Align(
                  alignment: numericColumns.contains(index)
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: SkeletonBox(
                    width: math.max(
                      0.0,
                      (width - AppSpace.xxl) *
                          _fractions[index % _fractions.length],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
