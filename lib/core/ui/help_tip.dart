import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'pressable.dart';

/// Small help icon next to a field label (DESIGN.md · Tooltips): confidence and severity.
///
/// Its [message] shows on hover, and also on keyboard focus (Tab) or when the icon is
/// pressed, so it is not mouse-only. [label] is its accessible name. Use it as
/// `FieldLabel.trailing`.
///
/// ```dart
/// HelpTip(label: 'Ayuda: nivel de confianza', message: 'Baja: …\nMedia: …')
/// ```
class HelpTip extends StatefulWidget {
  const HelpTip({required this.label, required this.message, super.key});

  /// What a screen reader announces, e.g. «Ayuda: severidad».
  final String label;

  /// The explanation. A line break puts each item on its own line.
  final String message;

  @override
  State<HelpTip> createState() => _HelpTipState();
}

class _HelpTipState extends State<HelpTip> {
  final _tooltip = GlobalKey<TooltipState>();
  final _focus = FocusNode(debugLabel: 'HelpTip');

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _show() => _tooltip.currentState?.ensureTooltipVisible();

  void _onFocusChange() {
    if (_focus.hasFocus) {
      _show();
    } else {
      Tooltip.dismissAllToolTips();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: _tooltip,
      message: widget.message,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 400),
      showDuration: const Duration(seconds: 6),
      child: Pressable(
        onPressed: _show,
        semanticLabel: widget.label,
        focusNode: _focus,
        borderRadius: AppRadius.full,
        builder: (context, state) => AppIcon(
          AppIcons.info,
          size: AppIconSize.sm,
          color: state.hovered || state.focused
              ? AppColors.iconPrimary
              : AppColors.iconSecondary,
        ),
      ),
    );
  }
}
