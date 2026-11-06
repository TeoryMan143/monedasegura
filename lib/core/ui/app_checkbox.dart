import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Selección · 20 px checkbox (DESIGN.md · Component kit).
///
/// A null [value] draws the indeterminate state used by the «select all» checkbox of
/// tables. Pressing it while indeterminate selects everything ([onChanged] gets `true`).
/// With a [label], clicking the text toggles it too.
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    required this.value,
    required this.onChanged,
    this.label,
    this.semanticLabel,
    this.focusNode,
    super.key,
  });

  /// `true`, `false` or `null` (indeterminate).
  final bool? value;

  /// Receives the new value. Null disables the checkbox.
  final ValueChanged<bool>? onChanged;
  final String? label;

  /// Accessible name when there is no visible [label] (e.g. «Seleccionar fila»).
  final String? semanticLabel;
  final FocusNode? focusNode;

  void _toggle() => onChanged?.call(value != true);

  @override
  Widget build(BuildContext context) {
    final box = SizedBox.square(
      dimension: AppSizes.checkbox,
      child: Checkbox(
        value: value,
        tristate: value == null,
        onChanged: onChanged == null ? null : (_) => _toggle(),
        focusNode: focusNode,
        semanticLabel: label ?? semanticLabel,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        splashRadius: AppSizes.checkbox * 0.75,
        mouseCursor: onChanged == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
        ),
        side: WidgetStateBorderSide.resolveWith(
          (states) => BorderSide(
            width: 1.5,
            color: states.contains(WidgetState.disabled)
                ? AppColors.borderSubtle
                : states.contains(WidgetState.selected)
                ? AppColors.bgBrand
                : states.contains(WidgetState.hovered)
                ? AppColors.borderStrong
                : AppColors.borderDefault,
          ),
        ),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.bgDisabled;
          }
          if (states.contains(WidgetState.selected)) return AppColors.bgBrand;
          return AppColors.bgSurface;
        }),
        checkColor: AppColors.gris0,
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? AppShadows.focusRing.first.color
              : states.contains(WidgetState.hovered)
              ? AppColors.bgSelected
              : null,
        ),
      ),
    );

    if (label == null) return box;
    return MouseRegion(
      cursor: onChanged == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged == null ? null : _toggle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            box,
            const SizedBox(width: AppSpace.sm),
            Flexible(
              child: ExcludeSemantics(
                child: Text(
                  label!,
                  style: AppText.bodyM.copyWith(
                    color: onChanged == null
                        ? AppColors.textDisabled
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
