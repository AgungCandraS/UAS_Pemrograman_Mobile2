// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PayrollReportImpl _$$PayrollReportImplFromJson(Map<String, dynamic> json) =>
    _$PayrollReportImpl(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalGrossSalary: (json['totalGrossSalary'] as num).toDouble(),
      totalTax: (json['totalTax'] as num).toDouble(),
      totalNetSalary: (json['totalNetSalary'] as num).toDouble(),
      totalBonus: (json['totalBonus'] as num).toDouble(),
      totalDeduction: (json['totalDeduction'] as num).toDouble(),
      employeePayrolls: (json['employeePayrolls'] as List<dynamic>)
          .map((e) => EmployeePayroll.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalEmployees: (json['totalEmployees'] as num).toInt(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$PayrollReportImplToJson(_$PayrollReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'totalGrossSalary': instance.totalGrossSalary,
      'totalTax': instance.totalTax,
      'totalNetSalary': instance.totalNetSalary,
      'totalBonus': instance.totalBonus,
      'totalDeduction': instance.totalDeduction,
      'employeePayrolls': instance.employeePayrolls,
      'totalEmployees': instance.totalEmployees,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };

_$EmployeePayrollImpl _$$EmployeePayrollImplFromJson(
        Map<String, dynamic> json) =>
    _$EmployeePayrollImpl(
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      position: json['position'] as String,
      baseSalary: (json['baseSalary'] as num).toDouble(),
      bonus: (json['bonus'] as num).toDouble(),
      deduction: (json['deduction'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      netSalary: (json['netSalary'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$$EmployeePayrollImplToJson(
        _$EmployeePayrollImpl instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'position': instance.position,
      'baseSalary': instance.baseSalary,
      'bonus': instance.bonus,
      'deduction': instance.deduction,
      'taxAmount': instance.taxAmount,
      'netSalary': instance.netSalary,
      'status': instance.status,
    };
