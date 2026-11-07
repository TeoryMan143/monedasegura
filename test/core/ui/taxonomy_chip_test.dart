import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/catalog_models.dart';
import 'package:monedasegura/core/ui/kit.dart';

import '../../helpers/kit_harness.dart';

void main() {
  testWidgets('a catalog row sets the code, the name and the colour', (
    tester,
  ) async {
    const type = CatalogFraudType(
      id: 1,
      code: 'ATO',
      name: 'Robo de cuenta',
      description: 'Un tercero toma control de la cuenta.',
      colorHex: '#D93B3B',
    );

    await pumpKit(tester, Center(child: TaxonomyChip.fromCatalog(type)));

    final chip = tester.widget<TaxonomyChip>(find.byType(TaxonomyChip));
    expect(chip.code, 'ATO');
    expect(chip.name, 'Robo de cuenta');
    expect(chip.color, const Color(0xFFD93B3B));
    expect(find.textContaining('Robo de cuenta'), findsOneWidget);
  });
}
