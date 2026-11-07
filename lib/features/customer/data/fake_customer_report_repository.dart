import '../../../core/domain/account_type.dart';
import '../../../core/domain/alert_status.dart';
import '../../../core/domain/currency.dart';
import '../../../core/domain/fraud_type.dart';
import '../../../core/domain/verdict.dart';
import '../../../core/errors/failure.dart';
import '../../../core/local_writes/local_writes_store.dart';
import '../domain/customer_report.dart';
import '../domain/date_range.dart';
import '../domain/report_enums.dart';
import 'customer_report_repository.dart';
import 'fake_customer_repository.dart';

/// [CustomerReportRepository] without a backend: «Ana María Rojas», the customer of
/// [FakeCustomerRepository], with the same accounts. Dates are relative to [now].
class FakeCustomerReportRepository implements CustomerReportRepository {
  FakeCustomerReportRepository(this._localWrites, {DateTime? now})
    : _now = now ?? DateTime.now();

  final LocalWritesStore _localWrites;
  final DateTime _now;

  static const _id = FakeCustomerRepository.customerId;

  DateTime _daysAgo(int days, [int hour = 10, int minute = 0]) =>
      DateTime(_now.year, _now.month, _now.day - days, hour, minute);

  void _check(String customerId) {
    if (customerId != _id) throw const Failure.notFound();
  }

  @override
  Future<CustomerProfile> fetchProfile(String customerId) async {
    _check(customerId);
    return CustomerProfile(
      id: _id,
      fullName: 'Ana María Rojas',
      documentType: 'CC',
      documentNumber: '1.020.456.789',
      birthDate: DateTime(1988, 4, 12),
      countryName: 'Colombia',
      cityName: 'Medellín',
      segment: CustomerSegment.retailMidIncome,
      riskLevel: RiskLevel.medium,
      customerSince: DateTime(2019, 8, 3),
      incomeCurrency: Currency.cop,
      declaredIncome: 6200000,
      occupation: 'Docente',
      email: 'ana.rojas@correo.co',
      phone: '+57 300 412 7781',
    );
  }

  @override
  Future<CustomerProducts> fetchProducts(String customerId) async {
    _check(customerId);
    return CustomerProducts(
      accounts: [
        ReportAccount(
          id: 'acc-savings',
          last4: '4417',
          type: AccountType.savings,
          currency: Currency.cop,
          bankName: 'Moneda Segura',
          status: ProductStatus.active,
          balance: 3184200,
          openedOn: DateTime(2019, 8, 3),
        ),
        ReportAccount(
          id: 'acc-checking',
          last4: '8820',
          type: AccountType.checking,
          currency: Currency.cop,
          bankName: 'Moneda Segura',
          status: ProductStatus.active,
          balance: 912500,
          openedOn: DateTime(2021, 2, 15),
        ),
        ReportAccount(
          id: 'acc-wallet',
          last4: '3391',
          type: AccountType.wallet,
          currency: Currency.cop,
          bankName: 'Moneda Segura',
          status: ProductStatus.blocked,
          balance: 40000,
          openedOn: DateTime(2024, 6, 1),
        ),
      ],
      cards: [
        ReportCard(
          id: 'card-debit',
          last4: '5521',
          network: 'Visa',
          type: CardType.debit,
          status: ProductStatus.active,
          expiresOn: DateTime(2028, 9, 30),
          accountLast4: '4417',
        ),
        ReportCard(
          id: 'card-credit',
          last4: '7730',
          network: 'Mastercard',
          currency: Currency.cop,
          type: CardType.credit,
          status: ProductStatus.active,
          expiresOn: DateTime(2027, 3, 31),
          creditLimit: 8000000,
        ),
      ],
      devices: [
        ReportDevice(
          id: 'device-phone',
          type: DeviceType.mobile,
          name: 'Samsung Galaxy A54',
          system: 'Android 14',
          firstSeenAt: _daysAgo(600),
          lastSeenAt: _daysAgo(1, 22, 30),
          isTrusted: true,
        ),
        ReportDevice(
          id: 'device-new',
          type: DeviceType.mobile,
          name: 'Xiaomi Redmi 12',
          system: 'Android 13',
          firstSeenAt: _daysAgo(1, 22, 35),
          lastSeenAt: _daysAgo(1, 22, 47),
          isTrusted: false,
        ),
      ],
    );
  }

  @override
  Future<CustomerHistory> fetchHistory(
    String customerId,
    DateRange range,
  ) async {
    _check(customerId);
    LabelHistoryItem label(int id, int days, Verdict verdict, String analyst) =>
        LabelHistoryItem(
          transactionId: id,
          transactionCode: 'TX-$id',
          occurredAt: _daysAgo(days),
          verdict: verdict,
          analystName: analyst,
          labeledAt: _daysAgo(days, 12),
        );
    final labels = [
      label(48219, 1, Verdict.fraud, 'Mateo Rojas'),
      label(48302, 2, Verdict.notFraud, 'Laura Gómez'),
      label(48303, 3, Verdict.notFraud, 'Laura Gómez'),
      label(48304, 4, Verdict.notFraud, 'Laura Gómez'),
      label(48306, 6, Verdict.uncertain, 'Laura Gómez'),
    ];
    final alerts = [
      AlertHistoryItem(
        code: 'AL-1043',
        score: 88,
        status: AlertStatus.pending,
        suggestedType: FraudType.accountTakeover,
        generatedAt: _daysAgo(1, 22, 48),
      ),
      AlertHistoryItem(
        code: 'AL-1042',
        score: 92,
        status: AlertStatus.confirmed,
        suggestedType: FraudType.accountTakeover,
        generatedAt: _daysAgo(1, 22, 42),
      ),
    ];
    return CustomerHistory(
      labels: withLocalHistory(
        [
          for (final item in labels)
            if (range.contains(item.occurredAt)) item,
        ]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt)),
        _localWrites,
      ),
      alerts: [
        for (final alert in alerts)
          if (range.contains(alert.generatedAt)) alert,
      ],
    );
  }
}
