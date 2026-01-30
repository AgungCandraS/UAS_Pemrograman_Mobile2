import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String department;
  final double defaultRatePerPcs;
  final String? description;
  final bool isActive;

  const Product({
    required this.id,
    required this.name,
    required this.department,
    required this.defaultRatePerPcs,
    this.description,
    required this.isActive,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      department: map['department'] ?? '',
      defaultRatePerPcs: (map['default_rate_per_pcs'] as num?)?.toDouble() ?? 0,
      description: map['description'],
      isActive: map['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'default_rate_per_pcs': defaultRatePerPcs,
      'description': description,
      'is_active': isActive,
    };
  }

  @override
  List<Object?> get props => [id, name, department, defaultRatePerPcs, description, isActive];
}
