import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/domain/catalog_models.dart';

/// Prototype catalogs that count the loads, and can fail for error state tests.
class CountingCatalogRepository extends FakeCatalogRepository {
  CountingCatalogRepository({this.countriesError});

  /// Thrown by [fetchCountries] while it is set.
  Object? countriesError;

  int currencyLoads = 0;

  @override
  Future<List<CatalogCurrency>> fetchCurrencies() {
    currencyLoads++;
    return super.fetchCurrencies();
  }

  @override
  Future<List<CatalogCountry>> fetchCountries() async {
    final error = countriesError;
    if (error != null) throw error;
    return super.fetchCountries();
  }
}
