import '../../../core/domain/catalog_models.dart';
import '../../../core/domain/country.dart';
import 'transaction_row.dart';

// `v_transactions_list` has no country column. Every country of the bank operates in its
// own currency (`countries.currency_code`), so the catalog gives the country of a
// transaction from its currency, and the currency to filter by from a country.

/// The country that operates in [currencyCode], or null if none does.
Country? countryOfCurrency(
  String currencyCode,
  List<CatalogCountry> countries,
) {
  for (final country in countries) {
    if (country.currencyCode == currencyCode) {
      return Country.values
          .where((value) => value.code == country.code)
          .firstOrNull;
    }
  }
  return null;
}

/// The currency of [countryCode], or null if the catalog does not have that country.
String? currencyOfCountry(String countryCode, List<CatalogCountry> countries) {
  for (final country in countries) {
    if (country.code == countryCode) return country.currencyCode;
  }
  return null;
}

/// [rows] with their country, read from the `countries` catalog.
List<TransactionRow> withCountries(
  List<TransactionRow> rows,
  List<CatalogCountry> countries,
) => [
  for (final row in rows)
    row.copyWith(country: countryOfCurrency(row.currency.code, countries)),
];
