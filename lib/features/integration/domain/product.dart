import 'package:equatable/equatable.dart';

/// Produk dinamis dengan harga per produksi
class Product extends Equatable {
  final String? id;
  final String
  name; // Nama produk (bisa ditambahkan dinamis, tidak terbatas belle/k5/k4/kulot)
  final String department; // e.g., "sablon", "obras", "jahit", "packing"
  final double defaultRatePerPcs; // Tarif per pcs untuk department ini
  final String? description;
  final bool isActive; // Produk aktif atau tidak
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    this.id,
    required this.name,
    required this.department,
    required this.defaultRatePerPcs,
    this.description,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String?,
      name: json['name'] as String,
      department: json['department'] as String,
      defaultRatePerPcs: (json['default_rate_per_pcs'] as num).toDouble(),
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'department': department,
      'default_rate_per_pcs': defaultRatePerPcs,
      if (description != null) 'description': description,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? department,
    double? defaultRatePerPcs,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      department: department ?? this.department,
      defaultRatePerPcs: defaultRatePerPcs ?? this.defaultRatePerPcs,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    department,
    defaultRatePerPcs,
    description,
    isActive,
    createdAt,
    updatedAt,
  ];
}
