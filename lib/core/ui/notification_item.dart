import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'pressable.dart';

/// NotificationItem (C-06) · 380 px row of the bell panel: IA icon, title with the score,
/// customer, relative time, and an unread dot with a bold title until it is read.
class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.title,
    required this.timeLabel,
    required this.unread,
    required this.onTap,
    this.subtitle,
    super.key,
  });

  /// E.g. «Nueva alerta · score 92».
  final String title;

  /// E.g. «AL-1042 · Juan Pérez».
  final String? subtitle;

  /// Already formatted relative time, e.g. «hace 3 min».
  final String timeLabel;
  final bool unread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const tone = StatusTone.info;
    return Pressable(
      onPressed: onTap,
      semanticLabel: [
        if (unread) 'Sin leer',
        title,
        ?subtitle,
        timeLabel,
      ].join(', '),
      builder: (context, state) => Container(
        width: AppSizes.toastWidth,
        padding: const EdgeInsets.all(AppSpace.md),
        decoration: BoxDecoration(
          color: state.hovered ? AppColors.bgRowHover : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSizes.kpiIconTile,
              height: AppSizes.kpiIconTile,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tone.background,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: AppIcon(
                AppIcons.ai,
                size: AppIconSize.sm,
                color: tone.text,
              ),
            ),
            const SizedBox(width: AppSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: unread ? AppText.bodyMSemiBold : AppText.bodyM,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodyS.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  Text(
                    timeLabel,
                    style: AppText.bodyS.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (unread) ...[
              const SizedBox(width: AppSpace.sm),
              Padding(
                padding: const EdgeInsets.only(top: AppSpace.xs),
                child: Container(
                  width: AppSpace.sm,
                  height: AppSpace.sm,
                  decoration: const BoxDecoration(
                    color: AppColors.bgBrand,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
