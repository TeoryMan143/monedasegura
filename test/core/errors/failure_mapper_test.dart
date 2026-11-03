import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/errors/failure.dart';
import 'package:monedasegura/core/errors/failure_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('mapToFailure', () {
    test('keeps a Failure as is', () {
      expect(mapToFailure(const Failure.notFound()), const Failure.notFound());
    });

    test('maps RPC conflict keys to conflict', () {
      const e = PostgrestException(
        message: 'alert_already_resolved',
        code: 'P0001',
      );
      expect(
        mapToFailure(e),
        const Failure.conflict(key: 'alert_already_resolved'),
      );
    });

    test('maps other RPC keys to validation', () {
      const e = PostgrestException(
        message: 'justification_required',
        code: 'P0001',
      );
      expect(
        mapToFailure(e),
        const Failure.validation(key: 'justification_required'),
      );
    });

    test('maps RPC not-found keys to notFound', () {
      const e = PostgrestException(
        message: 'transaction_not_found',
        code: 'P0001',
      );
      expect(mapToFailure(e), const Failure.notFound());
    });

    test('maps RLS rejections to forbidden', () {
      const e = PostgrestException(message: 'denied', code: '42501');
      expect(mapToFailure(e), const Failure.forbidden());
    });

    test('maps an expired JWT to unauthorized', () {
      const e = PostgrestException(message: 'JWT expired', code: 'PGRST303');
      expect(mapToFailure(e), const Failure.unauthorized());
    });

    test('maps wrong credentials to invalidCredentials', () {
      const e = AuthException('Invalid', code: 'invalid_credentials');
      expect(mapToFailure(e), const Failure.invalidCredentials());
    });

    test('maps socket errors and timeouts to network', () {
      expect(
        mapToFailure(const SocketException('offline')),
        const Failure.network(),
      );
      expect(mapToFailure(TimeoutException('slow')), const Failure.network());
    });

    test('maps anything else to unknown', () {
      expect(mapToFailure(StateError('boom')), isA<UnknownFailure>());
    });
  });
}
