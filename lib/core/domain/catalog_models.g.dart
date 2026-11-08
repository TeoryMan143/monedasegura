// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatalogFraudType _$CatalogFraudTypeFromJson(Map<String, dynamic> json) =>
    _CatalogFraudType(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      colorHex: json['color'] as String,
    );

Map<String, dynamic> _$CatalogFraudTypeToJson(_CatalogFraudType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'color': instance.colorHex,
    };

_CatalogConfidenceLevel _$CatalogConfidenceLevelFromJson(
  Map<String, dynamic> json,
) => _CatalogConfidenceLevel(
  level: (json['level'] as num).toInt(),
  name: json['name'] as String,
  meaning: json['meaning'] as String,
  criteria: json['criteria'] as String,
  sampleWeight: (json['sample_weight'] as num).toDouble(),
  requiresJustification: json['requires_justification'] as bool,
);

Map<String, dynamic> _$CatalogConfidenceLevelToJson(
  _CatalogConfidenceLevel instance,
) => <String, dynamic>{
  'level': instance.level,
  'name': instance.name,
  'meaning': instance.meaning,
  'criteria': instance.criteria,
  'sample_weight': instance.sampleWeight,
  'requires_justification': instance.requiresJustification,
};

_CatalogSeverityLevel _$CatalogSeverityLevelFromJson(
  Map<String, dynamic> json,
) => _CatalogSeverityLevel(
  level: json['level'] as String,
  sortOrder: (json['sort_order'] as num).toInt(),
  name: json['name'] as String,
  criteria: json['criteria'] as String,
);

Map<String, dynamic> _$CatalogSeverityLevelToJson(
  _CatalogSeverityLevel instance,
) => <String, dynamic>{
  'level': instance.level,
  'sort_order': instance.sortOrder,
  'name': instance.name,
  'criteria': instance.criteria,
};

_CatalogCurrency _$CatalogCurrencyFromJson(Map<String, dynamic> json) =>
    _CatalogCurrency(
      code: json['code'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      locale: json['locale'] as String,
    );

Map<String, dynamic> _$CatalogCurrencyToJson(_CatalogCurrency instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'locale': instance.locale,
    };

_CatalogCountry _$CatalogCountryFromJson(Map<String, dynamic> json) =>
    _CatalogCountry(
      code: json['code'] as String,
      name: json['name'] as String,
      currencyCode: json['currency_code'] as String,
      primaryDocumentType: json['primary_document_type'] as String,
      phonePrefix: json['phone_prefix'] as String,
      timeZone: json['time_zone'] as String,
    );

Map<String, dynamic> _$CatalogCountryToJson(_CatalogCountry instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'currency_code': instance.currencyCode,
      'primary_document_type': instance.primaryDocumentType,
      'phone_prefix': instance.phonePrefix,
      'time_zone': instance.timeZone,
    };

_CatalogChannel _$CatalogChannelFromJson(Map<String, dynamic> json) =>
    _CatalogChannel(
      code: json['code'] as String,
      name: json['name'] as String,
      isDigital: json['is_digital'] as bool,
      countryCode: json['country_code'] as String?,
    );

Map<String, dynamic> _$CatalogChannelToJson(_CatalogChannel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'is_digital': instance.isDigital,
      'country_code': instance.countryCode,
    };
