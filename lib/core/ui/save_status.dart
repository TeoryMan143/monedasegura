import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'pressable.dart';

/// State shown by [SaveStatus].
enum SaveState { idle, saving, saved, error }

/// «Guardando…» / «Guardado» / «Error · Reintentar» next to the panel actions (N-02, E-03).
///
/// Icon + text + colour for each state; nothing while [state] is idle.
class SaveStatus extends StatelessWidget {
  const SaveStatus({required this.state, this.onRetry, super.key});

  final SaveState state;

  /// «Reintentar» link in the error state.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: switch (state) {
        SaveState.idle => const SizedBox.shrink(),
        SaveState.saving => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox.square(
              dimension: AppIconSize.sm,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.iconSecondary,
              ),
            ),
            const SizedBox(width: AppSpace.xs),
            Text(
              'Guardando…',
              style: AppText.bodyS.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
        SaveState.saved => _Line(
          icon: AppIcons.check,
          text: 'Guardado',
          color: StatusTone.success.text,
        ),
        SaveState.error => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Line(
              icon: AppIcons.error,
              text: onRetry == null ? 'Error al guardar' : 'Error ·',
              color: StatusTone.danger.text,
            ),
            if (onRetry != null) ...[
              const SizedBox(width: AppSpace.xs),
              Pressable(
                onPressed: onRetry,
                semanticLabel: 'Reintentar guardar',
                borderRadius: AppRadius.sm,
                builder: (context, s) => Text(
                  'Reintentar',
                  style: AppText.bodySSemiBold.copyWith(
                    color: AppColors.textLink,
                    decoration: s.hovered ? TextDecoration.underline : null,
                    decorationColor: AppColors.textLink,
                  ),
                ),
              ),
            ],
          ],
        ),
      },
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text, required this.color});

  final AppIcons icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon(icon, size: AppIconSize.sm, color: color),
        const SizedBox(width: AppSpace.xs),
        Text(text, style: AppText.bodySSemiBold.copyWith(color: color)),
      ],
    );
  }
}
