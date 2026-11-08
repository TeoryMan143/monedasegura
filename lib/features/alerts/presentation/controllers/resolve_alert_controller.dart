import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/catalogs/catalog_providers.dart';
import '../../../../core/domain/catalog_models.dart';
import '../../../../core/domain/fraud_type.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/ui/save_status.dart';
import '../../../labeling/domain/label_form.dart';
import '../../../transactions/presentation/controllers/transactions_page_controller.dart';
import '../../domain/alert_detail.dart';
import '../../domain/resolve_alert_input.dart';
import '../../domain/resolve_validator.dart';
import 'alerts_providers.dart';

part 'resolve_alert_controller.freezed.dart';

@freezed
abstract class ResolveAlertState with _$ResolveAlertState {
  const factory ResolveAlertState({
    @Default(ResolveAlertAction.confirm) ResolveAlertAction action,

    @Default(LabelForm()) LabelForm form,

    @Default(<int>{}) Set<int> excludedTransactionIds,

    @Default(<LabelField>{}) Set<LabelField> touched,

    @Default(false) bool submitted,
    @Default(SaveState.idle) SaveState saveState,

    Failure? failure,
  }) = _ResolveAlertState;

  const ResolveAlertState._();

  bool get isSaving => saveState == SaveState.saving;

  int selectedCount(int total) => total - excludedTransactionIds.length;

  Map<LabelField, String> errors(FraudType suggested) =>
      validateResolution(action: action, form: form, suggested: suggested);

  Map<LabelField, String> visibleErrors(FraudType suggested) {
    final all = errors(suggested);
    return {
      for (final MapEntry(:key, :value) in all.entries)
        if (submitted || touched.contains(key)) key: value,
    };
  }

  String? transactionsError(int total) =>
      submitted ? validateTransactionSelection(selectedCount(total)) : null;

  bool canResolve(AlertDetail detail) =>
      errors(detail.alert.suggestedType).isEmpty &&
      validateTransactionSelection(selectedCount(detail.transactions.length)) ==
          null;
}

final resolveAlertControllerProvider = NotifierProvider.autoDispose
    .family<ResolveAlertController, ResolveAlertState, String>(
      ResolveAlertController.new,
      name: 'resolveAlertControllerProvider',
    );

class ResolveAlertController extends Notifier<ResolveAlertState> {
  ResolveAlertController(this.alertId);

  final String alertId;

  @override
  ResolveAlertState build() => const ResolveAlertState();

  void setAction(ResolveAlertAction action) {
    if (state.isSaving) return;
    state = state.copyWith(action: action, saveState: _unsaved());
  }

  void change(LabelForm form, LabelField field) {
    if (state.isSaving) return;
    state = state.copyWith(
      form: form,
      touched: {...state.touched, field},
      saveState: _unsaved(),
    );
  }

  void toggleTransaction(int transactionId) {
    if (state.isSaving) return;
    final excluded = {...state.excludedTransactionIds};
    if (!excluded.remove(transactionId)) excluded.add(transactionId);
    state = state.copyWith(
      excludedTransactionIds: excluded,
      saveState: _unsaved(),
    );
  }

  SaveState _unsaved() =>
      state.saveState == SaveState.error ? SaveState.error : SaveState.idle;

  Future<bool> submit() async {
    if (state.isSaving) return false;
    state = state.copyWith(submitted: true, failure: null);
    try {
      final detail = await ref.read(alertDetailProvider(alertId).future);
      if (!ref.mounted) return false;
      if (!state.canResolve(detail)) return false;

      state = state.copyWith(saveState: SaveState.saving);
      final fraudTypes = await ref.read(fraudTypesProvider.future);
      await ref.read(resolveAlertProvider)(_input(detail, fraudTypes));
      if (!ref.mounted) return true;

      state = state.copyWith(saveState: SaveState.saved);
      ref
        ..invalidate(transactionsPageProvider)
        ..invalidate(transactionsUnlabeledCountProvider);
      return true;
    } on Failure catch (failure) {
      if (!ref.mounted) return false;
      state = state.copyWith(saveState: SaveState.error, failure: failure);
      if (failure is ConflictFailure) {
        ref
          ..invalidate(alertDetailProvider(alertId))
          ..invalidate(alertsPageProvider);
      }
      return false;
    }
  }

  ResolveAlertInput _input(
    AlertDetail detail,
    List<CatalogFraudType> fraudTypes,
  ) {
    final label = resolutionLabel(
      action: state.action,
      form: state.form,
      suggested: detail.alert.suggestedType,
    );
    final justification = state.form.justification.trim();
    return ResolveAlertInput(
      alertId: alertId,
      action: state.action,
      finalTypeId: _typeId(label.fraudTypes.firstOrNull, fraudTypes),
      confidence: label.confidence,
      severity: label.severity,
      justification: justification.isEmpty ? null : justification,
      excludedTransactionIds: state.excludedTransactionIds.toList()..sort(),
    );
  }

  int? _typeId(FraudType? type, List<CatalogFraudType> fraudTypes) {
    if (type == null) return null;
    return fraudTypes.where((row) => row.code == type.dbValue).firstOrNull?.id;
  }
}
