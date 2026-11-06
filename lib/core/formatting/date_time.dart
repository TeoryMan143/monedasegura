import 'package:intl/intl.dart';

// Dates are Spanish and in the analyst's local time zone. They need
// `initializeDateFormatting('es')`, which `main.dart` runs at start up.
const _locale = 'es';

/// «06 nov 2026».
String formatDate(DateTime date) =>
    DateFormat('dd MMM yyyy', _locale).format(date.toLocal());

/// «14:32».
String formatTime(DateTime date) =>
    DateFormat('HH:mm', _locale).format(date.toLocal());

/// «06 nov 2026 · 14:32».
String formatDateTime(DateTime date) =>
    '${formatDate(date)} · ${formatTime(date)}';

/// «ahora», «hace 5 min», «hace 3 h», «ayer», «hace 2 d», then [formatDate].
///
/// [now] defaults to the clock and exists so the result can be tested. Future dates read
/// «ahora», because a slightly fast server clock must not show a negative time.
String formatRelative(DateTime date, {DateTime? now}) {
  final local = date.toLocal();
  final current = (now ?? DateTime.now()).toLocal();
  final elapsed = current.difference(local);
  if (elapsed.inMinutes < 1) return 'ahora';
  if (elapsed.inHours < 1) return 'hace ${elapsed.inMinutes} min';

  final days = _calendarDay(current).difference(_calendarDay(local)).inDays;
  if (days == 0) return 'hace ${elapsed.inHours} h';
  if (days == 1) return 'ayer';
  if (days < 7) return 'hace $days d';
  return formatDate(local);
}

/// UTC on purpose: a daylight saving change must not alter the count of days.
DateTime _calendarDay(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day);
