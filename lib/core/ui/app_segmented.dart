import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'field_label.dart';
import 'pressable.dart';

/// One option of an [AppSegmented].
@immutable
class AppSegment<T> {
  const AppSegment({
    required this.value,
    required this.label,
    this.icon,
    this.description,
  });

  final T value;
  final String label;
  final AppIcons? icon;

  /// Shown under the control while this option is selected (confidence, severity).
  final String? description;
}

/// Control segmentado (Figma Componentes `4:3`) · exclusive choice between 2–4 visible
/// options: verdict, confidence, severity, chart group-by, timeline zoom.
///
/// `bgSurfaceSubtle` track; the active segment is white with the `card` shadow. Under
/// the control, the selected option's [AppSegment.description] in `bodyS`. With
/// [label] it behaves as a form field (label above, red `*` when [required]).
/// Arrow keys are not needed: each segment is a focusable button (Tab + Enter).
class AppSegmented<T> extends StatelessWidget {
  const AppSegmented({
    required this.segments,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelTrailing,
    this.required = false,
    this.small = false,
    this.expand = true,
    super.key,
  });

  final List<AppSegment<T>> segments;

  /// Selected value; null when nothing is chosen yet.
  final T? value;

  /// Null disables the control.
  final ValueChanged<T>? onChanged;
  final String? label;

  /// Widget at the right end of the label, e.g. a `HelpTip`.
  final Widget? labelTrailing;
  final bool required;

  /// 28 px instead of 36 px, for chart toolbars.
  final bool small;

  /// Segments share the full width; otherwise each one fits its text.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final selected = segments.where((s) => s.value == value).firstOrNull;
    final track = Container(
      height: small ? AppSizes.segmentedS : AppSizes.segmented,
      padding: const EdgeInsets.all(AppSpace.xxs),
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceSubtle,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          for (final segment in segments)
            if (expand)
              Expanded(child: _buildSegment(segment))
            else
              _buildSegment(segment),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: expand
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          FieldLabel(label!, required: required, trailing: labelTrailing),
          const SizedBox(height: AppSpace.xs),
        ],
        Semantics(container: true, label: label, child: track),
        if (selected?.description != null) ...[
          const SizedBox(height: AppSpace.xs),
          Text(
            selected!.description!,
            style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }

  Widget _buildSegment(AppSegment<T> segment) {
    final active = segment.value == value;
    final onChanged = this.onChanged;
    return Pressable(
      onPressed: onChanged == null ? null : () => onChanged(segment.value),
      selected: active,
      semanticLabel: segment.label,
      borderRadius: AppRadius.sm,
      builder: (context, state) {
        final color = !state.enabled
            ? AppColors.textDisabled
            : active
            ? AppColors.textPrimary
            : state.hovered
            ? AppColors.textPrimary
            : AppColors.textSecondary;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.bgSurface : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: active ? AppShadows.card : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (segment.icon != null) ...[
                AppIcon(segment.icon!, size: AppIconSize.sm, color: color),
                const SizedBox(width: AppSpace.xs),
              ],
              Flexible(
                child: Text(
                  segment.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: (active ? AppText.bodyMSemiBold : AppText.bodyMMedium)
                      .copyWith(color: color),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
