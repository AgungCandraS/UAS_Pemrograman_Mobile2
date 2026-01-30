import 'package:equatable/equatable.dart';

enum EmployeeDepartment { sablon, obras, jahit, packing, management }

class Employee extends Equatable {
  final String id;
  final String? nik;
  final String nama;
  final String email;
  final String phone;
  final String department;
  final String position;
  final DateTime? startDate;
  final double salaryBase;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Employee({
    required this.id,
    this.nik,
    required this.nama,
    required this.email,
    required this.phone,
    required this.department,
    required this.position,
    this.startDate,
    required this.salaryBase,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  Employee copyWith({
    String? id,
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
    return Employee(
      id: id ?? this.id,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id']?.toString() ?? '',
      nik: map['nik']?.toString(),
      nama: map['nama']?.toString() ?? 'Unnamed',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      department: map['department']?.toString() ?? '',
      position: map['position']?.toString() ?? '',
      startDate: map['start_date'] != null
          ? DateTime.tryParse(map['start_date'].toString())
          : null,
      salaryBase: (map['salary_base'] as num?)?.toDouble() ?? 0,
      isActive: map['is_active'] == true,
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
    nik,
    nama,
    email,
    phone,
    department,
    position,
    startDate,
    salaryBase,
    isActive,
    createdAt,
    updatedAt,
  ];
}
