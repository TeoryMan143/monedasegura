import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';

/// Helper or error line below a form field (`bodyS`).
///
/// Errors are never only colour: they take the Error icon and `danger` text.
class FieldMessage extends StatelessWidget {
  const FieldMessage(this.text, {this.isError = false, super.key});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final color = isError ? StatusTone.danger.text : AppColors.textTertiary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isError) ...[
          AppIcon(AppIcons.error, size: AppIconSize.sm, color: color),
          const SizedBox(width: AppSpace.xs),
        ],
        Expanded(
          child: Text(text, style: AppText.bodyS.copyWith(color: color)),
        ),
      ],
    );
  }
}
