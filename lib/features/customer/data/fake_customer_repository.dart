import '../../../core/domain/account_type.dart';
import '../../../core/domain/channel.dart';
import '../../../core/domain/currency.dart';
import '../../../core/domain/page_result.dart';
import '../../../core/domain/transaction_type.dart';
import '../../../core/domain/verdict.dart';
import '../../../core/errors/failure.dart';
import '../../../core/local_writes/local_writes_store.dart';
import '../domain/customer_transaction.dart';
import '../domain/customer_transactions_query.dart';
import '../domain/customer_view.dart';
import '../domain/date_range.dart';
import '../domain/range_totals.dart';
import 'customer_repository.dart';

/// Offline customer view for `USE_FAKE_DATA=true` and tests: one customer, Ana María
/// Rojas, the first row of the fake transaction list. It stands in for the database,
/// so this is the only place where rows are filtered and added up in memory.
///
/// Dates are relative to [now], so the default range (the last 30 days) shows them.
class FakeCustomerRepository implements CustomerRepository {
  FakeCustomerRepository(this._localWrites, {DateTime? now})
    : _rows = _prototypeRows(now ?? DateTime.now());

  final LocalWritesStore _localWrites;
  final List<CustomerTransaction> _rows;

  static const customerId = '00000000-0000-4000-8000-000000000001';

  static const _accounts = [
    CustomerAccount(
      id: _savings,
      last4: '4417',
      type: AccountType.savings,
      currency: Currency.cop,
    ),
    CustomerAccount(
      id: _checking,
      last4: '8820',
      type: AccountType.checking,
      currency: Currency.cop,
    ),
    CustomerAccount(
      id: _wallet,
      last4: '3391',
      type: AccountType.wallet,
      currency: Currency.cop,
    ),
  ];

  static final _ids = {for (final account in _accounts) account.id};

  @override
  Future<CustomerView> fetchCustomer(String customerId) async {
    if (customerId != FakeCustomerRepository.customerId) {
      throw const Failure.notFound();
    }
    return const CustomerView(
      id: FakeCustomerRepository.customerId,
      fullName: 'Ana María Rojas',
      accounts: _accounts,
      pendingAlerts: 2,
    );
  }

  @override
  Future<DateTime?> fetchTransactionDate(int transactionId) async =>
      _rows.where((row) => row.id == transactionId).firstOrNull?.occurredAt;

  @override
  Future<LabelProgress> fetchProgress(
    CustomerView customer,
    DateRange range, {
    String? accountId,
  }) async {
    final rows = withLocalLabels(_inRange(range, accountId), _localWrites);
    return LabelProgress(
      labeled: rows.where((row) => row.isLabeled).length,
      total: rows.length,
    );
  }

  @override
  Future<List<RangeTotals>> fetchTotals(
    String customerId,
    DateRange range, {
    String? accountId,
  }) async {
    final rows = _inRange(range, accountId);
    if (rows.isEmpty) return const [];
    final accounts = accountId == null ? _ids : {accountId};
    num moneyIn = 0;
    num moneyOut = 0;
    for (final row in rows) {
      if (accounts.contains(row.destinationAccountId)) moneyIn += row.amount;
      if (accounts.contains(row.sourceAccountId)) moneyOut += row.amount;
    }
    return [
      RangeTotals(
        currency: Currency.cop,
        totalIn: moneyIn,
        totalOut: moneyOut,
        net: moneyIn - moneyOut,
        transactionCount: rows.length,
      ),
    ];
  }

  @override
  Future<PageResult<CustomerTransaction>> fetchPage(
    CustomerView customer,
    DateRange range,
    CustomerTransactionsQuery query,
  ) async {
    final rows = _inRange(range, query.accountId)
      ..sort((a, b) {
        final order = switch (query.sort) {
          CustomerTransactionsSort.date => a.occurredAt.compareTo(b.occurredAt),
          CustomerTransactionsSort.amount => a.amount.compareTo(b.amount),
        };
        if (order == 0) return b.id.compareTo(a.id);
        return query.ascending ? order : -order;
      });
    return PageResult(
      items: withLocalLabels(
        rows.skip(query.from).take(query.pageSize).toList(),
        _localWrites,
      ),
      total: rows.length,
    );
  }

  List<CustomerTransaction> _inRange(DateRange range, String? accountId) {
    final accounts = accountId == null ? _ids : {accountId};
    return _rows
        .where(
          (row) =>
              range.contains(row.occurredAt) &&
              (accounts.contains(row.sourceAccountId) ||
                  accounts.contains(row.destinationAccountId)),
        )
        .toList();
  }
}

const _savings = '00000000-0000-4000-9000-000000000001';
const _checking = '00000000-0000-4000-9000-000000000201';
const _wallet = '00000000-0000-4000-9000-000000000301';
const _external = '00000000-0000-4000-9000-000000000101';

List<CustomerTransaction> _prototypeRows(DateTime now) {
  DateTime daysAgo(int days, int hour, int minute) =>
      DateTime(now.year, now.month, now.day - days, hour, minute);

  return [
    CustomerTransaction(
      id: 48219,
      code: 'TX-48219',
      occurredAt: daysAgo(1, 22, 41),
      type: TransactionType.transfer,
      channel: Channel.app,
      amount: 1900000,
      currency: Currency.cop,
      sourceAccountId: _savings,
      destinationAccountId: _external,
      alertScore: 92,
      isLabeled: true,
      verdict: Verdict.fraud,
    ),
    CustomerTransaction(
      id: 48301,
      code: 'TX-48301',
      occurredAt: daysAgo(1, 22, 47),
      type: TransactionType.transfer,
      channel: Channel.app,
      amount: 1900000,
      currency: Currency.cop,
      sourceAccountId: _savings,
      destinationAccountId: _external,
      alertScore: 88,
      isLabeled: false,
    ),
    CustomerTransaction(
      id: 48302,
      code: 'TX-48302',
      occurredAt: daysAgo(2, 8, 14),
      type: TransactionType.payment,
      channel: Channel.pse,
      amount: 182400,
      currency: Currency.cop,
      sourceAccountId: _savings,
      merchantName: 'EPM Servicios',
      isLabeled: true,
      verdict: Verdict.notFraud,
    ),
    CustomerTransaction(
      id: 48303,
      code: 'TX-48303',
      occurredAt: daysAgo(3, 12, 30),
      type: TransactionType.purchase,
      channel: Channel.pos,
      amount: 96500,
      currency: Currency.cop,
      sourceAccountId: _checking,
      merchantName: 'Éxito Laureles',
      isLabeled: true,
      verdict: Verdict.notFraud,
    ),
    CustomerTransaction(
      id: 48304,
      code: 'TX-48304',
      occurredAt: daysAgo(4, 9, 10),
      type: TransactionType.credit,
      channel: Channel.payroll,
      amount: 4800000,
      currency: Currency.cop,
      destinationAccountId: _savings,
      merchantName: 'Colegio San José',
      isLabeled: true,
      verdict: Verdict.notFraud,
    ),
    CustomerTransaction(
      id: 48305,
      code: 'TX-48305',
      occurredAt: daysAgo(5, 23, 5),
      type: TransactionType.withdrawal,
      channel: Channel.atm,
      amount: 400000,
      currency: Currency.cop,
      sourceAccountId: _checking,
      isLabeled: false,
    ),
    CustomerTransaction(
      id: 48306,
      code: 'TX-48306',
      occurredAt: daysAgo(6, 15, 22),
      type: TransactionType.purchase,
      channel: Channel.web,
      amount: 249900,
      currency: Currency.cop,
      sourceAccountId: _wallet,
      merchantName: 'Falabella.com',
      isLabeled: true,
      verdict: Verdict.uncertain,
    ),
    CustomerTransaction(
      id: 48307,
      code: 'TX-48307',
      occurredAt: daysAgo(8, 19, 40),
      type: TransactionType.transfer,
      channel: Channel.app,
      amount: 300000,
      currency: Currency.cop,
      sourceAccountId: _checking,
      destinationAccountId: _savings,
      isLabeled: false,
    ),
    // Outside the default range of 30 days.
    CustomerTransaction(
      id: 48308,
      code: 'TX-48308',
      occurredAt: daysAgo(45, 10, 0),
      type: TransactionType.payment,
      channel: Channel.pse,
      amount: 120000,
      currency: Currency.cop,
      sourceAccountId: _savings,
      merchantName: 'Claro Colombia',
      isLabeled: false,
    ),
  ];
}
