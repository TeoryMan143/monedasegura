import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/catalogs/catalog_providers.dart';
import '../../../../core/domain/page_result.dart';
import '../../data/transactions_repository.dart';
import '../../domain/transaction_row.dart';
import '../../domain/transactions_query.dart';

/// A failed page shows «Reintentar» at once instead of a long skeleton.
Duration? _noAutoRetry(int retryCount, Object error) => null;

/// The page of the A-01 list for a query (HU-02). Waits for the `countries` catalog,
/// which gives each row its country (kept alive, so it loads once per session).
final transactionsPageProvider = FutureProvider.autoDispose
    .family<PageResult<TransactionRow>, TransactionsQuery>(
      (ref, query) async {
        final repository = ref.watch(transactionsRepositoryProvider);
        final countries = await ref.watch(countriesProvider.future);
        return repository.fetchPage(query, countries: countries);
      },
      retry: _noAutoRetry,
      name: 'transactionsPageProvider',
    );
