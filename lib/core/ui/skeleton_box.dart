import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';

/// A grey placeholder block shaped like the content it replaces while loading.
///
/// `bgSurfaceSubtle`, radius `sm`. Build loading layouts from these (never a spinner over
/// an empty area). It is static on purpose, so widget tests can `pumpAndSettle`.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    this.width,
    this.height = AppSizes.skeletonLine,
    this.radius = AppRadius.sm,
    super.key,
  });

  /// Null takes the parent's width.
  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceSubtle,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
