import 'package:freezed_annotation/freezed_annotation.dart';

part 'payroll_report.freezed.dart';
part 'payroll_report.g.dart';

@freezed
class PayrollReport with _$PayrollReport {
  const factory PayrollReport({
    required String id,
    required DateTime startDate,
    required DateTime endDate,
    required double totalGrossSalary,
    required double totalTax,
    required double totalNetSalary,
    required double totalBonus,
    required double totalDeduction,
    required List<EmployeePayroll> employeePayrolls,
    required int totalEmployees,
    required DateTime generatedAt,
  }) = _PayrollReport;

  factory PayrollReport.fromJson(Map<String, dynamic> json) =>
      _$PayrollReportFromJson(json);
}

@freezed
class EmployeePayroll with _$EmployeePayroll {
  const factory EmployeePayroll({
    required String employeeId,
    required String employeeName,
    required String position,
    required double baseSalary,
    required double bonus,
    required double deduction,
    required double taxAmount,
    required double netSalary,
    required String status,
  }) = _EmployeePayroll;

  factory EmployeePayroll.fromJson(Map<String, dynamic> json) =>
      _$EmployeePayrollFromJson(json);
}
