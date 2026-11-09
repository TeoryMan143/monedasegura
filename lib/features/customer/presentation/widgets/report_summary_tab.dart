import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatting/date_time.dart';
import '../../../../core/formatting/money.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/customer_report.dart';
import '../controllers/customer_report_controller.dart';

/// C-08 · «Resumen» of the customer report (HU-09): personal data, segment and risk, and
/// the labels and alerts of the range.
class ReportSummaryTab extends ConsumerWidget {
  const ReportSummaryTab({required this.customerId, super.key});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileProvider = customerReportProvider(customerId);
    final historyProvider = customerHistoryProvider(customerId);
    return ScreenState(
      value: ref.watch(profileProvider),
      onRetry: () => ref.invalidate(profileProvider),
      builder: (context, profile) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _PersonalData(profile: profile)),
                  const SizedBox(width: AppSpace.lg),
                  Expanded(child: _Profile(profile: profile)),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            ScreenState(
              value: ref.watch(historyProvider),
              onRetry: () => ref.invalidate(historyProvider),
              builder: (context, history) => IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _Labels(items: history.labels)),
                    const SizedBox(width: AppSpace.lg),
                    Expanded(child: _Alerts(items: history.alerts)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonalData extends StatelessWidget {
  const _PersonalData({required this.profile});

  final CustomerProfile profile;

  @override
  Widget build(BuildContext context) {
    final income = profile.declaredIncome;
    return AppPanel(
      title: 'Datos personales',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Field(
            'Documento',
            '${profile.documentType} ${profile.documentNumber}',
          ),
          _Field('Nacimiento', formatDate(profile.birthDate)),
          _Field('Ciudad', '${profile.cityName}, ${profile.countryName}'),
          _Field('Ocupación', profile.occupation ?? '—'),
          _Field(
            'Ingreso declarado',
            income == null ? '—' : formatMoney(income, profile.incomeCurrency),
          ),
          _Field('Correo', profile.email ?? '—'),
          _Field('Teléfono', profile.phone ?? '—'),
        ],
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile({required this.profile});

  final CustomerProfile profile;

  @override
  Widget build(BuildContext context) {
    final risk = profile.riskLevel;
    return AppPanel(
      title: 'Perfil',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              StatusBadge(
                label: profile.segment.label,
                tone: profile.segment.tone,
                icon: profile.segment.icon,
              ),
              StatusBadge(label: risk.label, tone: risk.tone, icon: risk.icon),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          _Field('Cliente desde', formatDate(profile.customerSince)),
        ],
      ),
    );
  }
}

class _Labels extends StatelessWidget {
  const _Labels({required this.items});

  final List<LabelHistoryItem> items;

  @override
  Widget build(BuildContext context) => AppPanel(
    title: 'Etiquetas en el rango',
    child: items.isEmpty
        ? const EmptyState(
            title: 'Sin etiquetas',
            message: 'Ninguna transacción del rango tiene etiqueta.',
          )
        : Column(
            children: [
              for (final item in items)
                _HistoryRow(
                  title: item.transactionCode,
                  detail: [
                    formatDate(item.occurredAt),
                    if (item.analystName case final name? when name.isNotEmpty)
                      name,
                  ].join(' · '),
                  badge: StatusBadge(
                    label: item.verdict.label,
                    tone: item.verdict.tone,
                    icon: item.verdict.icon,
                    small: true,
                  ),
                ),
            ],
          ),
  );
}

class _Alerts extends StatelessWidget {
  const _Alerts({required this.items});

  final List<AlertHistoryItem> items;

  @override
  Widget build(BuildContext context) => AppPanel(
    title: 'Alertas IA en el rango',
    child: items.isEmpty
        ? const EmptyState(
            title: 'Sin alertas',
            message: 'La IA no generó alertas en el rango.',
          )
        : Column(
            children: [
              for (final item in items)
                _HistoryRow(
                  title: '${item.code} · ${item.suggestedType.label}',
                  detail: formatDateTime(item.generatedAt),
                  leading: ScoreBadge(score: item.score),
                  badge: StatusBadge(
                    label: item.status.label,
                    tone: item.status.tone,
                    icon: item.status.icon,
                    small: true,
                  ),
                ),
            ],
          ),
  );
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.title,
    required this.detail,
    required this.badge,
    this.leading,
  });

  final String title;
  final String detail;
  final Widget badge;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final leading = this.leading;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Row(
        children: [
          if (leading != null) ...[leading, const SizedBox(width: AppSpace.sm)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.bodyMMedium),
                Text(
                  detail,
                  style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          badge,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(child: Text(value, style: AppText.bodyM)),
      ],
    ),
  );
}
