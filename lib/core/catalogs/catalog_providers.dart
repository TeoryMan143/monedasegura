import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/catalog_models.dart';
import 'catalog_repository.dart';

// Kept alive on purpose (no autoDispose): the catalogs are small, load once for the whole
// session and only screens behind the login read them.

/// A failed catalog shows «Reintentar» at once instead of a long skeleton.
Duration? _noAutoRetry(int retryCount, Object error) => null;

final fraudTypesProvider = FutureProvider<List<CatalogFraudType>>(
  (ref) => ref.watch(catalogRepositoryProvider).fetchFraudTypes(),
  retry: _noAutoRetry,
  name: 'fraudTypesProvider',
);

final confidenceLevelsProvider = FutureProvider<List<CatalogConfidenceLevel>>(
  (ref) => ref.watch(catalogRepositoryProvider).fetchConfidenceLevels(),
  retry: _noAutoRetry,
  name: 'confidenceLevelsProvider',
);

final severityLevelsProvider = FutureProvider<List<CatalogSeverityLevel>>(
  (ref) => ref.watch(catalogRepositoryProvider).fetchSeverityLevels(),
  retry: _noAutoRetry,
  name: 'severityLevelsProvider',
);

final currenciesProvider = FutureProvider<List<CatalogCurrency>>(
  (ref) => ref.watch(catalogRepositoryProvider).fetchCurrencies(),
  retry: _noAutoRetry,
  name: 'currenciesProvider',
);

final countriesProvider = FutureProvider<List<CatalogCountry>>(
  (ref) => ref.watch(catalogRepositoryProvider).fetchCountries(),
  retry: _noAutoRetry,
  name: 'countriesProvider',
);

final channelsProvider = FutureProvider<List<CatalogChannel>>(
  (ref) => ref.watch(catalogRepositoryProvider).fetchChannels(),
  retry: _noAutoRetry,
  name: 'channelsProvider',
);

/// Drops every catalog, so the next analyst loads them with their own session.
void invalidateCatalogs(Ref ref) {
  ref
    ..invalidate(fraudTypesProvider)
    ..invalidate(confidenceLevelsProvider)
    ..invalidate(severityLevelsProvider)
    ..invalidate(currenciesProvider)
    ..invalidate(countriesProvider)
    ..invalidate(channelsProvider);
}
