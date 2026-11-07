import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../core/domain/currency.dart';
import '../../../core/formatting/money.dart';

part 'range_totals.freezed.dart';
part 'range_totals.g.dart';

/// What came in, went out and the net of the customer in one currency, in the range.
/// A row of the `customer_range_totals` RPC (HU-03).
@Freezed(toJson: false)
abstract class RangeTotals with _$RangeTotals {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory RangeTotals({
    @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)
    required Currency currency,
    required num totalIn,
    required num totalOut,
    required num net,
    required int transactionCount,
  }) = _RangeTotals;

  factory RangeTotals.fromJson(Map<String, dynamic> json) =>
      _$RangeTotalsFromJson(json);
}

/// «Entradas $ 12,4 M · Salidas $ 9,8 M · Neto +$ 2,6 M COP»: the totals of one currency
/// as A-02 writes them next to the count.
///
/// Amounts of a million or more are shortened to millions with one decimal; smaller
/// ones keep the decimals of their currency (CLP has none). A positive net carries a
/// `+`, a negative one a `-`.
String rangeTotalsText(RangeTotals totals) {
  final currency = totals.currency;
  return 'Entradas ${compactMoney(totals.totalIn, currency)} · '
      'Salidas ${compactMoney(totals.totalOut, currency)} · '
      'Neto ${compactMoney(totals.net, currency, signed: true)} '
      '${currency.code}';
}

/// [amount] in [currency] without the code, in millions from a million up:
/// `$ 12,4 M`, `S/ 6.381,48`, `$ 250.000` (CLP). With [signed], a positive amount
/// starts with `+`.
String compactMoney(num amount, Currency currency, {bool signed = false}) {
  final String text;
  if (amount.abs() >= 1000000) {
    final millions = NumberFormat(
      '#,##0.0',
      currency.locale.replaceAll('-', '_'),
    ).format(amount.abs() / 1000000);
    text = '${amount < 0 ? '-' : ''}${currency.symbol} $millions M';
  } else {
    text = formatMoney(amount, currency, withCode: false);
  }
  return signed && amount > 0 ? '+$text' : text;
}
