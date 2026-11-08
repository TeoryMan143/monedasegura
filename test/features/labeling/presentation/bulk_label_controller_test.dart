import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/severity.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/core/ui/save_status.dart';
import 'package:monedasegura/features/auth/domain/analyst.dart';
import 'package:monedasegura/features/auth/presentation/controllers/session_controller.dart';
import 'package:monedasegura/features/labeling/data/fake_labeling_repository.dart';
import 'package:monedasegura/features/labeling/data/label_writer.dart';
import 'package:monedasegura/features/labeling/data/labeling_repository.dart';
import 'package:monedasegura/features/labeling/domain/label_form.dart';
import 'package:monedasegura/features/labeling/domain/transaction_selection.dart';
import 'package:monedasegura/features/labeling/presentation/controllers/bulk_label_controller.dart';
import 'package:monedasegura/features/labeling/presentation/controllers/transaction_selection_controller.dart';

class _SignedIn extends SessionController {
  @override
  Analyst? build() => const Analyst(
    id: 'a1',
    email: 'laura.gomez@monedasegura.test',
    fullName: 'Laura Gómez',
  );
}

class _SignedOut extends SessionController {
  @override
  Analyst? build() => null;
}

const _structuring = LabelForm(
  verdict: Verdict.fraud,
  fraudTypes: [FraudType.laundering],
  confidence: ConfidenceLevel.high,
  severity: Severity.critical,
);

void main() {
  const scope = SelectionScope.transactions;
  late LocalWritesStore store;
  late ProviderContainer container;
  final provider = bulkLabelProvider(scope);
  final selectionProvider = selectedTransactionsProvider(scope);

  ProviderContainer createContainer({bool signedIn = true}) {
    final container = ProviderContainer(
      overrides: [
        labelingRepositoryProvider.overrideWithValue(
          FakeLabelingRepository(LocalLabelWriter(store)),
        ),
        sessionProvider.overrideWith(signedIn ? _SignedIn.new : _SignedOut.new),
      ],
    );
    addTearDown(container.dispose);
    // Both providers are autoDispose: the listeners keep them alive as the dialog and
    // the table would.
    container
      ..listen(provider, (_, _) {})
      ..listen(selectionProvider, (_, _) {});
    return container;
  }

  setUp(() {
    store = LocalWritesStore(
      delay: Duration.zero,
      failingTransactionIds: const {99},
    );
    container = createContainer();
  });

  BulkLabelController notifier() => container.read(provider.notifier);
  BulkLabelState state() => container.read(provider);

  /// Checks [ids] in the table, the first one already labeled.
  TransactionSelection select(List<int> ids) {
    container.read(selectionProvider.notifier).selectAll([
      for (final (index, id) in ids.indexed)
        SelectedTransaction(id: id, isLabeled: index == 0),
    ]);
    return container.read(selectionProvider);
  }

  test('starts with an empty form and no errors shown', () {
    expect(state().form, const LabelForm());
    expect(state().visibleErrors, isEmpty);
    expect(state().saveState, SaveState.idle);
  });

  test('change keeps the form and marks the field the analyst changed', () {
    notifier().change(
      const LabelForm(verdict: Verdict.fraud),
      LabelField.verdict,
    );

    expect(state().form.verdict, Verdict.fraud);
    expect(state().touched, {LabelField.verdict});
    // Fraude without a type: that error waits until the types are touched.
    expect(state().visibleErrors.keys, isNot(contains(LabelField.fraudTypes)));

    notifier().change(
      const LabelForm(verdict: Verdict.fraud, fraudTypes: [FraudType.phishing]),
      LabelField.fraudTypes,
    );
    expect(state().touched, {LabelField.verdict, LabelField.fraudTypes});
  });

  test('review shows every error of an incomplete form', () {
    notifier().change(
      const LabelForm(verdict: Verdict.fraud),
      LabelField.verdict,
    );

    expect(notifier().review(), isFalse);
    expect(state().submitted, isTrue);
    expect(
      state().visibleErrors.keys,
      containsAll([
        LabelField.fraudTypes,
        LabelField.confidence,
        LabelField.severity,
      ]),
    );
  });

  test('review passes a complete form', () {
    notifier().change(_structuring, LabelField.verdict);

    expect(notifier().review(), isTrue);
  });

  test(
    'apply labels every selected transaction and clears the selection',
    () async {
      final selection = select([1, 2, 3]);
      notifier().change(_structuring, LabelField.verdict);

      final applied = await notifier().apply(selection);

      expect(applied, isTrue);
      expect(state().saveState, SaveState.saved);
      for (final id in [1, 2, 3]) {
        expect(store.labelFor(id)?.values.fraudTypes, [FraudType.laundering]);
      }
      expect(container.read(selectionProvider).isEmpty, isTrue);
    },
  );

  test('apply does not save an incomplete form', () async {
    final selection = select([1, 2]);
    notifier().change(
      const LabelForm(verdict: Verdict.uncertain),
      LabelField.verdict,
    );

    expect(await notifier().apply(selection), isFalse);
    expect(store.labelFor(1), isNull);
    expect(state().submitted, isTrue);
    expect(container.read(selectionProvider).count, 2);
  });

  test(
    'a failed save keeps the form and the selection for the retry',
    () async {
      final selection = select([1, 99]);
      notifier().change(_structuring, LabelField.verdict);

      expect(await notifier().apply(selection), isFalse);

      expect(state().saveState, SaveState.error);
      expect(state().failure, isA<Failure>());
      expect(state().form, _structuring);
      expect(store.labelFor(1), isNull);
      expect(container.read(selectionProvider).count, 2);
    },
  );

  test('without a session it fails as unauthorized', () async {
    container = createContainer(signedIn: false);
    final selection = select([1]);
    notifier().change(_structuring, LabelField.verdict);

    expect(await notifier().apply(selection), isFalse);
    expect(state().failure, isA<UnauthorizedFailure>());
  });
}
