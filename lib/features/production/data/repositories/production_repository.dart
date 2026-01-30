import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bisnisku/features/production/domain/production_record_model.dart';
import '../datasources/production_local_datasource.dart';
import '../models/production_record_model.dart' as production_model;

class ProductionRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final ProductionLocalDataSource? _localDataSource;
  static const String _tableName = 'production_records';

  ProductionRepository({ProductionLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? ProductionLocalDataSourceImpl();

  String? _getCurrentUserId() => _client.auth.currentUser?.id;

  Future<List<ProductionRecord>> fetchProductionRecords({
    String? employeeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      var query = _client.from(_tableName).select().eq('user_id', userId);

      if (employeeId != null) {
        query = query.eq('employee_id', employeeId);
      }

      if (startDate != null && endDate != null) {
        query = query
            .gte('date', startDate.toIso8601String().split('T')[0])
            .lte('date', endDate.toIso8601String().split('T')[0]);
      }

      final response = await query.order('date', ascending: false);

      final records = (response as List<dynamic>)
          .map((e) => ProductionRecord.fromMap(e as Map<String, dynamic>))
          .toList();

      // Cache locally
      if (_localDataSource != null) {
        final models = records
            .map(
              (r) => production_model.ProductionRecordModel.fromEntity(
                r,
                userId: userId,
              ),
            )
            .toList();
        await _localDataSource.saveRecords(models);
      }

      return records;
    } catch (e) {
      // Fallback to local cache
      if (_localDataSource != null) {
        final userId = _getCurrentUserId();
        if (userId != null) {
          if (employeeId != null) {
            final cached = await _localDataSource.getEmployeeRecords(
              userId,
              employeeId,
            );
            if (cached.isNotEmpty) return cached;
          } else {
            final cached = await _localDataSource.getUserRecords(userId);
            if (cached.isNotEmpty) return cached;
          }
        }
      }
      throw Exception('Failed to fetch production records: $e');
    }
  }

  Future<ProductionRecord> createProductionRecord({
    required String employeeId,
    required String productName,
    required String department,
    required int pcs,
    required DateTime date,
    required double ratePerPcs,
    String? losin,
    String? notes,
  }) async {
    try {
      final now = DateTime.now();
      final userId = _getCurrentUserId();

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _client
          .from(_tableName)
          .insert({
            'user_id': userId,
            'employee_id': employeeId,
            'product_name': productName,
            'department': department,
            'pcs': pcs,
            'date': date.toIso8601String().split('T')[0],
            'rate_per_pcs': ratePerPcs,
            'losin': losin,
            'notes': notes,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .select()
          .single();

      final record = ProductionRecord.fromMap(response);

      // Cache locally
      if (_localDataSource != null) {
        await _localDataSource.saveRecord(
          production_model.ProductionRecordModel.fromEntity(
            record,
            userId: userId,
          ),
        );
      }

      return record;
    } catch (e) {
      throw Exception('Failed to create production record: $e');
    }
  }

  Future<ProductionRecord> updateProductionRecord({
    required String id,
    String? productName,
    String? department,
    int? pcs,
    DateTime? date,
    double? ratePerPcs,
    String? losin,
    String? notes,
  }) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (productName != null) updates['product_name'] = productName;
      if (department != null) updates['department'] = department;
      if (pcs != null) updates['pcs'] = pcs;
      if (date != null) updates['date'] = date.toIso8601String().split('T')[0];
      if (ratePerPcs != null) updates['rate_per_pcs'] = ratePerPcs;
      if (losin != null) updates['losin'] = losin;
      if (notes != null) updates['notes'] = notes;

      final response = await _client
          .from(_tableName)
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      final record = ProductionRecord.fromMap(response);

      // Cache locally
      if (_localDataSource != null) {
        await _localDataSource.saveRecord(
          production_model.ProductionRecordModel.fromEntity(
            record,
            userId: userId,
          ),
        );
      }

      return record;
    } catch (e) {
      throw Exception('Failed to update production record: $e');
    }
  }

  Future<void> deleteProductionRecord(String id) async {
    try {
      await _client.from(_tableName).delete().eq('id', id);

      // Remove from local cache
      if (_localDataSource != null) {
        await _localDataSource.deleteRecord(id);
      }
    } catch (e) {
      throw Exception('Failed to delete production record: $e');
    }
  }

  Future<List<ProductionRecord>> fetchEmployeeMonthlyRecords(
    String employeeId,
    DateTime month,
  ) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);

      return await fetchProductionRecords(
        employeeId: employeeId,
        startDate: startOfMonth,
        endDate: endOfMonth,
      );
    } catch (e) {
      throw Exception('Failed to fetch monthly records: $e');
    }
  }
}
