import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/audit_repository.dart';
import '../../domain/audit_entry.dart';

/// A failed read shows «Reintentar» at once instead of a long skeleton.
Duration? _noAutoRetry(int retryCount, Object error) => null;

/// The changes to the label and alerts of a transaction, newest first (HU-15).
final labelHistoryProvider = FutureProvider.autoDispose
    .family<List<AuditEntry>, int>(
      (ref, transactionId) =>
          ref.watch(auditRepositoryProvider).fetchLabelHistory(transactionId),
      retry: _noAutoRetry,
      name: 'labelHistoryProvider',
    );
