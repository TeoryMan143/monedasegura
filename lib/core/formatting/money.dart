import 'package:intl/intl.dart';

import '../domain/currency.dart';

/// [amount] in its [currency]: `$ 1.900.000,00 COP`, `R$ 12.400,50 BRL`, `$ 1.500 CLP`.
///
/// The separators come from the currency's locale and the decimals from the catalog. The
/// pattern keeps the symbol first in every locale, as DESIGN.md writes amounts.
String formatMoney(num amount, Currency currency) {
  final number = NumberFormat.currency(
    locale: currency.locale.replaceAll('-', '_'),
    symbol: currency.symbol,
    decimalDigits: currency.decimals,
    customPattern: '¤ #,##0.00',
  ).format(amount);
  return '$number ${currency.code}';
}

/// [formatMoney] with an explicit `+` for credits and positive net totals.
///
/// Negative amounts already carry their `-`, and zero takes no sign.
String formatSignedMoney(num amount, Currency currency) {
  final money = formatMoney(amount, currency);
  return amount > 0 ? '+$money' : money;
}
