import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/demo/demo_cases.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/local_writes/local_writes_models.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';

const notFraud = LabelValues(
  verdict: Verdict.notFraud,
  confidence: ConfidenceLevel.medium,
  justification: 'Compra habitual',
);

void main() {
  final store = LocalWritesStore(delay: Duration.zero);

  test('the default store fails only on the demo transaction', () async {
    await expectLater(
      store.saveLabel(
        transactionId: DemoCases.failingTransactionId,
        values: notFraud,
        analystId: 'a1',
        analystName: 'Analista a1',
      ),
      throwsA(isA<Failure>()),
    );
  });

  test(
    'the structuring batch saves, since the failing transaction is not in it',
    () async {
      expect(
        DemoCases.structuringTransactionIds,
        isNot(contains(DemoCases.failingTransactionId)),
      );
      await store.saveLabels(
        transactionIds: DemoCases.structuringTransactionIds,
        values: notFraud,
        analystId: 'a1',
        analystName: 'Analista a1',
      );
      expect(
        DemoCases.structuringTransactionIds.map(store.labelFor),
        everyElement(isNotNull),
      );
    },
  );
}
