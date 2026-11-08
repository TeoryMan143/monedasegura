import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/audit_repository.dart';
import '../../domain/label_history.dart';

/// A failed read shows «Reintentar» at once instead of a long skeleton.
Duration? _noAutoRetry(int retryCount, Object error) => null;

/// The changes to the label and alerts of a transaction, newest first, and its AI
/// alerts (HU-15).
final labelHistoryProvider = FutureProvider.autoDispose
    .family<LabelHistory, int>(
      (ref, transactionId) =>
          ref.watch(auditRepositoryProvider).fetchLabelHistory(transactionId),
      retry: _noAutoRetry,
      name: 'labelHistoryProvider',
    );
