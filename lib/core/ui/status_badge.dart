import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';

/// Insignia (Figma Componentes `4:3`) · pill with tone background, tone text, icon and text.
///
/// Status is never only colour (DESIGN.md · Principles): pass the domain value's label,
/// tone and icon, which live in `core/domain` (`StatusBadge(label: verdict.label,
/// tone: verdict.tone, icon: verdict.icon)`). Sizes M 22 px and S 18 px ([small]).
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    required this.tone,
    this.icon,
    this.small = false,
    super.key,
  });

  final String label;
  final StatusTone tone;

  /// 12 px icon before the text.
  final AppIcons? icon;

  /// 18 px tall instead of 22 px.
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: small ? AppSizes.badgeS : AppSizes.badgeM,
      padding: EdgeInsets.symmetric(
        horizontal: small ? AppSpace.sm - AppSpace.xxs : AppSpace.sm,
      ),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            AppIcon(icon!, size: AppIconSize.xs, color: tone.text),
            const SizedBox(width: AppSpace.xs),
          ],
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.bodySSemiBold.copyWith(color: tone.text),
          ),
        ],
      ),
    );
  }
}
