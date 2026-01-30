import 'package:bisnisku/features/inventory/data/models/inventory_item_model.dart';
import 'package:bisnisku/features/inventory/domain/entities/index.dart';

abstract class InventoryLocalDataSource {
  Future<void> cacheItems(List<InventoryItemModel> items);
  Future<List<InventoryItemModel>> getCachedItems();
}

abstract class InventoryRemoteDataSource {
  Future<List<InventoryItemModel>> getAllItems();
  Future<InventoryItemModel?> getItemById(String itemId);
  Future<List<InventoryItemModel>> searchItems(String query);
  Future<String> createItem({
    required InventoryItemModel item,
    required List<InventoryVariantModel> variants,
  });
  Future<void> updateItem({required InventoryItemModel item});
  Future<String> addVariant({
    required String itemId,
    required InventoryVariantModel variant,
  });
  Future<void> updateVariant({required InventoryVariantModel variant});
  Future<void> deleteVariant(String variantId);
  Future<void> deleteItem(String itemId);
  Future<void> bulkEditVariants(BulkEditPayload payload);
}
