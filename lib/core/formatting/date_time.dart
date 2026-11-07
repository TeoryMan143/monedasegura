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

/// «19 mar»: the short date of tables, with [formatTime] below it.
String formatShortDate(DateTime date) =>
    DateFormat('d MMM', _locale).format(date.toLocal());

/// A range of calendar days, as filter chips and the date field show it.
///
/// - Same month: «1–20 mar 2026».
/// - Same year: «28 feb – 3 mar 2026».
/// - Different years: «20 dic 2025 – 5 ene 2026».
/// - Open ends: «Desde 1 mar 2026», «Hasta 20 mar 2026».
String formatDateRange(DateTime? from, DateTime? to) {
  final full = DateFormat('d MMM yyyy', _locale);
  if (from == null && to == null) return '';
  if (to == null) return 'Desde ${full.format(from!)}';
  if (from == null) return 'Hasta ${full.format(to)}';
  if (from.year != to.year) return '${full.format(from)} – ${full.format(to)}';
  if (from.month != to.month) {
    return '${DateFormat('d MMM', _locale).format(from)} – ${full.format(to)}';
  }
  if (from.day == to.day) return full.format(from);
  return '${from.day}–${full.format(to)}';
}

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
