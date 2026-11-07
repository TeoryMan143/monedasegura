import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/features/alerts/domain/resolve_alert_input.dart';

void main() {
  test('each action ends the alert in its status', () {
    expect(ResolveAlertAction.confirm.status, AlertStatus.confirmed);
    expect(ResolveAlertAction.reject.status, AlertStatus.rejected);
    expect(ResolveAlertAction.reclassify.status, AlertStatus.reclassified);
  });

  test('excluded transactions are empty by default', () {
    const input = ResolveAlertInput(
      alertId: 'a1',
      action: ResolveAlertAction.reject,
    );

    expect(input.excludedTransactionIds, isEmpty);
    expect(input.finalTypeId, isNull);
  });
}
