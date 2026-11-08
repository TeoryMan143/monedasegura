import '../../../core/domain/audit_action.dart';
import '../../../core/domain/catalog_models.dart';
import '../../../core/local_writes/local_writes_store.dart';
import '../domain/audit_entry.dart';
import 'audit_repository.dart';

/// [AuditRepository] without a backend: TX-48219 of `FakeLabelingRepository` was
/// labeled, edited and its alert AL-1042 confirmed. The other transactions only show
/// the changes of the session. Dates are relative to [now].
class FakeAuditRepository implements AuditRepository {
  FakeAuditRepository(this._localWrites, {DateTime? now})
    : _now = now ?? DateTime.now();

  final LocalWritesStore _localWrites;
  final DateTime _now;

  static const historyTransactionId = 48219;

  @override
  Future<List<CatalogFraudType>> Function() get fraudTypes =>
      throw UnimplementedError('The fake history needs no catalog');

  DateTime _yesterday(int hour, int minute) =>
      DateTime(_now.year, _now.month, _now.day - 1, hour, minute);

  @override
  Future<List<AuditEntry>> fetchLabelHistory(int transactionId) async {
    final database = transactionId == historyTransactionId
        ? _history()
        : const <AuditEntry>[];
    return mergeAuditHistory(
      database,
      sessionHistory(_localWrites, transactionId, const {}),
    );
  }

  List<AuditEntry> _history() {
    const created = {
      'verdict': 'uncertain',
      'confidence': 2,
      'severity': null,
      'justification':
          'Transferencia a un beneficiario nuevo; falta confirmar.',
    };
    const edited = {
      'verdict': 'fraud',
      'confidence': 3,
      'severity': 'high',
      'justification': 'Cambio de clave y dispositivo nuevo minutos antes.',
    };
    return [
      AuditEntry(
        action: AuditAction.createLabel,
        analystId: 'a0000000-0000-4000-8000-000000000006',
        analystName: 'Laura Gómez',
        createdAt: _yesterday(22, 50),
        newValue: created,
      ),
      AuditEntry(
        action: AuditAction.confirmAlert,
        analystId: 'a0000000-0000-4000-8000-000000000007',
        analystName: 'Mateo Rojas',
        createdAt: _yesterday(23, 4),
        oldValue: const {'code': 'AL-1042', 'status': 'pending'},
        newValue: const {
          'code': 'AL-1042',
          'status': 'confirmed',
          'final_type': 'ATO',
        },
      ),
      AuditEntry(
        action: AuditAction.updateLabel,
        analystId: 'a0000000-0000-4000-8000-000000000007',
        analystName: 'Mateo Rojas',
        createdAt: _yesterday(23, 5),
        oldValue: created,
        newValue: edited,
      ),
    ];
  }
}
