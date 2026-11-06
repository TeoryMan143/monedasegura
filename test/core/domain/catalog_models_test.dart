import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/core/domain/catalog_models.dart';
import 'package:monedasegura/core/formatting/money.dart';

void main() {
  setUpAll(() => initializeDateFormatting('es'));

  test('fraud type reads a row and its colour', () {
    final type = CatalogFraudType.fromJson(const {
      'id': 3,
      'code': 'CLO',
      'name': 'Tarjeta clonada',
      'description': 'Uso de una copia de la tarjeta.',
      'color': '#E9683B',
    });

    expect(type.id, 3);
    expect(type.colorHex, '#E9683B');
    expect(type.color, const Color(0xFFE9683B));
  });

  test('confidence level reads snake case columns and numeric weights', () {
    final level = CatalogConfidenceLevel.fromJson(const {
      'level': 1,
      'name': 'Low',
      'meaning': 'Un indicio',
      'criteria': 'Un solo indicio',
      'sample_weight': 1,
      'requires_justification': true,
    });

    expect(level.sampleWeight, 1.0);
    expect(level.requiresJustification, isTrue);
  });

  test('severity level reads its sort order', () {
    final level = CatalogSeverityLevel.fromJson(const {
      'level': 'critical',
      'sort_order': 4,
      'name': 'Crítica',
      'criteria': 'Vaciado de cuenta',
    });

    expect(level.level, 'critical');
    expect(level.sortOrder, 4);
  });

  test('country reads its currency and document', () {
    final country = CatalogCountry.fromJson(const {
      'code': 'BR',
      'name': 'Brasil',
      'currency_code': 'BRL',
      'primary_document_type': 'CPF',
      'phone_prefix': '+55',
    });

    expect(country.currencyCode, 'BRL');
    expect(country.primaryDocumentType, 'CPF');
    expect(country.phonePrefix, '+55');
  });

  test('a channel without country reads a null country code', () {
    final channel = CatalogChannel.fromJson(const {
      'code': 'APP',
      'name': 'App móvil',
      'country_code': null,
      'is_digital': true,
    });

    expect(channel.countryCode, isNull);
    expect(channel.isDigital, isTrue);
  });

  test('formatMoney uses the decimals of the catalog row', () {
    final fromCatalog = CatalogCurrency.fromJson(const {
      'code': 'COP',
      'name': 'Peso colombiano',
      'symbol': r'$',
      'decimals': 0,
      'locale': 'es-CO',
    });

    expect(formatMoney(1900000, fromCatalog), r'$ 1.900.000 COP');
    expect(formatSignedMoney(1500, fromCatalog), r'+$ 1.500 COP');
  });
}
