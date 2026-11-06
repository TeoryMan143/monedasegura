import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/ui/kit.dart';

/// Gallery panel that opens the overlays: dialogs M and L, the side panel and toasts.
class KitGalleryOverlaysSection extends StatelessWidget {
  const KitGalleryOverlaysSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      title: 'Ventanas emergentes',
      subtitle: 'showAppDialog · showSidePanel · showAppToast',
      child: Wrap(
        spacing: AppSpace.md,
        runSpacing: AppSpace.md,
        children: [
          AppButton(
            label: 'Diálogo M',
            variant: AppButtonVariant.secondary,
            onPressed: () => _openDialog(context, AppDialogSize.m),
          ),
          AppButton(
            label: 'Diálogo L',
            variant: AppButtonVariant.secondary,
            onPressed: () => _openDialog(context, AppDialogSize.l),
          ),
          AppButton(
            label: 'Panel lateral',
            icon: AppIcons.sidePanel,
            variant: AppButtonVariant.secondary,
            onPressed: () => _openPanel(context),
          ),
          for (final type in AppToastType.values)
            AppButton(
              label: 'Toast ${type.name}',
              variant: AppButtonVariant.tertiary,
              onPressed: () => showAppToast(
                context,
                type: type,
                title: switch (type) {
                  AppToastType.success => 'Etiqueta guardada',
                  AppToastType.error => 'No se pudo guardar',
                  AppToastType.info => 'Filtros aplicados',
                  AppToastType.warning => 'Conexión inestable',
                  AppToastType.aiAlert => 'Nueva alerta AL-1042',
                },
                message: type == AppToastType.aiAlert
                    ? 'Juan Pérez · Robo de cuenta'
                    : 'TX-77120',
                score: type == AppToastType.aiAlert ? 92 : null,
                actionLabel: type == AppToastType.aiAlert ? 'Abrir' : null,
                onAction: type == AppToastType.aiAlert ? () {} : null,
              ),
            ),
        ],
      ),
    );
  }

  void _openDialog(BuildContext context, AppDialogSize size) {
    showAppDialog<void>(
      context: context,
      builder: (dialogContext) {
        void close() => Navigator.of(dialogContext).pop();
        return AppDialog(
          title: size == AppDialogSize.m
              ? 'Resolver alerta'
              : 'Clasificar 3 transacciones',
          subtitle: 'AL-1042',
          size: size,
          onSubmit: close,
          footerLeading: const SaveStatus(state: SaveState.idle),
          body: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InlineBanner(
                tone: StatusTone.warning,
                title: 'Se modificarán 3 transacciones',
                message: '1 ya tenía etiqueta.',
              ),
              SizedBox(height: AppSpace.lg),
              AppTextArea(label: 'Justificación', required: true),
            ],
          ),
          actions: [
            AppButton(
              label: 'Cancelar',
              variant: AppButtonVariant.secondary,
              onPressed: close,
            ),
            AppButton(label: 'Confirmar', onPressed: close),
          ],
        );
      },
    );
  }

  void _openPanel(BuildContext context) {
    showSidePanel<void>(
      context: context,
      builder: (panelContext) => SidePanel(
        title: 'Clasificar transacción',
        subtitle: 'TX-77120',
        headerTrailing: const StatusBadge(
          label: 'Sin etiquetar',
          tone: StatusTone.neutral,
          icon: AppIcons.clock,
        ),
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InlineBanner(
              tone: StatusTone.info,
              title: 'Alerta de IA · score 92',
              message: 'Sugiere ATO · Robo de cuenta.',
            ),
            SizedBox(height: AppSpace.lg),
            AppTextArea(label: 'Justificación'),
          ],
        ),
        footer: Row(
          children: [
            AppButton(
              label: 'Siguiente',
              variant: AppButtonVariant.secondary,
              onPressed: () => Navigator.of(panelContext).pop(),
            ),
            const Spacer(),
            AppButton(
              label: 'Guardar etiqueta',
              onPressed: () => Navigator.of(panelContext).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
