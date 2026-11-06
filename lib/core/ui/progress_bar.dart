import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';

/// Barra de avance · labeled progress, e.g. «42/60 etiquetadas · 70 %» (DESIGN.md).
///
/// The counts and the percentage are always written, so the bar never carries meaning
/// by itself. Azul fill on `gris-100`, 240 px wide by default.
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    required this.done,
    required this.total,
    this.label = 'etiquetadas',
    this.width = AppSizes.progressBar,
    super.key,
  });

  final int done;
  final int total;

  /// Noun after the count: «42/60 etiquetadas».
  final String label;

  /// Null takes the parent's width.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final fraction = total <= 0
        ? 0.0
        : (done / total).clamp(0.0, 1.0).toDouble();
    final percent = (fraction * 100).round();
    final text = '$done/$total $label';

    return Semantics(
      label: '$text, $percent %',
      child: ExcludeSemantics(
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodyS.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Text('$percent %', style: AppText.bodySSemiBold),
                ],
              ),
              const SizedBox(height: AppSpace.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: SizedBox(
                  height: AppSizes.progressTrack,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: AppColors.bgSurfaceSubtle),
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: fraction,
                        child: const ColoredBox(color: AppColors.bgBrand),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
