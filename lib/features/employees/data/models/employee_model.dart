import '../../domain/employee_model.dart';

class EmployeeModel extends Employee {
  final String userId;

  const EmployeeModel({
    required super.id,
    required super.nik,
    required super.nama,
    required super.email,
    required super.phone,
    required super.department,
    required super.position,
    required this.userId,
    super.startDate,
    required super.salaryBase,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory EmployeeModel.fromEntity(Employee entity, {required String userId}) {
    return EmployeeModel(
      id: entity.id,
      userId: userId,
      nik: entity.nik,
      nama: entity.nama,
      email: entity.email,
      phone: entity.phone,
      department: entity.department,
      position: entity.position,
      startDate: entity.startDate,
      salaryBase: entity.salaryBase,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      nik: json['nik'] as String,
      nama: json['nama'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      department: json['department'] as String,
      position: json['position'] as String,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'] as String)
          : null,
      salaryBase: (json['salary_base'] as num?)?.toDouble() ?? 0,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nik': nik,
      'nama': nama,
      'email': email,
      'phone': phone,
      'department': department,
      'position': position,
      'start_date': startDate?.toIso8601String(),
      'salary_base': salaryBase,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  EmployeeModel copyWith({
    String? id,
    String? userId,
    String? nik,
    String? nama,
    String? email,
    String? phone,
    String? department,
    String? position,
    DateTime? startDate,
    double? salaryBase,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nik: nik ?? this.nik,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      salaryBase: salaryBase ?? this.salaryBase,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
