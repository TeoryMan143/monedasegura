import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Panel (Figma Componentes `4:3`) · the card container of the app (DESIGN.md · AppPanel).
///
/// `bgSurface`, 1 px `borderDefault`, radius `lg`. With a [title], a header row (`h3`
/// title, optional [subtitle] and right [action]) and a divider sit above the content.
/// Content padding is 20 px; pass [EdgeInsets.zero] for tables and charts that go edge
/// to edge. With [expand] the content fills the remaining height (tables in a page).
class AppPanel extends StatelessWidget {
  const AppPanel({
    required this.child,
    this.title,
    this.subtitle,
    this.action,
    this.padding = const EdgeInsets.all(AppSpace.xl),
    this.expand = false,
    super.key,
  });

  final Widget child;
  final String? title;

  /// What the panel measures, e.g. «Transacciones con veredicto Fraude por semana».
  final String? subtitle;

  /// Right end of the header: a button, a segmented control, a link…
  final Widget? action;
  final EdgeInsetsGeometry padding;

  /// Let [child] fill the remaining height. The panel then needs a bounded height.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border.all(color: AppColors.borderDefault),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.xl,
                AppSpace.lg,
                AppSpace.lg,
                AppSpace.lg,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title!, style: AppText.h3),
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
                  if (action != null) ...[
                    const SizedBox(width: AppSpace.md),
                    action!,
                  ],
                ],
              ),
            ),
            const Divider(),
          ],
          if (expand) Expanded(child: content) else content,
        ],
      ),
    );
  }
}
