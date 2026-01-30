import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../application/providers/payroll_report_provider.dart';
import '../../domain/entities/report_filters.dart';
import '../../data/services/pdf_export_service.dart';
import '../../data/services/excel_export_service.dart';

class PayrollReportPage extends ConsumerStatefulWidget {
  const PayrollReportPage({super.key});

  @override
  ConsumerState<PayrollReportPage> createState() => _PayrollReportPageState();
}

class _PayrollReportPageState extends ConsumerState<PayrollReportPage> {
  late DateTime startDate;
  late DateTime endDate;
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  void initState() {
    super.initState();
    endDate = DateTime.now();
    startDate = DateTime(endDate.year, endDate.month, 1);

    Future.microtask(() {
      ref
          .read(payrollReportProvider.notifier)
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
          .read(payrollReportProvider.notifier)
          .generateReport(
            ReportFilters(startDate: startDate, endDate: endDate),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(payrollReportProvider);

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
              'Laporan Penggajian',
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
                      final file = await pdfService.exportPayrollReport(
                        state.report!,
                      );

                      if (mounted) {
                        if (!kIsWeb) {
                          final bytes = await file.readAsBytes();
                          await Printing.sharePdf(
                            bytes: bytes,
                            filename: 'laporan_penggajian.pdf',
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
                      await excelService.exportPayrollReport(state.report!);

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
                  _buildPayrollSummary(colorScheme, textTheme, state.report!),
                  const SizedBox(height: 24),
                  _buildEmployeePayrollTable(
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

  Widget _buildPayrollSummary(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic report,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _PayrollSummaryCard(
                title: 'Total Gaji Bruto',
                value: currencyFormat.format(report.totalGrossSalary),
                icon: Icons.person,
                color: Colors.blue,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PayrollSummaryCard(
                title: 'Total Pajak',
                value: currencyFormat.format(report.totalTax),
                icon: Icons.receipt,
                color: Colors.orange,
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
              child: _PayrollSummaryCard(
                title: 'Total Gaji Bersih',
                value: currencyFormat.format(report.totalNetSalary),
                icon: Icons.wallet,
                color: Colors.green,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PayrollSummaryCard(
                title: 'Jumlah Karyawan',
                value: '${report.totalEmployees}',
                icon: Icons.group,
                color: Colors.purple,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmployeePayrollTable(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic report,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Gaji Karyawan',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Nama')),
              DataColumn(label: Text('Posisi')),
              DataColumn(label: Text('Gaji Bruto')),
              DataColumn(label: Text('Pajak')),
              DataColumn(label: Text('Bonus')),
              DataColumn(label: Text('Potongan')),
              DataColumn(label: Text('Gaji Bersih')),
            ],
            rows: report.employeePayrolls.map<DataRow>((employee) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(employee.employeeName, style: textTheme.bodySmall),
                  ),
                  DataCell(Text(employee.position, style: textTheme.bodySmall)),
                  DataCell(
                    Text(
                      currencyFormat.format(employee.baseSalary),
                      style: textTheme.bodySmall,
                    ),
                  ),
                  DataCell(
                    Text(
                      currencyFormat.format(employee.taxAmount),
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      currencyFormat.format(employee.bonus),
                      style: textTheme.bodySmall?.copyWith(color: Colors.green),
                    ),
                  ),
                  DataCell(
                    Text(
                      currencyFormat.format(employee.deduction),
                      style: textTheme.bodySmall?.copyWith(color: Colors.red),
                    ),
                  ),
                  DataCell(
                    Text(
                      currencyFormat.format(employee.netSalary),
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _PayrollSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _PayrollSummaryCard({
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
