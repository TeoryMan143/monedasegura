import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/label_status.dart';

part 'transactions_query.freezed.dart';

/// Columns the A-01 list can sort by.
enum TransactionsSort {
  date('Fecha'),
  amount('Monto'),
  score('Score');

  const TransactionsSort(this.label);

  /// Spanish label of the «Ordenar por» dropdown.
  final String label;
}

/// A filter of the N-01 panel or the search field, each one removable on its own.
enum TransactionsFilter {
  search,
  dateRange,
  country,
  channel,
  labelStatus,
  aiAlert,
}

/// Search, filters, sort and page of the A-01 list (HU-02).
@freezed
abstract class TransactionsQuery with _$TransactionsQuery {
  const factory TransactionsQuery({
    /// Customer, account or transaction ID.
    @Default('') String search,

    /// First day of the range, inclusive.
    DateTime? dateFrom,

    /// Last day of the range, inclusive.
    DateTime? dateTo,

    /// A `countries.code`.
    String? countryCode,

    /// A `channels.code`.
    String? channelCode,
    LabelStatus? labelStatus,

    /// True shows only the transactions with an AI alert.
    @Default(false) bool withAiAlert,
    @Default(TransactionsSort.date) TransactionsSort sort,
    @Default(false) bool ascending,
    @Default(1) int page,
    @Default(25) int pageSize,
  }) = _TransactionsQuery;

  const TransactionsQuery._();

  static const pageSizes = [25, 50, 100];

  /// First row of the page, for `.range(from, to)`.
  int get from => (page - 1) * pageSize;

  /// Last row of the page, for `.range(from, to)`.
  int get to => from + pageSize - 1;

  /// The filters that are set, in display order. A chip is shown for each one, except
  /// [TransactionsFilter.search], which has its own field.
  List<TransactionsFilter> get activeFilters => [
    if (search.trim().isNotEmpty) TransactionsFilter.search,
    if (dateFrom != null || dateTo != null) TransactionsFilter.dateRange,
    if (countryCode != null) TransactionsFilter.country,
    if (channelCode != null) TransactionsFilter.channel,
    if (labelStatus != null) TransactionsFilter.labelStatus,
    if (withAiAlert) TransactionsFilter.aiAlert,
  ];

  /// This query without [filter]. Keeps the page: the caller decides where to go.
  TransactionsQuery without(TransactionsFilter filter) => switch (filter) {
    TransactionsFilter.search => copyWith(search: ''),
    TransactionsFilter.dateRange => copyWith(dateFrom: null, dateTo: null),
    TransactionsFilter.country => copyWith(countryCode: null),
    TransactionsFilter.channel => copyWith(channelCode: null),
    TransactionsFilter.labelStatus => copyWith(labelStatus: null),
    TransactionsFilter.aiAlert => copyWith(withAiAlert: false),
  };
}
