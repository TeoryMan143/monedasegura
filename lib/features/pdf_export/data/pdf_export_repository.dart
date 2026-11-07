import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../../../core/supabase/supabase_client_provider.dart';
import '../domain/customer_report.dart';

/// Reads the data of the customer report PDF and saves the file (HU-12).
class PdfExportRepository {
  PdfExportRepository(this._client);

  final SupabaseClient _client;

  static const _currencyColumns = 'currencies(code, symbol, decimals, locale)';

  Future<CustomerReport> fetchCustomerReport({
    required String customerId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final customer = await _client
          .from('customers')
          .select(
            'id, first_names, last_names, document_type, document_number, '
            'segment, risk_level, customer_since, email, phone, countries(name)',
          )
          .eq('id', customerId)
          .single();

      final accountRows = await _client
          .from('accounts')
          .select(
            'id, last4, type, balance, status, banks(name), $_currencyColumns',
          )
          .eq('customer_id', customerId)
          .order('opened_on');
      final accountIds = [for (final row in accountRows) row['id'] as String];

      final transactionRows = accountIds.isEmpty
          ? const <Map<String, dynamic>>[]
          : await _client
                .from('transactions')
                .select(
                  'code, occurred_at, type, channel_code, amount, is_labeled, '
                  'latitude, longitude, cities(name), $_currencyColumns',
                )
                .or(
                  'source_account_id.in.(${accountIds.join(',')}),'
                  'destination_account_id.in.(${accountIds.join(',')})',
                )
                .gte('occurred_at', from.toUtc().toIso8601String())
                .lte('occurred_at', to.toUtc().toIso8601String())
                .order('occurred_at', ascending: false)
                .limit(reportTransactionLimit);

      return CustomerReport(
        customer: _customer(customer),
        accounts: [for (final row in accountRows) _account(row)],
        transactions: [for (final row in transactionRows) _transaction(row)],
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Writes the PDF where the analyst chose in the native save dialog.
  Future<void> saveFile(String path, Uint8List bytes) async {
    try {
      await File(path).writeAsBytes(bytes, flush: true);
    } on FileSystemException catch (error) {
      throw Failure.unknown(message: error.message);
    }
  }

  static ReportCustomer _customer(Map<String, dynamic> row) => ReportCustomer(
    id: row['id'] as String,
    fullName: '${row['first_names']} ${row['last_names']}',
    documentType: row['document_type'] as String,
    documentNumber: row['document_number'] as String,
    countryName: _map(row['countries'])['name'] as String? ?? '',
    segment: row['segment'] as String,
    riskLevel: row['risk_level'] as String,
    customerSince: DateTime.parse(row['customer_since'] as String),
    email: row['email'] as String?,
    phone: row['phone'] as String?,
  );

  static ReportAccount _account(Map<String, dynamic> row) => ReportAccount(
    last4: row['last4'] as String,
    type: row['type'] as String,
    bankName: _map(row['banks'])['name'] as String? ?? '',
    status: row['status'] as String,
    currency: _currency(_map(row['currencies'])),
    balance: (row['balance'] as num?)?.toDouble(),
  );

  static ReportTransaction _transaction(Map<String, dynamic> row) =>
      ReportTransaction(
        code: row['code'] as String,
        occurredAt: DateTime.parse(row['occurred_at'] as String).toLocal(),
        type: row['type'] as String,
        channelCode: row['channel_code'] as String,
        amount: (row['amount'] as num).toDouble(),
        currency: _currency(_map(row['currencies'])),
        isLabeled: row['is_labeled'] as bool? ?? false,
        cityName: _map(row['cities'])['name'] as String?,
        latitude: (row['latitude'] as num?)?.toDouble(),
        longitude: (row['longitude'] as num?)?.toDouble(),
      );

  static ReportCurrency _currency(Map<String, dynamic> row) => ReportCurrency(
    code: row['code'] as String? ?? '',
    symbol: row['symbol'] as String? ?? '',
    decimals: (row['decimals'] as num?)?.toInt() ?? 2,
    locale: row['locale'] as String? ?? 'es',
  );

  static Map<String, dynamic> _map(Object? value) =>
      value is Map<String, dynamic> ? value : const {};
}

final pdfExportRepositoryProvider = Provider<PdfExportRepository>(
  (ref) => PdfExportRepository(ref.watch(supabaseClientProvider)),
  name: 'pdfExportRepositoryProvider',
);
