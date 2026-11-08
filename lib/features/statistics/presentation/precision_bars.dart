import '../../../core/domain/fraud_type.dart';
import '../../../core/formatting/numbers.dart';
import '../domain/type_precision.dart';
import 'stats_labels.dart';
import 'widgets/horizontal_bars.dart';

/// The rows of «Precisión por tipo» (A-08): every fraud type, highest precision first.
///
/// A type with no resolved alerts has no entry in [precisions]: it goes last with
/// «Sin datos» and no bar, never «0 %». Each row's tooltip says how many alerts the figure
/// rests on, so a small sample is not read as a trend.
List<BarItem> precisionBars(List<TypePrecision> precisions) {
  final measured = [...precisions]
    ..sort((a, b) {
      final byPrecision = b.precision.compareTo(a.precision);
      return byPrecision != 0 ? byPrecision : b.alerts.compareTo(a.alerts);
    });
  final measuredCodes = {for (final p in measured) p.typeCode};
  return [
    for (final precision in measured)
      BarItem(
        label: fraudTypeLabel(precision.typeCode),
        value: precision.precision * 100,
        valueText: formatPercent(precision.precision * 100),
        detail:
            'n = ${formatCount(precision.alerts)} '
            '${precision.alerts == 1 ? 'alerta resuelta' : 'alertas resueltas'}',
      ),
    for (final type in FraudType.values)
      if (!measuredCodes.contains(type.dbValue))
        BarItem(
          label: type.label,
          value: null,
          valueText: 'Sin datos',
          detail: 'Sin alertas resueltas de este tipo',
        ),
  ];
}
