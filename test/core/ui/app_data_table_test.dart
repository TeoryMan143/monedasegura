import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/ui/kit.dart';

import '../../helpers/kit_harness.dart';

typedef _Row = ({String id, String name, int score});

const _rows = <_Row>[
  (id: 'TX-1', name: 'Juan Pérez', score: 92),
  (id: 'TX-2', name: 'Ana Ruiz', score: 30),
  (id: 'TX-3', name: 'Luis Mora', score: 55),
];

final _columns = [
  AppTableColumn<_Row>(
    id: 'name',
    label: 'Cliente',
    cellBuilder: (context, row) => Text(row.name),
  ),
  AppTableColumn<_Row>(
    id: 'score',
    label: 'Alerta IA',
    numeric: true,
    sortable: true,
    width: 120,
    cellBuilder: (context, row) => ScoreBadge(score: row.score),
  ),
];

Widget _table({
  List<_Row> rows = _rows,
  bool loading = false,
  ValueChanged<_Row>? onRowTap,
  Set<Object>? selected,
  ValueChanged<Set<Object>>? onSelectionChanged,
  ValueChanged<String>? onSort,
}) {
  return SizedBox(
    width: 900,
    height: 500,
    child: AppDataTable<_Row>(
      columns: _columns,
      rows: rows,
      rowKey: (row) => row.id,
      loading: loading,
      onRowTap: onRowTap,
      selectedKeys: selected,
      onSelectionChanged: onSelectionChanged,
      onSort: onSort,
      sort: const AppTableSort(
        columnId: 'score',
        direction: SortDirection.descending,
      ),
      isFlagged: (row) => row.score >= 70,
      empty: const EmptyState(title: 'Sin transacciones'),
    ),
  );
}

void main() {
  testWidgets('renders one row per item and opens a row on click', (
    tester,
  ) async {
    _Row? opened;
    await pumpKit(tester, _table(onRowTap: (row) => opened = row));

    expect(find.text('Juan Pérez'), findsOneWidget);
    expect(find.text('Ana Ruiz'), findsOneWidget);
    await tester.tap(find.text('Ana Ruiz'));
    expect(opened?.id, 'TX-2');
  });

  testWidgets('loading draws skeleton rows instead of data', (tester) async {
    await pumpKit(tester, _table(loading: true));

    expect(find.byType(SkeletonRow), findsWidgets);
    expect(find.text('Juan Pérez'), findsNothing);
  });

  testWidgets('no rows shows the empty state', (tester) async {
    await pumpKit(tester, _table(rows: const []));

    expect(find.text('Sin transacciones'), findsOneWidget);
  });

  testWidgets('the header checkbox selects the page without opening rows', (
    tester,
  ) async {
    Set<Object>? selection;
    var opened = false;
    await pumpKit(
      tester,
      _table(
        selected: const {},
        onSelectionChanged: (value) => selection = value,
        onRowTap: (_) => opened = true,
      ),
    );

    await tester.tap(find.byType(Checkbox).first);
    expect(selection, {'TX-1', 'TX-2', 'TX-3'});

    await tester.tap(find.byType(Checkbox).at(2));
    expect(selection, {'TX-2'});
    expect(opened, isFalse);
  });

  testWidgets('a partial selection makes the header checkbox indeterminate', (
    tester,
  ) async {
    await pumpKit(
      tester,
      _table(selected: const {'TX-1'}, onSelectionChanged: (_) {}),
    );

    final header = tester.widget<Checkbox>(find.byType(Checkbox).first);
    expect(header.value, isNull);
  });

  testWidgets('clicking a sortable header reports its column', (tester) async {
    String? sorted;
    await pumpKit(tester, _table(onSort: (id) => sorted = id));

    await tester.tap(find.text('Alerta IA'));
    expect(sorted, 'score');
  });

  test(
    'AppTableSort.toggle flips the same column and starts others descending',
    () {
      const sort = AppTableSort(
        columnId: 'date',
        direction: SortDirection.descending,
      );
      expect(sort.toggle('date').direction, SortDirection.ascending);
      expect(
        sort.toggle('date').toggle('date').direction,
        SortDirection.descending,
      );
      expect(
        sort.toggle('amount'),
        const AppTableSort(
          columnId: 'amount',
          direction: SortDirection.descending,
        ),
      );
    },
  );
}
