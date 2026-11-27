import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/realtime/fake_realtime_service.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/features/notifications/domain/app_notification.dart';
import 'package:monedasegura/features/notifications/presentation/widgets/notification_bell.dart';

import '../../helpers/shell_overrides.dart';

AppNotification _notification(
  String id, {
  required bool read,
  Duration age = const Duration(minutes: 5),
  String? code,
  int? score,
}) => AppNotification(
  id: id,
  alertId: 'alert-$id',
  alertCode: code,
  score: score,
  title: 'Nueva alerta ${code ?? id} · score ${score ?? 61}',
  body: 'Resumen de $id',
  createdAt: DateTime.now().subtract(age),
  read: read,
);

final _read = _notification('n1', read: true, age: const Duration(days: 1));
final _unread = _notification('n2', read: false);

class _Bell {
  _Bell(this.repository, this.realtime, this.opened);

  final FakeNotificationsRepository repository;
  final FakeRealtimeService realtime;
  final List<String> opened;
}

Future<_Bell> _pumpBell(WidgetTester tester) async {
  final repository = FakeNotificationsRepository(items: [_unread, _read]);
  final realtime = FakeRealtimeService();
  final opened = <String>[];
  await tester.pumpWidget(
    ProviderScope(
      overrides: shellOverrides(
        notifications: repository,
        realtime: realtime,
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
  return _Bell(repository, realtime, opened);
}

void main() {
  testWidgets('the counter shows the unread notifications', (tester) async {
    await _pumpBell(tester);

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('opening a notification writes read_at and opens the alert', (
    tester,
  ) async {
    final bell = await _pumpBell(tester);

    await tester.tap(find.byTooltip('Notificaciones, 1 sin leer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_unread.title));
    await tester.pumpAndSettle();

    expect(bell.opened, ['alert-n2']);
    expect(bell.repository.markedRead, ['n2']);
    expect(find.text('1'), findsNothing);
  });

  testWidgets('«Marcar todas como leídas» writes every unread one', (
    tester,
  ) async {
    final bell = await _pumpBell(tester);
    bell.repository.insert(_notification('n3', read: false));

    await tester.tap(find.byTooltip('Notificaciones, 1 sin leer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Marcar todas como leídas'));
    await tester.pumpAndSettle();

    expect(bell.repository.markedRead, ['n3', 'n2']);
    expect(find.byTooltip('Notificaciones'), findsOneWidget);
  });

  testWidgets('a realtime notification shows a toast and raises the counter', (
    tester,
  ) async {
    final bell = await _pumpBell(tester);

    bell.repository.insert(
      _notification(
        'n3',
        read: false,
        age: Duration.zero,
        code: 'AL-1042',
        score: 92,
      ),
    );
    bell.realtime.simulateNotification('n3');
    await tester.pumpAndSettle();

    expect(find.text('Nueva alerta AL-1042'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // Let the toast close by itself so no timer is left.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
  });
}
