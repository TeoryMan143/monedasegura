import 'package:flutter/material.dart';

/// Tooltip · dark (gris-900) with white `bodyS`, max 260 px (styled in `AppTheme`).
///
/// Required on icon-only buttons (`AppIconButton` already adds it) and on the confidence
/// and severity help icons. Wrap any widget:
///
/// ```dart
/// AppTooltip(message: 'Qué tan seguro estás del veredicto', child: AppIcon(AppIcons.info))
/// ```
class AppTooltip extends StatelessWidget {
  const AppTooltip({required this.message, required this.child, super.key});

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 400),
      child: child,
    );
  }
}
