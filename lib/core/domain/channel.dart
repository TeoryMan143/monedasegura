import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'domain_enum.dart';

/// Transaction channel (`channels.code`), used by HU-02, HU-03 and HU-13.
enum Channel implements DomainEnum {
  app('APP', 'App móvil', AppIcons.device),
  web('WEB', 'Banca web', AppIcons.device),
  pos('POS', 'POS', AppIcons.card),
  atm('ATM', 'Cajero', AppIcons.bank),
  pse('PSE', 'PSE', AppIcons.transfer),
  spei('SPEI', 'SPEI', AppIcons.transfer),
  yape('YAPE', 'Yape', AppIcons.transfer),
  pix('PIX', 'Pix', AppIcons.transfer),
  interbank('INTERBANK', 'Transferencia interbancaria', AppIcons.transfer),
  payroll('PAYROLL', 'Nómina', AppIcons.currency);

  const Channel(this.dbValue, this.label, this.icon);

  /// Reads the database value.
  factory Channel.fromDb(String value) => domainEnumFromDb(values, value);

  @override
  final String dbValue;
  @override
  final String label;
  @override
  final AppIcons icon;

  @override
  StatusTone get tone => StatusTone.neutral;
}
