import 'package:flutter/material.dart';

import '../../../../core/formatting/date_time.dart';
import '../../../../core/formatting/money.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/customer_transaction.dart';
import '../../domain/security_event.dart';
import '../../domain/timeline_point.dart';
import 'activity_style.dart';

/// The side card of the timeline and the map (C-11, C-12): the detail of the clicked
/// transaction or security event. [onOpenTransaction] opens the transaction in the
/// customer view, where it can be labeled.
class ActivityDetailCard extends StatelessWidget {
  const ActivityDetailCard({
    required this.point,
    required this.onOpenTransaction,
    super.key,
  });

  final TimelinePoint? point;
  final ValueChanged<int> onOpenTransaction;

  @override
  Widget build(BuildContext context) => AppPanel(
    title: 'Detalle',
    child: switch (point) {
      null => Text(
        'Selecciona un punto para ver su detalle.',
        style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
      ),
      TransactionPoint(:final transaction, :final anomalies) => _Transaction(
        transaction: transaction,
        anomalies: anomalies,
        onOpen: () => onOpenTransaction(transaction.id),
      ),
      SecurityEventPoint(:final event) => _Event(event: event),
    },
  );
}

class _Transaction extends StatelessWidget {
  const _Transaction({
    required this.transaction,
    required this.anomalies,
    required this.onOpen,
  });

  final CustomerTransaction transaction;
  final Set<ActivityAnomaly> anomalies;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(child: Text(transaction.code, style: AppText.h3)),
          if (transaction.alertScore case final score?)
            ScoreBadge(score: score),
        ],
      ),
      const SizedBox(height: AppSpace.sm),
      StatusBadge(
        label: transaction.labelText,
        tone: transaction.labelTone,
        icon: transaction.labelIcon,
      ),
      const SizedBox(height: AppSpace.md),
      _Field('Fecha', formatDateTime(transaction.occurredAt)),
      _Field(
        'Tipo · canal',
        '${transaction.type.label} · ${transaction.channel.label}',
      ),
      _Field('Monto', formatMoney(transaction.amount, transaction.currency)),
      if (transaction.merchantName case final merchant?)
        _Field('Comercio', merchant),
      _Field('Ciudad', transaction.cityName ?? 'Sin ubicación'),
      if (anomalies.isNotEmpty) ...[
        const SizedBox(height: AppSpace.xs),
        Wrap(
          spacing: AppSpace.xs,
          runSpacing: AppSpace.xs,
          children: [
            for (final anomaly in ActivityAnomaly.values)
              if (anomalies.contains(anomaly))
                StatusBadge(
                  label: anomaly.label,
                  tone: anomaly.tone,
                  icon: anomaly.icon,
                  small: true,
                ),
          ],
        ),
      ],
      const SizedBox(height: AppSpace.lg),
      AppButton(
        label: 'Abrir en la vista de cliente',
        variant: AppButtonVariant.secondary,
        trailingIcon: AppIcons.externalLink,
        expand: true,
        onPressed: onOpen,
      ),
    ],
  );
}

class _Event extends StatelessWidget {
  const _Event({required this.event});

  final SecurityEvent event;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Evento de seguridad', style: AppText.h3),
      const SizedBox(height: AppSpace.sm),
      StatusBadge(
        label: event.type.label,
        tone: event.type.tone,
        icon: event.type.icon,
      ),
      const SizedBox(height: AppSpace.md),
      _Field('Fecha', formatDateTime(event.occurredAt)),
      _Field('Resultado', event.succeeded ? 'Exitoso' : 'Fallido'),
      if (event.channel case final channel?) _Field('Canal', channel.label),
      _Field('Ciudad', event.cityName ?? 'Sin ubicación'),
    ],
  );
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpace.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.bodyS.copyWith(color: AppColors.textTertiary),
        ),
        Text(value, style: AppText.bodyM),
      ],
    ),
  );
}
