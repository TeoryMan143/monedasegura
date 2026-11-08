import '../../../core/domain/account_type.dart';
import '../../../core/domain/channel.dart';
import '../../../core/domain/confidence_level.dart';
import '../../../core/domain/currency.dart';
import '../../../core/domain/fraud_type.dart';
import '../../../core/domain/severity.dart';
import '../../../core/domain/transaction_type.dart';
import '../../../core/domain/verdict.dart';
import '../../../core/errors/failure.dart';
import '../domain/classification_target.dart';
import '../domain/label_form.dart';
import 'label_writer.dart';
import 'labeling_repository.dart';

/// [LabelingRepository] without a backend: the transactions of «Ana María Rojas», the
/// customer of `FakeCustomerRepository`, so the panel opens on any row of its A-02.
/// Labels go to the same [LabelWriter] as in the app.
class FakeLabelingRepository implements LabelingRepository {
  FakeLabelingRepository(this._writer, {DateTime? now})
    : _now = now ?? DateTime.now();

  final LabelWriter _writer;
  final DateTime _now;

  @override
  Future<ClassificationTarget> fetchTarget(int transactionId) async {
    final target = _targets(_now)[transactionId];
    if (target == null) throw const Failure.notFound();
    return withPendingLabel(target, _writer);
  }

  @override
  Future<SavedLabel> saveLabel({
    required int transactionId,
    required LabelForm form,
    required String analystId,
    required String analystName,
  }) => _writer.save(
    transactionId: transactionId,
    form: form,
    analystId: analystId,
    analystName: analystName,
  );

  @override
  Future<int> labelMany({
    required Set<int> transactionIds,
    required LabelForm form,
    required String analystId,
    required String analystName,
  }) => _writer.saveMany(
    transactionIds: transactionIds,
    form: form,
    analystId: analystId,
    analystName: analystName,
  );
}

Map<int, ClassificationTarget> _targets(DateTime now) {
  DateTime daysAgo(int days, int hour, int minute) =>
      DateTime(now.year, now.month, now.day - days, hour, minute);

  ClassificationTarget target(
    int id,
    DateTime occurredAt,
    TransactionType type,
    Channel channel,
    double amount, {
    String? merchant,
    String last4 = '4417',
    AccountType account = AccountType.savings,
    TargetAlert? alert,
    SavedLabel? label,
  }) => ClassificationTarget(
    id: id,
    code: 'TX-$id',
    occurredAt: occurredAt,
    type: type,
    channel: channel,
    amount: amount,
    currency: Currency.cop,
    merchantName: merchant,
    accountLast4: last4,
    accountType: account,
    alert: alert,
    label: label,
  );

  SavedLabel notFraud(int days) => SavedLabel(
    verdict: Verdict.notFraud,
    confidence: ConfidenceLevel.high,
    analystName: 'Laura Gómez',
    updatedAt: daysAgo(days, 9, 0),
  );

  return {
    for (final target in [
      target(
        48219,
        daysAgo(1, 22, 41),
        TransactionType.transfer,
        Channel.app,
        1900000,
        alert: const TargetAlert(
          code: 'AL-1042',
          score: 92,
          summary:
              'Transferencia a un beneficiario nuevo tras cambio de clave.',
          suggestedType: FraudType.accountTakeover,
        ),
        label: SavedLabel(
          verdict: Verdict.fraud,
          confidence: ConfidenceLevel.high,
          severity: Severity.high,
          fraudTypes: const [FraudType.accountTakeover],
          justification: 'Cambio de clave y dispositivo nuevo minutos antes.',
          analystName: 'Mateo Rojas',
          updatedAt: daysAgo(1, 23, 5),
        ),
      ),
      target(
        48301,
        daysAgo(1, 22, 47),
        TransactionType.transfer,
        Channel.app,
        1900000,
        alert: const TargetAlert(
          code: 'AL-1043',
          score: 88,
          summary: 'Segunda transferencia igual en 6 minutos.',
          suggestedType: FraudType.accountTakeover,
        ),
      ),
      target(
        48302,
        daysAgo(2, 8, 14),
        TransactionType.payment,
        Channel.pse,
        182400,
        merchant: 'EPM Servicios',
        label: notFraud(2),
      ),
      target(
        48303,
        daysAgo(3, 12, 30),
        TransactionType.purchase,
        Channel.pos,
        96500,
        merchant: 'Éxito Laureles',
        last4: '8820',
        account: AccountType.checking,
        label: notFraud(3),
      ),
      target(
        48304,
        daysAgo(4, 9, 10),
        TransactionType.credit,
        Channel.payroll,
        4800000,
        merchant: 'Colegio San José',
        label: notFraud(4),
      ),
      target(
        48306,
        daysAgo(6, 15, 22),
        TransactionType.purchase,
        Channel.web,
        249900,
        merchant: 'Falabella.com',
        last4: '3391',
        account: AccountType.wallet,
        label: SavedLabel(
          verdict: Verdict.uncertain,
          confidence: ConfidenceLevel.medium,
          justification: 'El cliente no reconoce el comercio; sin reclamo aún.',
          analystName: 'Laura Gómez',
          updatedAt: daysAgo(6, 18, 0),
        ),
      ),
      target(
        48305,
        daysAgo(5, 23, 5),
        TransactionType.withdrawal,
        Channel.atm,
        400000,
        last4: '8820',
        account: AccountType.checking,
      ),
      target(
        48307,
        daysAgo(8, 19, 40),
        TransactionType.transfer,
        Channel.app,
        300000,
        last4: '8820',
        account: AccountType.checking,
      ),
      target(
        48308,
        daysAgo(45, 10, 0),
        TransactionType.payment,
        Channel.pse,
        120000,
        merchant: 'Claro Colombia',
      ),
    ])
      target.id: target,
  };
}
