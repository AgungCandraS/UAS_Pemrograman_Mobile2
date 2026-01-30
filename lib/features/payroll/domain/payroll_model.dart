import 'package:equatable/equatable.dart';

class PayrollRecord extends Equatable {
  final String id;
  final String employeeId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double baseSalary;
  final double productionBonus;
  final double deductions;
  final double totalEarnings;
  final String status; // 'pending', 'approved', 'paid'
  final DateTime? paidDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PayrollRecord({
    required this.id,
    required this.employeeId,
    required this.periodStart,
    required this.periodEnd,
    required this.baseSalary,
    required this.productionBonus,
    required this.deductions,
    required this.totalEarnings,
    required this.status,
    this.paidDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  PayrollRecord copyWith({
    String? id,
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
    return PayrollRecord(
      id: id ?? this.id,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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

  factory PayrollRecord.fromMap(Map<String, dynamic> map) {
    return PayrollRecord(
      id: map['id']?.toString() ?? '',
      employeeId: map['employee_id']?.toString() ?? '',
      periodStart: map['period_start'] != null
          ? (DateTime.tryParse(map['period_start'].toString()) ??
                DateTime.now())
          : DateTime.now(),
      periodEnd: map['period_end'] != null
          ? (DateTime.tryParse(map['period_end'].toString()) ?? DateTime.now())
          : DateTime.now(),
      baseSalary: (map['base_salary'] as num?)?.toDouble() ?? 0,
      productionBonus: (map['production_bonus'] as num?)?.toDouble() ?? 0,
      deductions: (map['deductions'] as num?)?.toDouble() ?? 0,
      totalEarnings: (map['total_earnings'] as num?)?.toDouble() ?? 0,
      status: map['status']?.toString() ?? 'pending',
      paidDate: map['paid_date'] != null
          ? DateTime.tryParse(map['paid_date'].toString())
          : null,
      notes: map['notes']?.toString(),
      createdAt: map['created_at'] != null
          ? (DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now())
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? (DateTime.tryParse(map['updated_at'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    employeeId,
    periodStart,
    periodEnd,
    baseSalary,
    productionBonus,
    deductions,
    totalEarnings,
    status,
    paidDate,
    notes,
    createdAt,
    updatedAt,
  ];
}
