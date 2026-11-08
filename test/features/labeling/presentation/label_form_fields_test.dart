import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/catalogs/catalog_repository.dart';
import 'package:monedasegura/core/catalogs/fake_catalog_repository.dart';
import 'package:monedasegura/core/domain/confidence_level.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/core/domain/severity.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/features/labeling/domain/label_form.dart';
import 'package:monedasegura/features/labeling/domain/label_validator.dart';
import 'package:monedasegura/features/labeling/presentation/widgets/label_form_fields.dart';

/// Holds the form like a caller's controller would.
class _Host extends StatefulWidget {
  const _Host({
    required this.initial,
    this.showErrors = false,
    this.lockVerdict = false,
    this.lockedFraudTypes = const {},
  });

  final LabelForm initial;
  final bool showErrors;
  final bool lockVerdict;
  final Set<FraudType> lockedFraudTypes;

  @override
  State<_Host> createState() => _HostState();
}

late LabelForm current;
late List<LabelField> changes;

class _HostState extends State<_Host> {
  late LabelForm _form = widget.initial;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: LabelFormFields(
      form: _form,
      errors: widget.showErrors ? validateLabel(_form) : const {},
      lockVerdict: widget.lockVerdict,
      lockedFraudTypes: widget.lockedFraudTypes,
      onChanged: (form, field) => setState(() {
        _form = current = form;
        changes.add(field);
      }),
    ),
  );
}

void main() {
  setUpAll(() async {
    final font = FontLoader(AppText.fontFamily);
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      font.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
    }
    await font.load();
  });

  Future<void> pump(WidgetTester tester, _Host host) async {
    current = host.initial;
    changes = [];
    tester.view
      ..physicalSize = const Size(400, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(FakeCatalogRepository()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: host),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  Future<void> tapChip(WidgetTester tester, FraudType type) async {
    await tester.tap(find.textContaining(type.code, findRichText: true));
    await tester.pumpAndSettle();
  }

  testWidgets('No fraude shows no types and no severity', (tester) async {
    await pump(
      tester,
      const _Host(initial: LabelForm(verdict: Verdict.notFraud)),
    );

    expect(
      find.textContaining('Tipo(s) de fraude', findRichText: true),
      findsNothing,
    );
    expect(find.textContaining('Severidad', findRichText: true), findsNothing);
    expect(
      find.textContaining('Nivel de confianza', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Justificación', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('choosing No fraude clears the types and the severity', (
    tester,
  ) async {
    await pump(
      tester,
      const _Host(
        initial: LabelForm(
          verdict: Verdict.fraud,
          fraudTypes: [FraudType.phishing],
          severity: Severity.high,
        ),
      ),
    );
    expect(
      find.textContaining('Severidad', findRichText: true),
      findsOneWidget,
    );

    await tapText(tester, 'No fraude');

    expect(current.verdict, Verdict.notFraud);
    expect(current.fraudTypes, isEmpty);
    expect(current.severity, isNull);
    expect(changes, [LabelField.verdict]);
    expect(
      find.textContaining('Tipo(s) de fraude', findRichText: true),
      findsNothing,
    );
  });

  testWidgets('reports each change with its field', (tester) async {
    await pump(tester, const _Host(initial: LabelForm()));

    await tapText(tester, 'Fraude');
    await tapText(tester, 'Media');
    await tester.enterText(find.byType(TextField), 'Dispositivo nuevo');
    await tester.pumpAndSettle();

    expect(current.verdict, Verdict.fraud);
    expect(current.confidence, ConfidenceLevel.medium);
    expect(current.justification, 'Dispositivo nuevo');
    expect(changes, [
      LabelField.verdict,
      LabelField.confidence,
      LabelField.justification,
    ]);
  });

  testWidgets('shows the errors it receives', (tester) async {
    await pump(
      tester,
      const _Host(initial: LabelForm(verdict: Verdict.fraud), showErrors: true),
    );

    expect(find.text('Elige al menos un tipo de fraude.'), findsOneWidget);
    expect(find.text('Elige una severidad.'), findsOneWidget);
    expect(find.text('Elige un nivel de confianza.'), findsOneWidget);
  });

  testWidgets('A-06 «Rechazar»: a locked verdict does not change', (
    tester,
  ) async {
    await pump(
      tester,
      const _Host(
        initial: LabelForm(verdict: Verdict.notFraud),
        lockVerdict: true,
      ),
    );

    await tapText(tester, 'Fraude');

    expect(current.verdict, Verdict.notFraud);
    expect(changes, isEmpty);
  });

  testWidgets(
    'A-06 «Confirmar»: the suggested type stays, others can be added',
    (tester) async {
      await pump(
        tester,
        const _Host(
          initial: LabelForm(
            verdict: Verdict.fraud,
            fraudTypes: [FraudType.accountTakeover],
          ),
          lockVerdict: true,
          lockedFraudTypes: {FraudType.accountTakeover},
        ),
      );

      await tapChip(tester, FraudType.accountTakeover);
      expect(current.fraudTypes, [FraudType.accountTakeover]);

      await tapChip(tester, FraudType.phishing);
      expect(current.fraudTypes, [
        FraudType.accountTakeover,
        FraudType.phishing,
      ]);
    },
  );
}
