import '../domain/catalog_models.dart';
import '../domain/channel.dart';
import '../domain/confidence_level.dart';
import '../domain/country.dart';
import '../domain/currency.dart';
import '../domain/fraud_type.dart';
import '../domain/severity.dart';
import 'catalog_repository.dart';

/// Colours of the prototype taxonomy, as `fraud_types.color` stores them.
const _fraudTypeColors = {
  FraudType.accountTakeover: '#D93B3B',
  FraudType.phishing: '#865CF0',
  FraudType.clonedCard: '#E9683B',
  FraudType.moneyMule: '#5454E9',
  FraudType.laundering: '#4CB979',
  FraudType.syntheticIdentity: '#E4EB60',
  FraudType.simSwap: '#6B6C70',
  FraudType.unrecognizedPurchase: '#4343C4',
};

const _countryDetails = {
  Country.colombia: ('CC', '+57'),
  Country.mexico: ('CURP', '+52'),
  Country.peru: ('DNI', '+51'),
  Country.chile: ('RUT', '+56'),
  Country.argentina: ('DNI', '+54'),
  Country.brazil: ('CPF', '+55'),
};

/// Channels that exist in a single country.
const _localChannels = {
  Channel.pse: Country.colombia,
  Channel.spei: Country.mexico,
  Channel.yape: Country.peru,
  Channel.pix: Country.brazil,
};

const _inPersonChannels = {Channel.pos, Channel.atm, Channel.payroll};

/// Prototype catalogs built from the domain enums, so both always agree.
class FakeCatalogRepository implements CatalogRepository {
  @override
  Future<List<CatalogFraudType>> fetchFraudTypes() async => [
    for (final (index, type) in FraudType.values.indexed)
      CatalogFraudType(
        id: index + 1,
        code: type.code,
        name: type.label,
        description: type.description,
        colorHex: _fraudTypeColors[type]!,
      ),
  ];

  @override
  Future<List<CatalogConfidenceLevel>> fetchConfidenceLevels() async => [
    for (final level in ConfidenceLevel.values)
      CatalogConfidenceLevel(
        level: level.dbValue,
        name: level.label,
        meaning: level.label,
        criteria: level.criteria,
        sampleWeight: level.dbValue / ConfidenceLevel.values.length,
        requiresJustification: level.requiresJustification,
      ),
  ];

  @override
  Future<List<CatalogSeverityLevel>> fetchSeverityLevels() async => [
    for (final (index, severity) in Severity.values.indexed)
      CatalogSeverityLevel(
        level: severity.dbValue,
        sortOrder: index + 1,
        name: severity.label,
        criteria: severity.description,
      ),
  ];

  @override
  Future<List<CatalogCurrency>> fetchCurrencies() async => [
    for (final currency in Currency.values)
      CatalogCurrency(
        code: currency.code,
        name: currency.label,
        symbol: currency.symbol,
        decimals: currency.decimals,
        locale: currency.locale,
      ),
  ];

  @override
  Future<List<CatalogCountry>> fetchCountries() async => [
    for (final country in Country.values)
      CatalogCountry(
        code: country.code,
        name: country.label,
        currencyCode: country.currency.code,
        primaryDocumentType: _countryDetails[country]!.$1,
        phonePrefix: _countryDetails[country]!.$2,
      ),
  ];

  @override
  Future<List<CatalogChannel>> fetchChannels() async => [
    for (final channel in Channel.values)
      CatalogChannel(
        code: channel.dbValue,
        name: channel.label,
        isDigital: !_inPersonChannels.contains(channel),
        countryCode: _localChannels[channel]?.code,
      ),
  ];
}
