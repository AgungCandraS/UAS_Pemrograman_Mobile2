import 'package:bisnisku/features/inventory/data/datasources/inventory_datasource.dart';
import 'package:bisnisku/features/inventory/data/models/inventory_item_model.dart';
import 'package:bisnisku/features/inventory/domain/entities/index.dart';
import 'package:bisnisku/features/inventory/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl({required this.remoteDataSource});

  final InventoryRemoteDataSource remoteDataSource;

  @override
  Future<List<InventoryItem>> getAllItems() async {
    return remoteDataSource.getAllItems();
  }

  @override
  Future<InventoryItem?> getItemById(String itemId) async {
    return remoteDataSource.getItemById(itemId);
  }

  @override
  Future<List<InventoryItem>> searchItems(String query) async {
    if (query.trim().isEmpty) {
      return remoteDataSource.getAllItems();
    }
    return remoteDataSource.searchItems(query);
  }

  @override
  Future<String> createItem({
    required InventoryItem item,
    required List<InventoryVariant> variants,
  }) async {
    final itemModel = InventoryItemModel.fromEntity(item);
    final variantModels = variants
        .map((variant) => InventoryVariantModel.fromEntity(variant))
        .toList();
    return remoteDataSource.createItem(
      item: itemModel,
      variants: variantModels,
    );
  }

  @override
  Future<void> updateItem({required InventoryItem item}) async {
    final itemModel = InventoryItemModel.fromEntity(item);
    await remoteDataSource.updateItem(item: itemModel);
  }

  @override
  Future<String> addVariant({
    required String itemId,
    required InventoryVariant variant,
  }) async {
    final variantModel = InventoryVariantModel.fromEntity(
      variant.copyWith(inventoryItemId: itemId),
    );
    return remoteDataSource.addVariant(itemId: itemId, variant: variantModel);
  }

  @override
  Future<void> updateVariant({required InventoryVariant variant}) async {
    final variantModel = InventoryVariantModel.fromEntity(variant);
    await remoteDataSource.updateVariant(variant: variantModel);
  }

  @override
  Future<void> deleteVariant(String variantId) async {
    await remoteDataSource.deleteVariant(variantId);
  }

  @override
  Future<void> deleteItem(String itemId) async {
    await remoteDataSource.deleteItem(itemId);
  }

  @override
  Future<void> bulkEditVariants(BulkEditPayload payload) async {
    await remoteDataSource.bulkEditVariants(payload);
  }
}
