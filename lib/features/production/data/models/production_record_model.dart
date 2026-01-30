import '../../domain/production_record_model.dart';

class ProductionRecordModel extends ProductionRecord {
  final String userId;

  const ProductionRecordModel({
    required super.id,
    required super.employeeId,
    required super.productName,
    required super.department,
    required super.pcs,
    required super.date,
    required this.userId,
    super.losin,
    super.notes,
    required super.ratePerPcs,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductionRecordModel.fromEntity(
    ProductionRecord entity, {
    required String userId,
  }) {
    return ProductionRecordModel(
      id: entity.id,
      userId: userId,
      employeeId: entity.employeeId,
      productName: entity.productName,
      department: entity.department,
      pcs: entity.pcs,
      date: entity.date,
      losin: entity.losin,
      notes: entity.notes,
      ratePerPcs: entity.ratePerPcs,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory ProductionRecordModel.fromJson(Map<String, dynamic> json) {
    return ProductionRecordModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      employeeId: json['employee_id'] as String,
      productName: json['product_name'] as String,
      department: json['department'] as String,
      pcs: json['pcs'] as int,
      date: DateTime.parse(json['date'] as String),
      losin: json['losin'] as String?,
      notes: json['notes'] as String?,
      ratePerPcs: (json['rate_per_pcs'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
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

  @override
  ProductionRecordModel copyWith({
    String? id,
    String? userId,
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
    return ProductionRecordModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
}
