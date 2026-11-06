import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/ui/kit.dart';

import '../../helpers/kit_harness.dart';

Widget _state(AsyncValue<List<int>> value, {VoidCallback? onRetry}) {
  return ScreenState<List<int>>(
    value: value,
    loading: const Text('esqueleto'),
    isEmpty: (items) => items.isEmpty,
    empty: const EmptyState.noResults(onClearFilters: _noop),
    onRetry: onRetry,
    builder: (context, items) => Text('${items.length} filas'),
  );
}

void _noop() {}

void main() {
  testWidgets('loading shows the skeleton of the screen', (tester) async {
    await pumpKit(tester, _state(const AsyncLoading()));

    expect(find.text('esqueleto'), findsOneWidget);
  });

  testWidgets('data shows the builder', (tester) async {
    await pumpKit(tester, _state(const AsyncData([1, 2, 3])));

    expect(find.text('3 filas'), findsOneWidget);
  });

  testWidgets('an empty list shows the no-results state', (tester) async {
    await pumpKit(tester, _state(const AsyncData([])));

    expect(find.text('Sin resultados'), findsOneWidget);
    expect(find.text('Limpiar filtros'), findsOneWidget);
  });

  testWidgets('an error explains the failure and retries', (tester) async {
    var retried = false;
    await pumpKit(
      tester,
      _state(
        const AsyncError(Failure.network(), StackTrace.empty),
        onRetry: () => retried = true,
      ),
    );

    expect(find.text('Sin conexión'), findsOneWidget);
    await tester.tap(find.text('Reintentar'));
    expect(retried, isTrue);
  });
}
