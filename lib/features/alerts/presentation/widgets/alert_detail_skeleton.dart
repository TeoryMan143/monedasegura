import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';

/// Loading state of A-05 (HU-07): the same blocks as the screen (header, score, reasons,
/// transactions and the customer card), so nothing jumps when the data arrives.
class AlertDetailSkeleton extends StatelessWidget {
  const AlertDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cargando',
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppLayout.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeaderSkeleton(),
            SizedBox(height: AppLayout.blockGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ScoreSkeleton(),
                      SizedBox(height: AppLayout.blockGap),
                      _ListSkeleton(rows: 4, rowHeight: AppSizes.tableRow),
                      SizedBox(height: AppLayout.blockGap),
                      _ListSkeleton(rows: 2, rowHeight: AppSizes.tableRow),
                    ],
                  ),
                ),
                SizedBox(width: AppLayout.blockGap),
                SizedBox(
                  width: AppLayout.detailAsideWidth,
                  child: AppPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: 80),
                        SizedBox(height: AppSpace.lg),
                        SkeletonBox(width: 160),
                        SizedBox(height: AppSpace.lg),
                        SkeletonBox(width: 120, height: AppSizes.controlM),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 160),
              SizedBox(height: AppSpace.sm),
              SkeletonBox(width: 360, height: AppSpace.xxl),
              SizedBox(height: AppSpace.xs),
              SkeletonBox(width: 280),
            ],
          ),
        ),
        SizedBox(width: AppSpace.lg),
        SkeletonBox(width: 160, height: AppSizes.controlM),
      ],
    );
  }
}

class _ScoreSkeleton extends StatelessWidget {
  const _ScoreSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppPanel(
      child: Row(
        children: [
          SkeletonBox(
            width: AppSizes.scoreBadgeLarge,
            height: AppSizes.scoreBadgeLarge,
            radius: AppRadius.lg,
          ),
          SizedBox(width: AppSpace.xl),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 120),
                SizedBox(height: AppSpace.sm),
                SkeletonBox(),
              ],
            ),
          ),
          SizedBox(width: AppSpace.xl),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 100),
                SizedBox(height: AppSpace.sm),
                SkeletonBox(width: 160),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton({required this.rows, required this.rowHeight});

  final int rows;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SkeletonBox(width: 200),
          for (var i = 0; i < rows; i++) ...[
            const SizedBox(height: AppSpace.md),
            SkeletonBox(height: rowHeight),
          ],
        ],
      ),
    );
  }
}
