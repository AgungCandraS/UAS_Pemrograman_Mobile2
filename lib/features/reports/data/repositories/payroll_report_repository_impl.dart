import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/payroll_report.dart';
import '../../domain/entities/report_filters.dart';
import '../../domain/repositories/payroll_report_repository.dart';

class PayrollReportRepositoryImpl implements PayrollReportRepository {
  final SupabaseClient _supabaseClient;
  static final _logger = Logger();

  PayrollReportRepositoryImpl(this._supabaseClient);

  @override
  Future<PayrollReport> generatePayrollReport(ReportFilters filters) async {
    try {
      _logger.i(
        'Fetching payroll records for period: ${filters.startDate} to ${filters.endDate}',
      );

      // Get payroll data with proper date filtering
      // This queries for payroll records that overlap with the selected date range
      // A payroll period overlaps if: period_end >= startDate AND period_start <= endDate

      var query = _supabaseClient
          .from('payroll_records')
          .select('*, employees(id, nama, department)');

      // Apply date filters for period overlap
      query = query
          .gte('period_end', filters.startDate.toIso8601String())
          .lte('period_start', filters.endDate.toIso8601String());

      // Filter by approved status - remove if you want to see all statuses
      // Uncomment to filter only approved payroll:
      // query = query.eq('status', 'approved');

      final response = await query;

      final payrolls = response as List<dynamic>;
      _logger.i('Found ${payrolls.length} payroll records');

      if (payrolls.isEmpty) {
        _logger.w(
          'No payroll records found for the selected period. Date range: ${filters.startDate} to ${filters.endDate}',
        );
      }

      double totalGrossSalary = 0;
      double totalTax = 0;
      double totalNetSalary = 0;
      double totalBonus = 0;
      double totalDeduction = 0;

      final List<EmployeePayroll> employeePayrolls = [];
      final Set<String> uniqueEmployees = {};

      for (var payroll in payrolls) {
        final baseSalary = (payroll['base_salary'] as num?)?.toDouble() ?? 0;
        final bonus = (payroll['production_bonus'] as num?)?.toDouble() ?? 0;
        final deduction = (payroll['deductions'] as num?)?.toDouble() ?? 0;
        final netSalary = (payroll['total_earnings'] as num?)?.toDouble() ?? 0;

        // Tax is typically deductions or can be calculated separately
        final tax = deduction;

        totalGrossSalary += baseSalary;
        totalTax += tax;
        totalNetSalary += netSalary;
        totalBonus += bonus;
        totalDeduction += deduction;

        final employee = payroll['employees'] as Map<String, dynamic>?;
        final employeeId = payroll['employee_id'] as String? ?? 'unknown';

        if (!uniqueEmployees.contains(employeeId)) {
          uniqueEmployees.add(employeeId);
          employeePayrolls.add(
            EmployeePayroll(
              employeeId: employeeId,
              employeeName: employee?['nama'] as String? ?? 'N/A',
              position: employee?['department'] as String? ?? 'N/A',
              baseSalary: baseSalary,
              bonus: bonus,
              deduction: deduction,
              taxAmount: tax,
              netSalary: netSalary,
              status: payroll['status'] as String? ?? 'approved',
            ),
          );
        }
      }

      return PayrollReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        startDate: filters.startDate,
        endDate: filters.endDate,
        totalGrossSalary: totalGrossSalary,
        totalTax: totalTax,
        totalNetSalary: totalNetSalary,
        totalBonus: totalBonus,
        totalDeduction: totalDeduction,
        employeePayrolls: employeePayrolls,
        totalEmployees: uniqueEmployees.length,
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      _logger.e('Failed to generate payroll report: $e');
      throw Exception('Failed to generate payroll report: $e');
    }
  }

  @override
  Future<List<EmployeePayroll>> getEmployeePayrolls(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _supabaseClient
          .from('payroll_records')
          .select('*, employees(id, nama, department)')
          .gte('period_start', startDate.toIso8601String())
          .lte('period_end', endDate.toIso8601String());

      final payrolls = response as List<dynamic>;
      final Map<String, EmployeePayroll> employeePayrollMap = {};

      for (var payroll in payrolls) {
        final employeeId = payroll['employee_id'] as String? ?? 'unknown';
        final employee = payroll['employees'] as Map<String, dynamic>?;

        if (employeePayrollMap.containsKey(employeeId)) {
          // Aggregate multiple payroll entries for same employee
          final existing = employeePayrollMap[employeeId]!;
          employeePayrollMap[employeeId] = EmployeePayroll(
            employeeId: employeeId,
            employeeName: existing.employeeName,
            position: existing.position,
            baseSalary: existing.baseSalary,
            bonus:
                existing.bonus +
                ((payroll['production_bonus'] as num?)?.toDouble() ?? 0),
            deduction:
                existing.deduction +
                ((payroll['deductions'] as num?)?.toDouble() ?? 0),
            taxAmount: existing.taxAmount,
            netSalary:
                existing.netSalary +
                ((payroll['total_earnings'] as num?)?.toDouble() ?? 0),
            status: payroll['status'] as String? ?? 'paid',
          );
        } else {
          employeePayrollMap[employeeId] = EmployeePayroll(
            employeeId: employeeId,
            employeeName: employee?['nama'] as String? ?? 'N/A',
            position: employee?['department'] as String? ?? 'N/A',
            baseSalary: (payroll['base_salary'] as num?)?.toDouble() ?? 0,
            bonus: (payroll['production_bonus'] as num?)?.toDouble() ?? 0,
            deduction: (payroll['deductions'] as num?)?.toDouble() ?? 0,
            taxAmount: (payroll['total_earnings'] as num?)?.toDouble() ?? 0,
            netSalary: (payroll['total_earnings'] as num?)?.toDouble() ?? 0,
            status: payroll['status'] as String? ?? 'paid',
          );
        }
      }

      return employeePayrollMap.values.toList();
    } catch (e) {
      throw Exception('Failed to get employee payrolls: $e');
    }
  }
}
