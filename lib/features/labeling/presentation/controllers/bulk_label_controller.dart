import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/ui/save_status.dart';
import '../../../auth/presentation/controllers/session_controller.dart';
import '../../../transactions/presentation/controllers/transactions_page_controller.dart';
import '../../data/labeling_repository.dart';
import '../../domain/label_form.dart';
import '../../domain/label_validator.dart';
import '../../domain/transaction_selection.dart';
import 'transaction_selection_controller.dart';

part 'bulk_label_controller.freezed.dart';

/// The one form of A-03 and its save, for every selected transaction (HU-05).
@freezed
abstract class BulkLabelState with _$BulkLabelState {
  const factory BulkLabelState({
    @Default(LabelForm()) LabelForm form,

    /// Fields the analyst changed: only those show their error before applying.
    @Default(<LabelField>{}) Set<LabelField> touched,

    /// True after the first «Aplicar»: from then on every error shows.
    @Default(false) bool submitted,
    @Default(SaveState.idle) SaveState saveState,

    /// Why the last save failed. The form keeps its data for the retry.
    Failure? failure,
  }) = _BulkLabelState;

  const BulkLabelState._();

  /// Every broken rule of [form], from `validateLabel`.
  Map<LabelField, String> get errors => validateLabel(form);

  /// The errors to show now: all of them after «Aplicar», otherwise only the ones of
  /// fields the analyst touched.
  Map<LabelField, String> get visibleErrors =>
      visibleLabelErrors(form, touched: touched, submitted: submitted);

  bool get isSaving => saveState == SaveState.saving;
}

/// The bulk classification of the table of a `SelectionScope` (HU-05).
final bulkLabelProvider = NotifierProvider.autoDispose
    .family<BulkLabelController, BulkLabelState, String>(
      BulkLabelController.new,
      name: 'bulkLabelProvider',
    );

/// A `Notifier`, not an `AsyncNotifier`: A-03 loads nothing, and the save keeps its
/// own [SaveState] so the form stays on screen while it saves or after it fails.
class BulkLabelController extends Notifier<BulkLabelState> {
  BulkLabelController(this.scope);

  final String scope;

  @override
  BulkLabelState build() => const BulkLabelState();

  /// What `LabelFormFields` reports after a change: the whole [form] and the [field]
  /// the analyst changed.
  void change(LabelForm form, LabelField field) {
    final current = state;
    if (current.isSaving) return;
    state = current.copyWith(
      form: form,
      touched: {...current.touched, field},
      // An error stays until the retry; any other change is unsaved again.
      saveState: current.saveState == SaveState.error
          ? SaveState.error
          : SaveState.idle,
    );
  }

  /// «Aplicar»: true when the form can be applied. Otherwise every error shows.
  bool review() {
    if (state.errors.isEmpty) return true;
    state = state.copyWith(submitted: true);
    return false;
  }

  /// Saves the form on every transaction of [selection], all or none. Returns true
  /// when it was saved; then the selection of the table is cleared.
  ///
  /// On a failure the form keeps its data and [BulkLabelState.failure] says why.
  Future<bool> apply(TransactionSelection selection) async {
    if (state.isSaving || selection.isEmpty || !review()) return false;
    state = state.copyWith(
      submitted: true,
      saveState: SaveState.saving,
      failure: null,
    );
    try {
      final analyst = ref.read(sessionProvider);
      if (analyst == null) throw const Failure.unauthorized();
      await ref
          .read(labelingRepositoryProvider)
          .labelMany(
            transactionIds: selection.ids,
            form: state.form,
            analystId: analyst.id,
            analystName: analyst.fullName,
          );
      if (!ref.mounted) return true;
      state = state.copyWith(saveState: SaveState.saved);
      ref.read(selectedTransactionsProvider(scope).notifier).clear();
      // A-01 shows the new labels when the analyst goes back to it, as after N-02.
      ref
        ..invalidate(transactionsPageProvider)
        ..invalidate(transactionsUnlabeledCountProvider);
      return true;
    } on Failure catch (failure) {
      if (!ref.mounted) return false;
      state = state.copyWith(saveState: SaveState.error, failure: failure);
      return false;
    }
  }
}
