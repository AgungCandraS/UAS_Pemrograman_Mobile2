import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../application/providers/production_report_provider.dart';
import '../../domain/entities/report_filters.dart';
import '../../data/services/pdf_export_service.dart';
import '../../data/services/excel_export_service.dart';

class ProductionReportPage extends ConsumerStatefulWidget {
  const ProductionReportPage({super.key});

  @override
  ConsumerState<ProductionReportPage> createState() =>
      _ProductionReportPageState();
}

class _ProductionReportPageState extends ConsumerState<ProductionReportPage> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    endDate = DateTime.now();
    startDate = endDate.subtract(const Duration(days: 30));

    Future.microtask(() {
      ref
          .read(productionReportProvider.notifier)
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
          .read(productionReportProvider.notifier)
          .generateReport(
            ReportFilters(startDate: startDate, endDate: endDate),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(productionReportProvider);

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
              'Laporan Produksi',
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
                      final file = await pdfService.exportProductionReport(
                        state.report!,
                      );

                      if (mounted) {
                        if (!kIsWeb) {
                          final bytes = await file.readAsBytes();
                          await Printing.sharePdf(
                            bytes: bytes,
                            filename: 'laporan_produksi.pdf',
                          );
                        }

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              kIsWeb
                                  ? 'PDF siap untuk diunduh'
                                  : 'PDF disimpan',
                            ),
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
                      await excelService.exportProductionReport(state.report!);

                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              kIsWeb
                                  ? 'Excel siap untuk diunduh'
                                  : 'Excel disimpan',
                            ),
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
                  _buildProductionSummary(
                    colorScheme,
                    textTheme,
                    state.report!,
                  ),
                  const SizedBox(height: 24),
                  _buildCompletionChart(colorScheme, textTheme, state.report!),
                  const SizedBox(height: 24),
                  _buildStatusBreakdown(colorScheme, textTheme, state.report!),
                  const SizedBox(height: 24),
                  _buildEmployeeProductionTable(
                    colorScheme,
                    textTheme,
                    state.report!,
                  ),
                  const SizedBox(height: 24),
                  _buildDailyProductionChart(
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

  Widget _buildProductionSummary(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic report,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ProductionSummaryCard(
                title: 'Total Item',
                value: '${report.totalItems}',
                icon: Icons.inventory_2,
                color: Colors.blue,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ProductionSummaryCard(
                title: 'Selesai',
                value: '${report.completedItems}',
                icon: Icons.check_circle,
                color: Colors.green,
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
              child: _ProductionSummaryCard(
                title: 'Pending',
                value: '${report.pendingItems}',
                icon: Icons.schedule,
                color: Colors.orange,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ProductionSummaryCard(
                title: 'Dibatalkan',
                value: '${report.cancelledItems}',
                icon: Icons.cancel,
                color: Colors.red,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompletionChart(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic report,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tingkat Penyelesaian',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${report.completionRate.toStringAsFixed(1)}%',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: report.completionRate / 100,
            minHeight: 30,
            backgroundColor: colorScheme.outlineVariant,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Waktu Penyelesaian Rata-rata: ${report.averageCompletionTime.toStringAsFixed(1)} jam',
            style: textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBreakdown(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic report,
  ) {
    final data = report.statusBreakdown;
    if (data.isEmpty) {
      return SizedBox(
        height: 250,
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

    final statusColors = {
      'completed': Colors.green,
      'pending': Colors.orange,
      'cancelled': Colors.red,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rincian Status Produksi',
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
          child: PieChart(
            PieChartData(
              sections: data.map<PieChartSectionData>((status) {
                return PieChartSectionData(
                  value: status.count.toDouble(),
                  title: '${status.percentage.toStringAsFixed(1)}%',
                  color:
                      statusColors[status.status.toLowerCase()] ?? Colors.grey,
                  radius: 100,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeProductionTable(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic report,
  ) {
    final data = report.employeeProductions as List;
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    if (data.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Tidak ada data produksi karyawan',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produksi Per Karyawan',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...data.asMap().entries.map((entry) {
          final index = entry.key;
          final employee = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Employee Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee.employeeName,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (employee.department.isNotEmpty)
                              Text(
                                employee.department,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${employee.totalPcs} pcs',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          Text(
                            currencyFormat.format(employee.totalEarnings),
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Items Table - Responsive
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Produk',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Divisi',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Losin',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Pcs',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Total',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Data Rows
                      ...employee.items.map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Name
                              Expanded(
                                flex: 3,
                                child: Text(
                                  item.productName,
                                  style: textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Department
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getDepartmentColor(
                                      item.department,
                                    ).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.department,
                                    style: textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      color: _getDepartmentColor(
                                        item.department,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // Losin
                              Expanded(
                                flex: 1,
                                child: Text(
                                  item.losin ?? '-',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // PCS
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '${item.pcs}',
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              // Total Earnings
                              Expanded(
                                flex: 2,
                                child: Text(
                                  currencyFormat.format(item.earnings),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _getDepartmentColor(String department) {
    final dept = department.toLowerCase();
    if (dept.contains('potong') || dept.contains('cutting')) {
      return Colors.blue;
    } else if (dept.contains('jahit') || dept.contains('sewing')) {
      return Colors.purple;
    } else if (dept.contains('obras') || dept.contains('finishing')) {
      return Colors.orange;
    } else if (dept.contains('packing') || dept.contains('qc')) {
      return Colors.green;
    } else if (dept.contains('bordir') || dept.contains('embroidery')) {
      return Colors.pink;
    }
    return Colors.grey;
  }

  Widget _buildDailyProductionChart(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic report,
  ) {
    final data = report.dailyProduction;
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
      return FlSpot(e.key.toDouble(), e.value.completionRate.toDouble());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grafik Penyelesaian Harian',
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
                  color: Colors.green,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.green.withValues(alpha: 0.1),
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

class _ProductionSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ProductionSummaryCard({
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
