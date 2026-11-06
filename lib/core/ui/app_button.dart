import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'pressable.dart';

/// Visual weight of an [AppButton].
enum AppButtonVariant {
  /// Azul fill, white text. One per view.
  primary,

  /// White with `borderDefault`, primary text.
  secondary,

  /// No border, brand text: low emphasis and links.
  tertiary,

  /// Rojo fill: destructive or irreversible actions («Rechazar»).
  danger,
}

/// Height of an [AppButton].
enum AppButtonSize {
  /// 40 px: forms and bars.
  m,

  /// 32 px: tables and filters.
  s,
}

/// Botón (Figma Componentes `4:3`) · the only button of the app (DESIGN.md · Component kit).
///
/// Variants [AppButtonVariant], sizes [AppButtonSize], optional leading [icon] and a
/// [loading] state that keeps the width and blocks presses. No ripple: hover and pressed
/// change colours. Disabled when [onPressed] is null.
///
/// ```dart
/// AppButton(label: 'Guardar etiqueta', onPressed: save, loading: saving)
/// AppButton(label: 'Filtros', icon: AppIcons.filter, size: AppButtonSize.s,
///     variant: AppButtonVariant.secondary, onPressed: openFilters)
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.m,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expand = false,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Leading icon, 20 px (16 px in size S).
  final AppIcons? icon;

  /// Trailing icon, e.g. a chevron for buttons that open a menu.
  final AppIcons? trailingIcon;

  /// Shows a spinner instead of the icon and ignores presses.
  final bool loading;

  /// Takes the full width of its parent.
  final bool expand;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final isS = size == AppButtonSize.s;
    final iconSize = isS ? AppIconSize.sm : AppIconSize.md;
    return Pressable(
      onPressed: loading ? null : onPressed,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: label,
      builder: (context, state) {
        final colors = _ButtonColors.of(
          variant,
          state,
          enabled: onPressed != null,
        );
        final leading = loading
            ? SizedBox.square(
                dimension: iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.foreground,
                ),
              )
            : icon == null
            ? null
            : AppIcon(icon!, size: iconSize, color: colors.foreground);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: isS ? AppSizes.controlS : AppSizes.controlM,
          width: expand ? double.infinity : null,
          padding: EdgeInsets.symmetric(
            horizontal: isS ? AppSpace.md : AppSpace.lg,
          ),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: colors.border == null
                ? null
                : Border.all(color: colors.border!),
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading,
                const SizedBox(width: AppSpace.sm),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyMSemiBold.copyWith(
                    color: colors.foreground,
                  ),
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: AppSpace.xs),
                AppIcon(
                  trailingIcon!,
                  size: iconSize,
                  color: colors.foreground,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
  });

  factory _ButtonColors.of(
    AppButtonVariant variant,
    PressableState state, {
    required bool enabled,
  }) {
    final active = state.hovered || state.pressed;
    if (!enabled) {
      return switch (variant) {
        AppButtonVariant.tertiary => const _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.textDisabled,
        ),
        _ => const _ButtonColors(
          background: AppColors.bgDisabled,
          foreground: AppColors.textDisabled,
        ),
      };
    }
    return switch (variant) {
      AppButtonVariant.primary => _ButtonColors(
        background: active ? AppColors.bgBrandHover : AppColors.bgBrand,
        foreground: AppColors.textOnBrand,
      ),
      AppButtonVariant.secondary => _ButtonColors(
        background: state.pressed
            ? AppColors.bgSurfaceSubtle
            : state.hovered
            ? AppColors.bgRowHover
            : AppColors.bgSurface,
        foreground: AppColors.textPrimary,
        border: state.hovered
            ? AppColors.borderStrong
            : AppColors.borderDefault,
      ),
      AppButtonVariant.tertiary => _ButtonColors(
        background: active ? AppColors.bgBrandSubtle : Colors.transparent,
        foreground: AppColors.textBrand,
      ),
      AppButtonVariant.danger => _ButtonColors(
        background: active ? AppColors.rojo700 : AppColors.rojo500,
        foreground: AppColors.gris0,
      ),
    };
  }

  final Color background;
  final Color foreground;
  final Color? border;
}
