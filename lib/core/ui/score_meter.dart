import 'package:flutter/widgets.dart';

import '../domain/score_range.dart';
import '../theme/app_theme.dart';
import 'status_badge.dart';

/// Barra de avance y score · four-segment 0–100 bar coloured by [ScoreRange] plus a
/// `StatusBadge` with the range text («Riesgo crítico (85–100)») (DESIGN.md · ScoreMeter).
///
/// Segments up to the score's range are solid, the rest use the tone background; a dark
/// tick marks the exact score. The badge text keeps it readable without colour.
class ScoreMeter extends StatelessWidget {
  const ScoreMeter({required this.score, this.showScale = true, super.key});

  /// AI score 0–100.
  final int score;

  /// Writes the range limits (0 · 40 · 70 · 85 · 100) under the bar.
  final bool showScale;

  @override
  Widget build(BuildContext context) {
    final current = ScoreRange.of(score);
    final position = score.clamp(0, 100) / 100;

    return Semantics(
      label: 'Score $score de 100, ${current.riskLabel.toLowerCase()}',
      child: ExcludeSemantics(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return SizedBox(
                  height: AppSizes.scoreMeterTrack + AppSpace.xs,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: AppSpace.xxs,
                        height: AppSizes.scoreMeterTrack,
                        child: Row(
                          children: [
                            for (final (index, range)
                                in ScoreRange.values.indexed) ...[
                              if (index > 0)
                                const SizedBox(width: AppSpace.xxs),
                              Expanded(
                                flex: range.max - range.min + 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: range.index <= current.index
                                        ? range.tone.solid
                                        : range.tone.background,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.full,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Positioned(
                        left: (width * position - 1)
                            .clamp(0.0, width - 2)
                            .toDouble(),
                        top: 0,
                        bottom: 0,
                        child: Container(width: 2, color: AppColors.gris900),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (showScale) ...[
              const SizedBox(height: AppSpace.xs),
              Row(
                children: [
                  for (final range in ScoreRange.values)
                    Expanded(
                      flex: range.max - range.min + 1,
                      child: Text(
                        '${range.min}',
                        style: AppText.bodyS.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  Text(
                    '100',
                    style: AppText.bodyS.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpace.sm),
            StatusBadge(label: current.riskLabel, tone: current.tone),
          ],
        ),
      ),
    );
  }
}
