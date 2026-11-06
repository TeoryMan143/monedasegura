import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';
import 'empty_state.dart';
import 'error_state.dart';
import 'skeleton_box.dart';

/// Estados de pantalla (Figma Componentes `4:3`) · renders an [AsyncValue] as loading,
/// empty, error or data (AGENTS.md rule 5).
///
/// - **Loading:** [loading], a skeleton shaped like the content (`SkeletonRow`s for
///   tables). Without it, a generic block skeleton. While a provider refreshes and still
///   has data, the data stays on screen.
/// - **Empty:** when [isEmpty] returns true, [empty] (an `EmptyState`, or
///   `EmptyState.noResults` when filters are active).
/// - **Error:** an `ErrorState` with the text for the `Failure` and «Reintentar» when
///   [onRetry] is set (usually `() => ref.invalidate(provider)`).
/// - **Data:** [builder].
///
/// ```dart
/// ScreenState<CustomerView>(
///   value: ref.watch(customerViewProvider(id)),
///   onRetry: () => ref.invalidate(customerViewProvider(id)),
///   builder: (context, view) => CustomerHeader(view: view),
/// )
/// ```
class ScreenState<T> extends StatelessWidget {
  const ScreenState({
    required this.value,
    required this.builder,
    this.loading,
    this.isEmpty,
    this.empty,
    this.onRetry,
    this.errorTitle,
    this.errorMessage,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) builder;
  final Widget? loading;
  final bool Function(T data)? isEmpty;
  final Widget? empty;
  final VoidCallback? onRetry;

  /// Overrides the default error title for this screen.
  final String? errorTitle;

  /// Overrides the default error explanation for this screen.
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value.hasError && !value.isLoading) {
      return ErrorState(
        error: value.error!,
        onRetry: onRetry,
        title: errorTitle,
        message: errorMessage,
      );
    }
    if (value.hasValue) {
      final data = value.requireValue;
      if (isEmpty?.call(data) ?? false) {
        return empty ?? const EmptyState(title: 'No hay nada por aquí');
      }
      return builder(context, data);
    }
    return loading ?? const _DefaultSkeleton();
  }
}

class _DefaultSkeleton extends StatelessWidget {
  const _DefaultSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cargando',
      child: const Padding(
        padding: EdgeInsets.all(AppSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 240, height: AppSpace.xxl),
            SizedBox(height: AppSpace.lg),
            SkeletonBox(),
            SizedBox(height: AppSpace.sm),
            SkeletonBox(),
            SizedBox(height: AppSpace.sm),
            SkeletonBox(width: 320),
          ],
        ),
      ),
    );
  }
}
