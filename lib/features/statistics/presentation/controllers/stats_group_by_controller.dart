import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/stats_group_by.dart';

/// «Agrupar por» of the bars of the «Fraude» tab: only that chart asks again when it
/// changes (A-07).
final statsGroupByProvider =
    NotifierProvider.autoDispose<StatsGroupByNotifier, StatsGroupBy>(
      StatsGroupByNotifier.new,
      name: 'statsGroupByProvider',
    );

class StatsGroupByNotifier extends Notifier<StatsGroupBy> {
  @override
  StatsGroupBy build() => StatsGroupBy.type;

  void select(StatsGroupBy by) => state = by;
}
