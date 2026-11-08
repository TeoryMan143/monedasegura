import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import 'stats_async.dart';

/// A row of three KPI cards of the statistics page, with the states of one statistic
/// (A-07, A-08): a skeleton of three cards while loading, and a panel with the empty or
/// error state.
///
/// [cards] builds exactly three cards from the data.
class KpiRow<T> extends StatelessWidget {
  const KpiRow({
    required this.value,
    required this.onRetry,
    required this.cards,
    this.isEmpty,
    super.key,
  });

  final AsyncValue<T> value;
  final VoidCallback onRetry;
  final List<Widget> Function(T data) cards;
  final bool Function(T data)? isEmpty;

  @override
  Widget build(BuildContext context) {
    final state = ScreenState<T>(
      value: value,
      onRetry: onRetry,
      isEmpty: isEmpty,
      empty: const StatsEmpty(),
      loading: const _KpiSkeletons(),
      builder: (context, data) => _ThreeColumns(children: cards(data)),
    );
    final isLoading = !value.hasValue && !value.hasError;
    final showsCards =
        value.hasValue && !(isEmpty?.call(value.requireValue) ?? false);
    // The cards and their skeleton lay themselves out. An error or the empty state is
    // centred, so it needs a panel and a height.
    if (showsCards || isLoading) return state;
    return AppPanel(
      child: SizedBox(height: statsStateHeight, child: state),
    );
  }
}

class _KpiSkeletons extends StatelessWidget {
  const _KpiSkeletons();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cargando',
      child: const _ThreeColumns(
        children: [_KpiSkeleton(), _KpiSkeleton(), _KpiSkeleton()],
      ),
    );
  }
}

class _KpiSkeleton extends StatelessWidget {
  const _KpiSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 140),
          SizedBox(height: AppSpace.md),
          SkeletonBox(width: 100, height: AppSpace.xxl),
          SizedBox(height: AppSpace.md),
          SkeletonBox(),
        ],
      ),
    );
  }
}

/// Three equal columns with the page's gap between them.
class _ThreeColumns extends StatelessWidget {
  const _ThreeColumns({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, child) in children.indexed) ...[
            if (index > 0) const SizedBox(width: AppLayout.blockGap),
            Expanded(child: child),
          ],
        ],
      ),
    );
  }
}
