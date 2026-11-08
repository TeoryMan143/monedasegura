import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import '../../audit/presentation/label_history_dialog.dart';
import 'controllers/classification_controller.dart';
import 'widgets/classification_summary.dart';
import 'widgets/label_form_fields.dart';

/// N-02 · Classification side panel (HU-04): the transaction, its AI alert and its label
/// form, with live validation and the save.
///
/// The customer view (A-02) embeds it over its table. [onClose] is the ×, [onNext]
/// moves to the next transaction («Siguiente») and [onSaved] lets the caller refresh its
/// own data after a save. «Ver historial» opens the label history (N-03, HU-15).
///
/// A failed save (E-03) shows inside the panel with «Reintentar» and keeps the form.
class ClassificationPanel extends ConsumerStatefulWidget {
  const ClassificationPanel({
    required this.transactionId,
    required this.onClose,
    this.onNext,
    this.onSaved,
    super.key,
  });

  final int transactionId;
  final VoidCallback onClose;
  final VoidCallback? onNext;
  final VoidCallback? onSaved;

  @override
  ConsumerState<ClassificationPanel> createState() =>
      _ClassificationPanelState();
}

class _ClassificationPanelState extends ConsumerState<ClassificationPanel> {
  Future<void> _save() async {
    final provider = classificationProvider(widget.transactionId);
    final wasLabeled = ref.read(provider).value?.target.label != null;
    final saved = await ref.read(provider.notifier).save();
    if (!saved || !mounted) return;
    showAppToast(
      context,
      title: wasLabeled ? 'Etiqueta actualizada' : 'Etiqueta guardada',
      type: AppToastType.success,
    );
    widget.onSaved?.call();
  }

  @override
  Widget build(BuildContext context) {
    final provider = classificationProvider(widget.transactionId);
    final value = ref.watch(provider);
    final state = value.value;

    return SidePanel(
      title: 'Clasificar transacción',
      subtitle: state?.target.code,
      onClose: widget.onClose,
      body: ScreenState(
        value: value,
        onRetry: () => ref.invalidate(provider),
        errorTitle: 'No se pudo abrir la transacción',
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClassificationSummary(
              target: state.target,
              onOpenHistory: () => showLabelHistoryDialog(
                context: context,
                transactionId: widget.transactionId,
                transactionCode: state.target.code,
              ),
            ),
            const SizedBox(height: AppSpace.xl),
            LabelFormFields(
              form: state.form,
              errors: state.visibleErrors,
              enabled: !state.isSaving,
              onChanged: ref.read(provider.notifier).change,
            ),
            if (state.failure case final failure?) ...[
              const SizedBox(height: AppSpace.lg),
              InlineBanner(
                title: 'No se guardó la etiqueta',
                message: '${_failureText(failure)} Tus datos siguen aquí.',
                tone: StatusTone.danger,
                icon: AppIcons.error,
                action: AppButton(
                  label: 'Reintentar',
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.s,
                  onPressed: state.isSaving ? null : _save,
                ),
              ),
            ],
          ],
        ),
      ),
      footer: state == null
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (state.saveState != SaveState.idle) ...[
                  SaveStatus(state: state.saveState, onRetry: _save),
                  const SizedBox(height: AppSpace.sm),
                ],
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Siguiente',
                        variant: AppButtonVariant.secondary,
                        expand: true,
                        onPressed: state.isSaving ? null : widget.onNext,
                      ),
                    ),
                    const SizedBox(width: AppSpace.sm),
                    Expanded(
                      flex: 2,
                      child: AppButton(
                        label: state.target.label == null
                            ? 'Guardar etiqueta'
                            : 'Actualizar etiqueta',
                        expand: true,
                        loading: state.isSaving,
                        onPressed: state.isSaving ? null : _save,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

String _failureText(Failure failure) => switch (failure) {
  NetworkFailure() => 'No hay conexión.',
  UnauthorizedFailure() => 'Tu sesión terminó.',
  ForbiddenFailure() => 'No tienes permiso para etiquetar esta transacción.',
  ValidationFailure() => 'La base rechazó la etiqueta: revisa los campos.',
  _ => 'Ocurrió un error al guardar.',
};
