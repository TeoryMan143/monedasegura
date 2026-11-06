import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/features/notifications/domain/app_notification.dart';
import 'package:monedasegura/features/notifications/presentation/widgets/notification_bell.dart';

import '../../helpers/shell_overrides.dart';

final _read = AppNotification(
  id: 'n1',
  alertId: 'a1',
  title: 'Nueva alerta · score 61',
  body: 'AL-1001 · Ana Ruiz',
  createdAt: DateTime.now().subtract(const Duration(days: 1)),
  read: true,
);

final _unread = AppNotification(
  id: 'n2',
  alertId: 'a2',
  title: 'Nueva alerta · score 88',
  body: 'AL-1002 · Luis Mora',
  createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
  read: false,
);

final _live = AppNotification(
  id: 'live-a3',
  alertId: 'a3',
  alertCode: 'AL-1042',
  title: 'Nueva alerta · score 92',
  body: 'AL-1042 · Juan Pérez · Robo de cuenta',
  score: 92,
  createdAt: DateTime.now(),
  read: false,
  live: true,
);

Future<List<String>> _pumpBell(WidgetTester tester) async {
  final opened = <String>[];
  await tester.pumpWidget(
    ProviderScope(
      overrides: shellOverrides(
        notifications: FakeNotificationsRepository(
          items: [_unread, _read],
          pending: _live,
        ),
        newAlertDelay: const Duration(seconds: 30),
      ),
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Align(
            alignment: Alignment.topRight,
            child: NotificationBell(onOpenAlert: opened.add),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return opened;
}

void main() {
  testWidgets('the counter shows the unread notifications', (tester) async {
    await _pumpBell(tester);

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('the panel lists notifications and opens the alert', (
    tester,
  ) async {
    final opened = await _pumpBell(tester);

    await tester.tap(find.byTooltip('Notificaciones, 1 sin leer'));
    await tester.pumpAndSettle();
    expect(find.text('Nueva alerta · score 88'), findsOneWidget);

    await tester.tap(find.text('Nueva alerta · score 88'));
    await tester.pumpAndSettle();
    expect(opened, ['a2']);
    expect(find.text('1'), findsNothing);
  });

  testWidgets('a realtime alert shows a toast and raises the counter', (
    tester,
  ) async {
    await _pumpBell(tester);

    await tester.pump(const Duration(seconds: 30));
    await tester.pumpAndSettle();

    expect(find.text('Nueva alerta AL-1042'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // Let the toast close by itself so no timer is left.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
  });
}
