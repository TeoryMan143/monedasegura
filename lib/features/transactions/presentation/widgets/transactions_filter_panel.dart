import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/catalogs/catalog_providers.dart';
import '../../../../core/domain/label_status.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/transactions_query.dart';
import '../controllers/transactions_query_controller.dart';

/// Opens N-01 over A-01.
Future<void> showTransactionsFilterPanel(BuildContext context) =>
    showSidePanel<void>(
      context: context,
      builder: (context) => const TransactionsFilterPanel(),
    );

/// N-01 · Filter panel of the transaction list (HU-02).
///
/// Edits a draft of the filters: nothing changes in the list until «Aplicar filtros».
/// «Limpiar todo» empties the draft. The search stays as it is: it has its own field.
class TransactionsFilterPanel extends ConsumerStatefulWidget {
  const TransactionsFilterPanel({super.key});

  @override
  ConsumerState<TransactionsFilterPanel> createState() =>
      _TransactionsFilterPanelState();
}

class _TransactionsFilterPanelState
    extends ConsumerState<TransactionsFilterPanel> {
  late TransactionsQuery _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(transactionsQueryProvider);
  }

  void _update(TransactionsQuery draft) => setState(() => _draft = draft);

  void _clear() => _update(
    _draft
        .without(TransactionsFilter.dateRange)
        .without(TransactionsFilter.country)
        .without(TransactionsFilter.channel)
        .without(TransactionsFilter.labelStatus)
        .without(TransactionsFilter.aiAlert),
  );

  void _apply() {
    final draft = _draft;
    ref
        .read(transactionsQueryProvider.notifier)
        .setFilter(
          (query) => query.copyWith(
            dateFrom: draft.dateFrom,
            dateTo: draft.dateTo,
            countryCode: draft.countryCode,
            channelCodes: draft.channelCodes,
            labelStatus: draft.labelStatus,
            withAiAlert: draft.withAiAlert,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final active = _draft.activeFilters
        .where((filter) => filter != TransactionsFilter.search)
        .length;

    return SidePanel(
      title: 'Filtros',
      headerTrailing: active == 0
          ? null
          : Text(
              active == 1 ? '1 activo' : '$active activos',
              style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
            ),
      onClose: () => Navigator.of(context).pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DateRangeField(
            from: _draft.dateFrom,
            to: _draft.dateTo,
            onChanged: (range) => _update(
              _draft.copyWith(dateFrom: range?.start, dateTo: range?.end),
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          _CountryField(
            value: _draft.countryCode,
            onChanged: (code) => _update(_draft.copyWith(countryCode: code)),
          ),
          const SizedBox(height: AppSpace.lg),
          _ChannelField(
            selected: _draft.channelCodes,
            onChanged: (codes) => _update(_draft.copyWith(channelCodes: codes)),
          ),
          const SizedBox(height: AppSpace.lg),
          AppSegmented<LabelStatus?>(
            label: 'Estado de etiqueta',
            value: _draft.labelStatus,
            segments: [
              const AppSegment(value: null, label: 'Todas'),
              for (final status in LabelStatus.values)
                AppSegment(value: status, label: status.label),
            ],
            onChanged: (status) =>
                _update(_draft.copyWith(labelStatus: status)),
          ),
          const SizedBox(height: AppSpace.lg),
          const FieldLabel('Alerta de IA'),
          const SizedBox(height: AppSpace.sm),
          AppCheckbox(
            value: _draft.withAiAlert,
            label: 'Solo transacciones con alerta de IA',
            onChanged: (value) => _update(_draft.copyWith(withAiAlert: value)),
          ),
        ],
      ),
      footer: Row(
        children: [
          AppButton(
            label: 'Limpiar todo',
            variant: AppButtonVariant.secondary,
            onPressed: active == 0 ? null : _clear,
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: AppButton(
              label: 'Aplicar filtros',
              icon: AppIcons.check,
              expand: true,
              onPressed: _apply,
            ),
          ),
        ],
      ),
    );
  }
}

/// «Rango de fechas»: opens the date range picker; × removes the range.
class _DateRangeField extends StatelessWidget {
  const _DateRangeField({
    required this.from,
    required this.to,
    required this.onChanged,
  });

  final DateTime? from;
  final DateTime? to;
  final ValueChanged<DateTimeRange?> onChanged;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final from = this.from;
    final to = this.to;
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: from == null || to == null
          ? null
          : DateTimeRange(start: from, end: to),
      helpText: 'Rango de fechas',
      saveText: 'Aplicar',
    );
    if (range != null) onChanged(range);
  }

  @override
  Widget build(BuildContext context) {
    final text = formatDateRange(from, to);
    return AppTextField(
      // The text only changes through the picker, so a new value rebuilds the field.
      key: ValueKey(text),
      label: 'Rango de fechas',
      initialValue: text,
      hint: 'Todas las fechas',
      variant: AppTextFieldVariant.date,
      readOnly: true,
      onTap: () => _pick(context),
      suffix: text.isEmpty
          ? null
          : AppIconButton(
              icon: AppIcons.close,
              tooltip: 'Quitar rango de fechas',
              small: true,
              onPressed: () => onChanged(null),
            ),
      semanticLabel: 'Rango de fechas',
    );
  }
}

/// «País»: the countries of the catalog, or «Todos».
class _CountryField extends ConsumerWidget {
  const _CountryField({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countries = ref.watch(countriesProvider).value ?? const [];
    return AppDropdown<String?>(
      label: 'País',
      value: value,
      hint: 'Todos',
      items: [
        const AppDropdownItem(value: null, label: 'Todos'),
        for (final country in countries)
          AppDropdownItem(value: country.code, label: country.name),
      ],
      onChanged: onChanged,
    );
  }
}

/// «Canal»: one checkbox per channel of the catalog; a transaction matches any of them.
class _ChannelField extends ConsumerWidget {
  const _ChannelField({required this.selected, required this.onChanged});

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channels = ref.watch(channelsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Canal'),
        const SizedBox(height: AppSpace.sm),
        switch (channels) {
          AsyncValue(hasError: true) => const FieldMessage(
            'No se pudieron cargar los canales.',
            isError: true,
          ),
          AsyncValue(:final value?) => Wrap(
            spacing: AppSpace.lg,
            runSpacing: AppSpace.sm,
            children: [
              for (final channel in value)
                AppCheckbox(
                  value: selected.contains(channel.code),
                  label: channel.name,
                  onChanged: (checked) => onChanged(
                    checked
                        ? {...selected, channel.code}
                        : selected.difference({channel.code}),
                  ),
                ),
            ],
          ),
          _ => Text(
            'Cargando canales…',
            style: AppText.bodyS.copyWith(color: AppColors.textTertiary),
          ),
        },
      ],
    );
  }
}
