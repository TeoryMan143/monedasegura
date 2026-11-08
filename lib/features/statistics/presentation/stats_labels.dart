import '../../../core/domain/channel.dart';
import '../../../core/domain/country.dart';
import '../../../core/domain/fraud_type.dart';
import '../domain/stats_group_by.dart';

/// Spanish label of a group key, from the domain enums. A code the app does not know yet
/// shows as it comes, rather than breaking the chart.
String groupLabel(StatsGroupBy by, String key) => switch (by) {
  StatsGroupBy.type => fraudTypeLabel(key),
  StatsGroupBy.channel =>
    Channel.values.where((c) => c.dbValue == key).firstOrNull?.label ?? key,
  StatsGroupBy.country =>
    Country.values.where((c) => c.dbValue == key).firstOrNull?.label ?? key,
};

/// «Robo de cuenta» for `ATO`.
String fraudTypeLabel(String code) =>
    FraudType.values.where((t) => t.dbValue == code).firstOrNull?.label ?? code;

/// «tipo», «canal» or «país»: the grouping as the subtitle of the bars writes it.
String groupByNoun(StatsGroupBy by) => switch (by) {
  StatsGroupBy.type => 'tipo',
  StatsGroupBy.channel => 'canal',
  StatsGroupBy.country => 'país',
};
