import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'app_menu.dart';
import 'field_label.dart';
import 'field_message.dart';
import 'pressable.dart';

/// One option of an [AppDropdown].
@immutable
class AppDropdownItem<T> {
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.detail,
  });

  final T value;
  final String label;
  final AppIcons? icon;

  /// Text at the right end of the option, e.g. a count.
  final String? detail;
}

/// Desplegable (Figma Componentes `4:3`) · a field with a chevron that opens an [AppMenu].
///
/// Looks like [AppTextField] (label above, 40 px or 32 px with [small], error below). The
/// selected option shows `bgSelected` + Check in the menu. [prefix] is written before the
/// value inside the field, as in «Ordenar por: **Fecha**».
///
/// ```dart
/// AppDropdown<int>(
///   value: pageSize,
///   items: [for (final n in [25, 50, 100]) AppDropdownItem(value: n, label: '$n')],
///   onChanged: setPageSize,
///   small: true,
/// )
/// ```
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.hint = 'Seleccionar',
    this.prefix,
    this.required = false,
    this.errorText,
    this.small = false,
    this.width,
    this.semanticLabel,
    super.key,
  });

  final List<AppDropdownItem<T>> items;

  /// Selected value; null shows [hint].
  final T? value;

  /// Null disables the field.
  final ValueChanged<T>? onChanged;
  final String? label;
  final String hint;

  /// Text before the value inside the field («Ordenar por:»).
  final String? prefix;
  final bool required;
  final String? errorText;
  final bool small;

  /// Fixed width. Without it the field takes its parent's width.
  final double? width;

  /// Accessible name when there is no visible [label].
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final selected = items.where((item) => item.value == value).firstOrNull;
    final enabled = onChanged != null;
    final hasError = errorText != null;

    Widget field = LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        // Inside a Row without a width, fall back to the menu width.
        width: constraints.hasBoundedWidth ? null : AppSizes.menuMinWidth,
        child: _buildMenu(
          constraints.hasBoundedWidth
              ? constraints.maxWidth
              : AppSizes.menuMinWidth,
          selected: selected,
          enabled: enabled,
          hasError: hasError,
        ),
      ),
    );
    if (width != null) field = SizedBox(width: width, child: field);

    if (label == null && !hasError) return field;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          FieldLabel(label!, required: required),
          const SizedBox(height: AppSpace.xs),
        ],
        field,
        if (hasError) ...[
          const SizedBox(height: AppSpace.xs),
          FieldMessage(errorText!, isError: true),
        ],
      ],
    );
  }

  Widget _buildMenu(
    double menuWidth, {
    required AppDropdownItem<T>? selected,
    required bool enabled,
    required bool hasError,
  }) {
    return AppMenu(
      minWidth: menuWidth,
      entries: [
        for (final item in items)
          AppMenuAction(
            label: item.label,
            icon: item.icon,
            detail: item.detail,
            selected: item.value == value,
            onSelected: enabled ? () => onChanged!(item.value) : null,
          ),
      ],
      builder: (context, controller) => Pressable(
        onPressed: enabled ? controller.toggle : null,
        semanticLabel: label ?? semanticLabel ?? prefix,
        builder: (context, state) => _Trigger(
          selected: selected,
          hint: hint,
          prefix: prefix,
          small: small,
          hasError: hasError,
          open: controller.isOpen,
          state: state,
        ),
      ),
    );
  }
}

class _Trigger<T> extends StatelessWidget {
  const _Trigger({
    required this.selected,
    required this.hint,
    required this.prefix,
    required this.small,
    required this.hasError,
    required this.open,
    required this.state,
  });

  final AppDropdownItem<T>? selected;
  final String hint;
  final String? prefix;
  final bool small;
  final bool hasError;
  final bool open;
  final PressableState state;

  @override
  Widget build(BuildContext context) {
    final enabled = state.enabled;
    final borderColor = hasError
        ? AppColors.borderDanger
        : open
        ? AppColors.borderFocus
        : state.hovered
        ? AppColors.borderStrong
        : AppColors.borderDefault;
    final textColor = enabled ? AppColors.textPrimary : AppColors.textDisabled;

    return Container(
      height: small ? AppSizes.controlS : AppSizes.controlM,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
      decoration: BoxDecoration(
        color: enabled ? AppColors.bgSurface : AppColors.bgDisabled,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: borderColor, width: open ? 2 : 1),
      ),
      child: Row(
        children: [
          if (selected?.icon != null) ...[
            AppIcon(
              selected!.icon!,
              size: AppIconSize.md,
              color: AppColors.iconSecondary,
            ),
            const SizedBox(width: AppSpace.sm),
          ],
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  if (prefix != null)
                    TextSpan(
                      text: '$prefix ',
                      style: AppText.bodyM.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  TextSpan(
                    text: selected?.label ?? hint,
                    style:
                        (prefix != null ? AppText.bodyMSemiBold : AppText.bodyM)
                            .copyWith(
                              color: selected == null
                                  ? AppColors.textTertiary
                                  : textColor,
                            ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          AppIcon(
            open ? AppIcons.chevronUp : AppIcons.chevronDown,
            size: AppIconSize.md,
            color: enabled ? AppColors.iconSecondary : AppColors.textDisabled,
          ),
        ],
      ),
    );
  }
}
