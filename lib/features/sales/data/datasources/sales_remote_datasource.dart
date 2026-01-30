import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sale_model.dart';

abstract class SalesRemoteDataSource {
  Future<SaleModel> recordSale({
    required String userId,
    required String saleType,
    required String channel,
    required List<SaleItemModel> items,
    required double totalRevenue,
    required double totalCost,
    required double totalAdminFee,
    required double totalProfit,
    required String notes,
  });

  Future<List<SaleModel>> getSalesByDate(String userId, DateTime date);
  Future<List<SaleModel>> getSalesByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );
}

class SalesRemoteDataSourceImpl implements SalesRemoteDataSource {
  final SupabaseClient _supabaseClient;

  SalesRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<SaleModel> recordSale({
    required String userId,
    required String saleType,
    required String channel,
    required List<SaleItemModel> items,
    required double totalRevenue,
    required double totalCost,
    required double totalAdminFee,
    required double totalProfit,
    required String notes,
  }) async {
    try {
      final now = DateTime.now();
      final dateOnly = DateTime(now.year, now.month, now.day);
      final dateStr = dateOnly.toIso8601String().split('T')[0];

      // Convert items to proper JSON structure
      // Keep numeric values as-is (don't over-convert)
      final List<Map<String, dynamic>> itemsList = items.map((e) {
        final json = e.toJson();
        return {
          'product_id': json['product_id'],
          'product_name': json['product_name'],
          'sku': json['sku'],
          'quantity': json['quantity'],
          'selling_price': json['selling_price'],
          'cost_price': json['cost_price'],
          'subtotal': json['subtotal'],
          'profit': json['profit'],
        };
      }).toList();

      // Build insert data
      final insertData = {
        'user_id': userId,
        'date': dateStr,
        'sale_type': saleType,
        'channel': channel,
        'items': itemsList,
        'total_revenue': totalRevenue,
        'total_cost': totalCost,
        'total_admin_fee': totalAdminFee,
        'total_profit': totalProfit,
        'notes': notes,
      };

      debugPrint('💾 Inserting to database:');
      debugPrint('   User ID: $userId');
      debugPrint('   Date: $dateStr');
      debugPrint('   Type: $saleType');
      debugPrint('   Channel: $channel');
      debugPrint('   Items count: ${itemsList.length}');
      for (int i = 0; i < itemsList.length; i++) {
        debugPrint(
          '   Item $i: ${itemsList[i]['product_name']} x ${itemsList[i]['quantity']} @ ${itemsList[i]['selling_price']}',
        );
      }
      debugPrint('   Revenue: $totalRevenue');
      debugPrint('   Cost: $totalCost');
      debugPrint('   Admin Fee: $totalAdminFee');
      debugPrint('   Profit: $totalProfit');

      debugPrint('💾 Sending to database: ${jsonEncode(insertData)}');

      final response = await _supabaseClient
          .from('sales')
          .insert(insertData)
          .select();

      if (response.isEmpty) {
        throw Exception('No response from server');
      }

      debugPrint('✅ Database response successful');

      return SaleModel.fromJson(response.first);
    } catch (e, stack) {
      debugPrint('❌ Database error: $e');
      debugPrint('Stack trace: $stack');
      rethrow; // Rethrow to preserve original error
    }
  }

  @override
  Future<List<SaleModel>> getSalesByDate(String userId, DateTime date) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);
      final dateStr = dateOnly.toIso8601String().split('T')[0];

      final response = await _supabaseClient
          .from('sales')
          .select()
          .eq('user_id', userId)
          .eq('date', dateStr)
          .order('created_at', ascending: false);

      if (response.isEmpty) {
        return [];
      }

      return (response as List<dynamic>)
          .map((e) => SaleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get sales: $e');
    }
  }

  @override
  Future<List<SaleModel>> getSalesByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final startOnly = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );
      final endOnly = DateTime(endDate.year, endDate.month, endDate.day);
      final startStr = startOnly.toIso8601String().split('T')[0];
      final endStr = endOnly.toIso8601String().split('T')[0];

      final response = await _supabaseClient
          .from('sales')
          .select()
          .eq('user_id', userId)
          .gte('date', startStr)
          .lte('date', endStr)
          .order('date', ascending: false);

      if (response.isEmpty) {
        return [];
      }

      return (response as List<dynamic>)
          .map((e) => SaleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get sales: $e');
    }
  }
}
