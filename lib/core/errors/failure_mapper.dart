import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'failure.dart';

/// RPC error keys (see DATABASE.md) that mean "someone else changed it first".
const _conflictKeys = {'alert_already_resolved'};

/// RPC error keys that mean the target row does not exist.
const _notFoundKeys = {'transaction_not_found', 'alert_not_found'};

/// Maps any error thrown by Supabase or the network to a [Failure].
///
/// The one place where Supabase exceptions are interpreted. Repositories call it in
/// their `catch` blocks.
Failure mapToFailure(Object error) => switch (error) {
  Failure() => error,
  AuthException(:final code) when code == 'invalid_credentials' =>
    const Failure.invalidCredentials(),
  AuthException() => const Failure.unauthorized(),
  PostgrestException() => _fromPostgrest(error),
  SocketException() || TimeoutException() => const Failure.network(),
  _ => Failure.unknown(message: error.toString()),
};

Failure _fromPostgrest(PostgrestException e) {
  final code = e.code;
  return switch (code) {
    // Error keys raised by our RPCs: `raise exception '<key>' using errcode = 'P0001'`.
    'P0001' when _conflictKeys.contains(e.message) => Failure.conflict(
      key: e.message,
    ),
    'P0001' when _notFoundKeys.contains(e.message) => const Failure.notFound(),
    'P0001' => Failure.validation(key: e.message),
    // Expired or invalid JWT.
    'PGRST301' || 'PGRST303' => const Failure.unauthorized(),
    // RLS / missing grant.
    '42501' => const Failure.forbidden(),
    // `.single()` found no row.
    'PGRST116' => const Failure.notFound(),
    // Unique violation.
    '23505' => Failure.conflict(key: e.message),
    // CHECK, NOT NULL or foreign key violation.
    '23514' || '23502' || '23503' => Failure.validation(key: e.message),
    _ => Failure.unknown(message: '[$code] ${e.message}'),
  };
}
