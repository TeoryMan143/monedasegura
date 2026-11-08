import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/currency.dart';
import '../../../../core/formatting/money.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/customer_report.dart';
import '../../domain/range_totals.dart';
import '../controllers/customer_report_controller.dart';

/// What the bars measure. Count and amount never share an axis: one at a time.
enum _Metric { amount, count }

/// «Actividad por mes» of the report summary (C-08, HU-09): one bar per month, with the
/// amount or the number of transactions. The tooltip of a bar shows both.
///
/// The totals come added up from the database (`customer_monthly_activity`). With more
/// than one currency, a selector picks which one to show: amounts in different
/// currencies are never added together.
class ReportActivityChart extends ConsumerStatefulWidget {
  const ReportActivityChart({required this.customerId, super.key});

  final String customerId;

  @override
  ConsumerState<ReportActivityChart> createState() =>
      _ReportActivityChartState();
}

class _ReportActivityChartState extends ConsumerState<ReportActivityChart> {
  _Metric _metric = _Metric.amount;
  Currency? _currency;

  @override
  Widget build(BuildContext context) {
    final provider = customerMonthlyActivityProvider(widget.customerId);
    final value = ref.watch(provider);
    final currencies = [
      ...{
        for (final row in value.value ?? const <MonthlyActivity>[])
          row.currency,
      },
    ];
    final currency = currencies.contains(_currency)
        ? _currency
        : currencies.firstOrNull;

    return AppPanel(
      title: 'Actividad por mes',
      subtitle: 'Transacciones del cliente en el rango',
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currencies.length > 1) ...[
            AppSegmented<Currency>(
              small: true,
              expand: false,
              value: currency,
              onChanged: (value) => setState(() => _currency = value),
              segments: [
                for (final item in currencies)
                  AppSegment(value: item, label: item.code),
              ],
            ),
            const SizedBox(width: AppSpace.sm),
          ],
          AppSegmented<_Metric>(
            small: true,
            expand: false,
            value: _metric,
            onChanged: (value) => setState(() => _metric = value),
            segments: const [
              AppSegment(value: _Metric.amount, label: 'Monto'),
              AppSegment(value: _Metric.count, label: 'Cantidad'),
            ],
          ),
        ],
      ),
      child: ScreenState(
        value: value,
        onRetry: () => ref.invalidate(provider),
        isEmpty: (rows) => rows.isEmpty,
        empty: const EmptyState(
          title: 'Sin actividad en el rango',
          message: 'El cliente no tiene transacciones en estas fechas.',
          icon: AppIcons.statistics,
        ),
        builder: (context, rows) => SizedBox(
          height: 240,
          child: _Bars(
            rows: [
              for (final row in rows)
                if (row.currency == currency) row,
            ],
            metric: _metric,
          ),
        ),
      ),
    );
  }
}

class _Bars extends StatelessWidget {
  const _Bars({required this.rows, required this.metric});

  /// One currency, oldest month first.
  final List<MonthlyActivity> rows;
  final _Metric metric;

  double _value(MonthlyActivity row) => switch (metric) {
    _Metric.amount => row.totalAmount,
    _Metric.count => row.transactionCount.toDouble(),
  };

  String _axis(double value) => switch (metric) {
    _Metric.amount => compactMoney(value, rows.first.currency),
    _Metric.count => NumberFormat.compact(locale: 'es').format(value),
  };

  @override
  Widget build(BuildContext context) {
    final month = DateFormat('MMM yy', 'es');
    final count = NumberFormat.decimalPattern('es');
    final axisStyle = AppText.bodyS.copyWith(color: AppColors.textSecondary);
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        minY: 0,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: AppColors.borderSubtle, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 72,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                meta: meta,
                child: Text(_axis(value), style: axisStyle),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                meta: meta,
                child: Text(
                  month.format(rows[value.toInt()].month),
                  style: axisStyle,
                ),
              ),
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AppColors.gris900,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final row = rows[group.x];
              return BarTooltipItem(
                '${DateFormat('MMMM yyyy', 'es').format(row.month)}\n',
                AppText.bodySSemiBold.copyWith(color: AppColors.textOnBrand),
                children: [
                  TextSpan(
                    text:
                        '${count.format(row.transactionCount)} transacciones\n'
                        '${formatMoney(row.totalAmount, row.currency)}',
                    style: AppText.bodyS.copyWith(color: AppColors.textOnBrand),
                  ),
                ],
              );
            },
          ),
        ),
        barGroups: [
          for (var i = 0; i < rows.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: _value(rows[i]),
                  width: 20,
                  color: AppColors.azul500,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
