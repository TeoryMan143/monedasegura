import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import 'app_icon_button.dart';

/// Width of an [AppDialog].
enum AppDialogSize {
  /// 560 px: confirmations and short forms.
  m(AppLayout.dialogM),

  /// 800 px: larger forms (A-03, A-06, C-14).
  l(AppLayout.dialogL);

  const AppDialogSize(this.width);

  final double width;
}

/// Opens [builder] (usually an [AppDialog]) centred on `bgOverlay`.
///
/// Esc or a click outside closes it (unless [barrierDismissible] is false). Overlays are
/// not routes (ARCHITECTURAL_SPINE.md · Navigation): call this from the screen.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    builder: builder,
    barrierDismissible: barrierDismissible,
    barrierColor: AppColors.bgOverlay,
    barrierLabel: 'Cerrar',
  );
}

/// Modal (Figma Componentes `4:3`) · header (title + close) → scrollable body → footer
/// with the secondary action left of the primary (DESIGN.md · Dialogs).
///
/// Radius `xl`, `modal` shadow, M 560 / L 800 px. [onSubmit] runs on Enter, which
/// should be the same callback as the primary action.
///
/// ```dart
/// showAppDialog<void>(
///   context: context,
///   builder: (context) => AppDialog(
///     title: 'Exportar reporte a PDF',
///     body: const ExportOptions(),
///     actions: [
///       AppButton(label: 'Cancelar', variant: AppButtonVariant.secondary,
///           onPressed: () => Navigator.pop(context)),
///       AppButton(label: 'Exportar', onPressed: export),
///     ],
///     onSubmit: export,
///   ),
/// );
/// ```
class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    required this.body,
    this.subtitle,
    this.actions = const [],
    this.footerLeading,
    this.size = AppDialogSize.m,
    this.onSubmit,
    this.onClose,
    this.bodyPadding = const EdgeInsets.all(AppSpace.xxl),
    super.key,
  });

  final String title;

  /// Short line under the title, e.g. an id.
  final String? subtitle;
  final Widget body;

  /// Footer buttons in order: secondary first, primary last.
  final List<Widget> actions;

  /// Content at the left of the footer, e.g. a summary or a `SaveStatus`.
  final Widget? footerLeading;
  final AppDialogSize size;

  /// Run on Enter.
  final VoidCallback? onSubmit;

  /// Close button and Esc. Defaults to popping the dialog.
  final VoidCallback? onClose;
  final EdgeInsetsGeometry bodyPadding;

  @override
  Widget build(BuildContext context) {
    final VoidCallback close =
        onClose ?? () => Navigator.of(context).maybePop();
    final submit = onSubmit;
    final dialog = Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(AppSpace.x3l),
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.modal,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.xxl,
                  AppSpace.xl,
                  AppSpace.lg,
                  AppSpace.lg,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(title, style: AppText.h3),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: AppText.bodyS.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    AppIconButton(
                      icon: AppIcons.close,
                      tooltip: 'Cerrar',
                      onPressed: close,
                    ),
                  ],
                ),
              ),
              const Divider(),
              Flexible(
                child: SingleChildScrollView(padding: bodyPadding, child: body),
              ),
              if (actions.isNotEmpty || footerLeading != null) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.xxl,
                    vertical: AppSpace.lg,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: footerLeading ?? const SizedBox.shrink()),
                      for (final (index, action) in actions.indexed) ...[
                        if (index > 0) const SizedBox(width: AppSpace.sm),
                        action,
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): close,
        const SingleActivator(LogicalKeyboardKey.enter): ?submit,
        const SingleActivator(LogicalKeyboardKey.numpadEnter): ?submit,
      },
      child: FocusScope(autofocus: true, child: dialog),
    );
  }
}
