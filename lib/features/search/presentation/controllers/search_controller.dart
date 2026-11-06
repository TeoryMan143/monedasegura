import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/search_repository.dart';
import '../../domain/search_result.dart';
import '../../domain/search_terms.dart';

/// Text typed in the C-05 search dialog. Disposed when the dialog closes.
final searchQueryProvider =
    NotifierProvider.autoDispose<SearchQueryController, String>(
      SearchQueryController.new,
      name: 'searchQueryProvider',
    );

class SearchQueryController extends Notifier<String> {
  @override
  String build() => '';

  void change(String query) => state = query;
}

/// How long the dialog waits after the last keystroke before querying the database.
const searchDebounce = Duration(milliseconds: 250);

/// Results for the current query, grouped by kind (customers, accounts, transactions).
///
/// Debounced: a keystroke rebuilds this provider, which marks the previous run as stale
/// before it reaches the database.
final searchResultsProvider = FutureProvider.autoDispose<List<SearchResult>>((
  ref,
) async {
  final terms = SearchTerms.parse(ref.watch(searchQueryProvider));
  if (!terms.isSearchable) return const [];
  final repository = ref.watch(searchRepositoryProvider);

  var stale = false;
  ref.onDispose(() => stale = true);
  await Future<void>.delayed(searchDebounce);
  if (stale) return const [];

  return repository.search(terms);
}, name: 'searchResultsProvider');
