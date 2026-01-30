import '../../domain/payroll_model.dart';

class PayrollRecordModel extends PayrollRecord {
  final String userId;

  const PayrollRecordModel({
    required super.id,
    required super.employeeId,
    required super.periodStart,
    required super.periodEnd,
    required super.baseSalary,
    required super.productionBonus,
    required super.deductions,
    required super.totalEarnings,
    required super.status,
    required this.userId,
    super.paidDate,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PayrollRecordModel.fromEntity(
    PayrollRecord entity, {
    required String userId,
  }) {
    return PayrollRecordModel(
      id: entity.id,
      userId: userId,
      employeeId: entity.employeeId,
      periodStart: entity.periodStart,
      periodEnd: entity.periodEnd,
      baseSalary: entity.baseSalary,
      productionBonus: entity.productionBonus,
      deductions: entity.deductions,
      totalEarnings: entity.totalEarnings,
      status: entity.status,
      paidDate: entity.paidDate,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory PayrollRecordModel.fromJson(Map<String, dynamic> json) {
    return PayrollRecordModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      employeeId: json['employee_id'] as String,
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      baseSalary: (json['base_salary'] as num).toDouble(),
      productionBonus: (json['production_bonus'] as num).toDouble(),
      deductions: (json['deductions'] as num).toDouble(),
      totalEarnings: (json['total_earnings'] as num).toDouble(),
      status: json['status'] as String,
      paidDate: json['paid_date'] != null
          ? DateTime.parse(json['paid_date'] as String)
          : null,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'employee_id': employeeId,
      'period_start': periodStart.toIso8601String(),
      'period_end': periodEnd.toIso8601String(),
      'base_salary': baseSalary,
      'production_bonus': productionBonus,
      'deductions': deductions,
      'total_earnings': totalEarnings,
      'status': status,
      'paid_date': paidDate?.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  PayrollRecordModel copyWith({
    String? id,
    String? userId,
    String? employeeId,
    DateTime? periodStart,
    DateTime? periodEnd,
    double? baseSalary,
    double? productionBonus,
    double? deductions,
    double? totalEarnings,
    String? status,
    DateTime? paidDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PayrollRecordModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      employeeId: employeeId ?? this.employeeId,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      baseSalary: baseSalary ?? this.baseSalary,
      productionBonus: productionBonus ?? this.productionBonus,
      deductions: deductions ?? this.deductions,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      status: status ?? this.status,
      paidDate: paidDate ?? this.paidDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
