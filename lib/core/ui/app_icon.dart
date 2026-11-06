import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

/// Renders one of the [AppIcons] line icons (DESIGN.md · Icons).
///
/// Size and colour fall back to the surrounding [IconTheme], then to 24 px and
/// [AppColors.iconPrimary]. Use 20 px in buttons and inputs and 16 px in badges.
/// Pass [semanticLabel] only when the icon carries meaning on its own.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    this.size,
    this.color,
    this.semanticLabel,
    super.key,
  });

  final AppIcons icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final resolvedSize = size ?? theme.size ?? 24;
    final resolvedColor = color ?? theme.color ?? AppColors.iconPrimary;
    return SvgPicture.asset(
      icon.asset,
      width: resolvedSize,
      height: resolvedSize,
      colorFilter: ColorFilter.mode(resolvedColor, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
