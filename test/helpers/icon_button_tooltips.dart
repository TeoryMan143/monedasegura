import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/ui/kit.dart';

/// Checks every icon-only button on screen: each [AppIconButton] has a non-empty tooltip
/// that is really drawn as a `Tooltip`, and no Material [IconButton] sneaked in.
///
/// Returns how many [AppIconButton]s it found, so a test can also assert that the screen
/// has the buttons it should (a screen with none would pass this check by accident).
int expectIconButtonsHaveTooltips(WidgetTester tester) {
  expect(
    find.byType(IconButton),
    findsNothing,
    reason: 'Use AppIconButton: it requires a tooltip',
  );
  final buttons = find.byType(AppIconButton);
  for (final element in buttons.evaluate()) {
    final button = element.widget as AppIconButton;
    expect(
      button.tooltip.trim(),
      isNotEmpty,
      reason: 'AppIconButton(${button.icon}) has an empty tooltip',
    );
    expect(
      find.descendant(
        of: find.byWidget(button),
        matching: find.byWidgetPredicate(
          (widget) => widget is Tooltip && widget.message == button.tooltip,
        ),
      ),
      findsOneWidget,
      reason: 'AppIconButton(${button.icon}) does not draw its tooltip',
    );
  }
  return buttons.evaluate().length;
}
