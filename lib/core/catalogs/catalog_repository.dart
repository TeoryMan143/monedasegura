import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env.dart';
import '../domain/catalog_models.dart';
import '../errors/failure_mapper.dart';
import '../supabase/supabase_client_provider.dart';
import 'fake_catalog_repository.dart';

/// Reads the small read-only catalogs. The only queries that download whole tables.
class CatalogRepository {
  CatalogRepository(this._client);

  final SupabaseClient _client;

  Future<List<CatalogFraudType>> fetchFraudTypes() => _fetch(
    table: 'fraud_types',
    columns: 'id, code, name, description, color',
    orderBy: 'id',
    fromJson: CatalogFraudType.fromJson,
  );

  Future<List<CatalogConfidenceLevel>> fetchConfidenceLevels() => _fetch(
    table: 'confidence_levels',
    columns:
        'level, name, meaning, criteria, sample_weight, requires_justification',
    orderBy: 'level',
    fromJson: CatalogConfidenceLevel.fromJson,
  );

  Future<List<CatalogSeverityLevel>> fetchSeverityLevels() => _fetch(
    table: 'severity_levels',
    columns: 'level, sort_order, name, criteria',
    orderBy: 'sort_order',
    fromJson: CatalogSeverityLevel.fromJson,
  );

  Future<List<CatalogCurrency>> fetchCurrencies() => _fetch(
    table: 'currencies',
    columns: 'code, name, symbol, decimals, locale',
    orderBy: 'code',
    fromJson: CatalogCurrency.fromJson,
  );

  Future<List<CatalogCountry>> fetchCountries() => _fetch(
    table: 'countries',
    columns: 'code, name, currency_code, primary_document_type, phone_prefix, time_zone',
    orderBy: 'name',
    fromJson: CatalogCountry.fromJson,
  );

  Future<List<CatalogChannel>> fetchChannels() => _fetch(
    table: 'channels',
    columns: 'code, name, country_code, is_digital',
    orderBy: 'name',
    fromJson: CatalogChannel.fromJson,
  );

  Future<List<T>> _fetch<T>({
    required String table,
    required String columns,
    required String orderBy,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      final rows = await _client.from(table).select(columns).order(orderBy);
      return [for (final row in rows) fromJson(row)];
    } catch (error) {
      throw mapToFailure(error);
    }
  }
}

/// The catalog repository of the app. It reads Supabase with the analyst's session, or
/// [FakeCatalogRepository] when the app runs with `USE_FAKE_DATA`.
final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => Env.useFakeData
      ? FakeCatalogRepository()
      : CatalogRepository(ref.watch(supabaseClientProvider)),
  name: 'catalogRepositoryProvider',
);
