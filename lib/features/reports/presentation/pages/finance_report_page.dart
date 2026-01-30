import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../application/providers/finance_report_provider.dart';
import '../../domain/entities/report_filters.dart';
import '../../data/services/pdf_export_service.dart';
import '../../data/services/excel_export_service.dart';

class FinanceReportPage extends ConsumerStatefulWidget {
  const FinanceReportPage({super.key});

  @override
  ConsumerState<FinanceReportPage> createState() => _FinanceReportPageState();
}

class _FinanceReportPageState extends ConsumerState<FinanceReportPage> {
  late DateTime startDate;
  late DateTime endDate;
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  void initState() {
    super.initState();
    endDate = DateTime.now();
    startDate = endDate.subtract(const Duration(days: 30));

    Future.microtask(() {
      ref
          .read(financeReportProvider.notifier)
          .generateReport(
            ReportFilters(startDate: startDate, endDate: endDate),
          );
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });

      ref
          .read(financeReportProvider.notifier)
          .generateReport(
            ReportFilters(startDate: startDate, endDate: endDate),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(financeReportProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.surface,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(
              'Laporan Keuangan',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (!state.isLoading && state.report != null) ...[
                IconButton(
                  onPressed: () async {
                    try {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuat PDF...')),
                      );

                      final pdfService = ref.read(pdfExportServiceProvider);
                      final file = await pdfService.exportFinanceReport(
                        state.report!,
                      );

                      if (mounted) {
                        if (!kIsWeb) {
                          final bytes = await file.readAsBytes();
                          await Printing.sharePdf(
                            bytes: bytes,
                            filename: 'laporan_keuangan.pdf',
                          );
                        }

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('PDF disimpan atau siap diunduh'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal export PDF: $e')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  tooltip: 'Export PDF',
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuat Excel...')),
                      );

                      final excelService = ref.read(excelExportServiceProvider);
                      await excelService.exportFinanceReport(state.report!);

                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Excel disimpan atau siap diunduh'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal export Excel: $e')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.table_chart),
                  tooltip: 'Export Excel',
                ),
              ],
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildDateRangeSelector(context, colorScheme, textTheme),
                const SizedBox(height: 20),

                if (state.isLoading)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    ),
                  )
                else if (state.error != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.error, size: 48, color: colorScheme.error),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.error}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state.report != null) ...[
                  _buildFinanceSummary(colorScheme, textTheme, state.report!),
                  const SizedBox(height: 24),
                  _buildIncomeExpenseChart(
                    colorScheme,
                    textTheme,
                    state.report!,
                  ),
                  const SizedBox(height: 24),
                  _buildIncomeBreakdown(colorScheme, textTheme, state.report!),
                  const SizedBox(height: 24),
                  _buildExpenseBreakdown(colorScheme, textTheme, state.report!),
                  const SizedBox(height: 24),
                  _buildDailyBalanceChart(
                    colorScheme,
                    textTheme,
                    state.report!,
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectDateRange(context),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_month, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${DateFormat('dd MMM yyyy', 'id_ID').format(startDate)} - ${DateFormat('dd MMM yyyy', 'id_ID').format(endDate)}',
                  style: textTheme.bodySmall,
                ),
              ),
              Icon(Icons.expand_more, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinanceSummary(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic report,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _FinanceSummaryCard(
                title: 'Total Pemasukan',
                value: currencyFormat.format(report.totalIncome),
                icon: Icons.arrow_downward,
                color: Colors.green,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _FinanceSummaryCard(
                title: 'Total Pengeluaran',
                value: currencyFormat.format(report.totalExpense),
                icon: Icons.arrow_upward,
                color: Colors.red,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _FinanceSummaryCard(
                title: 'Saldo Bersih',
                value: currencyFormat.format(report.netBalance),
                icon: Icons.wallet,
                color: report.netBalance >= 0 ? Colors.blue : Colors.orange,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIncomeExpenseChart(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic report,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perbandingan Pemasukan & Pengeluaran',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: BarChart(
            BarChartData(
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: report.totalIncome.toDouble(),
                      color: Colors.green,
                      width: 40,
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: report.totalExpense.toDouble(),
                      color: Colors.red,
                      width: 40,
                    ),
                  ],
                ),
              ],
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(value == 0 ? 'Pemasukan' : 'Pengeluaran'),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeBreakdown(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic report,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rincian Pemasukan',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...report.incomeCategories.map<Widget>((category) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(category.name, style: textTheme.bodySmall),
                    Text(
                      '${category.percentage.toStringAsFixed(1)}%',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: category.percentage / 100,
                    minHeight: 8,
                    backgroundColor: colorScheme.outlineVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green.shade400,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currencyFormat.format(category.amount),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${category.transactionCount} transaksi',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildExpenseBreakdown(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic report,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rincian Pengeluaran',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...report.expenseCategories.map<Widget>((category) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(category.name, style: textTheme.bodySmall),
                    Text(
                      '${category.percentage.toStringAsFixed(1)}%',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: category.percentage / 100,
                    minHeight: 8,
                    backgroundColor: colorScheme.outlineVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.red.shade400,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currencyFormat.format(category.amount),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${category.transactionCount} transaksi',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDailyBalanceChart(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic report,
  ) {
    final data = report.dailyBalance;
    if (data.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Text(
            'Tidak ada data',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final spots = data.asMap().entries.map<FlSpot>((e) {
      return FlSpot(e.key.toDouble(), e.value.balance.toDouble());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grafik Saldo Harian',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: colorScheme.primary,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FinanceSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _FinanceSummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
