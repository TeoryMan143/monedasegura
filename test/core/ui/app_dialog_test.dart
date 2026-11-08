import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/core/ui/kit.dart';

void main() {
  late List<Object?> sounds;

  Future<void> openDialog(
    WidgetTester tester, {
    required bool barrierDismissible,
  }) async {
    sounds = [];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemSound.play' &&
            call.arguments == 'SystemSoundType.alert') {
          sounds.add(call.arguments);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Center(
            child: TextButton(
              onPressed: () => showAppDialog<void>(
                context: context,
                barrierDismissible: barrierDismissible,
                builder: (context) =>
                    const AppDialog(title: 'Clasificar', body: Text('Cuerpo')),
              ),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
  }

  testWidgets('a click outside closes a dismissible dialog', (tester) async {
    await openDialog(tester, barrierDismissible: true);

    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();

    expect(find.text('Cuerpo'), findsNothing);
    expect(sounds, isEmpty);
  });

  testWidgets(
    'a click outside a dialog that must stay open does nothing, silently',
    (tester) async {
      await openDialog(tester, barrierDismissible: false);

      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();

      expect(find.text('Cuerpo'), findsOneWidget);
      // The barrier alone would play the system alert: the Windows «ding».
      expect(sounds, isEmpty);
    },
  );
}
