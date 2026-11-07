import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/catalogs/catalog_providers.dart';
import '../../../../core/domain/page_result.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/local_writes/local_writes_provider.dart';
import '../../../../core/supabase/supabase_client_provider.dart';
import '../../../auth/presentation/controllers/session_controller.dart';
import '../../data/alerts_repository.dart';
import '../../domain/ai_alert.dart';
import '../../domain/alert_detail.dart';
import '../../domain/alerts_query.dart';
import '../../domain/resolve_alert_input.dart';

/// A failed request shows «Reintentar» at once instead of a long skeleton.
Duration? _noAutoRetry(int retryCount, Object error) => null;

/// The alerts repository of the app (HU-06, HU-07, HU-08).
final alertsRepositoryProvider = Provider<AlertsRepository>(
  (ref) => AlertsRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(localWritesStoreProvider),
  ),
  name: 'alertsRepositoryProvider',
);

/// One page of the inbox for [AlertsQuery] (HU-06). The screen watches
/// `alertsQueryProvider` and passes its value here.
final alertsPageProvider = FutureProvider.autoDispose
    .family<PageResult<AiAlert>, AlertsQuery>(
      (ref, query) => ref.watch(alertsRepositoryProvider).list(query),
      retry: _noAutoRetry,
      name: 'alertsPageProvider',
    );

/// The alert with its reasons and transactions, by alert ID (HU-07).
final alertDetailProvider = FutureProvider.autoDispose
    .family<AlertDetail, String>(
      (ref, alertId) => ref.watch(alertsRepositoryProvider).getById(alertId),
      retry: _noAutoRetry,
      name: 'alertDetailProvider',
    );

/// Resolves an alert as the signed-in analyst (HU-08) and reloads the inbox and the
/// detail, so they show the new status.
///
/// Throws the [Failure] of the repository: `conflict` when someone resolved it first,
/// `validation` with the key of the broken rule.
final resolveAlertProvider =
    Provider<Future<void> Function(ResolveAlertInput input)>((ref) {
      return (input) async {
        final analyst = ref.read(sessionProvider);
        if (analyst == null) throw const Failure.unauthorized();
        final fraudTypes = await ref.read(fraudTypesProvider.future);
        await ref
            .read(alertsRepositoryProvider)
            .resolve(
              input,
              fraudTypes: fraudTypes,
              analystId: analyst.id,
              analystName: analyst.fullName,
            );
        ref.invalidate(alertsPageProvider);
        ref.invalidate(alertDetailProvider(input.alertId));
      };
    }, name: 'resolveAlertProvider');
