import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/kit.dart';
import '../controllers/transactions_query_controller.dart';

const _width = 320.0;

/// «Buscar cliente, cuenta o ID» of A-01 (HU-02).
///
/// Waits [debounce] after the last key before asking the server, so typing a name does
/// not send one query per letter. Follows the query when the search is cleared elsewhere
/// («Limpiar filtros»).
class TransactionsSearchField extends ConsumerStatefulWidget {
  const TransactionsSearchField({super.key});

  static const debounce = Duration(milliseconds: 300);

  @override
  ConsumerState<TransactionsSearchField> createState() =>
      _TransactionsSearchFieldState();
}

class _TransactionsSearchFieldState
    extends ConsumerState<TransactionsSearchField> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(transactionsQueryProvider).search,
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(TransactionsSearchField.debounce, () {
      ref
          .read(transactionsQueryProvider.notifier)
          .setFilter((query) => query.copyWith(search: text.trim()));
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(transactionsQueryProvider.select((query) => query.search), (
      _,
      search,
    ) {
      if (search == _controller.text.trim()) return;
      _debounce?.cancel();
      _controller.text = search;
    });

    return SizedBox(
      width: _width,
      child: AppTextField(
        controller: _controller,
        variant: AppTextFieldVariant.search,
        hint: 'Buscar cliente, cuenta o ID',
        onChanged: _onChanged,
        semanticLabel: 'Buscar transacciones por cliente, cuenta o ID',
      ),
    );
  }
}
