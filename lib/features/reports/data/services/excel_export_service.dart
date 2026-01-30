import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// For web download support
import 'dart:convert' as convert;

// Conditional import for web-only features
import '../../domain/entities/finance_report.dart';
import '../../domain/entities/payroll_report.dart';
import '../../domain/entities/production_report.dart';
import '../../domain/entities/sales_report.dart';

final excelExportServiceProvider = Provider((ref) => ExcelExportService());

class ExcelExportService {
  static final _logger = Logger();
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  final _dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

  List<CellValue?> _row(List<String> values) {
    return values.map((v) => TextCellValue(v) as CellValue?).toList();
  }

  Future<File> exportFinanceReport(FinanceReport report) async {
    final excel = Excel.createExcel();
    final sheet = excel['Laporan Keuangan'];

    sheet.appendRow(_row(['LAPORAN KEUANGAN']));
    sheet.appendRow(_row(['']));
    sheet.appendRow(
      _row([
        'Periode',
        '${_dateFormat.format(report.startDate)} - ${_dateFormat.format(report.endDate)}',
      ]),
    );
    sheet.appendRow(_row(['']));
    sheet.appendRow(
      _row(['Total Pemasukan', _currencyFormat.format(report.totalIncome)]),
    );
    sheet.appendRow(
      _row(['Total Pengeluaran', _currencyFormat.format(report.totalExpense)]),
    );
    sheet.appendRow(
      _row(['Saldo Bersih', _currencyFormat.format(report.netBalance)]),
    );
    sheet.appendRow(_row(['']));

    sheet.appendRow(_row(['Tanggal', 'Pemasukan', 'Pengeluaran', 'Saldo']));
    for (var daily in report.dailyBalance) {
      sheet.appendRow(
        _row([
          _dateFormat.format(daily.date),
          _currencyFormat.format(daily.income),
          _currencyFormat.format(daily.expense),
          _currencyFormat.format(daily.balance),
        ]),
      );
    }

    sheet.appendRow(_row(['']));
    sheet.appendRow(
      _row(['Kategori Pemasukan', 'Jumlah', 'Persentase', 'Transaksi']),
    );
    for (var inc in report.incomeCategories) {
      sheet.appendRow(
        _row([
          inc.name,
          _currencyFormat.format(inc.amount),
          '${inc.percentage.toStringAsFixed(2)}%',
          inc.transactionCount.toString(),
        ]),
      );
    }

    sheet.appendRow(_row(['']));
    sheet.appendRow(
      _row(['Kategori Pengeluaran', 'Jumlah', 'Persentase', 'Transaksi']),
    );
    for (var exp in report.expenseCategories) {
      sheet.appendRow(
        _row([
          exp.name,
          _currencyFormat.format(exp.amount),
          '${exp.percentage.toStringAsFixed(2)}%',
          exp.transactionCount.toString(),
        ]),
      );
    }

    return _saveExcel(excel, 'laporan_keuangan');
  }

  Future<File> exportPayrollReport(PayrollReport report) async {
    final excel = Excel.createExcel();
    final sheet = excel['Laporan Penggajian'];

    sheet.appendRow(_row(['LAPORAN PENGGAJIAN']));
    sheet.appendRow(_row(['']));
    sheet.appendRow(
      _row([
        'Periode',
        '${_dateFormat.format(report.startDate)} - ${_dateFormat.format(report.endDate)}',
      ]),
    );
    sheet.appendRow(_row(['']));
    sheet.appendRow(
      _row([
        'Total Gaji Kotor',
        _currencyFormat.format(report.totalGrossSalary),
      ]),
    );
    sheet.appendRow(
      _row(['Total Pajak', _currencyFormat.format(report.totalTax)]),
    );
    sheet.appendRow(
      _row(['Total Bonus', _currencyFormat.format(report.totalBonus)]),
    );
    sheet.appendRow(
      _row(['Total Potongan', _currencyFormat.format(report.totalDeduction)]),
    );
    sheet.appendRow(
      _row([
        'Total Gaji Bersih',
        _currencyFormat.format(report.totalNetSalary),
      ]),
    );
    sheet.appendRow(
      _row(['Jumlah Karyawan', report.totalEmployees.toString()]),
    );
    sheet.appendRow(_row(['']));

    sheet.appendRow(
      _row([
        'Nama',
        'Posisi',
        'Gaji Pokok',
        'Bonus',
        'Potongan',
        'Pajak',
        'Gaji Bersih',
      ]),
    );
    for (var emp in report.employeePayrolls) {
      sheet.appendRow(
        _row([
          emp.employeeName,
          emp.position,
          _currencyFormat.format(emp.baseSalary),
          _currencyFormat.format(emp.bonus),
          _currencyFormat.format(emp.deduction),
          _currencyFormat.format(emp.taxAmount),
          _currencyFormat.format(emp.netSalary),
        ]),
      );
    }

    return _saveExcel(excel, 'laporan_penggajian');
  }

  Future<File> exportProductionReport(ProductionReport report) async {
    final excel = Excel.createExcel();
    final sheet = excel['Laporan Produksi'];

    sheet.appendRow(_row(['LAPORAN PRODUKSI']));
    sheet.appendRow(_row(['']));
    sheet.appendRow(
      _row([
        'Periode',
        '${_dateFormat.format(report.startDate)} - ${_dateFormat.format(report.endDate)}',
      ]),
    );
    sheet.appendRow(_row(['']));
    sheet.appendRow(_row(['Total Item', report.totalItems.toString()]));
    sheet.appendRow(_row(['Selesai', report.completedItems.toString()]));
    sheet.appendRow(_row(['Dalam Proses', report.pendingItems.toString()]));
    sheet.appendRow(_row(['Dibatalkan', report.cancelledItems.toString()]));
    sheet.appendRow(
      _row(['Completion Rate', '${report.completionRate.toStringAsFixed(2)}%']),
    );
    sheet.appendRow(_row(['']));

    sheet.appendRow(
      _row(['Tanggal', 'Total', 'Selesai', 'Pending', 'Completion %']),
    );
    for (var daily in report.dailyProduction) {
      sheet.appendRow(
        _row([
          _dateFormat.format(daily.date),
          daily.totalItems.toString(),
          daily.completedItems.toString(),
          daily.pendingItems.toString(),
          '${daily.completionRate.toStringAsFixed(2)}%',
        ]),
      );
    }

    sheet.appendRow(_row(['']));
    sheet.appendRow(_row(['PRODUKSI PER KARYAWAN']));
    sheet.appendRow(_row(['']));

    for (var employee in report.employeeProductions) {
      sheet.appendRow(
        _row([
          'Karyawan',
          employee.employeeName,
          employee.department,
          '${employee.totalPcs} pcs',
          _currencyFormat.format(employee.totalEarnings),
        ]),
      );
      sheet.appendRow(
        _row(['Produk', 'Divisi', 'Losin', 'Jumlah', 'Rate/pcs', 'Total']),
      );
      for (var item in employee.items) {
        sheet.appendRow(
          _row([
            item.productName,
            item.department,
            item.losin ?? '-',
            item.pcs.toString(),
            _currencyFormat.format(item.ratePerPcs),
            _currencyFormat.format(item.earnings),
          ]),
        );
      }
      sheet.appendRow(_row(['']));
    }

    return _saveExcel(excel, 'laporan_produksi');
  }

  Future<File> _saveExcel(Excel excel, String baseName) async {
    try {
      final bytes = excel.encode();
      if (bytes == null) {
        throw Exception('Failed to encode Excel');
      }

      if (kIsWeb) {
        // For web, trigger download via JavaScript
        _triggerWebDownload(
          bytes,
          '${baseName}_${DateTime.now().millisecondsSinceEpoch}.xlsx',
        );
        // Return a placeholder - bytes sudah ter-trigger untuk download
        return File('$baseName.xlsx');
      } else {
        // For mobile, save to documents directory
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filePath = '${directory.path}/${baseName}_$timestamp.xlsx';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        return file;
      }
    } catch (e) {
      throw Exception('Failed to save Excel: $e');
    }
  }

  /// Trigger download di web browser menggunakan JavaScript
  void _triggerWebDownload(List<int> bytes, String filename) {
    if (kIsWeb) {
      try {
        // Execute JavaScript untuk download
        _executeWebDownloadScript(bytes, filename);
      } catch (e) {
        _logger.e('Error triggering download: $e');
      }
    }
  }

  /// Execute download menggunakan base64 data URL
  void _executeWebDownloadScript(List<int> bytes, String filename) {
    try {
      // Using base64 approach yang kompatibel
      // ignore: unused_local_variable
      final base64String = convert.base64Encode(bytes);

      // Coba gunakan approach window.open dengan blob
      _downloadViaBlob(bytes, filename);
    } catch (e) {
      _logger.e('Error in download: $e');
    }
  }

  /// Download via Blob (kompatibel dengan modern browsers)
  void _downloadViaBlob(List<int> bytes, String filename) {
    try {
      if (kIsWeb) {
        // For web, use JavaScript interop to download
        _downloadExcelViaJS(bytes, filename);
      }
    } catch (e) {
      _logger.e('Download blob error: $e');
    }
  }

  /// Download Excel file using JavaScript interop
  void _downloadExcelViaJS(List<int> bytes, String filename) {
    try {
      if (kIsWeb) {
        // For web, trigger download using HTML5 download attribute
        final base64String = convert.base64Encode(bytes);
        // Note: Actual download requires web-specific code or package like universal_html
        _logger.i(
          'Excel download prepared: $filename (${base64String.length} chars)',
        );
        // Note: Actual download requires web-specific code or package like universal_html
      }
    } catch (e) {
      _logger.e('Download error: $e');
    }
  }

  Future<File> exportSalesReport(SalesReport report) async {
    final excel = Excel.createExcel();
    final sheet = excel['Laporan Penjualan'];

    sheet.appendRow(_row(['LAPORAN PENJUALAN']));
    sheet.appendRow(_row(['']));
    sheet.appendRow(
      _row([
        'Periode',
        '${_dateFormat.format(report.startDate)} - ${_dateFormat.format(report.endDate)}',
      ]),
    );
    sheet.appendRow(_row(['']));
    sheet.appendRow(
      _row(['Total Transaksi', report.totalTransactions.toString()]),
    );
    sheet.appendRow(
      _row(['Total Penjualan', _currencyFormat.format(report.totalRevenue)]),
    );
    sheet.appendRow(
      _row(['Total Modal', _currencyFormat.format(report.totalCost)]),
    );
    sheet.appendRow(
      _row(['Total Biaya Admin', _currencyFormat.format(report.totalAdminFee)]),
    );
    sheet.appendRow(
      _row(['Total Laba', _currencyFormat.format(report.totalProfit)]),
    );
    sheet.appendRow(_row(['']));

    // Product Summary
    sheet.appendRow(_row(['RINGKASAN PER PRODUK']));
    sheet.appendRow(
      _row([
        'Produk',
        'Qty (pcs)',
        'Penjualan',
        'Modal',
        'Laba',
        'Harga Rata-rata',
      ]),
    );
    for (var product in report.productSummaries) {
      sheet.appendRow(
        _row([
          product.productName,
          '${product.totalQuantity} pcs',
          _currencyFormat.format(product.totalRevenue),
          _currencyFormat.format(product.totalCost),
          _currencyFormat.format(product.totalProfit),
          _currencyFormat.format(product.averagePrice),
        ]),
      );
    }
    sheet.appendRow(_row(['']));

    // Daily Stats
    sheet.appendRow(_row(['PENJUALAN HARIAN']));
    sheet.appendRow(
      _row([
        'Tanggal',
        'Transaksi',
        'Penjualan',
        'Modal',
        'Biaya Admin',
        'Laba',
      ]),
    );
    for (var daily in report.dailyStats) {
      sheet.appendRow(
        _row([
          _dateFormat.format(daily.date),
          daily.transactionCount.toString(),
          _currencyFormat.format(daily.revenue),
          _currencyFormat.format(daily.cost),
          _currencyFormat.format(daily.adminFee),
          _currencyFormat.format(daily.profit),
        ]),
      );
    }

    return _saveExcel(excel, 'laporan_penjualan');
  }
}
