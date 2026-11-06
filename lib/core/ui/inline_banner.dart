import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'app_icon_button.dart';

/// Aviso en línea (Figma Componentes `4:3`) · persistent full-width notice in the content.
///
/// Tone background and border, icon, bold first line ([title]) and an explanation.
/// Examples: «TX-77120 ya tiene una etiqueta…», impossible travel, an alert resolved by
/// another analyst, invalid credentials on the login (C-02).
class InlineBanner extends StatelessWidget {
  const InlineBanner({
    required this.title,
    required this.tone,
    this.message,
    this.icon,
    this.action,
    this.onClose,
    super.key,
  });

  final String title;
  final StatusTone tone;
  final String? message;

  /// Defaults to the tone's usual icon (Error, Advertencia, Check, IA, Info).
  final AppIcons? icon;

  /// A button or link under the text, e.g. «Ver historial».
  final Widget? action;

  /// Shows a close button.
  final VoidCallback? onClose;

  AppIcons get _defaultIcon => switch (tone) {
    StatusTone.danger => AppIcons.error,
    StatusTone.warning || StatusTone.high => AppIcons.warning,
    StatusTone.success => AppIcons.check,
    StatusTone.info => AppIcons.ai,
    StatusTone.neutral || StatusTone.brand => AppIcons.info,
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: tone == StatusTone.danger,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpace.md),
        decoration: BoxDecoration(
          color: tone.background,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: tone.solid.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.xxs),
              child: AppIcon(
                icon ?? _defaultIcon,
                size: AppIconSize.md,
                color: tone.text,
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.bodyMSemiBold.copyWith(color: tone.text),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: AppSpace.xxs),
                    Text(
                      message!,
                      style: AppText.bodyS.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (action != null) ...[
                    const SizedBox(height: AppSpace.sm),
                    action!,
                  ],
                ],
              ),
            ),
            if (onClose != null) ...[
              const SizedBox(width: AppSpace.sm),
              AppIconButton(
                icon: AppIcons.close,
                tooltip: 'Cerrar aviso',
                small: true,
                onPressed: onClose,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
