import '../entities/payroll_report.dart';
import '../entities/report_filters.dart';

abstract class PayrollReportRepository {
  Future<PayrollReport> generatePayrollReport(ReportFilters filters);
  Future<List<EmployeePayroll>> getEmployeePayrolls(
    DateTime startDate,
    DateTime endDate,
  );
}
