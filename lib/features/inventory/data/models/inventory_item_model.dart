import 'package:bisnisku/features/inventory/domain/entities/index.dart';

class InventoryItemModel extends InventoryItem {
  const InventoryItemModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.sku,
    super.description,
    super.category,
    super.imageUrl,
    super.isActive = true,
    super.variants = const [],
    required super.createdAt,
    required super.updatedAt,
  });

  factory InventoryItemModel.fromEntity(InventoryItem item) {
    return InventoryItemModel(
      id: item.id,
      userId: item.userId,
      title: item.title,
      sku: item.sku,
      description: item.description,
      category: item.category,
      imageUrl: item.imageUrl,
      isActive: item.isActive,
      variants: item.variants
          .map((v) => InventoryVariantModel.fromEntity(v))
          .toList(),
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    final variantsJson = (json['variants'] as List<dynamic>?) ?? [];
    return InventoryItemModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      sku: json['sku'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      imageUrl: json['image_url'] as String?,
      isActive: (json['is_active'] as bool?) ?? true,
      variants: variantsJson
          .map(
            (v) => InventoryVariantModel.fromJson(
              v as Map<String, dynamic>,
              fallbackItemId: json['id'] as String,
              fallbackUserId: json['user_id'] as String,
            ),
          )
          .toList(),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson({
    bool includeId = false,
    bool includeUser = true,
  }) {
    return {
      if (includeId) 'id': id,
      if (includeUser) 'user_id': userId,
      'title': title,
      'sku': sku,
      'description': description,
      'category': category,
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }
}

class InventoryVariantModel extends InventoryVariant {
  const InventoryVariantModel({
    required super.id,
    required super.inventoryItemId,
    required super.userId,
    required super.colorName,
    required super.initialPrice,
    required super.sellingPrice,
    required super.stockQuantity,
    required super.minStockLevel,
    required super.createdAt,
    required super.updatedAt,
  });

  factory InventoryVariantModel.fromEntity(InventoryVariant variant) {
    return InventoryVariantModel(
      id: variant.id,
      inventoryItemId: variant.inventoryItemId,
      userId: variant.userId,
      colorName: variant.colorName,
      initialPrice: variant.initialPrice,
      sellingPrice: variant.sellingPrice,
      stockQuantity: variant.stockQuantity,
      minStockLevel: variant.minStockLevel,
      createdAt: variant.createdAt,
      updatedAt: variant.updatedAt,
    );
  }

  factory InventoryVariantModel.fromJson(
    Map<String, dynamic> json, {
    required String fallbackItemId,
    required String fallbackUserId,
  }) {
    return InventoryVariantModel(
      id: json['id'] as String,
      inventoryItemId: (json['inventory_item_id'] as String?) ?? fallbackItemId,
      userId: (json['user_id'] as String?) ?? fallbackUserId,
      colorName: json['color_name'] as String,
      initialPrice: (json['initial_price'] as num).toDouble(),
      sellingPrice: (json['selling_price'] as num).toDouble(),
      stockQuantity: (json['stock_quantity'] as num).toInt(),
      minStockLevel: (json['min_stock_level'] as num).toInt(),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson({
    bool includeId = false,
    bool includeItemId = true,
    bool includeUserId = true,
  }) {
    return {
      if (includeId) 'id': id,
      if (includeItemId) 'inventory_item_id': inventoryItemId,
      if (includeUserId) 'user_id': userId,
      'color_name': colorName,
      'initial_price': initialPrice,
      'selling_price': sellingPrice,
      'stock_quantity': stockQuantity,
      'min_stock_level': minStockLevel,
    };
  }
}

DateTime _parseDate(dynamic value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.parse(value);
  return DateTime.now();
}
