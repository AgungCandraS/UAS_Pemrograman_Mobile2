import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/employee_repository.dart';
import '../domain/employee_model.dart';

// Repository Provider
final employeeRepositoryProvider = Provider((ref) => EmployeeRepository());

// ==================== EMPLOYEE PROVIDERS ====================

/// Fetch all employees
final employeesProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(employeeRepositoryProvider);
  return repo.fetchEmployees();
});

/// Fetch single employee by ID
final employeeByIdProvider = FutureProvider.autoDispose
    .family<Employee?, String>((ref, id) async {
      final repo = ref.watch(employeeRepositoryProvider);
      return repo.fetchEmployeeById(id);
    });

/// Create employee
final createEmployeeProvider = FutureProvider.autoDispose
    .family<
      Employee,
      ({
        String nama,
        String email,
        String phone,
        String department,
        String position,
        DateTime? startDate,
        double salaryBase,
        String? nik,
      })
    >((ref, params) async {
      final repo = ref.watch(employeeRepositoryProvider);
      final employee = await repo.createEmployee(
        nama: params.nama,
        email: params.email,
        phone: params.phone,
        department: params.department,
        position: params.position,
        startDate: params.startDate,
        salaryBase: params.salaryBase,
        nik: params.nik,
      );
      ref.invalidate(employeesProvider);
      return employee;
    });

/// Update employee
final updateEmployeeProvider = FutureProvider.autoDispose
    .family<
      Employee,
      ({
        String id,
        String? nik,
        String? nama,
        String? email,
        String? phone,
        String? department,
        String? position,
        DateTime? startDate,
        double? salaryBase,
        bool? isActive,
      })
    >((ref, params) async {
      final repo = ref.watch(employeeRepositoryProvider);
      final employee = await repo.updateEmployee(
        id: params.id,
        nik: params.nik,
        nama: params.nama,
        email: params.email,
        phone: params.phone,
        department: params.department,
        position: params.position,
        startDate: params.startDate,
        salaryBase: params.salaryBase,
        isActive: params.isActive,
      );
      ref.invalidate(employeesProvider);
      ref.invalidate(employeeByIdProvider(params.id));
      return employee;
    });

/// Delete employee (soft delete)
final deleteEmployeeProvider = FutureProvider.autoDispose.family<void, String>((
  ref,
  id,
) async {
  final repo = ref.watch(employeeRepositoryProvider);
  await repo.deleteEmployee(id);
  ref.invalidate(employeesProvider);
  ref.invalidate(employeeByIdProvider(id));
});
