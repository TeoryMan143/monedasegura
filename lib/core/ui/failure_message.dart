import '../errors/failure.dart';

/// Spanish title and explanation for an error shown to the analyst.
typedef FailureMessage = ({String title, String message});

/// Default text for each [Failure] (ARCHITECTURAL_SPINE.md · Data flow, rule 4).
///
/// Screens can pass their own text to `ScreenState` / `ErrorState` when a message must
/// be more specific. Anything that is not a [Failure] is treated as unknown.
FailureMessage failureMessage(Object error) => switch (error) {
  NetworkFailure() => (
    title: 'Sin conexión',
    message: 'No pudimos conectar con el servidor. Revisa tu conexión e inténtalo de nuevo.',
  ),
  UnauthorizedFailure() => (
    title: 'Tu sesión expiró',
    message: 'Vuelve a iniciar sesión para continuar.',
  ),
  InvalidCredentialsFailure() => (
    title: 'Correo o contraseña incorrectos',
    message: 'Revisa tus datos e inténtalo de nuevo.',
  ),
  ForbiddenFailure() => (
    title: 'Acceso no permitido',
    message: 'Tu cuenta no tiene permiso para ver o cambiar esta información.',
  ),
  ConflictFailure() => (
    title: 'Otro analista hizo un cambio',
    message: 'Los datos cambiaron mientras los revisabas. Recarga para ver la versión actual.',
  ),
  ValidationFailure() => (
    title: 'Revisa los datos',
    message: 'Algunos campos no cumplen las reglas. Corrígelos e inténtalo de nuevo.',
  ),
  NotFoundFailure() => (
    title: 'No encontramos lo que buscas',
    message: 'Puede que se haya eliminado o que el enlace no sea correcto.',
  ),
  _ => (
    title: 'Algo salió mal',
    message:
        'Ocurrió un error inesperado. Inténtalo de nuevo en unos segundos.',
  ),
};
