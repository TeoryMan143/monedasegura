import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';

/// C-01 · Azul Icesi hero of the login: brand mark, eyebrow, headline, an illustrative
/// preview of the labeling table, three key numbers and the Icesi footer.
///
/// The preview hides itself when the window is too short (1280×720) so nothing scrolls.
class LoginHero extends StatelessWidget {
  const LoginHero({super.key});

  static const _previewMinHeight = 820.0;

  @override
  Widget build(BuildContext context) {
    const onBrandSoft = AppColors.textOnBrandSecondary;
    return ColoredBox(
      color: AppColors.bgBrand,
      child: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.all(AppSpace.x5l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandMark.onBrand(),
              const Spacer(),
              Text(
                'MESA DE ETIQUETADO',
                style: AppText.label.copyWith(color: onBrandSoft),
              ),
              const SizedBox(height: AppSpace.md),
              Text(
                'Cada etiqueta entrena una detección de fraude más precisa.',
                style: AppText.display.copyWith(color: AppColors.textOnBrand),
              ),
              const SizedBox(height: AppSpace.md),
              Text(
                'Revisa transacciones, verifica las alertas de la IA y construye el '
                'dataset con el que aprende el modelo.',
                style: AppText.bodyL.copyWith(color: onBrandSoft),
              ),
              if (constraints.maxHeight >= _previewMinHeight) ...[
                const SizedBox(height: AppSpace.x3l),
                const _Preview(),
              ],
              const SizedBox(height: AppSpace.x3l),
              const _KeyNumbers(),
              const Spacer(),
              Text(
                'Proyecto académico · Universidad Icesi',
                style: AppText.bodyS.copyWith(color: onBrandSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A static, illustrative slice of the transactions table.
class _Preview extends StatelessWidget {
  const _Preview();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: AppLayout.loginCardWidth + AppSpace.x4l,
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.modal,
      ),
      child: const Column(
        children: [
          _PreviewRow(
            name: 'Juan Pérez',
            meta: 'Transferencia · App móvil',
            score: 92,
            label: 'Fraude',
            tone: StatusTone.danger,
            icon: AppIcons.error,
          ),
          Divider(),
          _PreviewRow(
            name: 'María Fernanda Ruiz',
            meta: 'Compra · Tarjeta',
            score: 58,
            label: 'Incierto',
            tone: StatusTone.warning,
            icon: AppIcons.info,
          ),
          Divider(),
          _PreviewRow(
            name: 'Carlos Andrade',
            meta: 'Retiro · Cajero',
            score: 12,
            label: 'No fraude',
            tone: StatusTone.success,
            icon: AppIcons.check,
          ),
        ],
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.name,
    required this.meta,
    required this.score,
    required this.label,
    required this.tone,
    required this.icon,
  });

  final String name;
  final String meta;
  final int score;
  final String label;
  final StatusTone tone;
  final AppIcons icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.lg,
        vertical: AppSpace.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTableCell(value: name, meta: meta),
          ),
          StatusBadge(label: label, tone: tone, icon: icon),
          const SizedBox(width: AppSpace.md),
          ScoreBadge(score: score),
        ],
      ),
    );
  }
}

/// Three facts about the labeling desk.
class _KeyNumbers extends StatelessWidget {
  const _KeyNumbers();

  @override
  Widget build(BuildContext context) {
    const facts = [
      ('8', 'tipos de fraude'),
      ('6', 'países'),
      ('4', 'niveles de confianza'),
    ];
    return Wrap(
      spacing: AppSpace.x4l,
      runSpacing: AppSpace.md,
      children: [
        for (final (value, label) in facts)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppText.kpi.copyWith(color: AppColors.textOnBrand),
              ),
              Text(
                label,
                style: AppText.bodyS.copyWith(
                  color: AppColors.textOnBrandSecondary,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
