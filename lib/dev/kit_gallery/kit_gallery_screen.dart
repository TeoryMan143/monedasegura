import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/ui/kit.dart';
import 'kit_gallery_data_section.dart';
import 'kit_gallery_overlays_section.dart';

/// Dev gallery of the `core/ui` kit (run `lib/main_kit.dart`).
///
/// Inspired by a widget catalog: each panel shows one family of components with its
/// variants and states, wired to local state so they can be tried with mouse and
/// keyboard. Local `setState` is fine here: this is a demo, not a feature.
class KitGalleryScreen extends StatefulWidget {
  const KitGalleryScreen({super.key});

  @override
  State<KitGalleryScreen> createState() => _KitGalleryScreenState();
}

class _KitGalleryScreenState extends State<KitGalleryScreen> {
  String _verdict = 'fraud';
  int _confidence = 3;
  bool? _check = true;
  int _tab = 0;
  String _sortBy = 'date';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppLayout.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BrandMark(),
            const SizedBox(height: AppSpace.lg),
            Text('Kit de componentes', style: AppText.h1),
            Text(
              'core/ui · Figma Componentes 4:3',
              style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppLayout.blockGap),
            _buttons(),
            const SizedBox(height: AppLayout.blockGap),
            _fields(),
            const SizedBox(height: AppLayout.blockGap),
            _status(),
            const SizedBox(height: AppLayout.blockGap),
            _navigation(),
            const SizedBox(height: AppLayout.blockGap),
            const KitGalleryDataSection(),
            const SizedBox(height: AppLayout.blockGap),
            const KitGalleryOverlaysSection(),
          ],
        ),
      ),
    );
  }

  Widget _buttons() {
    void noop() {}
    return AppPanel(
      title: 'Botones',
      subtitle: 'AppButton · AppIconButton',
      child: Wrap(
        spacing: AppSpace.md,
        runSpacing: AppSpace.md,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          AppButton(label: 'Guardar etiqueta', onPressed: noop),
          AppButton(
            label: 'Filtros',
            icon: AppIcons.filter,
            variant: AppButtonVariant.secondary,
            onPressed: noop,
          ),
          AppButton(
            label: 'Ver historial',
            variant: AppButtonVariant.tertiary,
            onPressed: noop,
          ),
          AppButton(
            label: 'Rechazar',
            variant: AppButtonVariant.danger,
            onPressed: noop,
          ),
          AppButton(label: 'Guardando', loading: true, onPressed: noop),
          const AppButton(label: 'Deshabilitado', onPressed: null),
          AppButton(
            label: 'Tamaño S',
            size: AppButtonSize.s,
            variant: AppButtonVariant.secondary,
            onPressed: noop,
          ),
          AppIconButton(
            icon: AppIcons.close,
            tooltip: 'Cerrar',
            onPressed: noop,
          ),
          AppIconButton(
            icon: AppIcons.moreOptions,
            tooltip: 'Más opciones',
            variant: AppIconButtonVariant.secondary,
            onPressed: noop,
          ),
        ],
      ),
    );
  }

  Widget _fields() {
    return AppPanel(
      title: 'Campos',
      subtitle: 'AppTextField · AppDropdown · AppTextArea · AppCheckbox · AppSegmented',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Correo',
                  hint: 'nombre@monedasegura.co',
                  required: true,
                ),
              ),
              SizedBox(width: AppSpace.lg),
              Expanded(
                child: AppTextField(
                  label: 'Monto',
                  initialValue: '1.900.000',
                  variant: AppTextFieldVariant.amount,
                  errorText: 'El monto debe ser mayor que cero.',
                ),
              ),
              SizedBox(width: AppSpace.lg),
              Expanded(
                child: AppTextField(
                  label: 'Contraseña',
                  variant: AppTextFieldVariant.password,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: AppTextField(
                  hint: 'Buscar por cliente, cuenta o ID',
                  semanticLabel: 'Buscar transacciones',
                  variant: AppTextFieldVariant.search,
                ),
              ),
              const SizedBox(width: AppSpace.lg),
              const Expanded(
                child: AppTextField(
                  label: 'Desde',
                  initialValue: '03 mar 2026',
                  variant: AppTextFieldVariant.date,
                  readOnly: true,
                ),
              ),
              const SizedBox(width: AppSpace.lg),
              Expanded(
                child: AppDropdown<String>(
                  label: 'Ordenar por',
                  value: _sortBy,
                  onChanged: (value) => setState(() => _sortBy = value),
                  items: const [
                    AppDropdownItem(value: 'date', label: 'Fecha'),
                    AppDropdownItem(value: 'amount', label: 'Monto'),
                    AppDropdownItem(value: 'score', label: 'Score IA'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppSegmented<String>(
                  label: 'Veredicto',
                  required: true,
                  value: _verdict,
                  onChanged: (value) => setState(() => _verdict = value),
                  segments: const [
                    AppSegment(value: 'fraud', label: 'Fraude'),
                    AppSegment(value: 'not_fraud', label: 'No fraude'),
                    AppSegment(value: 'uncertain', label: 'Incierto'),
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.lg),
              Expanded(
                child: AppSegmented<int>(
                  label: 'Nivel de confianza',
                  value: _confidence,
                  onChanged: (value) => setState(() => _confidence = value),
                  segments: const [
                    AppSegment(
                      value: 1,
                      label: 'Baja',
                      description:
                          'Hay pocos indicios; requiere justificación.',
                    ),
                    AppSegment(
                      value: 2,
                      label: 'Media',
                      description: 'Algunos indicios apuntan al veredicto.',
                    ),
                    AppSegment(
                      value: 3,
                      label: 'Alta',
                      description:
                          'Varios indicios claros sostienen el veredicto.',
                    ),
                    AppSegment(
                      value: 4,
                      label: 'Muy alta',
                      description: 'Evidencia concluyente.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: AppTextArea(
                  label: 'Justificación',
                  hint: 'Describe los indicios que respaldan el veredicto',
                  helperText:
                      'Obligatoria con confianza Baja o veredicto Incierto.',
                ),
              ),
              const SizedBox(width: AppSpace.lg),
              Expanded(
                child: Wrap(
                  spacing: AppSpace.lg,
                  runSpacing: AppSpace.sm,
                  children: [
                    AppCheckbox(
                      value: _check,
                      label: 'Con alerta IA (pulsa para cambiar)',
                      onChanged: (value) => setState(() => _check = value),
                    ),
                    AppCheckbox(
                      value: null,
                      label: 'Indeterminado',
                      onChanged: (_) {},
                    ),
                    const AppCheckbox(
                      value: false,
                      label: 'Deshabilitado',
                      onChanged: null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _status() {
    return AppPanel(
      title: 'Estados y datos',
      subtitle: 'StatusBadge · ScoreBadge · ScoreMeter · ProgressBar · chips · SaveStatus · InlineBanner',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              StatusBadge(
                label: 'Fraude',
                tone: StatusTone.danger,
                icon: AppIcons.error,
              ),
              StatusBadge(
                label: 'No fraude',
                tone: StatusTone.success,
                icon: AppIcons.check,
              ),
              StatusBadge(
                label: 'Incierto',
                tone: StatusTone.warning,
                icon: AppIcons.info,
              ),
              StatusBadge(
                label: 'Sin etiquetar',
                tone: StatusTone.neutral,
                icon: AppIcons.clock,
              ),
              StatusBadge(
                label: 'Alerta IA',
                tone: StatusTone.info,
                icon: AppIcons.ai,
              ),
              StatusBadge(label: 'Alta', tone: StatusTone.high, small: true),
              StatusBadge(label: '12', tone: StatusTone.brand, small: true),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          const Row(
            children: [
              ScoreBadge(score: 12),
              SizedBox(width: AppSpace.sm),
              ScoreBadge(score: 55),
              SizedBox(width: AppSpace.sm),
              ScoreBadge(score: 78),
              SizedBox(width: AppSpace.sm),
              ScoreBadge(score: 92),
              SizedBox(width: AppSpace.lg),
              ScoreBadge.large(score: 92),
              SizedBox(width: AppSpace.xxl),
              SizedBox(width: 320, child: ScoreMeter(score: 92)),
              SizedBox(width: AppSpace.xxl),
              ProgressBar(done: 42, total: 60),
              SizedBox(width: AppSpace.xxl),
              AppAvatar(name: 'Laura Gómez'),
              SizedBox(width: AppSpace.sm),
              AppAvatar(name: 'Juan Pérez', small: true),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppFilterChip(
                label: 'Etiqueta',
                value: 'Sin etiquetar',
                onRemove: () {},
              ),
              AppFilterChip(label: 'País', value: 'Colombia', onRemove: () {}),
              const TaxonomyChip(
                code: 'ATO',
                name: 'Robo de cuenta',
                color: AppColors.rojo500,
              ),
              TaxonomyChip(
                code: 'PHI',
                name: 'Phishing',
                color: AppColors.morado500,
                selected: true,
                onTap: () {},
              ),
              TaxonomyChip(
                code: 'CLO',
                name: 'Tarjeta clonada',
                color: AppColors.naranja500,
                onRemove: () {},
              ),
              const SaveStatus(state: SaveState.saving),
              const SaveStatus(state: SaveState.saved),
              SaveStatus(state: SaveState.error, onRetry: () {}),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          const InlineBanner(
            tone: StatusTone.warning,
            title: 'TX-77120 ya tiene una etiqueta',
            message: 'La puso Laura Gómez el 03 mar 2026. Si la cambias, queda en el historial.',
          ),
          const SizedBox(height: AppSpace.sm),
          const InlineBanner(
            tone: StatusTone.danger,
            title: 'Viaje imposible',
            message: 'Bogotá → Madrid en 47 min (≈ 10.200 km/h).',
          ),
        ],
      ),
    );
  }

  Widget _navigation() {
    return AppPanel(
      title: 'Navegación',
      subtitle: 'AppTabs · Breadcrumbs · AppMenu',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Breadcrumbs(
            items: [
              Breadcrumb('Transacciones', onTap: () {}),
              Breadcrumb('Juan Pérez', onTap: () {}),
              const Breadcrumb('Reporte'),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          AppTabs(
            selectedIndex: _tab,
            onChanged: (index) => setState(() => _tab = index),
            tabs: const [
              AppTab(label: 'Resumen'),
              AppTab(label: 'Cuentas', count: 3),
              AppTab(label: 'Línea de tiempo'),
              AppTab(label: 'Mapa'),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Align(
            alignment: Alignment.centerLeft,
            child: AppMenu(
              entries: [
                AppMenuAction(
                  label: 'Ver perfil',
                  icon: AppIcons.user,
                  onSelected: () {},
                ),
                AppMenuAction(
                  label: 'Exportar PDF',
                  icon: AppIcons.download,
                  detail: 'Ctrl P',
                  onSelected: () {},
                ),
                const AppMenuDivider(),
                AppMenuAction(
                  label: 'Rechazar',
                  destructive: true,
                  onSelected: () {},
                ),
              ],
              builder: (context, controller) => AppButton(
                label: 'Abrir menú',
                trailingIcon: AppIcons.chevronDown,
                variant: AppButtonVariant.secondary,
                onPressed: controller.toggle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
