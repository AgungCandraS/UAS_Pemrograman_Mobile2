import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bisnisku/features/payroll/domain/payroll_model.dart';
import 'package:bisnisku/features/production/data/repositories/production_repository.dart';
import 'package:bisnisku/features/employees/data/repositories/employee_repository.dart';
import '../datasources/payroll_local_datasource.dart';
import '../models/payroll_record_model.dart' as payroll_model;

class PayrollRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final PayrollLocalDataSource? _localDataSource;
  static const String _tableName = 'payroll_records';
  final ProductionRepository _productionRepo;
  final EmployeeRepository _employeeRepo;

  PayrollRepository({
    ProductionRepository? productionRepo,
    EmployeeRepository? employeeRepo,
    PayrollLocalDataSource? localDataSource,
  }) : _productionRepo = productionRepo ?? ProductionRepository(),
       _employeeRepo = employeeRepo ?? EmployeeRepository(),
       _localDataSource = localDataSource ?? PayrollLocalDataSourceImpl();

  String _dateOnly(DateTime dt) => dt.toIso8601String().split('T')[0];

  String? _getCurrentUserId() => _client.auth.currentUser?.id;

  String _requireUserId() {
    final userId = _getCurrentUserId();
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return userId;
  }

  Future<List<PayrollRecord>> fetchPayrollRecords({
    String? employeeId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final userId = _requireUserId();
      var query = _client.from(_tableName).select().eq('user_id', userId);

      if (employeeId != null) {
        query = query.eq('employee_id', employeeId);
      }

      if (status != null) {
        query = query.eq('status', status);
      }

      if (startDate != null && endDate != null) {
        query = query
            .gte('period_start', _dateOnly(startDate))
            .lte('period_end', _dateOnly(endDate));
      }

      final response = await query.order('period_start', ascending: false);

      final records = (response as List<dynamic>)
          .map((e) => PayrollRecord.fromMap(e as Map<String, dynamic>))
          .toList();

      // Cache locally
      if (_localDataSource != null) {
        final models = records
            .map(
              (r) => payroll_model.PayrollRecordModel.fromEntity(
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
      throw Exception('Failed to fetch payroll records: $e');
    }
  }

  Future<PayrollRecord?> fetchPayrollByPeriod(
    String employeeId,
    DateTime periodStart,
    DateTime periodEnd,
  ) async {
    try {
      final userId = _requireUserId();
      final response = await _client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .eq('employee_id', employeeId)
          .eq('period_start', _dateOnly(periodStart))
          .eq('period_end', _dateOnly(periodEnd))
          .maybeSingle();

      if (response == null) return null;
      final record = PayrollRecord.fromMap(response);

      // Cache locally
      if (_localDataSource != null) {
        await _localDataSource.saveRecord(
          payroll_model.PayrollRecordModel.fromEntity(record, userId: userId),
        );
      }

      return record;
    } catch (e) {
      throw Exception('Failed to fetch payroll: $e');
    }
  }

  Future<PayrollRecord> generatePayroll({
    required String employeeId,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async {
    try {
      final userId = _requireUserId();

      // Fetch employee data
      final employee = await _employeeRepo.fetchEmployeeById(employeeId);
      if (employee == null) {
        throw Exception('Employee not found');
      }

      // Fetch production records for the period
      final productionRecords = await _productionRepo.fetchProductionRecords(
        employeeId: employeeId,
        startDate: periodStart,
        endDate: periodEnd,
      );

      // Calculate production bonus dari total_earnings setiap production record
      double productionBonus = 0;
      for (final record in productionRecords) {
        productionBonus += record.totalEarnings;
      }

      // Calculate total earnings
      final baseSalary = employee.salaryBase;
      final totalEarnings = baseSalary + productionBonus;

      // Hapus record yang sudah ada untuk periode ini agar tidak duplikat
      // Saat di-regenerate, record lama dihapus dan dibuat baru dengan kalkulasi terbaru
      await _client
          .from(_tableName)
          .delete()
          .eq('user_id', userId)
          .eq('employee_id', employeeId)
          .eq('period_start', _dateOnly(periodStart))
          .eq('period_end', _dateOnly(periodEnd));

      // Insert record baru dengan kalkulasi terbaru
      final now = DateTime.now();
      final response = await _client
          .from(_tableName)
          .insert({
            'user_id': userId,
            'employee_id': employeeId,
            'period_start': _dateOnly(periodStart),
            'period_end': _dateOnly(periodEnd),
            'base_salary': baseSalary,
            'production_bonus': productionBonus,
            'deductions': 0,
            'total_earnings': totalEarnings,
            'status': 'pending',
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .select()
          .single();

      final record = PayrollRecord.fromMap(response);

      // Cache locally
      if (_localDataSource != null) {
        await _localDataSource.saveRecord(
          payroll_model.PayrollRecordModel.fromEntity(record, userId: userId),
        );
      }

      return record;
    } catch (e) {
      throw Exception('Failed to generate payroll: $e');
    }
  }

  Future<PayrollRecord> updatePayroll({
    required String id,
    double? baseSalary,
    double? productionBonus,
    double? deductions,
    double? totalEarnings,
    String? status,
    DateTime? paidDate,
    String? notes,
  }) async {
    try {
      final userId = _requireUserId();
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (baseSalary != null) updates['base_salary'] = baseSalary;
      if (productionBonus != null) {
        updates['production_bonus'] = productionBonus;
      }
      if (deductions != null) updates['deductions'] = deductions;
      if (totalEarnings != null) updates['total_earnings'] = totalEarnings;
      if (status != null) updates['status'] = status;
      if (paidDate != null) updates['paid_date'] = paidDate.toIso8601String();
      if (notes != null) updates['notes'] = notes;

      final response = await _client
          .from(_tableName)
          .update(updates)
          .eq('user_id', userId)
          .eq('id', id)
          .select()
          .single();

      final record = PayrollRecord.fromMap(response);

      // Cache locally
      if (_localDataSource != null) {
        await _localDataSource.saveRecord(
          payroll_model.PayrollRecordModel.fromEntity(record, userId: userId),
        );
      }

      return record;
    } catch (e) {
      throw Exception('Failed to update payroll: $e');
    }
  }

  Future<void> approvePayroll(String id) async {
    try {
      final userId = _requireUserId();
      await _client
          .from(_tableName)
          .update({
            'status': 'approved',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('id', id);

      // Update local cache
      if (_localDataSource != null) {
        final record = await _localDataSource.getRecordById(id);
        if (record != null) {
          await _localDataSource.saveRecord(
            record.copyWith(status: 'approved'),
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to approve payroll: $e');
    }
  }

  Future<void> markAsPaid(String id, DateTime paidDate) async {
    try {
      final userId = _requireUserId();
      await _client
          .from(_tableName)
          .update({
            'status': 'paid',
            'paid_date': paidDate.toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('id', id);

      // Update local cache
      if (_localDataSource != null) {
        final record = await _localDataSource.getRecordById(id);
        if (record != null) {
          await _localDataSource.saveRecord(
            record.copyWith(status: 'paid', paidDate: paidDate),
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to mark payroll as paid: $e');
    }
  }
}
