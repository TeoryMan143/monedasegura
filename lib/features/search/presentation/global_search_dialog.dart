import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import '../domain/search_result.dart';
import '../domain/search_terms.dart';
import 'controllers/search_controller.dart';

/// Opens the customer view of a result; [transactionId] selects that transaction.
///
/// The shell passes it, so this feature does not depend on the router.
typedef OpenSearchResult =
    void Function(String customerId, {String? transactionId});

/// Opens C-05 · global search (HU-14). Called from the top bar button and Ctrl/Cmd+K.
Future<void> showGlobalSearch(
  BuildContext context, {
  required OpenSearchResult onOpen,
}) {
  return showAppDialog<void>(
    context: context,
    builder: (context) => GlobalSearchDialog(onOpen: onOpen),
  );
}

/// C-05 · search dialog: field on top, results grouped by customers, accounts and
/// transactions, and keyboard navigation (↑ ↓ to move, Enter to open, Esc to close).
///
/// Every result opens the customer view; transactions open it with that transaction
/// selected (`?tx=`).
class GlobalSearchDialog extends ConsumerStatefulWidget {
  const GlobalSearchDialog({required this.onOpen, super.key});

  final OpenSearchResult onOpen;

  @override
  ConsumerState<GlobalSearchDialog> createState() => _GlobalSearchDialogState();
}

class _GlobalSearchDialogState extends ConsumerState<GlobalSearchDialog> {
  final _controller = TextEditingController();
  int _highlighted = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<SearchResult> get _results {
    final value = ref.read(searchResultsProvider);
    return value.hasValue ? value.requireValue : const [];
  }

  void _move(int delta) {
    final count = _results.length;
    if (count == 0) return;
    setState(() => _highlighted = (_highlighted + delta) % count);
  }

  void _open(SearchResult result) {
    Navigator.of(context).pop();
    widget.onOpen(result.customerId, transactionId: result.transactionId);
  }

  void _openHighlighted() {
    final results = _results;
    if (_highlighted < results.length) _open(results[_highlighted]);
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowDown): () => _move(1),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => _move(-1),
        const SingleActivator(LogicalKeyboardKey.enter): _openHighlighted,
        const SingleActivator(LogicalKeyboardKey.numpadEnter): _openHighlighted,
      },
      child: AppDialog(
        title: 'Buscar',
        subtitle: 'Clientes, cuentas y transacciones',
        bodyPadding: const EdgeInsets.all(AppSpace.lg),
        footerLeading: Text(
          '↑ ↓ para moverte · Enter para abrir · Esc para cerrar',
          style: AppText.bodyS.copyWith(color: AppColors.textTertiary),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _controller,
              autofocus: true,
              variant: AppTextFieldVariant.search,
              hint: 'Nombre, documento, últimos dígitos de cuenta o TX-48219',
              semanticLabel: 'Buscar clientes, cuentas o transacciones',
              onChanged: (text) {
                ref.read(searchQueryProvider.notifier).change(text);
                setState(() => _highlighted = 0);
              },
            ),
            const SizedBox(height: AppSpace.lg),
            if (!SearchTerms.parse(query).isSearchable)
              Text(
                'Escribe al menos ${SearchTerms.minLength} caracteres.',
                style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
              )
            else
              ScreenState<List<SearchResult>>(
                value: results,
                onRetry: () => ref.invalidate(searchResultsProvider),
                loading: const _ResultsSkeleton(),
                isEmpty: (items) => items.isEmpty,
                empty: EmptyState.noResults(
                  message:
                      'No encontramos clientes, cuentas ni transacciones '
                      'para «${query.trim()}».',
                ),
                builder: (context, items) => _ResultsList(
                  results: items,
                  highlighted: _highlighted,
                  onHover: (index) => setState(() => _highlighted = index),
                  onOpen: _open,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({
    required this.results,
    required this.highlighted,
    required this.onHover,
    required this.onOpen,
  });

  final List<SearchResult> results;
  final int highlighted;
  final ValueChanged<int> onHover;
  final ValueChanged<SearchResult> onOpen;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    SearchResultKind? group;
    for (final (index, result) in results.indexed) {
      if (result.kind != group) {
        group = result.kind;
        children.add(
          Padding(
            padding: EdgeInsets.only(
              top: index == 0 ? AppSpace.none : AppSpace.md,
              bottom: AppSpace.xs,
              left: AppSpace.sm,
            ),
            child: Text(
              group.groupLabel.toUpperCase(),
              style: AppText.label.copyWith(color: AppColors.textTertiary),
            ),
          ),
        );
      }
      children.add(
        _ResultRow(
          result: result,
          highlighted: index == highlighted,
          onHover: () => onHover(index),
          onOpen: () => onOpen(result),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _ResultRow extends StatefulWidget {
  const _ResultRow({
    required this.result,
    required this.highlighted,
    required this.onHover,
    required this.onOpen,
  });

  final SearchResult result;
  final bool highlighted;
  final VoidCallback onHover;
  final VoidCallback onOpen;

  @override
  State<_ResultRow> createState() => _ResultRowState();
}

class _ResultRowState extends State<_ResultRow> {
  @override
  void didUpdateWidget(_ResultRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep the row moved to with the arrow keys inside the scrolled area.
    if (widget.highlighted && !oldWidget.highlighted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Scrollable.ensureVisible(context, alignment: 0.5);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final occurredAt = result.occurredAt;
    final subtitle = occurredAt == null
        ? result.subtitle
        : '${result.subtitle} · '
              '${DateFormat('d MMM yyyy · HH:mm', 'es').format(occurredAt)}';

    return MouseRegion(
      onEnter: (_) => widget.onHover(),
      child: Pressable(
        onPressed: widget.onOpen,
        selected: widget.highlighted,
        semanticLabel:
            '${result.kind.groupLabel}: ${result.title}, $subtitle',
        builder: (context, state) => Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.sm,
            vertical: AppSpace.sm,
          ),
          decoration: BoxDecoration(
            color: widget.highlighted ? AppColors.bgSelected : null,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              AppIcon(
                result.kind.icon,
                size: AppIconSize.md,
                color: widget.highlighted
                    ? AppColors.iconBrand
                    : AppColors.iconSecondary,
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodyMMedium,
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodyS.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.highlighted)
                const AppIcon(
                  AppIcons.chevronRight,
                  size: AppIconSize.sm,
                  color: AppColors.iconBrand,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultsSkeleton extends StatelessWidget {
  const _ResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < 4; i++)
          const Padding(
            padding: EdgeInsets.all(AppSpace.sm),
            child: Row(
              children: [
                SkeletonBox(width: AppIconSize.md, height: AppIconSize.md),
                SizedBox(width: AppSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: AppSizes.progressBar),
                      SizedBox(height: AppSpace.xs),
                      SkeletonBox(width: AppSizes.menuMinWidth),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
