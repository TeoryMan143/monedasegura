import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import 'app_icon_button.dart';

/// Slides [builder] (usually a [SidePanel]) in from the right over the content, which is
/// dimmed with `bgOverlay` (DESIGN.md · Side panel).
///
/// Esc or a click on the dimmed area closes it. Returns the value passed to
/// `Navigator.pop`.
Future<T?> showSidePanel<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double width = AppLayout.sidePanelWidth,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Cerrar panel',
    barrierColor: AppColors.bgOverlay,
    transitionDuration: const Duration(milliseconds: 220),
    // Not dismissible: the dimmed area takes the click silently, instead of the barrier
    // playing the system alert (the Windows «ding»).
    pageBuilder: (context, animation, secondaryAnimation) => Listener(
      behavior: barrierDismissible
          ? HitTestBehavior.deferToChild
          : HitTestBehavior.opaque,
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: width,
          height: double.infinity,
          child: Builder(builder: builder),
        ),
      ),
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
  );
}

/// Panel lateral (N-02 pattern) · ~400 px panel: header with `h3` title, id and close;
/// scrollable body; sticky footer with the actions.
///
/// Works both inside [showSidePanel] and embedded in a screen's `Stack` (when the panel
/// is driven by the URL, e.g. `?tx=`). Closes with ×, Esc, after saving or «Siguiente»:
/// the caller decides by passing [onClose].
class SidePanel extends StatelessWidget {
  const SidePanel({
    required this.title,
    required this.body,
    this.subtitle,
    this.footer,
    this.scrollBody = true,
    this.headerTrailing,
    this.onClose,
    super.key,
  });

  final String title;

  /// The id under the title, e.g. «TX-77120».
  final String? subtitle;
  final Widget body;

  /// Sticky actions at the bottom, e.g. «Siguiente» + «Guardar etiqueta».
  final Widget? footer;

  /// True (default): the body scrolls when it is taller than the panel. False: the body
  /// gets the panel's height as a bound and must fit it by itself (e.g. scaling down).
  final bool scrollBody;

  /// Extra content before the close button (a status badge…).
  final Widget? headerTrailing;

  /// Close button and Esc. Defaults to popping the route.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final VoidCallback close =
        onClose ?? () => Navigator.of(context).maybePop();
    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): close},
      child: FocusScope(
        autofocus: true,
        child: Material(
          color: AppColors.bgSurface,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.bgSurface,
              boxShadow: AppShadows.modal,
              border: Border(left: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpace.xl,
                    AppSpace.lg,
                    AppSpace.md,
                    AppSpace.lg,
                  ),
                  child: Row(
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
                      if (headerTrailing != null) ...[
                        headerTrailing!,
                        const SizedBox(width: AppSpace.sm),
                      ],
                      AppIconButton(
                        icon: AppIcons.close,
                        tooltip: 'Cerrar panel',
                        onPressed: close,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: scrollBody
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.all(AppSpace.xl),
                          child: body,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(AppSpace.xl),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: body,
                          ),
                        ),
                ),
                if (footer != null) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpace.xl,
                      vertical: AppSpace.lg,
                    ),
                    child: footer,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
