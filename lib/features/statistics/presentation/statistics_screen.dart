import 'package:flutter/material.dart';

import '../../../core/ui/placeholder_view.dart';

/// Tabs of the statistics page, as they appear in the route (`/statistics/:tab`).
enum StatisticsTab {
  fraud,
  ai;

  /// The tab for a route segment, falling back to [fraud] for unknown values.
  static StatisticsTab fromPath(String? value) =>
      values.asNameMap()[value] ?? fraud;
}

/// A-07 / A-08 · Statistics (HU-13).
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({required this.tab, super.key});

  final StatisticsTab tab;

  @override
  Widget build(BuildContext context) =>
      const PlaceholderView(title: 'Estadísticas', story: 'HU-13');
}
