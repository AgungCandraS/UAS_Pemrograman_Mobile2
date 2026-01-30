import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../models/employee_model.dart' as employee_model;

/// Local datasource untuk caching employees di device
abstract class EmployeeLocalDataSource {
  Future<void> saveEmployee(employee_model.EmployeeModel employee);
  Future<void> saveEmployees(List<employee_model.EmployeeModel> employees);
  Future<employee_model.EmployeeModel?> getEmployeeById(String employeeId);
  Future<List<employee_model.EmployeeModel>> getUserEmployees(String userId);
  Future<void> deleteEmployee(String employeeId);
  Future<void> clearAllEmployees();
}

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource {
  static const _boxName = 'employees';

  EmployeeLocalDataSourceImpl();

  Future<Box<String>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }

  @override
  Future<void> saveEmployee(employee_model.EmployeeModel employee) async {
    final box = await _getBox();
    final json = jsonEncode(employee.toJson());
    await box.put(employee.id, json);
  }

  @override
  Future<void> saveEmployees(
    List<employee_model.EmployeeModel> employees,
  ) async {
    final box = await _getBox();
    for (final employee in employees) {
      final json = jsonEncode(employee.toJson());
      await box.put(employee.id, json);
    }
  }

  @override
  Future<employee_model.EmployeeModel?> getEmployeeById(
    String employeeId,
  ) async {
    final box = await _getBox();
    final json = box.get(employeeId);
    if (json == null) return null;
    final data = jsonDecode(json) as Map<String, dynamic>;
    return employee_model.EmployeeModel.fromJson(data);
  }

  @override
  Future<List<employee_model.EmployeeModel>> getUserEmployees(
    String userId,
  ) async {
    final box = await _getBox();
    final allEmployees = <employee_model.EmployeeModel>[];

    for (final json in box.values) {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final employee = employee_model.EmployeeModel.fromJson(data);
      allEmployees.add(employee);
    }

    // Filter by userId and isActive
    return allEmployees
        .where((emp) => emp.userId == userId && emp.isActive)
        .toList()
      ..sort((a, b) => a.nama.compareTo(b.nama));
  }

  @override
  Future<void> deleteEmployee(String employeeId) async {
    final box = await _getBox();
    await box.delete(employeeId);
  }

  @override
  Future<void> clearAllEmployees() async {
    final box = await _getBox();
    await box.clear();
  }
}
