import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../domain/entities/sales_report.dart';
import '../../application/providers/sales_report_provider.dart';
import '../../data/services/pdf_export_service.dart';
import '../../data/services/excel_export_service.dart';

class SalesReportPage extends ConsumerStatefulWidget {
  const SalesReportPage({super.key});

  @override
  ConsumerState<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends ConsumerState<SalesReportPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  late final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
  );
  late final DateFormat _dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

  @override
  void initState() {
    super.initState();
  }

  void _loadReport() {
    if (!mounted) return;
    final userId = ref.read(supabaseProvider).auth.currentUser?.id;
    if (userId != null) {
      ref
          .read(salesReportProvider(userId).notifier)
          .generateReport(startDate: _startDate, endDate: _endDate);
    }
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadReport();
    }
  }

  Future<void> _exportToPdf(SalesReport report) async {
    try {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Membuat PDF...')));

      final pdfService = ref.read(pdfExportServiceProvider);
      final file = await pdfService.exportSalesReport(report);

      if (mounted) {
        if (!kIsWeb) {
          final bytes = await file.readAsBytes();
          await Printing.sharePdf(
            bytes: bytes,
            filename: 'laporan_penjualan.pdf',
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(kIsWeb ? 'PDF siap untuk diunduh' : 'PDF disimpan'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal export PDF: $e')));
      }
    }
  }

  Future<void> _exportToExcel(SalesReport report) async {
    try {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Membuat Excel...')));

      final excelService = ref.read(excelExportServiceProvider);
      await excelService.exportSalesReport(report);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Excel siap untuk diunduh')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal export Excel: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final userId = ref.watch(supabaseProvider).auth.currentUser?.id;
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Laporan Penjualan')),
        body: const Center(child: Text('User tidak ditemukan')),
      );
    }

    final reportState = ref.watch(salesReportProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Laporan Penjualan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReport,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: reportState.when(
        data: (report) {
          if (report == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 80, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Pilih rentang tanggal untuk\nmenampilkan laporan',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _selectDateRange,
                    icon: const Icon(Icons.date_range),
                    label: const Text('Pilih Rentang Tanggal'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDateRangeCard(colorScheme, textTheme),
                const SizedBox(height: 16),
                _buildExportButtons(report, colorScheme),
                const SizedBox(height: 16),
                _buildSummaryCards(report, colorScheme, textTheme),
                const SizedBox(height: 16),
                _buildSalesChart(report, colorScheme, textTheme),
                const SizedBox(height: 16),
                _buildProductTable(report, colorScheme, textTheme),
                const SizedBox(height: 16),
                _buildDailyTable(report, colorScheme, textTheme),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                'Error: $error',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loadReport,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.calendar_month, color: colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Periode Laporan',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_dateFormat.format(_startDate)} - ${_dateFormat.format(_endDate)}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: _selectDateRange,
              icon: const Icon(Icons.edit_calendar),
              label: const Text('Ubah'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButtons(SalesReport report, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _exportToPdf(report),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('PDF'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _exportToExcel(report),
            icon: const Icon(Icons.table_chart),
            label: const Text('Excel'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(
    SalesReport report,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final metrics = [
      (
        title: 'Transaksi',
        value: report.totalTransactions.toString(),
        icon: Icons.receipt_long,
        color: Colors.blue.shade400,
      ),
      (
        title: 'Penjualan',
        value: _currencyFormat.format(report.totalRevenue),
        icon: Icons.attach_money,
        color: Colors.green.shade400,
      ),
      (
        title: 'Modal',
        value: _currencyFormat.format(report.totalCost),
        icon: Icons.money_off,
        color: Colors.orange.shade400,
      ),
      (
        title: 'Laba',
        value: _currencyFormat.format(report.totalProfit),
        icon: Icons.trending_up,
        color: Colors.teal.shade400,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: metrics.map((m) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(m.icon, size: 28, color: m.color),
                const SizedBox(height: 8),
                Text(
                  m.title,
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  m.value,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: m.color,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSalesChart(
    SalesReport report,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (report.dailyStats.isEmpty) return const SizedBox.shrink();

    final stats = report.dailyStats.length > 60
        ? report.dailyStats.sublist(report.dailyStats.length - 60)
        : report.dailyStats;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grafik Penjualan',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 25,
                        interval: stats.length > 20
                            ? (stats.length / 5).ceilToDouble()
                            : 1.0,
                        getTitlesWidget: (v, m) => stats.length <= 20
                            ? Text(
                                DateFormat('d/M').format(stats[v.toInt()].date),
                                style: textTheme.bodySmall,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (v, m) => Text(
                          NumberFormat.compact(locale: 'id_ID').format(v),
                          style: textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        stats.length,
                        (i) => FlSpot(i.toDouble(), stats[i].revenue),
                      ),
                      isCurved: true,
                      color: Colors.green.shade400,
                      barWidth: 2,
                      dotData: FlDotData(show: stats.length <= 15),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.shade400.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTable(
    SalesReport report,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (report.productSummaries.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Per Produk',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: report.productSummaries.length,
              itemBuilder: (ctx, i) {
                final p = report.productSummaries[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.productName,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${p.totalQuantity} pcs',
                              style: textTheme.bodySmall,
                            ),
                            Text(
                              _currencyFormat.format(p.totalProfit),
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTable(
    SalesReport report,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (report.dailyStats.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Per Hari',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: report.dailyStats.length,
              itemBuilder: (ctx, i) {
                final d = report.dailyStats[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _dateFormat.format(d.date),
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${d.transactionCount} tx',
                              style: textTheme.bodySmall,
                            ),
                            Text(
                              _currencyFormat.format(d.profit),
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
