import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Interaction states handed to a [Pressable] builder.
@immutable
class PressableState {
  const PressableState({
    required this.enabled,
    required this.hovered,
    required this.pressed,
    required this.focused,
  });

  final bool enabled;
  final bool hovered;
  final bool pressed;

  /// Keyboard focus is visible (not set by mouse clicks).
  final bool focused;
}

/// Base of every clickable piece of the kit: hover, pressed and keyboard focus states,
/// Enter / Space activation, click cursor and the focus ring (DESIGN.md · Accessibility).
///
/// There is no ripple: components change colours from the [PressableState] they get in
/// [builder]. Disabled when [onPressed] is null.
class Pressable extends StatefulWidget {
  const Pressable({
    required this.builder,
    required this.onPressed,
    this.semanticLabel,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
    this.borderRadius = AppRadius.md,
    this.showFocusRing = true,
    this.selected,
    super.key,
  });

  final Widget Function(BuildContext context, PressableState state) builder;
  final VoidCallback? onPressed;

  /// Accessible name. Required for icon-only content.
  final String? semanticLabel;

  /// Optional tooltip shown on hover.
  final String? tooltip;
  final FocusNode? focusNode;
  final bool autofocus;

  /// Radius of the focus ring; match the component's shape.
  final double borderRadius;

  /// Set to false when the component draws its own focus indication.
  final bool showFocusRing;

  /// Selected state for toggle-like components (tabs, segments, chips).
  final bool? selected;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final state = PressableState(
      enabled: _enabled,
      hovered: _enabled && _hovered,
      pressed: _enabled && _pressed,
      focused: _enabled && _focused,
    );

    Widget child = widget.builder(context, state);
    if (widget.showFocusRing) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: state.focused ? AppShadows.focusRing : null,
        ),
        child: child,
      );
    }

    Widget result = Semantics(
      button: true,
      enabled: _enabled,
      selected: widget.selected,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onShowHoverHighlight: (value) => setState(() => _hovered = value),
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _enabled ? (_) => _setPressed(true) : null,
          onTapUp: _enabled ? (_) => _setPressed(false) : null,
          onTapCancel: _enabled ? () => _setPressed(false) : null,
          onTap: widget.onPressed,
          child: child,
        ),
      ),
    );

    final tooltip = widget.tooltip;
    if (tooltip != null) {
      result = Tooltip(message: tooltip, child: result);
    }
    return result;
  }
}
