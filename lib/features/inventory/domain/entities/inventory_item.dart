import 'package:equatable/equatable.dart';

/// Inventory item with its color variants.
class InventoryItem extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String sku;
  final String? description;
  final String? category;
  final String? imageUrl;
  final bool isActive;
  final List<InventoryVariant> variants;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InventoryItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.sku,
    this.description,
    this.category,
    this.imageUrl,
    this.isActive = true,
    this.variants = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  int getTotalStock() => variants.fold(0, (sum, v) => sum + v.stockQuantity);

  bool hasLowStock() => variants.any((v) => v.isLowStock());

  double getAverageSellingPrice() {
    if (variants.isEmpty) return 0;
    final total = variants.fold<double>(0, (sum, v) => sum + v.sellingPrice);
    return total / variants.length;
  }

  InventoryItem copyWith({
    String? id,
    String? userId,
    String? title,
    String? sku,
    String? description,
    String? category,
    String? imageUrl,
    bool? isActive,
    List<InventoryVariant>? variants,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      variants: variants ?? this.variants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    sku,
    description,
    category,
    imageUrl,
    isActive,
    variants,
    createdAt,
    updatedAt,
  ];
}

/// Variant represents a specific color and stock for an inventory item.
class InventoryVariant extends Equatable {
  final String id;
  final String inventoryItemId;
  final String userId;
  final String colorName;
  final double initialPrice;
  final double sellingPrice;
  final int stockQuantity;
  final int minStockLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InventoryVariant({
    required this.id,
    required this.inventoryItemId,
    required this.userId,
    required this.colorName,
    required this.initialPrice,
    required this.sellingPrice,
    required this.stockQuantity,
    required this.minStockLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  double getProfitMargin() {
    if (initialPrice == 0) return 0;
    return ((sellingPrice - initialPrice) / initialPrice) * 100;
  }

  bool isLowStock() => stockQuantity <= minStockLevel;

  InventoryVariant copyWith({
    String? id,
    String? inventoryItemId,
    String? userId,
    String? colorName,
    double? initialPrice,
    double? sellingPrice,
    int? stockQuantity,
    int? minStockLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryVariant(
      id: id ?? this.id,
      inventoryItemId: inventoryItemId ?? this.inventoryItemId,
      userId: userId ?? this.userId,
      colorName: colorName ?? this.colorName,
      initialPrice: initialPrice ?? this.initialPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    inventoryItemId,
    userId,
    colorName,
    initialPrice,
    sellingPrice,
    stockQuantity,
    minStockLevel,
    createdAt,
    updatedAt,
  ];
}
