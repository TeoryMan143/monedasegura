import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/core/formatting/date_time.dart';

void main() {
  setUpAll(() => initializeDateFormatting('es'));

  final date = DateTime(2026, 11, 6, 14, 32);

  test('dates are in Spanish', () {
    expect(formatDate(date), '06 nov 2026');
    expect(formatDate(DateTime(2026, 1, 15)), '15 ene 2026');
  });

  test('times use 24 hours', () {
    expect(formatTime(date), '14:32');
    expect(formatTime(DateTime(2026, 11, 6, 9, 5)), '09:05');
  });

  test('date and time are joined with a dot', () {
    expect(formatDateTime(date), '06 nov 2026 · 14:32');
  });

  test('UTC instants are shown in local time', () {
    expect(formatDateTime(date.toUtc()), '06 nov 2026 · 14:32');
  });

  test('tables use the short date', () {
    expect(formatShortDate(date), '6 nov');
    expect(formatShortDate(DateTime(2026, 3, 19)), '19 mar');
  });

  group('formatDateRange', () {
    test('a range in one month writes the month once', () {
      expect(
        formatDateRange(DateTime(2026, 3), DateTime(2026, 3, 20)),
        '1–20 mar 2026',
      );
    });

    test('a range across months or years writes both ends', () {
      expect(
        formatDateRange(DateTime(2026, 2, 28), DateTime(2026, 3, 3)),
        '28 feb – 3 mar 2026',
      );
      expect(
        formatDateRange(DateTime(2025, 12, 20), DateTime(2026, 1, 5)),
        '20 dic 2025 – 5 ene 2026',
      );
    });

    test('a single day and open ends', () {
      expect(
        formatDateRange(DateTime(2026, 3, 5), DateTime(2026, 3, 5)),
        '5 mar 2026',
      );
      expect(formatDateRange(DateTime(2026, 3), null), 'Desde 1 mar 2026');
      expect(formatDateRange(null, DateTime(2026, 3, 20)), 'Hasta 20 mar 2026');
      expect(formatDateRange(null, null), '');
    });
  });

  group('formatRelative', () {
    final now = DateTime(2026, 11, 6, 14, 32);

    String ago(Duration elapsed) =>
        formatRelative(now.subtract(elapsed), now: now);

    test('under a minute, and future dates, read «ahora»', () {
      expect(ago(const Duration(seconds: 59)), 'ahora');
      expect(
        formatRelative(now.add(const Duration(minutes: 5)), now: now),
        'ahora',
      );
    });

    test('minutes', () {
      expect(ago(const Duration(minutes: 5)), 'hace 5 min');
      expect(ago(const Duration(minutes: 59)), 'hace 59 min');
    });

    test('hours of the same day', () {
      expect(ago(const Duration(hours: 3)), 'hace 3 h');
    });

    test('the previous calendar day reads «ayer»', () {
      expect(ago(const Duration(hours: 15)), 'ayer');
      expect(ago(const Duration(hours: 38)), 'ayer');
    });

    test('just after midnight, recent times keep their minutes', () {
      expect(
        formatRelative(
          DateTime(2026, 11, 5, 23, 50),
          now: DateTime(2026, 11, 6, 0, 10),
        ),
        'hace 20 min',
      );
    });

    test('this week counts days, older dates show the date', () {
      expect(ago(const Duration(days: 2)), 'hace 2 d');
      expect(ago(const Duration(days: 6)), 'hace 6 d');
      expect(ago(const Duration(days: 7)), '30 oct 2026');
    });
  });
}
