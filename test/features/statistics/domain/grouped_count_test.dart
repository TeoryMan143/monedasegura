import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/statistics/domain/grouped_count.dart';

void main() {
  test('reads a group from a row of the database', () {
    final group = GroupedCount.fromJson({'key': 'WEB', 'count': 120});

    expect(group.key, 'WEB');
    expect(group.count, 120);
  });

  test('two groups with the same values are equal', () {
    expect(
      const GroupedCount(key: 'ATO', count: 7),
      const GroupedCount(key: 'ATO', count: 7),
    );
  });
}
