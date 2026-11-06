import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';

/// Trend line under a KPI value.
@immutable
class KpiTrend {
  const KpiTrend({required this.text, required this.up, this.tone});

  /// E.g. «+8 % vs. mes anterior».
  final String text;

  /// Draws Tendencia arriba (true) or abajo (false).
  final bool up;

  /// Defaults to success for up and danger for down. Pass the opposite when a rise is
  /// bad news (more frauds).
  final StatusTone? tone;
}

/// KPI card (A-07 / A-08): title, icon tile, value in `kpi`, and a detail or trend line
/// (DESIGN.md · KpiCard).
class KpiCard extends StatelessWidget {
  const KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    this.detail,
    this.trend,
    super.key,
  });

  final String title;

  /// Already formatted value, e.g. «1.284» or «92 %».
  final String value;
  final AppIcons icon;

  /// Supporting line in `bodyS` tertiary. Ignored when [trend] is set.
  final String? detail;
  final KpiTrend? trend;

  @override
  Widget build(BuildContext context) {
    final trend = this.trend;
    final trendTone =
        trend?.tone ??
        (trend?.up ?? true ? StatusTone.success : StatusTone.danger);

    return Container(
      padding: const EdgeInsets.all(AppSpace.xl),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
                ),
              ),
              Container(
                width: AppSizes.kpiIconTile,
                height: AppSizes.kpiIconTile,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.bgBrandSubtle,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: AppIcon(
                  icon,
                  size: AppIconSize.sm,
                  color: AppColors.iconBrand,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.xs),
          Text(value, style: AppText.kpi),
          const SizedBox(height: AppSpace.xs),
          if (trend != null)
            Row(
              children: [
                AppIcon(
                  trend.up ? AppIcons.trendUp : AppIcons.trendDown,
                  size: AppIconSize.sm,
                  color: trendTone.text,
                ),
                const SizedBox(width: AppSpace.xs),
                Flexible(
                  child: Text(
                    trend.text,
                    style: AppText.bodySSemiBold.copyWith(
                      color: trendTone.text,
                    ),
                  ),
                ),
              ],
            )
          else if (detail != null)
            Text(
              detail!,
              style: AppText.bodyS.copyWith(color: AppColors.textTertiary),
            ),
        ],
      ),
    );
  }
}
