import 'package:equatable/equatable.dart';

/// Kategori akuntansi untuk pencatatan income/expense
class AccountingCategory extends Equatable {
  final String? id;
  final String name; // e.g., "Penjualan", "Bahan Baku", "Operasional"
  final String type; // 'income' atau 'expense'
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AccountingCategory({
    this.id,
    required this.name,
    required this.type,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountingCategory.fromJson(Map<String, dynamic> json) {
    return AccountingCategory(
      id: json['id'] as String?,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'type': type,
      if (description != null) 'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AccountingCategory copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountingCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    description,
    createdAt,
    updatedAt,
  ];
}
