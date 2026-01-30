import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/sale.dart';
import '../../domain/repositories/sales_repository.dart';
import '../datasources/sales_remote_datasource.dart';
import '../models/sale_model.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesRemoteDataSource _remoteDataSource;
  final SupabaseClient _supabaseClient;

  SalesRepositoryImpl(this._remoteDataSource, this._supabaseClient);

  @override
  Future<Sale> recordSale({
    required String saleType,
    required String channel,
    required List<SaleItem> items,
    required double adminFee,
    required String notes,
  }) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;

      if (userId == null || userId.isEmpty) {
        throw Exception('User not authenticated. Please login again.');
      }

      debugPrint('📝 Recording sale for user: $userId');
      debugPrint('📝 Sale type: $saleType, Channel: $channel');
      debugPrint('📝 Items count: ${items.length}');
      debugPrint('📝 Admin fee: $adminFee');

      // Calculate totals
      double totalRevenue = 0;
      double totalCost = 0;
      double totalProfit = 0;

      final saleItems = <SaleItemModel>[];

      for (var item in items) {
        totalRevenue += item.subtotal;
        totalCost += item.costPrice * item.quantity;

        final itemProfit = item.subtotal - (item.costPrice * item.quantity);
        totalProfit += itemProfit;

        saleItems.add(
          SaleItemModel(
            productId: item.productId,
            productName: item.productName,
            sku: item.sku,
            quantity: item.quantity,
            sellingPrice: item.sellingPrice,
            costPrice: item.costPrice,
            subtotal: item.subtotal,
            profit: itemProfit,
          ),
        );
      }

      // Apply admin fee
      final finalProfit = totalProfit - adminFee;

      final result = await _remoteDataSource.recordSale(
        userId: userId,
        saleType: saleType,
        channel: channel,
        items: saleItems,
        totalRevenue: totalRevenue,
        totalCost: totalCost,
        totalAdminFee: adminFee,
        totalProfit: finalProfit,
        notes: notes,
      );
      return result.toDomain();
    } catch (e) {
      throw Exception('Failed to record sale: $e');
    }
  }

  @override
  Future<List<Sale>> getSalesByDate(DateTime date) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id ?? '';
      final models = await _remoteDataSource.getSalesByDate(userId, date);
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get sales: $e');
    }
  }

  @override
  Future<SaleSummary> getSalesSummary(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id ?? '';
      final salesModels = await _remoteDataSource.getSalesByDateRange(
        userId,
        startDate,
        endDate,
      );

      double totalRevenue = 0;
      double totalCost = 0;
      double totalProfit = 0;
      double totalAdminFee = 0;

      for (var sale in salesModels) {
        totalRevenue += sale.totalRevenue;
        totalCost += sale.totalCost;
        totalProfit += sale.totalProfit;
        totalAdminFee += sale.totalAdminFee;
      }

      return SaleSummary(
        totalSales: salesModels.length,
        totalRevenue: totalRevenue,
        totalCost: totalCost,
        totalProfit: totalProfit,
        totalAdminFee: totalAdminFee,
        sales: salesModels.map((m) => m.toDomain()).toList(),
      );
    } catch (e) {
      throw Exception('Failed to get sales summary: $e');
    }
  }

  @override
  Future<Sale> getSaleById(String id) async {
    try {
      final response = await _supabaseClient
          .from('sales')
          .select()
          .eq('id', id);
      return SaleModel.fromJson(response.first).toDomain();
    } catch (e) {
      throw Exception('Failed to get sale: $e');
    }
  }

  @override
  Future<void> updateSale(Sale sale) async {
    try {
      final itemsJson = sale.items
          .map(
            (e) => {
              'product_id': e.productId,
              'product_name': e.productName,
              'sku': e.sku,
              'quantity': e.quantity,
              'selling_price': e.sellingPrice,
              'cost_price': e.costPrice,
              'subtotal': e.subtotal,
              'profit': e.profit,
            },
          )
          .toList();

      await _supabaseClient
          .from('sales')
          .update({
            'sale_type': sale.saleType,
            'channel': sale.channel,
            'items': itemsJson,
            'total_revenue': sale.totalRevenue,
            'total_cost': sale.totalCost,
            'total_admin_fee': sale.totalAdminFee,
            'total_profit': sale.totalProfit,
            'notes': sale.notes,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', sale.id);
    } catch (e) {
      throw Exception('Failed to update sale: $e');
    }
  }

  @override
  Future<void> deleteSale(String id) async {
    try {
      await _supabaseClient.from('sales').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete sale: $e');
    }
  }
}
