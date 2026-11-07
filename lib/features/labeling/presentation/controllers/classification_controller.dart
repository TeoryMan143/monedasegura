import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/confidence_level.dart';
import '../../../../core/domain/fraud_type.dart';
import '../../../../core/domain/severity.dart';
import '../../../../core/domain/verdict.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/ui/save_status.dart';
import '../../../auth/presentation/controllers/session_controller.dart';
import '../../../transactions/presentation/controllers/transactions_page_controller.dart';
import '../../data/labeling_repository.dart';
import '../../domain/classification_target.dart';
import '../../domain/label_form.dart';
import '../../domain/label_validator.dart';

part 'classification_controller.freezed.dart';

/// What the N-02 panel shows and edits for one transaction (HU-04).
@freezed
abstract class ClassificationState with _$ClassificationState {
  const factory ClassificationState({
    required ClassificationTarget target,
    required LabelForm form,

    /// Fields the analyst changed: only those show their error before saving.
    @Default(<LabelField>{}) Set<LabelField> touched,

    /// True after the first «Guardar»: from then on every error shows.
    @Default(false) bool submitted,
    @Default(SaveState.idle) SaveState saveState,

    /// Why the last save failed (E-03). The form keeps its data.
    Failure? failure,
  }) = _ClassificationState;

  const ClassificationState._();

  /// Every broken rule of [form], from `validateLabel`.
  Map<LabelField, String> get errors => validateLabel(form);

  /// The errors to show now: all of them after a save attempt, otherwise only the
  /// ones of fields the analyst touched.
  Map<LabelField, String> get visibleErrors => {
    for (final MapEntry(:key, :value) in errors.entries)
      if (submitted || touched.contains(key)) key: value,
  };

  bool get isSaving => saveState == SaveState.saving;
}

/// The classification of one transaction: its data, the form and the save (HU-04).
final classificationProvider = AsyncNotifierProvider.autoDispose
    .family<ClassificationController, ClassificationState, int>(
      ClassificationController.new,
      name: 'classificationProvider',
    );

class ClassificationController extends AsyncNotifier<ClassificationState> {
  ClassificationController(this.transactionId);

  final int transactionId;

  @override
  Future<ClassificationState> build() async {
    final target = await ref
        .watch(labelingRepositoryProvider)
        .fetchTarget(transactionId);
    return ClassificationState(
      target: target,
      form: target.label?.toForm() ?? const LabelForm(),
    );
  }

  /// No fraude takes no types and no severity, so choosing it clears them.
  void setVerdict(Verdict verdict) => _edit(
    LabelField.verdict,
    (form) => verdict == Verdict.notFraud
        ? form.copyWith(verdict: verdict, fraudTypes: const [], severity: null)
        : form.copyWith(verdict: verdict),
  );

  void toggleFraudType(FraudType type) => _edit(LabelField.fraudTypes, (form) {
    final types = [...form.fraudTypes];
    types.contains(type) ? types.remove(type) : types.add(type);
    return form.copyWith(fraudTypes: types);
  });

  void setConfidence(ConfidenceLevel confidence) => _edit(
    LabelField.confidence,
    (form) => form.copyWith(confidence: confidence),
  );

  void setSeverity(Severity severity) =>
      _edit(LabelField.severity, (form) => form.copyWith(severity: severity));

  void setJustification(String text) => _edit(
    LabelField.justification,
    (form) => form.copyWith(justification: text),
  );

  /// Saves the label. Returns true when it was saved.
  ///
  /// With errors it only shows them. On a failure (E-03) the form keeps its data and
  /// [ClassificationState.failure] says why, so «Reintentar» calls this again.
  Future<bool> save() async {
    final current = state.value;
    if (current == null || current.isSaving) return false;
    if (current.errors.isNotEmpty) {
      state = AsyncData(current.copyWith(submitted: true));
      return false;
    }
    state = AsyncData(
      current.copyWith(
        submitted: true,
        saveState: SaveState.saving,
        failure: null,
      ),
    );
    try {
      final analyst = ref.read(sessionProvider);
      if (analyst == null) throw const Failure.unauthorized();
      final saved = await ref
          .read(labelingRepositoryProvider)
          .saveLabel(
            transactionId: transactionId,
            form: current.form,
            analystId: analyst.id,
            analystName: analyst.fullName,
          );
      if (!ref.mounted) return true;
      final latest = state.requireValue;
      state = AsyncData(
        latest.copyWith(
          target: latest.target.copyWith(label: saved),
          saveState: SaveState.saved,
        ),
      );
      // The A-01 list shows the new label when the analyst goes back.
      ref
        ..invalidate(transactionsPageProvider)
        ..invalidate(transactionsUnlabeledCountProvider);
      return true;
    } on Failure catch (failure) {
      if (!ref.mounted) return false;
      state = AsyncData(
        state.requireValue.copyWith(
          saveState: SaveState.error,
          failure: failure,
        ),
      );
      return false;
    }
  }

  void _edit(LabelField field, LabelForm Function(LabelForm) update) {
    final current = state.value;
    if (current == null || current.isSaving) return;
    state = AsyncData(
      current.copyWith(
        form: update(current.form),
        touched: {...current.touched, field},
        // A change after «Guardado» is unsaved again; an error stays until the retry.
        saveState: current.saveState == SaveState.error
            ? SaveState.error
            : SaveState.idle,
      ),
    );
  }
}
