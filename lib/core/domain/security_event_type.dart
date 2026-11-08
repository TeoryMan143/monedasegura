import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'domain_enum.dart';

/// Type of a security event of a customer (`security_event_type` in the database), shown
/// on the customer timeline (HU-10).
enum SecurityEventType implements DomainEnum {
  login('login', 'Inicio de sesión', AppIcons.user, StatusTone.neutral),
  loginFailed(
    'login_failed',
    'Inicio de sesión fallido',
    AppIcons.error,
    StatusTone.danger,
  ),
  loginNewDevice(
    'login_new_device',
    'Dispositivo nuevo',
    AppIcons.device,
    StatusTone.warning,
  ),
  passwordChange(
    'password_change',
    'Cambio de contraseña',
    AppIcons.lock,
    StatusTone.warning,
  ),
  phoneChange(
    'phone_change',
    'Cambio de teléfono',
    AppIcons.device,
    StatusTone.warning,
  ),
  simChange('sim_change', 'Cambio de SIM', AppIcons.signal, StatusTone.high),
  emailChange(
    'email_change',
    'Cambio de correo',
    AppIcons.mail,
    StatusTone.warning,
  ),
  logout('logout', 'Cierre de sesión', AppIcons.logout, StatusTone.neutral);

  const SecurityEventType(this.dbValue, this.label, this.icon, this.tone);

  /// Reads the database value.
  factory SecurityEventType.fromDb(String value) =>
      domainEnumFromDb(values, value);

  @override
  final String dbValue;
  @override
  final String label;
  @override
  final AppIcons icon;
  @override
  final StatusTone tone;
}
