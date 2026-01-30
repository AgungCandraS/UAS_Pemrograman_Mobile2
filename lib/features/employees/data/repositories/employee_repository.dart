import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bisnisku/features/employees/domain/employee_model.dart';
import '../datasources/employee_local_datasource.dart';
import '../models/employee_model.dart' as employee_model;

class EmployeeRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final EmployeeLocalDataSource? _localDataSource;
  static const String _tableName = 'employees';

  EmployeeRepository({EmployeeLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? EmployeeLocalDataSourceImpl();

  String? _getCurrentUserId() => _client.auth.currentUser?.id;

  /// Fetch employees from remote, cache locally, with local fallback
  Future<List<Employee>> fetchEmployees() async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Try remote first
      final response = await _client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('nama');

      final employees = (response as List<dynamic>)
          .map((e) => Employee.fromMap(e as Map<String, dynamic>))
          .toList();

      // Cache locally
      if (_localDataSource != null) {
        final models = employees
            .map(
              (e) => employee_model.EmployeeModel.fromEntity(e, userId: userId),
            )
            .toList();
        await _localDataSource.saveEmployees(models);
      }

      return employees;
    } catch (e) {
      // Fallback to local cache
      if (_localDataSource != null) {
        final userId = _getCurrentUserId();
        if (userId != null) {
          final cachedEmployees = await _localDataSource.getUserEmployees(
            userId,
          );
          if (cachedEmployees.isNotEmpty) {
            return cachedEmployees;
          }
        }
      }
      throw Exception('Failed to fetch employees: $e');
    }
  }

  Future<Employee?> fetchEmployeeById(String id) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;
      final employee = Employee.fromMap(response);

      // Cache locally
      if (_localDataSource != null) {
        await _localDataSource.saveEmployee(
          employee_model.EmployeeModel.fromEntity(employee, userId: userId),
        );
      }

      return employee;
    } catch (e) {
      // Fallback to local cache
      if (_localDataSource != null) {
        final cached = await _localDataSource.getEmployeeById(id);
        if (cached != null) return cached;
      }
      throw Exception('Failed to fetch employee: $e');
    }
  }

  Future<Employee> createEmployee({
    required String nama,
    required String email,
    required String phone,
    required String department,
    required String position,
    DateTime? startDate,
    double salaryBase = 0,
    String? nik,
  }) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final now = DateTime.now();
      final response = await _client
          .from(_tableName)
          .insert({
            'user_id': userId,
            'nik': nik,
            'nama': nama,
            'email': email,
            'phone': phone,
            'department': department,
            'position': position,
            'start_date': startDate?.toIso8601String(),
            'salary_base': salaryBase,
            'is_active': true,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .select()
          .single();

      final employee = Employee.fromMap(response);

      // Cache locally
      if (_localDataSource != null) {
        await _localDataSource.saveEmployee(
          employee_model.EmployeeModel.fromEntity(employee, userId: userId),
        );
      }

      return employee;
    } catch (e) {
      throw Exception('Failed to create employee: $e');
    }
  }

  Future<Employee> updateEmployee({
    required String id,
    String? nik,
    String? nama,
    String? email,
    String? phone,
    String? department,
    String? position,
    DateTime? startDate,
    double? salaryBase,
    bool? isActive,
  }) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (nik != null) updates['nik'] = nik;
      if (nama != null) updates['nama'] = nama;
      if (email != null) updates['email'] = email;
      if (phone != null) updates['phone'] = phone;
      if (department != null) updates['department'] = department;
      if (position != null) updates['position'] = position;
      if (startDate != null) {
        updates['start_date'] = startDate.toIso8601String();
      }
      if (salaryBase != null) updates['salary_base'] = salaryBase;
      if (isActive != null) updates['is_active'] = isActive;

      final response = await _client
          .from(_tableName)
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      final employee = Employee.fromMap(response);

      // Cache locally
      if (_localDataSource != null) {
        await _localDataSource.saveEmployee(
          employee_model.EmployeeModel.fromEntity(employee, userId: userId),
        );
      }

      return employee;
    } catch (e) {
      throw Exception('Failed to update employee: $e');
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await _client.from(_tableName).update({'is_active': false}).eq('id', id);

      // Remove from local cache
      if (_localDataSource != null) {
        await _localDataSource.deleteEmployee(id);
      }
    } catch (e) {
      throw Exception('Failed to delete employee: $e');
    }
  }
}
