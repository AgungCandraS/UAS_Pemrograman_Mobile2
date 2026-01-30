import 'package:bisnisku/features/inventory/application/providers.dart';
import 'package:bisnisku/features/inventory/domain/entities/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final inventoryItemsProvider = FutureProvider<List<InventoryItem>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getAllItems();
});

final inventorySearchQueryProvider = StateProvider<String>((ref) => '');

final inventorySearchProvider =
    FutureProvider.family<List<InventoryItem>, String>((ref, query) async {
      final repository = ref.watch(inventoryRepositoryProvider);
      final trimmed = query.trim();
      if (trimmed.isEmpty) {
        return ref.watch(inventoryItemsProvider.future);
      }
      return repository.searchItems(trimmed);
    });

final inventoryItemByIdProvider = FutureProvider.family<InventoryItem?, String>(
  (ref, itemId) async {
    final repository = ref.watch(inventoryRepositoryProvider);
    return repository.getItemById(itemId);
  },
);

final selectedVariantsProvider = StateProvider<Set<String>>(
  (ref) => <String>{},
);

final lowStockOnlyProvider = StateProvider<bool>((ref) => false);
