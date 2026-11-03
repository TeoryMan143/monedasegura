import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Every error a repository can throw. Presentation decides the Spanish text for each one.
@freezed
sealed class Failure with _$Failure implements Exception {
  /// No connection or the request timed out.
  const factory Failure.network() = NetworkFailure;

  /// The session expired or is invalid: the app signs out.
  const factory Failure.unauthorized() = UnauthorizedFailure;

  /// Wrong email or password on sign in (HU-01). Never says which one.
  const factory Failure.invalidCredentials() = InvalidCredentialsFailure;

  /// RLS or a grant rejected the operation.
  const factory Failure.forbidden() = ForbiddenFailure;

  /// The data changed under us, e.g. `alert_already_resolved`.
  const factory Failure.conflict({required String key}) = ConflictFailure;

  /// The database rejected the input. [key] is the RPC error key
  /// (`fraud_type_required`, `justification_required`…).
  const factory Failure.validation({
    required String key,
    @Default({}) Map<String, String> fieldErrors,
  }) = ValidationFailure;

  /// The requested row does not exist.
  const factory Failure.notFound() = NotFoundFailure;

  /// Anything else. [message] is for logs, never for the UI.
  const factory Failure.unknown({String? message}) = UnknownFailure;
}
