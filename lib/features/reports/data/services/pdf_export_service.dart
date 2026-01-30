import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../domain/entities/finance_report.dart';
import '../../domain/entities/payroll_report.dart';
import '../../domain/entities/production_report.dart';
import '../../domain/entities/sales_report.dart';

final pdfExportServiceProvider = Provider((ref) => PdfExportService());

class PdfExportService {
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  final _dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

  // Finance Report PDF
  Future<File> exportFinanceReport(FinanceReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader('LAPORAN KEUANGAN'),
          _buildSubHeader(
            'Periode: ${_dateFormat.format(report.startDate)} - ${_dateFormat.format(report.endDate)}',
          ),
          pw.SizedBox(height: 20),

          // Summary Section
          _buildSectionTitle('Ringkasan'),
          _buildSummaryTable([
            ['Total Pemasukan', _currencyFormat.format(report.totalIncome)],
            ['Total Pengeluaran', _currencyFormat.format(report.totalExpense)],
            ['Saldo Bersih', _currencyFormat.format(report.netBalance)],
          ]),
          pw.SizedBox(height: 20),

          // Income Categories
          _buildSectionTitle('Kategori Pemasukan'),
          _buildDataTable(
            headers: ['Kategori', 'Jumlah', 'Persentase', 'Transaksi'],
            rows: report.incomeCategories
                .map(
                  (income) => [
                    income.name,
                    _currencyFormat.format(income.amount),
                    '${income.percentage.toStringAsFixed(2)}%',
                    income.transactionCount.toString(),
                  ],
                )
                .toList(),
          ),
          pw.SizedBox(height: 20),

          // Expense Categories
          _buildSectionTitle('Kategori Pengeluaran'),
          _buildDataTable(
            headers: ['Kategori', 'Jumlah', 'Persentase', 'Transaksi'],
            rows: report.expenseCategories
                .map(
                  (expense) => [
                    expense.name,
                    _currencyFormat.format(expense.amount),
                    '${expense.percentage.toStringAsFixed(2)}%',
                    expense.transactionCount.toString(),
                  ],
                )
                .toList(),
          ),
          pw.SizedBox(height: 20),

          // Daily Balance
          _buildSectionTitle('Saldo Harian'),
          _buildDataTable(
            headers: ['Tanggal', 'Pemasukan', 'Pengeluaran', 'Saldo'],
            rows: report.dailyBalance
                .map(
                  (daily) => [
                    _dateFormat.format(daily.date),
                    _currencyFormat.format(daily.income),
                    _currencyFormat.format(daily.expense),
                    _currencyFormat.format(daily.balance),
                  ],
                )
                .toList(),
          ),

          pw.SizedBox(height: 30),
          _buildFooter(report.generatedAt),
        ],
      ),
    );

    return _savePdf(
      pdf,
      'Laporan_Keuangan_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  // Payroll Report PDF
  Future<File> exportPayrollReport(PayrollReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader('LAPORAN PENGGAJIAN'),
          _buildSubHeader(
            'Periode: ${_dateFormat.format(report.startDate)} - ${_dateFormat.format(report.endDate)}',
          ),
          pw.SizedBox(height: 20),

          // Summary
          _buildSectionTitle('Ringkasan'),
          _buildSummaryTable([
            ['Total Karyawan', report.totalEmployees.toString()],
            [
              'Total Gaji Kotor',
              _currencyFormat.format(report.totalGrossSalary),
            ],
            ['Total Bonus', _currencyFormat.format(report.totalBonus)],
            ['Total Potongan', _currencyFormat.format(report.totalDeduction)],
            ['Total Pajak', _currencyFormat.format(report.totalTax)],
            [
              'Total Gaji Bersih',
              _currencyFormat.format(report.totalNetSalary),
            ],
          ]),
          pw.SizedBox(height: 20),

          // Employee Details
          _buildSectionTitle('Detail Gaji Karyawan'),
          _buildDataTable(
            headers: [
              'Nama',
              'Posisi',
              'Gaji Pokok',
              'Bonus',
              'Potongan',
              'Pajak',
              'Gaji Bersih',
            ],
            rows: report.employeePayrolls
                .map(
                  (emp) => [
                    emp.employeeName,
                    emp.position,
                    _currencyFormat.format(emp.baseSalary),
                    _currencyFormat.format(emp.bonus),
                    _currencyFormat.format(emp.deduction),
                    _currencyFormat.format(emp.taxAmount),
                    _currencyFormat.format(emp.netSalary),
                  ],
                )
                .toList(),
          ),

          pw.SizedBox(height: 30),
          _buildFooter(report.generatedAt),
        ],
      ),
    );

    return _savePdf(
      pdf,
      'Laporan_Penggajian_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  // Production Report PDF
  Future<File> exportProductionReport(ProductionReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader('LAPORAN PRODUKSI'),
          _buildSubHeader(
            'Periode: ${_dateFormat.format(report.startDate)} - ${_dateFormat.format(report.endDate)}',
          ),
          pw.SizedBox(height: 20),

          // Summary
          _buildSectionTitle('Ringkasan'),
          _buildSummaryTable([
            ['Total Item', report.totalItems.toString()],
            ['Item Selesai', report.completedItems.toString()],
            ['Item Pending', report.pendingItems.toString()],
            ['Item Dibatalkan', report.cancelledItems.toString()],
            [
              'Tingkat Penyelesaian',
              '${report.completionRate.toStringAsFixed(2)}%',
            ],
            [
              'Rata-rata Waktu Penyelesaian',
              '${report.averageCompletionTime.toStringAsFixed(2)} hari',
            ],
          ]),
          pw.SizedBox(height: 20),

          // Status Breakdown
          _buildSectionTitle('Breakdown Status'),
          _buildDataTable(
            headers: ['Status', 'Jumlah', 'Persentase'],
            rows: report.statusBreakdown
                .map(
                  (status) => [
                    status.status,
                    status.count.toString(),
                    '${status.percentage.toStringAsFixed(2)}%',
                  ],
                )
                .toList(),
          ),
          pw.SizedBox(height: 20),

          // Employee Productions
          _buildSectionTitle('Produksi Per Karyawan'),
          ...report.employeeProductions.map((employee) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue50,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            employee.employeeName,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          if (employee.department.isNotEmpty)
                            pw.Text(
                              employee.department,
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            '${employee.totalPcs} pcs',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue700,
                            ),
                          ),
                          pw.Text(
                            _currencyFormat.format(employee.totalEarnings),
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.green700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 8),
                _buildDataTable(
                  headers: [
                    'Produk',
                    'Divisi',
                    'Losin',
                    'Jumlah',
                    'Rate/pcs',
                    'Total',
                  ],
                  rows: employee.items
                      .map(
                        (item) => [
                          item.productName,
                          item.department,
                          item.losin ?? '-',
                          item.pcs.toString(),
                          _currencyFormat.format(item.ratePerPcs),
                          _currencyFormat.format(item.earnings),
                        ],
                      )
                      .toList(),
                ),
                pw.SizedBox(height: 16),
              ],
            );
          }),

          // Daily Production
          _buildSectionTitle('Produksi Harian'),
          _buildDataTable(
            headers: [
              'Tanggal',
              'Total',
              'Selesai',
              'Pending',
              'Tingkat Penyelesaian',
            ],
            rows: report.dailyProduction
                .map(
                  (daily) => [
                    _dateFormat.format(daily.date),
                    daily.totalItems.toString(),
                    daily.completedItems.toString(),
                    daily.pendingItems.toString(),
                    '${daily.completionRate.toStringAsFixed(2)}%',
                  ],
                )
                .toList(),
          ),

          pw.SizedBox(height: 30),
          _buildFooter(report.generatedAt),
        ],
      ),
    );

    return _savePdf(
      pdf,
      'Laporan_Produksi_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  // Helper Widgets
  pw.Widget _buildHeader(String title) {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 2)),
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _buildSubHeader(String subtitle) {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Text(subtitle, style: const pw.TextStyle(fontSize: 12)),
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(width: 1.5)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _buildSummaryTable(List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
      },
      children: rows
          .map(
            (row) => pw.TableRow(
              children: row
                  .map(
                    (cell) => pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        cell,
                        style: pw.TextStyle(
                          fontWeight: row[0] == cell
                              ? pw.FontWeight.bold
                              : pw.FontWeight.normal,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }

  pw.Widget _buildDataTable({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: headers
              .map(
                (header) => pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text(
                    header,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        // Data Rows
        ...rows.map(
          (row) => pw.TableRow(
            children: row
                .map(
                  (cell) => pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      cell,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildFooter(DateTime generatedAt) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(),
        pw.Text(
          'Digenerate pada: ${DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(generatedAt)}',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.Text(
          'Bisnisku © ${DateTime.now().year}',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
      ],
    );
  }

  // Sales Report PDF
  Future<File> exportSalesReport(SalesReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader('LAPORAN PENJUALAN'),
          _buildSubHeader(
            'Periode: ${_dateFormat.format(report.startDate)} - ${_dateFormat.format(report.endDate)}',
          ),
          pw.SizedBox(height: 20),

          // Summary Section
          _buildSectionTitle('Ringkasan'),
          _buildSummaryTable([
            ['Total Transaksi', report.totalTransactions.toString()],
            ['Total Penjualan', _currencyFormat.format(report.totalRevenue)],
            ['Total Modal', _currencyFormat.format(report.totalCost)],
            ['Total Biaya Admin', _currencyFormat.format(report.totalAdminFee)],
            ['Total Laba', _currencyFormat.format(report.totalProfit)],
          ]),
          pw.SizedBox(height: 20),

          // Product Sales Summary
          _buildSectionTitle('Ringkasan Penjualan per Produk'),
          _buildDataTable(
            headers: ['Produk', 'Qty (pcs)', 'Penjualan', 'Modal', 'Laba'],
            rows: report.productSummaries
                .map(
                  (product) => [
                    product.productName,
                    '${product.totalQuantity} pcs',
                    _currencyFormat.format(product.totalRevenue),
                    _currencyFormat.format(product.totalCost),
                    _currencyFormat.format(product.totalProfit),
                  ],
                )
                .toList(),
          ),
          pw.SizedBox(height: 20),

          // Daily Sales
          _buildSectionTitle('Penjualan Harian'),
          _buildDataTable(
            headers: [
              'Tanggal',
              'Transaksi',
              'Penjualan',
              'Modal',
              'Biaya Admin',
              'Laba',
            ],
            rows: report.dailyStats
                .map(
                  (daily) => [
                    _dateFormat.format(daily.date),
                    daily.transactionCount.toString(),
                    _currencyFormat.format(daily.revenue),
                    _currencyFormat.format(daily.cost),
                    _currencyFormat.format(daily.adminFee),
                    _currencyFormat.format(daily.profit),
                  ],
                )
                .toList(),
          ),

          pw.SizedBox(height: 30),
          _buildFooter(report.generatedAt),
        ],
      ),
    );

    return _savePdf(
      pdf,
      'Laporan_Penjualan_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<File> _savePdf(pw.Document pdf, String fileName) async {
    try {
      final bytes = await pdf.save();

      if (kIsWeb) {
        // For web, use Printing.sharePdf to download
        await Printing.sharePdf(bytes: bytes, filename: '$fileName.pdf');
        // Return a dummy file for web (not actually used)
        return File('$fileName.pdf');
      } else {
        // For mobile, save to documents directory
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName.pdf');
        await file.writeAsBytes(bytes);
        return file;
      }
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }
}
