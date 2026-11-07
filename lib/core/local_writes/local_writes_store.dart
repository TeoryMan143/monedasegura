import 'dart:collection';

import '../demo/demo_cases.dart';
import '../domain/alert_status.dart';
import '../domain/audit_action.dart';
import '../errors/failure.dart';
import 'local_writes_models.dart';

/// Transactions that fail to save on purpose, to show E-03 (HU-04).
const Set<int> demoFailingTransactionIds = {DemoCases.failingTransactionId};

/// The prototype's writes, kept in memory because nothing writes to the database yet.
///
/// Repositories merge these reads over what comes from the database. Once the RPCs exist,
/// their write methods call them and this store is deleted. Each write stands for one RPC:
/// it waits [delay] so the UI shows «Guardando…», and it applies completely or not at all.
class LocalWritesStore {
  LocalWritesStore({
    this.failingTransactionIds = demoFailingTransactionIds,
    this.delay = const Duration(milliseconds: 400),
    this._clock = DateTime.now,
  });

  final Set<int> failingTransactionIds;
  final Duration delay;
  final DateTime Function() _clock;

  final Map<int, LocalLabel> _labels = {};
  final Map<String, AlertResolution> _alerts = {};
  final List<AuditEntry> _audit = [];

  /// Changes on [clear], so a write that was waiting does not reach the next session.
  int _session = 0;

  /// The label saved for [transactionId], or null if this session saved none.
  LocalLabel? labelFor(int transactionId) => _labels[transactionId];

  /// The status set for [alertId], or null if this session did not resolve it.
  AlertStatus? alertStatusFor(String alertId) => _alerts[alertId]?.status;

  /// Who resolved [alertId] and how, or null if this session did not resolve it.
  AlertResolution? alertResolutionFor(String alertId) => _alerts[alertId];

  /// Every alert this session resolved, by alert ID. The database still has them pending,
  /// so the inbox uses it to hide them there and to show them in their new status.
  Map<String, AlertResolution> get alertResolutions =>
      UnmodifiableMapView(_alerts);

  /// The changes to the label of [transactionId], newest first.
  List<AuditEntry> auditFor(int transactionId) =>
      _newestFirst((entry) => entry.transactionId == transactionId);

  /// The resolution of [alertId] and the label changes it caused, newest first.
  List<AuditEntry> auditForAlert(String alertId) =>
      _newestFirst((entry) => entry.alertId == alertId);

  /// Saves the label of one transaction.
  ///
  /// Throws a [Failure] if [transactionId] is in [failingTransactionIds].
  Future<LocalLabel> saveLabel({
    required int transactionId,
    required LabelValues values,
    required String analystId,
    required String analystName,
  }) async {
    await _prepareWrite([transactionId]);
    return _writeLabel(
      transactionId: transactionId,
      values: values,
      analystId: analystId,
      analystName: analystName,
      now: _clock(),
    );
  }

  /// Saves the same label on every transaction, and returns how many already had one here.
  ///
  /// One ID in [failingTransactionIds] rejects them all.
  Future<int> saveLabels({
    required Iterable<int> transactionIds,
    required LabelValues values,
    required String analystId,
    required String analystName,
  }) async {
    final ids = transactionIds.toSet();
    await _prepareWrite(ids);
    final overwritten = ids.where(_labels.containsKey).length;
    final now = _clock();
    for (final id in ids) {
      _writeLabel(
        transactionId: id,
        values: values,
        analystId: analystId,
        analystName: analystName,
        now: now,
      );
    }
    return overwritten;
  }

  /// Resolves an alert and labels [transactionIds], the ones the analyst left checked.
  ///
  /// The first analyst wins: a second resolution throws a [ConflictFailure]. One ID in
  /// [failingTransactionIds] rejects the whole resolution.
  Future<AlertResolution> resolveAlert({
    required String alertId,
    required AlertStatus status,
    required Iterable<int> transactionIds,
    required LabelValues values,
    required String analystId,
    required String analystName,
  }) async {
    final action = AuditAction.forResolution(status);
    final ids = transactionIds.toSet();
    await _prepareWrite(ids);
    if (_alerts.containsKey(alertId)) {
      throw const Failure.conflict(key: 'alert_already_resolved');
    }

    final now = _clock();
    final resolution = AlertResolution(
      alertId: alertId,
      status: status,
      analystId: analystId,
      analystName: analystName,
      resolvedAt: now,
      finalType: status == AlertStatus.rejected
          ? null
          : values.fraudTypes.firstOrNull,
    );
    _alerts[alertId] = resolution;
    _audit.add(
      AuditEntry(
        action: action,
        analystId: analystId,
        analystName: analystName,
        createdAt: now,
        alertId: alertId,
        oldValue: {'status': AlertStatus.pending.dbValue},
        newValue: {
          'status': status.dbValue,
          'final_type': resolution.finalType?.dbValue,
        },
      ),
    );
    for (final id in ids) {
      _writeLabel(
        transactionId: id,
        values: values,
        alertId: alertId,
        analystId: analystId,
        analystName: analystName,
        now: now,
      );
    }
    return resolution;
  }

  /// Forgets everything. Signing out does not call it: the writes stay for every
  /// analyst until the app closes, like labels in the shared database.
  void clear() {
    _session++;
    _labels.clear();
    _alerts.clear();
    _audit.clear();
  }

  /// Waits like an RPC, then rejects the write if it must fail or its session ended.
  Future<void> _prepareWrite(Iterable<int> transactionIds) async {
    final session = _session;
    await Future<void>.delayed(delay);
    if (session != _session) throw const Failure.unauthorized();

    final failing = transactionIds.where(failingTransactionIds.contains);
    if (failing.isNotEmpty) {
      throw Failure.unknown(message: 'Simulated save error: ${failing.first}');
    }
  }

  LocalLabel _writeLabel({
    required int transactionId,
    required LabelValues values,
    String? alertId,
    required String analystId,
    required String analystName,
    required DateTime now,
  }) {
    final previous = _labels[transactionId];
    final label = LocalLabel(
      transactionId: transactionId,
      values: values,
      alertId: alertId,
      analystId: analystId,
      analystName: analystName,
      createdAt: previous?.createdAt ?? now,
      updatedAt: now,
      version: (previous?.version ?? 0) + 1,
    );
    _labels[transactionId] = label;
    _audit.add(
      AuditEntry(
        action: previous == null
            ? AuditAction.createLabel
            : AuditAction.updateLabel,
        analystId: analystId,
        analystName: analystName,
        createdAt: now,
        transactionId: transactionId,
        alertId: alertId,
        oldValue: previous == null ? null : _auditValues(previous.values),
        newValue: _auditValues(values),
      ),
    );
    return label;
  }

  Map<String, Object?> _auditValues(LabelValues values) => {
    'verdict': values.verdict.dbValue,
    'confidence': values.confidence.dbValue,
    'severity': values.severity?.dbValue,
    'justification': values.justification,
    'fraud_types': [for (final type in values.fraudTypes) type.dbValue],
  };

  List<AuditEntry> _newestFirst(bool Function(AuditEntry) test) =>
      UnmodifiableListView(_audit.reversed.where(test).toList());
}
