import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../../core/domain/account_type.dart';
import '../../../core/domain/alert_status.dart';
import '../../../core/domain/currency.dart';
import '../../../core/domain/fraud_type.dart';
import '../../../core/domain/verdict.dart';
import '../../../core/errors/failure_mapper.dart';
import '../../../core/local_writes/local_writes_provider.dart';
import '../../../core/local_writes/local_writes_store.dart';
import '../../../core/supabase/supabase_client_provider.dart';
import '../domain/customer_report.dart';
import '../domain/date_range.dart';
import '../domain/report_enums.dart';
import 'fake_customer_report_repository.dart';

/// Rows of each history list in the report summary.
const reportHistoryLimit = 20;

/// Reads the customer report (C-08…C-12, HU-09): the profile, the products of «Cuentas»
/// and the latest labels and alerts in the range.
class CustomerReportRepository {
  CustomerReportRepository(this._client, this._localWrites);

  final SupabaseClient _client;
  final LocalWritesStore _localWrites;

  Future<CustomerProfile> fetchProfile(String customerId) async {
    try {
      final row = await _client
          .from('customers')
          .select(
            'id, first_names, last_names, document_type, document_number, '
            'birth_date, email, phone, occupation, declared_income, '
            'income_currency, customer_since, segment, risk_level, '
            'countries(name), cities(name)',
          )
          .eq('id', customerId)
          .single();
      return profileFromRow(row);
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  Future<CustomerProducts> fetchProducts(String customerId) async {
    try {
      final results = await Future.wait<List<Map<String, dynamic>>>([
        _client
            .from('accounts')
            .select(
              'id, last4, type, currency_code, balance, credit_limit, status, '
              'opened_on, banks(name)',
            )
            .eq('customer_id', customerId)
            .order('opened_on'),
        _client
            .from('cards')
            .select(
              'id, last4, network, type, status, credit_limit, expires_on, '
              'accounts(last4, currency_code)',
            )
            .eq('customer_id', customerId)
            .order('issued_on'),
        _client
            .from('customer_devices')
            .select(
              'first_seen_at, last_seen_at, is_trusted, '
              'devices(id, type, brand, model, os, os_version)',
            )
            .eq('customer_id', customerId)
            .order('last_seen_at', ascending: false),
      ]);
      return CustomerProducts(
        accounts: [for (final row in results[0]) accountFromRow(row)],
        cards: [for (final row in results[1]) cardFromRow(row)],
        devices: [for (final row in results[2]) deviceFromRow(row)],
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Transactions and amount per month and currency in [range], added up in the database
  /// by the `customer_monthly_activity` RPC.
  Future<List<MonthlyActivity>> fetchMonthlyActivity(
    String customerId,
    DateRange range,
  ) async {
    try {
      final rows = await _client.rpc<List<dynamic>>(
        'customer_monthly_activity',
        params: {
          'p_customer_id': customerId,
          'p_from': range.start.toUtc().toIso8601String(),
          'p_to': range.end.toUtc().toIso8601String(),
        },
      );
      return [
        for (final row in rows)
          monthlyActivityFromRow(row as Map<String, dynamic>),
      ];
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// The latest labeled transactions and AI alerts of the customer in [range]. Labels
  /// saved in this session show over the database's.
  Future<CustomerHistory> fetchHistory(
    String customerId,
    DateRange range,
  ) async {
    try {
      final local = _localWrites.labeledTransactionIds.toList();
      final labeled = local.isEmpty
          ? 'label_id.not.is.null'
          : 'label_id.not.is.null,id.in.(${local.join(',')})';
      final results = await Future.wait<List<Map<String, dynamic>>>([
        _client
            .from('v_transactions_list')
            .select('id, code, occurred_at, verdict, labeled_by, labeled_at')
            .eq('customer_id', customerId)
            .or(labeled)
            .gte('occurred_at', range.start.toUtc().toIso8601String())
            .lt('occurred_at', range.end.toUtc().toIso8601String())
            .order('occurred_at', ascending: false)
            .limit(reportHistoryLimit),
        _client
            .from('ai_alerts')
            .select(
              'code, score, status, generated_at, '
              'suggested_type:fraud_types!ai_alerts_suggested_type_id_fkey(code)',
            )
            .eq('customer_id', customerId)
            .gte('generated_at', range.start.toUtc().toIso8601String())
            .lt('generated_at', range.end.toUtc().toIso8601String())
            .order('generated_at', ascending: false)
            .limit(reportHistoryLimit),
      ]);
      final analystIds = {
        for (final row in results[0]) ?row['labeled_by'] as String?,
      };
      final analysts = analystIds.isEmpty
          ? const <Map<String, dynamic>>[]
          : await _client
                .from('analysts')
                .select('id, full_name')
                .inFilter('id', analystIds.toList());
      final names = {
        for (final row in analysts)
          row['id'] as String: row['full_name'] as String,
      };
      return CustomerHistory(
        labels: withLocalHistory([
          for (final row in results[0])
            if (row['verdict'] != null || local.contains(row['id']))
              labelItemFromRow(row, analystName: names[row['labeled_by']]),
        ], _localWrites),
        alerts: [for (final row in results[1]) alertItemFromRow(row)],
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }
}

/// [items] with the verdict, analyst and date of the labels saved in this session.
List<LabelHistoryItem> withLocalHistory(
  List<LabelHistoryItem> items,
  LocalWritesStore localWrites,
) => [
  for (final item in items)
    switch (localWrites.labelFor(item.transactionId)) {
      final local? => item.copyWith(
        verdict: local.values.verdict,
        analystName: local.analystName,
        labeledAt: local.updatedAt,
      ),
      null => item,
    },
];

CustomerProfile profileFromRow(Map<String, dynamic> row) {
  final income = row['declared_income'] as num?;
  return CustomerProfile(
    id: row['id'] as String,
    fullName: '${row['first_names']} ${row['last_names']}',
    documentType: row['document_type'] as String,
    documentNumber: row['document_number'] as String,
    birthDate: DateTime.parse(row['birth_date'] as String),
    countryName: _embedded(row, 'countries') ?? '',
    cityName: _embedded(row, 'cities') ?? '',
    segment: CustomerSegment.fromDb(row['segment'] as String),
    riskLevel: RiskLevel.fromDb(row['risk_level'] as String),
    customerSince: DateTime.parse(row['customer_since'] as String),
    incomeCurrency: Currency.fromDb(row['income_currency'] as String),
    declaredIncome: income?.toDouble(),
    occupation: row['occupation'] as String?,
    email: row['email'] as String?,
    phone: row['phone'] as String?,
  );
}

ReportAccount accountFromRow(Map<String, dynamic> row) {
  final openedOn = row['opened_on'] as String?;
  return ReportAccount(
    id: row['id'] as String,
    last4: row['last4'] as String,
    type: AccountType.fromDb(row['type'] as String),
    currency: Currency.fromDb(row['currency_code'] as String),
    bankName: _embedded(row, 'banks') ?? '',
    status: ProductStatus.fromDb(row['status'] as String),
    balance: (row['balance'] as num?)?.toDouble(),
    creditLimit: (row['credit_limit'] as num?)?.toDouble(),
    openedOn: openedOn == null ? null : DateTime.parse(openedOn),
  );
}

ReportCard cardFromRow(Map<String, dynamic> row) => ReportCard(
  id: row['id'] as String,
  last4: row['last4'] as String,
  network: row['network'] as String,
  type: CardType.fromDb(row['type'] as String),
  status: ProductStatus.fromDb(row['status'] as String),
  expiresOn: DateTime.parse(row['expires_on'] as String),
  accountLast4: _embedded(row, 'accounts', field: 'last4'),
  currency: switch (_embedded(row, 'accounts', field: 'currency_code')) {
    final code? => Currency.fromDb(code),
    null => null,
  },
  creditLimit: (row['credit_limit'] as num?)?.toDouble(),
);

/// A row of `customer_devices` with its `devices` row embedded.
ReportDevice deviceFromRow(Map<String, dynamic> row) {
  final device = row['devices'] as Map<String, dynamic>;
  String? join(List<Object?> parts) {
    final text = parts.whereType<String>().join(' ').trim();
    return text.isEmpty ? null : text;
  }

  return ReportDevice(
    id: device['id'] as String,
    type: DeviceType.fromDb(device['type'] as String),
    name: join([device['brand'], device['model']]),
    system: join([device['os'], device['os_version']]),
    firstSeenAt: DateTime.parse(row['first_seen_at'] as String).toLocal(),
    lastSeenAt: DateTime.parse(row['last_seen_at'] as String).toLocal(),
    isTrusted: row['is_trusted'] as bool,
  );
}

/// A row of `v_transactions_list`. A transaction labeled only in this session has no
/// verdict in the database yet: [withLocalHistory] fills it.
LabelHistoryItem labelItemFromRow(
  Map<String, dynamic> row, {
  String? analystName,
}) {
  final verdict = row['verdict'] as String?;
  final labeledAt = row['labeled_at'] as String?;
  return LabelHistoryItem(
    transactionId: row['id'] as int,
    transactionCode: row['code'] as String,
    occurredAt: DateTime.parse(row['occurred_at'] as String).toLocal(),
    verdict: verdict == null ? Verdict.uncertain : Verdict.fromDb(verdict),
    analystName: analystName,
    labeledAt: labeledAt == null ? null : DateTime.parse(labeledAt).toLocal(),
  );
}

/// A row of `customer_monthly_activity`: `month` is a date, the first of the month.
MonthlyActivity monthlyActivityFromRow(Map<String, dynamic> row) {
  final month = DateTime.parse(row['month'] as String);
  return MonthlyActivity(
    month: DateTime(month.year, month.month),
    currency: Currency.fromDb(row['currency_code'] as String),
    transactionCount: row['transaction_count'] as int,
    totalAmount: (row['total_amount'] as num).toDouble(),
  );
}

AlertHistoryItem alertItemFromRow(Map<String, dynamic> row) => AlertHistoryItem(
  code: row['code'] as String,
  score: row['score'] as int,
  status: AlertStatus.fromDb(row['status'] as String),
  suggestedType: FraudType.fromDb(
    (row['suggested_type'] as Map<String, dynamic>)['code'] as String,
  ),
  generatedAt: DateTime.parse(row['generated_at'] as String).toLocal(),
);

String? _embedded(
  Map<String, dynamic> row,
  String table, {
  String field = 'name',
}) => (row[table] as Map<String, dynamic>?)?[field] as String?;

/// The report repository of the app. With `--dart-define=USE_FAKE_DATA=true` (no
/// backend) it is [FakeCustomerReportRepository].
final customerReportRepositoryProvider = Provider<CustomerReportRepository>((
  ref,
) {
  final localWrites = ref.watch(localWritesStoreProvider);
  return Env.useFakeData
      ? FakeCustomerReportRepository(localWrites)
      : CustomerReportRepository(
          ref.watch(supabaseClientProvider),
          localWrites,
        );
}, name: 'customerReportRepositoryProvider');
