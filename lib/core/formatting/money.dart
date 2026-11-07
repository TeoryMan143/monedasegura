import 'package:intl/intl.dart';

import '../domain/currency.dart';

/// [amount] in its [currency]: `$ 1.900.000,00 COP`, `R$ 12.400,50 BRL`, `$ 1.500 CLP`.
///
/// Pass a row of `currenciesProvider` when it is loaded: its locale and decimals are the
/// ones that count. The `Currency` enum mirrors them for code without the catalog. The
/// pattern keeps the symbol first in every locale, as DESIGN.md writes amounts.
///
/// [withCode] false leaves the code out, for tables that write it on its own line below
/// the amount (`$ 1.900.000,00` / `COP`).
String formatMoney(num amount, MoneyCurrency currency, {bool withCode = true}) {
  final number = NumberFormat.currency(
    locale: currency.locale.replaceAll('-', '_'),
    symbol: currency.symbol,
    decimalDigits: currency.decimals,
    customPattern: '¤ #,##0.00',
  ).format(amount);
  return withCode ? '$number ${currency.code}' : number;
}

/// [formatMoney] with an explicit `+` for credits and positive net totals.
///
/// Negative amounts already carry their `-`, and zero takes no sign.
String formatSignedMoney(
  num amount,
  MoneyCurrency currency, {
  bool withCode = true,
}) {
  final money = formatMoney(amount, currency, withCode: withCode);
  return amount > 0 ? '+$money' : money;
}
