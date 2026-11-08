import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formatting/date_time.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import '../domain/audit_change.dart';
import '../domain/audit_entry.dart';
import '../domain/label_history.dart';
import 'controllers/label_history_controller.dart';

/// Opens N-03 for [transactionId], from «Ver historial» of the N-02 panel (HU-15).
/// [transactionCode] («TX-48219») goes in the title.
Future<void> showLabelHistoryDialog({
  required BuildContext context,
  required int transactionId,
  String? transactionCode,
}) => showAppDialog<void>(
  context: context,
  builder: (context) => LabelHistoryDialog(
    transactionId: transactionId,
    transactionCode: transactionCode,
  ),
);

/// N-03 · Label history (Figma `2009:6567`, HU-15): every change to the label of a
/// transaction and to its alerts, newest first, one card each with «antes → después»
/// per field, and the AI alerts that flagged it. Read only.
class LabelHistoryDialog extends ConsumerWidget {
  const LabelHistoryDialog({
    required this.transactionId,
    this.transactionCode,
    super.key,
  });

  final int transactionId;
  final String? transactionCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = labelHistoryProvider(transactionId);
    return AppDialog(
      title: ['Historial de la etiqueta', ?transactionCode].join(' · '),
      subtitle:
          'Cambios registrados en auditoría. No se pueden editar ni borrar.',
      actions: [
        AppButton(
          label: 'Cerrar',
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ],
      body: ScreenState(
        value: ref.watch(provider),
        onRetry: () => ref.invalidate(provider),
        errorTitle: 'No se pudo cargar el historial',
        builder: (context, history) => _History(history: history),
      ),
    );
  }
}

class _History extends StatelessWidget {
  const _History({required this.history});

  final LabelHistory history;

  @override
  Widget build(BuildContext context) {
    final entries = history.entries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (entries.isEmpty)
          const EmptyState(
            title: 'Sin cambios',
            message: 'Esta transacción aún no tiene cambios registrados.',
            icon: AppIcons.audit,
          ),
        for (final (index, entry) in entries.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpace.md),
          AuditEntryCard(entry: entry),
        ],
        for (final alert in history.alerts) ...[
          const SizedBox(height: AppSpace.lg),
          Text(
            'Alerta ${alert.code} · generada por la IA el '
            '${formatShortDate(alert.generatedAt)} '
            '${formatTime(alert.generatedAt)} (score ${alert.score})',
            style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }
}

/// One change of N-03: who, when and what, and each field «antes → después».
class AuditEntryCard extends StatelessWidget {
  const AuditEntryCard({required this.entry, super.key});

  final AuditEntry entry;

  @override
  Widget build(BuildContext context) {
    final action = entry.action;
    final changes = auditChanges(entry);
    return Container(
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border.all(color: AppColors.borderSubtle),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(name: entry.analystName, small: true),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.analystName, style: AppText.bodyMSemiBold),
                    Text(
                      '${formatRelative(entry.createdAt)} · '
                      '${formatDateTime(entry.createdAt)}',
                      style: AppText.bodyS.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Wrap(
                spacing: AppSpace.xs,
                runSpacing: AppSpace.xs,
                alignment: WrapAlignment.end,
                children: [
                  if (entry.fromSession)
                    const StatusBadge(
                      label: 'En esta sesión',
                      tone: StatusTone.neutral,
                      small: true,
                    ),
                  StatusBadge(
                    label: [action.label, ?entry.alertCode].join(' · '),
                    tone: action.tone,
                    icon: action.icon,
                    small: true,
                  ),
                ],
              ),
            ],
          ),
          if (changes.isNotEmpty) ...[
            const SizedBox(height: AppSpace.md),
            for (final change in changes) _ChangeRow(change: change),
          ],
        ],
      ),
    );
  }
}

class _ChangeRow extends StatelessWidget {
  const _ChangeRow({required this.change});

  final AuditChange change;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              change.field,
              style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: change.before ?? '—'),
                  const TextSpan(text: ' → '),
                  TextSpan(
                    text: change.after ?? '—',
                    style: AppText.bodySSemiBold,
                  ),
                ],
              ),
              style: AppText.bodyS,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
