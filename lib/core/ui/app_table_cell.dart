import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';

/// Two-line table cell: value on top, meta below (DESIGN.md · Tables).
///
/// Examples: date / time, customer / masked account · country, type / channel,
/// amount / currency. [numeric] uses `tableData` (tabular figures) and right alignment;
/// [valueColor] colours the value, e.g. credits in the success text tone. [leadingIcon]
/// goes before the value, e.g. the IA sparkle on rows with an alert.
class AppTableCell extends StatelessWidget {
  const AppTableCell({
    required this.value,
    this.meta,
    this.numeric = false,
    this.valueColor,
    this.leadingIcon,
    this.leadingIconColor,
    super.key,
  });

  final String value;
  final String? meta;
  final bool numeric;
  final Color? valueColor;
  final AppIcons? leadingIcon;
  final Color? leadingIconColor;

  @override
  Widget build(BuildContext context) {
    final align = numeric ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final valueText = Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: numeric ? TextAlign.right : TextAlign.left,
      style: (numeric ? AppText.tableData : AppText.bodyMMedium).copyWith(
        color: valueColor ?? AppColors.textPrimary,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: align,
      children: [
        if (leadingIcon == null)
          valueText
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                leadingIcon!,
                size: AppIconSize.sm,
                color: leadingIconColor ?? StatusTone.info.text,
              ),
              const SizedBox(width: AppSpace.xs),
              Flexible(child: valueText),
            ],
          ),
        if (meta != null)
          Text(
            meta!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: numeric ? TextAlign.right : TextAlign.left,
            style: AppText.bodyS.copyWith(color: AppColors.textTertiary),
          ),
      ],
    );
  }
}
