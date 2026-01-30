import 'package:bisnisku/features/inventory/data/datasources/inventory_datasource.dart';
import 'package:bisnisku/features/inventory/data/models/inventory_item_model.dart';
import 'package:bisnisku/features/inventory/domain/entities/index.dart';
import 'package:bisnisku/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  InventoryRemoteDataSourceImpl({required this.supabaseService});

  final SupabaseService supabaseService;

  static const _itemSelect =
      'id,user_id,title,sku,description,category,image_url,is_active,created_at,updated_at,'
      'variants:inventory_item_variants(id,inventory_item_id,user_id,color_name,initial_price,selling_price,stock_quantity,min_stock_level,created_at,updated_at)';

  String _requireUserId() {
    final userId = supabaseService.currentUser?.id;
    if (userId == null) {
      throw const PostgrestException(
        code: 'not_authenticated',
        message: 'User is not authenticated',
        details: 'Login is required to access inventory',
      );
    }
    return userId;
  }

  @override
  Future<List<InventoryItemModel>> getAllItems() async {
    return _guard(() async {
      final userId = _requireUserId();
      final response = await supabaseService.client
          .from('inventory_items')
          .select(_itemSelect)
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => InventoryItemModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<InventoryItemModel?> getItemById(String itemId) async {
    return _guard(() async {
      final userId = _requireUserId();
      final Map<String, dynamic>? response = await supabaseService.client
          .from('inventory_items')
          .select(_itemSelect)
          .eq('id', itemId)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;
      return InventoryItemModel.fromJson(response);
    });
  }

  @override
  Future<List<InventoryItemModel>> searchItems(String query) async {
    return _guard(() async {
      final userId = _requireUserId();
      final response = await supabaseService.client
          .from('inventory_items')
          .select(_itemSelect)
          .eq('user_id', userId)
          .or('title.ilike.%$query%,sku.ilike.%$query%')
          .order('updated_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => InventoryItemModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<String> createItem({
    required InventoryItemModel item,
    required List<InventoryVariantModel> variants,
  }) async {
    return _guard(() async {
      final userId = _requireUserId();
      final payload = item.toJson(includeUser: false)..['user_id'] = userId;

      final inserted = await supabaseService.client
          .from('inventory_items')
          .insert(payload)
          .select('id')
          .single();

      final itemId = inserted['id'] as String;

      if (variants.isNotEmpty) {
        final nowIso = DateTime.now().toIso8601String();
        final variantPayload = variants.map((variant) {
          final data = variant.toJson(
            includeId: false,
            includeItemId: true,
            includeUserId: true,
          );
          data['inventory_item_id'] = itemId;
          data['user_id'] = userId;
          data['created_at'] = nowIso;
          data['updated_at'] = nowIso;
          return data;
        }).toList();

        await supabaseService.client
            .from('inventory_item_variants')
            .insert(variantPayload);
      }

      return itemId;
    });
  }

  @override
  Future<void> updateItem({required InventoryItemModel item}) async {
    return _guard(() async {
      _requireUserId();
      final payload = item.toJson(includeId: false, includeUser: false)
        ..['updated_at'] = DateTime.now().toIso8601String();

      await supabaseService.client
          .from('inventory_items')
          .update(payload)
          .eq('id', item.id);
    });
  }

  @override
  Future<String> addVariant({
    required String itemId,
    required InventoryVariantModel variant,
  }) async {
    return _guard(() async {
      final userId = _requireUserId();
      final nowIso = DateTime.now().toIso8601String();
      final payload =
          variant.toJson(
              includeId: false,
              includeItemId: true,
              includeUserId: true,
            )
            ..['inventory_item_id'] = itemId
            ..['user_id'] = userId
            ..['created_at'] = nowIso
            ..['updated_at'] = nowIso;

      final response = await supabaseService.client
          .from('inventory_item_variants')
          .insert(payload)
          .select('id')
          .single();

      return response['id'] as String;
    });
  }

  @override
  Future<void> updateVariant({required InventoryVariantModel variant}) async {
    return _guard(() async {
      _requireUserId();
      final payload = variant.toJson(includeId: false, includeItemId: false)
        ..['updated_at'] = DateTime.now().toIso8601String();

      await supabaseService.client
          .from('inventory_item_variants')
          .update(payload)
          .eq('id', variant.id);
    });
  }

  @override
  Future<void> deleteVariant(String variantId) async {
    return _guard(() async {
      _requireUserId();
      await supabaseService.client
          .from('inventory_item_variants')
          .delete()
          .eq('id', variantId);
    });
  }

  @override
  Future<void> deleteItem(String itemId) async {
    return _guard(() async {
      _requireUserId();
      await supabaseService.client
          .from('inventory_items')
          .delete()
          .eq('id', itemId);
    });
  }

  @override
  Future<void> bulkEditVariants(BulkEditPayload payload) async {
    return _guard(() async {
      if (payload.variantIds.isEmpty) return;
      final userId = _requireUserId();

      final variants = await supabaseService.client
          .from('inventory_item_variants')
          .select('id,stock_quantity,min_stock_level,selling_price')
          .inFilter('id', payload.variantIds)
          .eq('user_id', userId);

      final now = DateTime.now().toIso8601String();

      await Future.wait(
        (variants as List<dynamic>).map((variant) async {
          final currentStock = (variant['stock_quantity'] as num).toInt();
          final currentMinStock = (variant['min_stock_level'] as num).toInt();
          final updatePayload = <String, dynamic>{
            if (payload.newSellingPrice != null)
              'selling_price': payload.newSellingPrice,
            if (payload.stockQuantity != null)
              'stock_quantity': payload.incrementStock
                  ? currentStock + payload.stockQuantity!
                  : payload.stockQuantity,
            if (payload.minStockLevel != null)
              'min_stock_level': payload.minStockLevel ?? currentMinStock,
            'updated_at': now,
          };

          await supabaseService.client
              .from('inventory_item_variants')
              .update(updatePayload)
              .eq('id', variant['id'] as String);
        }),
      );
    });
  }

  Future<T> _guard<T>(Future<T> Function() runner) async {
    try {
      return await _runWithRetry(runner);
    } on PostgrestException {
      rethrow;
    } catch (error) {
      throw PostgrestException(
        message: error.toString(),
        details: 'Inventory datasource failure',
        code: 'inventory_error',
      );
    }
  }

  Future<T> _runWithRetry<T>(
    Future<T> Function() runner, {
    bool canRetry = true,
  }) async {
    try {
      return await runner();
    } on PostgrestException catch (error) {
      final shouldRefresh = _isAuthExpired(error) && canRetry;
      if (shouldRefresh) {
        await _refreshSession();
        return _runWithRetry(runner, canRetry: false);
      }
      rethrow;
    }
  }

  bool _isAuthExpired(PostgrestException error) {
    final message = error.message.toLowerCase();
    return error.code == 'PGRST303' || message.contains('jwt expired');
  }

  Future<void> _refreshSession() async {
    try {
      await supabaseService.auth.refreshSession();
    } catch (_) {
      // Bubble up original failure; refresh best-effort only.
    }
  }
}
