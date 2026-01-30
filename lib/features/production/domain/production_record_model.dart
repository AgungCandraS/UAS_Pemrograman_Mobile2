import 'package:equatable/equatable.dart';

class ProductionRecord extends Equatable {
  final String id;
  final String employeeId;
  final String productName;
  final String department;
  final int pcs;
  final DateTime date;
  final String? losin;
  final String? notes;
  final double ratePerPcs;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductionRecord({
    required this.id,
    required this.employeeId,
    required this.productName,
    required this.department,
    required this.pcs,
    required this.date,
    this.losin,
    this.notes,
    required this.ratePerPcs,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalEarnings => pcs * ratePerPcs;

  ProductionRecord copyWith({
    String? id,
    String? employeeId,
    String? productName,
    String? department,
    int? pcs,
    DateTime? date,
    String? losin,
    String? notes,
    double? ratePerPcs,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductionRecord(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      productName: productName ?? this.productName,
      department: department ?? this.department,
      pcs: pcs ?? this.pcs,
      date: date ?? this.date,
      losin: losin ?? this.losin,
      notes: notes ?? this.notes,
      ratePerPcs: ratePerPcs ?? this.ratePerPcs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employeeId,
      'product_name': productName,
      'department': department,
      'pcs': pcs,
      'date': date.toIso8601String(),
      'losin': losin,
      'notes': notes,
      'rate_per_pcs': ratePerPcs,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ProductionRecord.fromMap(Map<String, dynamic> map) {
    return ProductionRecord(
      id: map['id']?.toString() ?? '',
      employeeId: map['employee_id']?.toString() ?? '',
      productName: map['product_name']?.toString() ?? 'Unknown Product',
      department: map['department']?.toString() ?? 'Unknown',
      pcs: (map['pcs'] as num?)?.toInt() ?? 0,
      date: map['date'] != null
          ? (DateTime.tryParse(map['date'].toString()) ?? DateTime.now())
          : DateTime.now(),
      losin: map['losin']?.toString(),
      notes: map['notes']?.toString(),
      ratePerPcs: (map['rate_per_pcs'] as num?)?.toDouble() ?? 0,
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
    productName,
    department,
    pcs,
    date,
    losin,
    notes,
    ratePerPcs,
    createdAt,
    updatedAt,
  ];
}
