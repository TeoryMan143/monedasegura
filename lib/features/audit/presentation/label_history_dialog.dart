import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formatting/date_time.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import '../domain/audit_change.dart';
import '../domain/audit_entry.dart';
import 'controllers/label_history_controller.dart';

/// Opens N-03 for [transactionId], from «Ver historial» of the N-02 panel (HU-15).
/// [transactionCode] («TX-48219») goes under the title.
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

/// N-03 · Label history (HU-15): every change to the label of a transaction and to its
/// alerts, newest first, with «antes → después» per field. Read only.
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
      title: 'Historial de la etiqueta',
      subtitle: transactionCode,
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
        isEmpty: (entries) => entries.isEmpty,
        empty: const EmptyState(
          title: 'Sin cambios',
          message: 'Esta transacción aún no tiene cambios registrados.',
          icon: AppIcons.audit,
        ),
        builder: (context, entries) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, entry) in entries.indexed) ...[
              if (index > 0) const Divider(height: AppSpace.xxl),
              AuditEntryTile(entry: entry),
            ],
          ],
        ),
      ),
    );
  }
}

/// One change of N-03: who, what, when, and each field «antes → después».
class AuditEntryTile extends StatelessWidget {
  const AuditEntryTile({required this.entry, super.key});

  final AuditEntry entry;

  @override
  Widget build(BuildContext context) {
    final action = entry.action;
    final changes = auditChanges(entry);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(name: entry.analystName),
        const SizedBox(width: AppSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: AppSpace.sm,
                      runSpacing: AppSpace.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(entry.analystName, style: AppText.bodyMSemiBold),
                        StatusBadge(
                          label: [action.label, ?entry.alertCode].join(' · '),
                          tone: action.tone,
                          icon: action.icon,
                          small: true,
                        ),
                        if (entry.fromSession)
                          const StatusBadge(
                            label: 'En esta sesión',
                            tone: StatusTone.neutral,
                            small: true,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpace.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatRelative(entry.createdAt),
                        style: AppText.bodyS.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        formatDateTime(entry.createdAt),
                        style: AppText.bodyS.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (changes.isNotEmpty) ...[
                const SizedBox(height: AppSpace.sm),
                for (final change in changes) _ChangeRow(change: change),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ChangeRow extends StatelessWidget {
  const _ChangeRow({required this.change});

  final AuditChange change;

  @override
  Widget build(BuildContext context) {
    final secondary = AppText.bodyM.copyWith(color: AppColors.textSecondary);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(change.field, style: secondary)),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: change.before ?? '—', style: secondary),
                  TextSpan(text: '  →  ', style: secondary),
                  TextSpan(
                    text: change.after ?? '—',
                    style: AppText.bodyMMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
