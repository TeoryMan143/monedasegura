import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/kit.dart';
import '../controllers/statistics_providers.dart';

/// Height of the loading, empty and error states inside a statistics panel.
const statsStateHeight = 240.0;

/// One statistic through [ScreenState] (AGENTS.md rule 5): every panel has its own, so a
/// failure in one view leaves the others on screen.
///
/// The loading, empty and error states are centred in a box of [stateHeight], because they
/// need a bounded height. The data is laid out as [builder] says.
class StatsAsync<T> extends StatelessWidget {
  const StatsAsync({
    required this.value,
    required this.onRetry,
    required this.loading,
    required this.builder,
    this.isEmpty,
    this.empty,
    this.stateHeight = statsStateHeight,
    super.key,
  });

  final AsyncValue<T> value;
  final VoidCallback onRetry;

  /// Skeleton shaped like the data.
  final Widget loading;
  final Widget Function(BuildContext context, T data) builder;
  final bool Function(T data)? isEmpty;

  /// Replaces the default «Sin datos en este rango» ([StatsEmpty]).
  final Widget? empty;
  final double stateHeight;

  @override
  Widget build(BuildContext context) {
    final showsData =
        value.hasValue && !(isEmpty?.call(value.requireValue) ?? false);
    final screenState = ScreenState<T>(
      value: value,
      onRetry: onRetry,
      isEmpty: isEmpty,
      empty: empty ?? const StatsEmpty(),
      loading: loading,
      builder: builder,
    );
    return showsData
        ? screenState
        : SizedBox(height: stateHeight, child: screenState);
  }
}

/// «Sin datos en este rango», with «Limpiar filtros» when there are filters to clear.
class StatsEmpty extends ConsumerWidget {
  const StatsEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasFilters = ref.watch(statisticsFilterProvider).hasFilters;
    return EmptyState.noResults(
      title: 'Sin datos en este rango',
      message: 'No hay información con los filtros actuales.',
      onClearFilters: hasFilters
          ? ref.read(statisticsFilterProvider.notifier).reset
          : null,
    );
  }
}
