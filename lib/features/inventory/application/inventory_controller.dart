import 'package:bisnisku/features/inventory/application/inventory_state.dart';
import 'package:bisnisku/features/inventory/application/providers.dart';
import 'package:bisnisku/features/inventory/domain/entities/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryController {
  InventoryController(this.ref);

  final Ref ref;

  String _requireUserId() {
    final userId = ref.read(supabaseServiceProvider).currentUser?.id;
    if (userId == null || userId.isEmpty) {
      throw StateError('User not authenticated');
    }
    return userId;
  }

  Future<String> createInventoryItem({
    required String title,
    required String sku,
    String? description,
    String? category,
    String? imageUrl,
    required List<InventoryVariant> variants,
  }) async {
    final repository = ref.read(inventoryRepositoryProvider);
    final userId = _requireUserId();
    final now = DateTime.now();

    final item = InventoryItem(
      id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      title: title,
      sku: sku,
      description: description,
      category: category,
      imageUrl: imageUrl,
      isActive: true,
      variants: variants,
      createdAt: now,
      updatedAt: now,
    );

    final itemId = await repository.createItem(item: item, variants: variants);
    ref.invalidate(inventoryItemsProvider);
    return itemId;
  }

  Future<void> updateInventoryItem({
    required String itemId,
    required String title,
    required String sku,
    String? description,
    String? category,
    String? imageUrl,
    required List<InventoryVariant> variants,
    List<String> removedVariantIds = const [],
  }) async {
    final repository = ref.read(inventoryRepositoryProvider);
    final userId = _requireUserId();
    final now = DateTime.now();

    final item = InventoryItem(
      id: itemId,
      userId: userId,
      title: title,
      sku: sku,
      description: description,
      category: category,
      imageUrl: imageUrl,
      isActive: true,
      variants: variants,
      createdAt: now,
      updatedAt: now,
    );

    await repository.updateItem(item: item);

    for (final variant in variants) {
      if (variant.id.isEmpty) {
        await repository.addVariant(itemId: itemId, variant: variant);
      } else {
        await repository.updateVariant(variant: variant);
      }
    }

    for (final variantId in removedVariantIds) {
      await repository.deleteVariant(variantId);
    }

    ref.invalidate(inventoryItemsProvider);
    ref.invalidate(inventoryItemByIdProvider(itemId));
  }

  Future<void> deleteInventoryItem(String itemId) async {
    final repository = ref.read(inventoryRepositoryProvider);
    await repository.deleteItem(itemId);
    ref.invalidate(inventoryItemsProvider);
  }

  Future<void> bulkEditVariants(BulkEditPayload payload) async {
    final repository = ref.read(inventoryRepositoryProvider);
    await repository.bulkEditVariants(payload);
    ref.invalidate(inventoryItemsProvider);
  }
}

final inventoryControllerProvider = Provider<InventoryController>((ref) {
  return InventoryController(ref);
});
