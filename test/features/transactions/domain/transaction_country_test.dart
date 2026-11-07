import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/domain/catalog_models.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/country.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/transaction_type.dart';
import 'package:monedasegura/features/transactions/domain/transaction_country.dart';
import 'package:monedasegura/features/transactions/domain/transaction_row.dart';

void main() {
  late List<CatalogCountry> countries;

  setUp(() async {
    countries = await FakeCatalogRepository().fetchCountries();
  });

  test('each currency of the catalog gives its country', () {
    for (final country in Country.values) {
      expect(countryOfCurrency(country.currency.code, countries), country);
    }
  });

  test('each country of the catalog gives its currency', () {
    expect(currencyOfCountry('CO', countries), 'COP');
    expect(currencyOfCountry('BR', countries), 'BRL');
  });

  test('values outside the catalog give no match', () {
    expect(countryOfCurrency('USD', countries), isNull);
    expect(currencyOfCountry('US', countries), isNull);
    expect(countryOfCurrency('COP', const []), isNull);
  });

  test('withCountries fills the country of every row', () {
    final row = TransactionRow(
      id: 1,
      code: 'TX-1',
      occurredAt: DateTime(2026, 3),
      type: TransactionType.purchase,
      channel: Channel.pos,
      amount: 1500,
      currency: Currency.clp,
      isLabeled: false,
    );

    expect(withCountries([row], countries).single.country, Country.chile);
  });
}
