import 'dart:ui' show Color;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'currency.dart';

part 'catalog_models.freezed.dart';
part 'catalog_models.g.dart';

/// A row of `fraud_types`: the [id] that RPCs take and the colour of the taxonomy.
@freezed
abstract class CatalogFraudType with _$CatalogFraudType {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CatalogFraudType({
    required int id,
    required String code,
    required String name,
    required String description,
    @JsonKey(name: 'color') required String colorHex,
  }) = _CatalogFraudType;

  const CatalogFraudType._();

  factory CatalogFraudType.fromJson(Map<String, dynamic> json) =>
      _$CatalogFraudTypeFromJson(json);

  /// The `#RRGGBB` of the catalog, used only for the chip square and chart series.
  Color get color =>
      Color(0xFF000000 | int.parse(colorHex.substring(1), radix: 16));
}

/// A row of `confidence_levels`.
@freezed
abstract class CatalogConfidenceLevel with _$CatalogConfidenceLevel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CatalogConfidenceLevel({
    required int level,
    required String name,
    required String meaning,
    required String criteria,
    required double sampleWeight,
    required bool requiresJustification,
  }) = _CatalogConfidenceLevel;

  factory CatalogConfidenceLevel.fromJson(Map<String, dynamic> json) =>
      _$CatalogConfidenceLevelFromJson(json);
}

/// A row of `severity_levels`.
@freezed
abstract class CatalogSeverityLevel with _$CatalogSeverityLevel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CatalogSeverityLevel({
    required String level,
    required int sortOrder,
    required String name,
    required String criteria,
  }) = _CatalogSeverityLevel;

  factory CatalogSeverityLevel.fromJson(Map<String, dynamic> json) =>
      _$CatalogSeverityLevelFromJson(json);
}

/// A row of `currencies`. `formatMoney` reads its locale and decimals.
@freezed
abstract class CatalogCurrency with _$CatalogCurrency implements MoneyCurrency {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CatalogCurrency({
    required String code,
    required String name,
    required String symbol,
    required int decimals,
    required String locale,
  }) = _CatalogCurrency;

  factory CatalogCurrency.fromJson(Map<String, dynamic> json) =>
      _$CatalogCurrencyFromJson(json);
}

/// A row of `countries`.
@freezed
abstract class CatalogCountry with _$CatalogCountry {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CatalogCountry({
    required String code,
    required String name,
    required String currencyCode,
    required String primaryDocumentType,
    required String phonePrefix,

    /// IANA time zone, e.g. `America/Bogota`: the customer's clock for unusual hours.
    required String timeZone,
  }) = _CatalogCountry;

  factory CatalogCountry.fromJson(Map<String, dynamic> json) =>
      _$CatalogCountryFromJson(json);
}

/// A row of `channels`. A null [countryCode] means the channel exists in every country.
@freezed
abstract class CatalogChannel with _$CatalogChannel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CatalogChannel({
    required String code,
    required String name,
    required bool isDigital,
    String? countryCode,
  }) = _CatalogChannel;

  factory CatalogChannel.fromJson(Map<String, dynamic> json) =>
      _$CatalogChannelFromJson(json);
}
