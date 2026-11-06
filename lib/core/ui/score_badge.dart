import 'package:flutter/material.dart';

import '../domain/score_range.dart';
import '../theme/app_theme.dart';

/// AI score badge: the number on the solid tone of its [ScoreRange] (DESIGN.md · ScoreBadge).
///
/// White text, except on the warning (yellow) range. The table size is about 40×28 and
/// shows the range in a tooltip; [ScoreBadge.large] (alert detail, 80×80) adds «de 100».
/// The number + range text keep it readable without colour.
class ScoreBadge extends StatelessWidget {
  const ScoreBadge({required this.score, super.key}) : large = false;

  /// 80×80 variant with «de 100» under the number (A-05 alert detail).
  const ScoreBadge.large({required this.score, super.key}) : large = true;

  /// AI score 0–100.
  final int score;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final range = ScoreRange.of(score);
    final tone = range.tone;
    final semantics = 'Score $score de 100, ${range.riskLabel.toLowerCase()}';

    if (large) {
      return Semantics(
        label: semantics,
        child: ExcludeSemantics(
          child: Container(
            width: AppSizes.scoreBadgeLarge,
            height: AppSizes.scoreBadgeLarge,
            decoration: BoxDecoration(
              color: tone.solid,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$score',
                  style: AppText.display.copyWith(
                    color: tone.onSolid,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  'de 100',
                  style: AppText.bodyS.copyWith(color: tone.onSolid),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Tooltip(
      message: range.riskLabel,
      excludeFromSemantics: true,
      child: Semantics(
        label: semantics,
        child: ExcludeSemantics(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: AppSizes.scoreBadgeWidth,
            ),
            height: AppSizes.scoreBadgeHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
            decoration: BoxDecoration(
              color: tone.solid,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            // widthFactor keeps the badge as narrow as its number.
            child: Align(
              widthFactor: 1,
              child: Text(
                '$score',
                style: AppText.tableData.copyWith(
                  color: tone.onSolid,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
