import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Temporary page body for screens that are not built yet.
///
/// Delete it once every screen in the story map exists.
class PlaceholderView extends StatelessWidget {
  const PlaceholderView({required this.title, required this.story, super.key});

  /// Page title, as it will appear in the finished screen.
  final String title;

  /// Story code the screen belongs to, e.g. `HU-02`.
  final String story;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppLayout.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.h1),
          const SizedBox(height: AppSpace.xs),
          Text(
            'Pantalla en construcción · $story',
            style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
