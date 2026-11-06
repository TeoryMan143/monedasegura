import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'pressable.dart';

/// Visual weight of an [AppIconButton].
enum AppIconButtonVariant { tertiary, secondary }

/// Botón ícono (Figma Componentes `4:3`) · 36×36 icon-only button (28×28 with [small]).
///
/// Always has a [tooltip], which is also its accessible name. Disabled when
/// [onPressed] is null.
///
/// ```dart
/// AppIconButton(icon: AppIcons.close, tooltip: 'Cerrar', onPressed: close)
/// ```
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.variant = AppIconButtonVariant.tertiary,
    this.small = false,
    this.color,
    this.focusNode,
    super.key,
  });

  final AppIcons icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final AppIconButtonVariant variant;

  /// 28 px square with a 16 px icon, for chips, toasts and table cells.
  final bool small;

  /// Icon colour override (defaults to `iconPrimary`).
  final Color? color;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final side = small ? AppSizes.iconButtonS : AppSizes.iconButton;
    return Pressable(
      onPressed: onPressed,
      tooltip: tooltip,
      semanticLabel: tooltip,
      focusNode: focusNode,
      builder: (context, state) {
        final secondary = variant == AppIconButtonVariant.secondary;
        final background = state.pressed
            ? AppColors.bgSurfaceSubtle
            : state.hovered
            ? AppColors.bgRowHover
            : secondary
            ? AppColors.bgSurface
            : Colors.transparent;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: side,
          height: side,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: secondary
                ? Border.all(color: AppColors.borderDefault)
                : null,
          ),
          child: AppIcon(
            icon,
            size: small ? AppIconSize.sm : AppIconSize.md,
            color: state.enabled
                ? (color ?? AppColors.iconPrimary)
                : AppColors.textDisabled,
          ),
        );
      },
    );
  }
}
