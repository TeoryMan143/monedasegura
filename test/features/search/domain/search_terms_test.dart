import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/search/domain/search_terms.dart';

void main() {
  test('names are split in words and need two characters', () {
    expect(SearchTerms.parse('juan perez').words, ['juan', 'perez']);
    expect(SearchTerms.parse('j').isSearchable, isFalse);
    expect(SearchTerms.parse('   ').isSearchable, isFalse);
  });

  test('characters that break a PostgREST filter are removed', () {
    final terms = SearchTerms.parse('pérez,(*%):');
    expect(terms.words, ['pérez']);
  });

  test('only digits search the last digits of an account', () {
    expect(SearchTerms.parse('4417').digits, '4417');
    expect(SearchTerms.parse('juan 44').digits, isNull);
    expect(SearchTerms.parse('4').digits, isNull);
  });

  test('transaction codes are read with or without the TX prefix', () {
    expect(SearchTerms.parse('TX-48219').transactionDigits, '48219');
    expect(SearchTerms.parse('tx48219').transactionDigits, '48219');
    expect(SearchTerms.parse('48219').transactionDigits, '48219');
    expect(SearchTerms.parse('juan').transactionDigits, isNull);
  });
}
