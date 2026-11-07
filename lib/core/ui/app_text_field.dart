import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'field_label.dart';
import 'field_message.dart';
import 'pressable.dart';

/// Flavour of an [AppTextField].
enum AppTextFieldVariant {
  /// Plain text.
  text,

  /// Leading Buscar icon, for list and global search.
  search,

  /// Trailing Calendario icon. Usually read-only with [AppTextField.onTap].
  date,

  /// Right-aligned tabular figures and a numeric keyboard.
  amount,

  /// Obscured text with a show / hide toggle.
  password,
}

/// Campo de texto (Figma Componentes `4:3`) · single-line input (DESIGN.md · Component kit).
///
/// The [label] is always visible above (a red `*` when [required]). The field is 40 px
/// (32 px with [small]), radius `md`, `borderDefault`; focus shows the 2 px `borderFocus`
/// border and the focus ring; an [errorText] turns the border red and is written below
/// with the Error icon. Supports disabled ([enabled]) and [readOnly].
class AppTextField extends StatefulWidget {
  const AppTextField({
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.errorText,
    this.helperText,
    this.required = false,
    this.enabled = true,
    this.readOnly = false,
    this.variant = AppTextFieldVariant.text,
    this.small = false,
    this.prefixIcon,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    super.key,
  });

  /// Label above the field. Leave null only for search fields with a [hint].
  final String? label;

  /// Placeholder, in `textTertiary`.
  final String? hint;
  final TextEditingController? controller;

  /// Initial text when no [controller] is given.
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Tap on the field, e.g. to open a date picker on a read-only date field.
  final VoidCallback? onTap;

  /// Validation message shown below. A non-null value marks the field as invalid.
  final String? errorText;

  /// Helper line below the field when there is no error.
  final String? helperText;
  final bool required;
  final bool enabled;
  final bool readOnly;
  final AppTextFieldVariant variant;

  /// 32 px height, for filter bars.
  final bool small;

  /// Leading icon; the search variant sets Buscar by default.
  final AppIcons? prefixIcon;

  /// Trailing widget, e.g. the `Ctrl K` keycap of the global search.
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final bool autofocus;
  final FocusNode? focusNode;

  /// Accessible name when there is no visible [label].
  final String? semanticLabel;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode? _ownFocusNode;
  bool _focused = false;
  bool _obscured = true;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_onFocusChange);
      _focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focused != _focusNode.hasFocus) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final isAmount = widget.variant == AppTextFieldVariant.amount;
    final isPassword = widget.variant == AppTextFieldVariant.password;
    final iconColor = widget.enabled
        ? AppColors.iconSecondary
        : AppColors.textDisabled;
    final prefixIcon =
        widget.prefixIcon ??
        (widget.variant == AppTextFieldVariant.search ? AppIcons.search : null);

    final field = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: _focused && !widget.readOnly ? AppShadows.focusRing : null,
      ),
      child: TextFormField(
        controller: widget.controller,
        initialValue: widget.controller == null ? widget.initialValue : null,
        focusNode: _focusNode,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        obscureText: isPassword && _obscured,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        keyboardType:
            widget.keyboardType ??
            (isAmount
                ? const TextInputType.numberWithOptions(decimal: true)
                : null),
        textInputAction: widget.textInputAction,
        inputFormatters: widget.inputFormatters,
        autofillHints: widget.autofillHints,
        textAlign: isAmount ? TextAlign.right : TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: (isAmount ? AppText.tableData : AppText.bodyM).copyWith(
          color: widget.enabled
              ? AppColors.textPrimary
              : AppColors.textDisabled,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          isDense: true,
          // 20 px line + vertical padding = 40 px (M) or 32 px (S). A fixed
          // `constraints` height left the border wrapped tight around the text.
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpace.md,
            vertical: widget.small
                ? (AppSizes.controlS - _lineHeight) / 2
                : (AppSizes.controlM - _lineHeight) / 2,
          ),
          fillColor: widget.enabled
              ? AppColors.bgSurface
              : AppColors.bgDisabled,
          prefixIcon: prefixIcon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpace.md,
                    right: AppSpace.sm,
                  ),
                  child: AppIcon(
                    prefixIcon,
                    size: AppIconSize.md,
                    color: iconColor,
                  ),
                ),
          prefixIconConstraints: BoxConstraints(
            minHeight: widget.small ? AppSizes.controlS : AppSizes.controlM,
          ),
          suffixIcon: _buildSuffix(isPassword, iconColor),
          suffixIconConstraints: BoxConstraints(
            minHeight: widget.small ? AppSizes.controlS : AppSizes.controlM,
          ),
          enabledBorder: hasError ? _errorBorder : null,
          focusedBorder: hasError ? _focusedErrorBorder : null,
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[
          FieldLabel(widget.label!, required: widget.required),
          const SizedBox(height: AppSpace.xs),
        ],
        if (widget.label == null && widget.semanticLabel != null)
          Semantics(label: widget.semanticLabel, child: field)
        else
          field,
        if (hasError || widget.helperText != null) ...[
          const SizedBox(height: AppSpace.xs),
          FieldMessage(
            hasError ? widget.errorText! : widget.helperText!,
            isError: hasError,
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffix(bool isPassword, Color iconColor) {
    Widget? icon;
    if (isPassword) {
      icon = Pressable(
        onPressed: widget.enabled
            ? () => setState(() => _obscured = !_obscured)
            : null,
        tooltip: _obscured ? 'Mostrar contraseña' : 'Ocultar contraseña',
        semanticLabel: _obscured ? 'Mostrar contraseña' : 'Ocultar contraseña',
        borderRadius: AppRadius.sm,
        builder: (context, state) => AppIcon(
          _obscured ? AppIcons.eye : AppIcons.eyeOff,
          size: AppIconSize.md,
          color: state.hovered ? AppColors.iconPrimary : iconColor,
        ),
      );
    } else if (widget.variant == AppTextFieldVariant.date) {
      icon = AppIcon(AppIcons.calendar, size: AppIconSize.md, color: iconColor);
    } else {
      icon = widget.suffix;
    }
    if (icon == null) return null;
    return Padding(
      padding: const EdgeInsets.only(left: AppSpace.sm, right: AppSpace.md),
      child: icon,
    );
  }

  /// Line height of `bodyM` / `tableData`, the text styles of the field.
  static const _lineHeight = 20.0;

  static const _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
    borderSide: BorderSide(color: AppColors.borderDanger),
  );

  static const _focusedErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
    borderSide: BorderSide(color: AppColors.borderDanger, width: 2),
  );
}
