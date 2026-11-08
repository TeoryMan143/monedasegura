import 'package:intl/intl.dart';

// Spanish numbers, with `.` for thousands: «50.312». Colombian locale, like the money.
const _locale = 'es_CO';

/// A whole number with thousands separators: «50.312».
String formatCount(num value) => NumberFormat('#,##0', _locale).format(value);

/// A whole percentage with a space before the sign, as the cards write it: «62 %».
String formatPercent(num value) => '${formatCount(value.round())} %';
