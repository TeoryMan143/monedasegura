import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'app_button.dart';
import 'app_icon.dart';
import 'failure_message.dart';

/// Estados de pantalla · error: what went wrong and a «Reintentar» button.
///
/// The text comes from [failureMessage] unless [title] / [message] are given.
class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.error,
    this.onRetry,
    this.title,
    this.message,
    super.key,
  });

  /// Usually a `Failure` thrown by a repository.
  final Object error;
  final VoidCallback? onRetry;
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = failureMessage(error);
    const tone = StatusTone.danger;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.dialogM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSpace.x5l,
              height: AppSpace.x5l,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tone.background,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: AppIcon(AppIcons.error, color: tone.text),
            ),
            const SizedBox(height: AppSpace.lg),
            Text(
              title ?? text.title,
              style: AppText.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpace.xs),
            Text(
              message ?? text.message,
              textAlign: TextAlign.center,
              style: AppText.bodyL.copyWith(color: AppColors.textSecondary),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpace.lg),
              AppButton(
                label: 'Reintentar',
                icon: AppIcons.refresh,
                onPressed: onRetry,
                variant: AppButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
