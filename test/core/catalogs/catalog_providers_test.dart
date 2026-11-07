import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/catalogs/catalog_providers.dart';
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/country.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/severity.dart';

import '../../helpers/counting_catalog_repository.dart';

void main() {
  test('the fake catalogs carry the values of the enums', () async {
    final container = ProviderContainer(
      overrides: [
        catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
      ],
    );
    addTearDown(container.dispose);

    final fraudTypes = await container.read(fraudTypesProvider.future);
    final confidence = await container.read(confidenceLevelsProvider.future);
    final severities = await container.read(severityLevelsProvider.future);
    final currencies = await container.read(currenciesProvider.future);
    final countries = await container.read(countriesProvider.future);
    final channels = await container.read(channelsProvider.future);

    expect(
      fraudTypes.map((type) => FraudType.fromDb(type.code)),
      FraudType.values,
    );
    expect(
      confidence.map((level) => ConfidenceLevel.fromDb(level.level)),
      ConfidenceLevel.values,
    );
    expect(
      severities.map((level) => Severity.fromDb(level.level)),
      Severity.values,
    );
    expect(
      currencies.map((item) => Currency.fromDb(item.code)),
      Currency.values,
    );
    expect(countries.map((item) => Country.fromDb(item.code)), Country.values);
    expect(channels.map((item) => Channel.fromDb(item.code)), Channel.values);
  });

  test('every prototype colour is a valid #RRGGBB', () async {
    final types = await FakeCatalogRepository().fetchFraudTypes();

    for (final type in types) {
      expect(type.colorHex, matches(RegExp(r'^#[0-9A-F]{6}$')));
    }
  });

  test('a catalog loads once and stays alive without listeners', () async {
    final repository = CountingCatalogRepository();
    final container = ProviderContainer(
      overrides: [catalogRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(currenciesProvider.future);
    await container.pump();
    await container.read(currenciesProvider.future);

    expect(repository.currencyLoads, 1);
  });
}
