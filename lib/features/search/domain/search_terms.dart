/// What the global search looks for in a raw query (HU-14).
///
/// - [words]: tokens for names and document numbers, without characters that would
///   break a PostgREST filter (`,()*%:"'\`).
/// - [digits]: the query when it is only digits (2+), for the last digits of an account.
/// - [transactionDigits]: the number of a transaction code, from «TX-48219», «tx48219» or
///   «48219».
class SearchTerms {
  const SearchTerms._({
    required this.words,
    required this.digits,
    required this.transactionDigits,
  });

  factory SearchTerms.parse(String raw) {
    final cleaned = raw.replaceAll(_unsafe, ' ').trim();
    final words = cleaned
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    final compact = cleaned.replaceAll(' ', '');
    final digits = _onlyDigits.hasMatch(compact) ? compact : null;
    final transaction = _transactionCode.firstMatch(compact)?.group(1);
    return SearchTerms._(
      words: cleaned.length < minLength ? const [] : words,
      digits: digits,
      transactionDigits: transaction,
    );
  }

  /// Shortest query that is sent to the database.
  static const minLength = 2;

  static final _unsafe = RegExp(r'''[,()*%:"'\\]''');
  static final _onlyDigits = RegExp(r'^\d{2,}$');
  static final _transactionCode = RegExp(r'^(?:tx-?)?(\d{2,})$', caseSensitive: false);

  final List<String> words;
  final String? digits;
  final String? transactionDigits;

  /// Whether the query is long enough to search.
  bool get isSearchable => words.isNotEmpty;
}
