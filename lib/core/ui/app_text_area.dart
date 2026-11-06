import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'field_label.dart';
import 'field_message.dart';

/// Área de texto (Figma Componentes `4:3`) · multi-line field with a character counter at
/// the bottom right (`0/500`) and a helper line (DESIGN.md · Component kit).
///
/// Used for the label justification: the helper states the rule («Obligatoria con
/// confianza Baja o veredicto Incierto») and [errorText] reports it when broken.
class AppTextArea extends StatefulWidget {
  const AppTextArea({
    this.label,
    this.hint,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.helperText,
    this.errorText,
    this.required = false,
    this.enabled = true,
    this.maxLength = 500,
    this.minLines = 3,
    this.maxLines = 6,
    this.focusNode,
    super.key,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;

  /// Initial text when no [controller] is given.
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? helperText;
  final String? errorText;
  final bool required;
  final bool enabled;
  final int maxLength;
  final int minLines;
  final int maxLines;
  final FocusNode? focusNode;

  @override
  State<AppTextArea> createState() => _AppTextAreaState();
}

class _AppTextAreaState extends State<AppTextArea> {
  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;
  bool _focused = false;

  TextEditingController get _controller =>
      widget.controller ??
      (_ownController ??= TextEditingController(text: widget.initialValue));

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _ownFocusNode?.dispose();
    _ownController?.dispose();
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
    const errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
      borderSide: BorderSide(color: AppColors.borderDanger),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[
          FieldLabel(widget.label!, required: widget.required),
          const SizedBox(height: AppSpace.xs),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: _focused ? AppShadows.focusRing : null,
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            onChanged: widget.onChanged,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            keyboardType: TextInputType.multiline,
            style: AppText.bodyM,
            decoration: InputDecoration(
              hintText: widget.hint,
              counterText: '',
              contentPadding: const EdgeInsets.all(AppSpace.md),
              fillColor: widget.enabled
                  ? AppColors.bgSurface
                  : AppColors.bgDisabled,
              enabledBorder: hasError ? errorBorder : null,
              focusedBorder: hasError
                  ? errorBorder.copyWith(
                      borderSide: const BorderSide(
                        color: AppColors.borderDanger,
                        width: 2,
                      ),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: AppSpace.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: hasError || widget.helperText != null
                  ? FieldMessage(
                      hasError ? widget.errorText! : widget.helperText!,
                      isError: hasError,
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: AppSpace.sm),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) => Text(
                '${value.text.characters.length}/${widget.maxLength}',
                style: AppText.bodyS.copyWith(
                  color: AppColors.textTertiary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
