import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_checkbox.dart';
import 'app_icon.dart';
import 'pressable.dart';
import 'skeleton_row.dart';

/// Direction of the active sort.
enum SortDirection { ascending, descending }

/// The column a table is sorted by and its direction.
@immutable
class AppTableSort {
  const AppTableSort({required this.columnId, required this.direction});

  final String columnId;
  final SortDirection direction;

  /// The sort after clicking [id]: flips the direction on the same column, otherwise
  /// sorts the new column descending (newest, highest amount or score first).
  AppTableSort toggle(String id) => AppTableSort(
    columnId: id,
    direction: id == columnId && direction == SortDirection.descending
        ? SortDirection.ascending
        : SortDirection.descending,
  );

  @override
  bool operator ==(Object other) =>
      other is AppTableSort &&
      other.columnId == columnId &&
      other.direction == direction;

  @override
  int get hashCode => Object.hash(columnId, direction);
}

/// One column of an [AppDataTable].
@immutable
class AppTableColumn<T> {
  const AppTableColumn({
    required this.id,
    required this.label,
    required this.cellBuilder,
    this.width,
    this.minWidth = 120,
    this.flex = 1,
    this.numeric = false,
    this.sortable = false,
  });

  /// Stable id, handed to `onSort` (e.g. `'amount'`).
  final String id;

  /// Header text.
  final String label;

  /// Builds the cell. Use `AppTableCell` for two-line cells (value + meta).
  final Widget Function(BuildContext context, T row) cellBuilder;

  /// Fixed width. Columns without it share the free space by [flex].
  final double? width;

  /// Width below which the table scrolls horizontally inside its card.
  final double minWidth;
  final int flex;

  /// Right-aligned: amounts, counts, scores.
  final bool numeric;

  /// Shows the Ordenar icon and calls `onSort` on click.
  final bool sortable;
}

/// Tablas (Figma Componentes `4:3`) · the data table of the app (DESIGN.md · Tables).
///
/// - Header 40 px on `bgSurfaceSubtle`, `bodySSemiBold`; sortable columns show the
///   Ordenar icon or the direction arrow of the active [sort].
/// - Rows 48 px minimum, `borderSubtle` divider, hover `gris-50`, the [activeKey] row and
///   selected rows in `bgSelected`, keyboard focus with a 2 px azul outline.
/// - Rows where [isFlagged] is true (AI alert) get the 3 px `info` left border.
/// - With [selectedKeys] a checkbox column appears; the header checkbox selects the page
///   and shows the indeterminate state. The checkbox never triggers [onRowTap].
/// - While [loading] it draws `SkeletonRow`s with the real column widths.
/// - Wide tables scroll horizontally inside their card, never the page.
///
/// By default the body scrolls and the table fills its parent's height (put it in an
/// `Expanded`, with the `Pagination` footer below). Use [shrinkWrap] inside a page that
/// already scrolls. Data, sort and pagination come from the controller: the table only
/// renders and reports clicks.
class AppDataTable<T> extends StatefulWidget {
  const AppDataTable({
    required this.columns,
    required this.rows,
    required this.rowKey,
    this.loading = false,
    this.skeletonRowCount = 8,
    this.sort,
    this.onSort,
    this.onRowTap,
    this.selectedKeys,
    this.onSelectionChanged,
    this.activeKey,
    this.isFlagged,
    this.empty,
    this.shrinkWrap = false,
    this.rowSemanticLabel,
    super.key,
  });

  final List<AppTableColumn<T>> columns;
  final List<T> rows;

  /// Stable identity of a row (its id), used for selection and [activeKey].
  final Object Function(T row) rowKey;
  final bool loading;
  final int skeletonRowCount;
  final AppTableSort? sort;

  /// Receives the id of the clicked sortable column. See [AppTableSort.toggle].
  final ValueChanged<String>? onSort;
  final ValueChanged<T>? onRowTap;

  /// Selected row keys. Non-null shows the checkbox column.
  final Set<Object>? selectedKeys;
  final ValueChanged<Set<Object>>? onSelectionChanged;

  /// Key of the row opened elsewhere (e.g. in the classification panel).
  final Object? activeKey;

  /// Rows with an AI alert: 3 px `info` left border.
  final bool Function(T row)? isFlagged;

  /// Shown instead of the rows when [rows] is empty and not [loading]: an `EmptyState`.
  final Widget? empty;
  final bool shrinkWrap;

  /// Accessible name of a clickable row, e.g. «Abrir TX-77120 de Juan Pérez».
  final String Function(T row)? rowSemanticLabel;

  @override
  State<AppDataTable<T>> createState() => _AppDataTableState<T>();
}

class _AppDataTableState<T> extends State<AppDataTable<T>> {
  final _horizontal = ScrollController();
  final _vertical = ScrollController();

  @override
  void dispose() {
    _horizontal.dispose();
    _vertical.dispose();
    super.dispose();
  }

  bool get _selectable => widget.selectedKeys != null;

  double get _leadingWidth =>
      _selectable ? AppSizes.tableCheckboxColumn : AppSpace.none;

  /// Column widths: fixed ones as given, flexible ones share the free space.
  List<double> _resolveWidths(double available) {
    var fixed = 0.0;
    var minFlexible = 0.0;
    var totalFlex = 0;
    for (final column in widget.columns) {
      final width = column.width;
      if (width != null) {
        fixed += width;
      } else {
        minFlexible += column.minWidth;
        totalFlex += column.flex;
      }
    }
    final extra = math.max(0.0, available - fixed - minFlexible);
    return [
      for (final column in widget.columns)
        column.width ??
            column.minWidth +
                (totalFlex == 0 ? 0 : extra * column.flex / totalFlex),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final leading = _leadingWidth;
        final widths = _resolveWidths(
          constraints.hasBoundedWidth ? constraints.maxWidth - leading : 0,
        );
        final tableWidth = leading + widths.fold(0.0, (sum, w) => sum + w);
        final body = _buildBody(widths);

        final table = SizedBox(
          width: tableWidth,
          child: Column(
            mainAxisSize: widget.shrinkWrap
                ? MainAxisSize.min
                : MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header<T>(
                columns: widget.columns,
                widths: widths,
                leadingWidth: leading,
                sort: widget.sort,
                onSort: widget.onSort,
                selectAll: _selectable ? _selectAllValue() : false,
                onSelectAll:
                    _selectable && !widget.loading && widget.rows.isNotEmpty
                    ? _toggleAll
                    : null,
                selectable: _selectable,
              ),
              if (widget.shrinkWrap) body else Expanded(child: body),
            ],
          ),
        );

        if (!constraints.hasBoundedWidth ||
            tableWidth <= constraints.maxWidth + 0.5) {
          return table;
        }
        return Scrollbar(
          controller: _horizontal,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontal,
            scrollDirection: Axis.horizontal,
            child: table,
          ),
        );
      },
    );
  }

  Widget _buildBody(List<double> widths) {
    if (widget.loading) {
      final skeleton = [
        for (var i = 0; i < widget.skeletonRowCount; i++)
          SkeletonRow(
            columnWidths: widths,
            leadingWidth: _leadingWidth,
            numericColumns: {
              for (final (index, column) in widget.columns.indexed)
                if (column.numeric) index,
            },
          ),
      ];
      return widget.shrinkWrap
          ? Column(children: skeleton)
          : ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: skeleton,
            );
    }

    if (widget.rows.isEmpty) {
      final empty = Padding(
        padding: const EdgeInsets.all(AppSpace.x3l),
        child: widget.empty ?? const SizedBox.shrink(),
      );
      return widget.shrinkWrap
          ? empty
          : SingleChildScrollView(child: Center(child: empty));
    }

    if (widget.shrinkWrap) {
      return Column(
        children: [for (final row in widget.rows) _buildRow(row, widths)],
      );
    }
    return Scrollbar(
      controller: _vertical,
      child: ListView.builder(
        controller: _vertical,
        itemCount: widget.rows.length,
        itemBuilder: (context, index) => _buildRow(widget.rows[index], widths),
      ),
    );
  }

  Widget _buildRow(T row, List<double> widths) {
    final key = widget.rowKey(row);
    final selected = widget.selectedKeys?.contains(key) ?? false;
    final onRowTap = widget.onRowTap;
    return _TableRow<T>(
      key: ValueKey<Object>(key),
      row: row,
      columns: widget.columns,
      widths: widths,
      leadingWidth: _leadingWidth,
      selectable: _selectable,
      selected: selected,
      active: widget.activeKey == key,
      flagged: widget.isFlagged?.call(row) ?? false,
      onTap: onRowTap == null ? null : () => onRowTap(row),
      onSelect: widget.onSelectionChanged == null
          ? null
          : (value) => _toggleRow(key, value),
      semanticLabel: widget.rowSemanticLabel?.call(row),
    );
  }

  bool? _selectAllValue() {
    final selected = widget.selectedKeys!;
    final keys = widget.rows.map(widget.rowKey);
    final count = keys.where(selected.contains).length;
    if (count == 0) return false;
    if (count == widget.rows.length) return true;
    return null;
  }

  void _toggleAll(bool value) {
    final next = Set<Object>.of(widget.selectedKeys!);
    final keys = widget.rows.map(widget.rowKey);
    value ? next.addAll(keys) : next.removeAll(keys);
    widget.onSelectionChanged?.call(next);
  }

  void _toggleRow(Object key, bool value) {
    final next = Set<Object>.of(widget.selectedKeys!);
    value ? next.add(key) : next.remove(key);
    widget.onSelectionChanged?.call(next);
  }
}

class _Header<T> extends StatelessWidget {
  const _Header({
    required this.columns,
    required this.widths,
    required this.leadingWidth,
    required this.sort,
    required this.onSort,
    required this.selectAll,
    required this.onSelectAll,
    required this.selectable,
  });

  final List<AppTableColumn<T>> columns;
  final List<double> widths;
  final double leadingWidth;
  final AppTableSort? sort;
  final ValueChanged<String>? onSort;
  final bool? selectAll;
  final ValueChanged<bool>? onSelectAll;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.tableHeader,
      decoration: const BoxDecoration(
        color: AppColors.bgSurfaceSubtle,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          if (selectable)
            SizedBox(
              width: leadingWidth,
              child: Center(
                child: AppCheckbox(
                  value: selectAll,
                  onChanged: onSelectAll,
                  semanticLabel: 'Seleccionar todas las filas de la página',
                ),
              ),
            ),
          for (final (index, column) in columns.indexed)
            SizedBox(
              width: widths[index],
              child: _HeaderCell<T>(column: column, sort: sort, onSort: onSort),
            ),
        ],
      ),
    );
  }
}

class _HeaderCell<T> extends StatelessWidget {
  const _HeaderCell({
    required this.column,
    required this.sort,
    required this.onSort,
  });

  final AppTableColumn<T> column;
  final AppTableSort? sort;
  final ValueChanged<String>? onSort;

  @override
  Widget build(BuildContext context) {
    final active = sort?.columnId == column.id;
    final alignment = column.numeric
        ? Alignment.centerRight
        : Alignment.centerLeft;

    Widget content(Color iconColor) => Row(
      mainAxisAlignment: column.numeric
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            column.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.bodySSemiBold.copyWith(
              color: active ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
        if (column.sortable) ...[
          const SizedBox(width: AppSpace.xs),
          AppIcon(
            !active
                ? AppIcons.sort
                : sort!.direction == SortDirection.ascending
                ? AppIcons.arrowUp
                : AppIcons.arrowDown,
            size: AppIconSize.sm,
            color: active ? AppColors.iconBrand : iconColor,
          ),
        ],
      ],
    );

    const padding = EdgeInsets.symmetric(horizontal: AppSpace.md);
    final onSort = this.onSort;
    if (!column.sortable || onSort == null) {
      return Padding(
        padding: padding,
        child: Align(
          alignment: alignment,
          child: content(AppColors.iconSecondary),
        ),
      );
    }

    final direction = !active
        ? ''
        : sort!.direction == SortDirection.ascending
        ? ', orden ascendente'
        : ', orden descendente';
    return Pressable(
      onPressed: () => onSort(column.id),
      semanticLabel: 'Ordenar por ${column.label}$direction',
      borderRadius: AppRadius.sm,
      builder: (context, state) => Container(
        padding: padding,
        alignment: alignment,
        color: state.hovered ? AppColors.gris200.withValues(alpha: 0.4) : null,
        child: content(
          state.hovered ? AppColors.iconPrimary : AppColors.iconSecondary,
        ),
      ),
    );
  }
}

class _TableRow<T> extends StatelessWidget {
  const _TableRow({
    required this.row,
    required this.columns,
    required this.widths,
    required this.leadingWidth,
    required this.selectable,
    required this.selected,
    required this.active,
    required this.flagged,
    required this.onTap,
    required this.onSelect,
    required this.semanticLabel,
    super.key,
  });

  final T row;
  final List<AppTableColumn<T>> columns;
  final List<double> widths;
  final double leadingWidth;
  final bool selectable;
  final bool selected;
  final bool active;
  final bool flagged;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSelect;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return _buildContent(context, null);
    return Pressable(
      onPressed: onTap,
      semanticLabel: semanticLabel,
      showFocusRing: false,
      selected: selected || active,
      builder: _buildContent,
    );
  }

  Widget _buildContent(BuildContext context, PressableState? state) {
    final background = selected || active
        ? AppColors.bgSelected
        : (state?.hovered ?? false)
        ? AppColors.bgRowHover
        : AppColors.bgSurface;

    return Container(
      decoration: BoxDecoration(
        color: background,
        border: const Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      foregroundDecoration: (state?.focused ?? false)
          ? BoxDecoration(
              border: Border.all(color: AppColors.borderFocus, width: 2),
            )
          : null,
      child: Stack(
        children: [
          DefaultTextStyle.merge(
            style: AppText.bodyM,
            child: Row(
              children: [
                if (selectable)
                  _cell(
                    width: leadingWidth,
                    padding: EdgeInsets.zero,
                    alignment: Alignment.center,
                    child: AppCheckbox(
                      value: selected,
                      onChanged: onSelect,
                      semanticLabel: 'Seleccionar fila',
                    ),
                  ),
                for (final (index, column) in columns.indexed)
                  _cell(
                    width: widths[index],
                    alignment: column.numeric
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: column.cellBuilder(context, row),
                  ),
              ],
            ),
          ),
          if (flagged)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: AppSizes.tableAlertBorder,
                color: StatusTone.info.solid,
              ),
            ),
        ],
      ),
    );
  }

  Widget _cell({
    required double width,
    required Alignment alignment,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: AppSpace.md,
      vertical: AppSpace.sm,
    ),
  }) {
    return SizedBox(
      width: width,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.tableRow),
        child: Padding(
          padding: padding,
          child: Align(alignment: alignment, child: child),
        ),
      ),
    );
  }
}
