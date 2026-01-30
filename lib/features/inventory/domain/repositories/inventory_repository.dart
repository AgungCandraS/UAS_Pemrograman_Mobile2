import 'package:bisnisku/features/inventory/domain/entities/index.dart';

abstract class InventoryRepository {
  /// Get all inventory items for current user.
  Future<List<InventoryItem>> getAllItems();

  /// Get a single inventory item by ID.
  Future<InventoryItem?> getItemById(String itemId);

  /// Search inventory items by title or SKU.
  Future<List<InventoryItem>> searchItems(String query);

  /// Create a new inventory item with variants and return the new item id.
  Future<String> createItem({
    required InventoryItem item,
    required List<InventoryVariant> variants,
  });

  /// Update an inventory item base info.
  Future<void> updateItem({required InventoryItem item});

  /// Add a new variant under an item and return the new variant id.
  Future<String> addVariant({
    required String itemId,
    required InventoryVariant variant,
  });

  /// Update an existing variant.
  Future<void> updateVariant({required InventoryVariant variant});

  /// Delete a variant by id.
  Future<void> deleteVariant(String variantId);

  /// Delete an inventory item (variants removed via cascade).
  Future<void> deleteItem(String itemId);

  /// Bulk edit multiple variants at once.
  Future<void> bulkEditVariants(BulkEditPayload payload);
}
