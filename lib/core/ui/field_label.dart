import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';

/// Label above a form field (`bodyMSemiBold`), with a red `*` when [required].
///
/// Used by [AppTextField], `AppTextArea`, `AppDropdown` and the segmented fields.
class FieldLabel extends StatelessWidget {
  const FieldLabel(
    this.text, {
    this.required = false,
    this.trailing,
    super.key,
  });

  final String text;
  final bool required;

  /// Optional widget at the right end, e.g. a help tooltip.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text.rich(
            TextSpan(
              text: text,
              children: [
                if (required)
                  TextSpan(
                    text: ' *',
                    style: AppText.bodyMSemiBold.copyWith(
                      color: AppColors.rojo500,
                    ),
                  ),
              ],
            ),
            style: AppText.bodyMSemiBold,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpace.xs),
          trailing!,
        ],
      ],
    );
  }
}
