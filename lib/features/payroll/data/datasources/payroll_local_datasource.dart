import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../models/payroll_record_model.dart' as payroll_model;

/// Local datasource untuk caching payroll records di device
abstract class PayrollLocalDataSource {
  Future<void> saveRecord(payroll_model.PayrollRecordModel record);
  Future<void> saveRecords(List<payroll_model.PayrollRecordModel> records);
  Future<payroll_model.PayrollRecordModel?> getRecordById(String recordId);
  Future<List<payroll_model.PayrollRecordModel>> getUserRecords(String userId);
  Future<List<payroll_model.PayrollRecordModel>> getEmployeeRecords(
    String userId,
    String employeeId,
  );
  Future<void> deleteRecord(String recordId);
  Future<void> clearAllRecords();
}

class PayrollLocalDataSourceImpl implements PayrollLocalDataSource {
  static const _boxName = 'payroll_records';

  PayrollLocalDataSourceImpl();

  Future<Box<String>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }

  @override
  Future<void> saveRecord(payroll_model.PayrollRecordModel record) async {
    final box = await _getBox();
    final json = jsonEncode(record.toJson());
    await box.put(record.id, json);
  }

  @override
  Future<void> saveRecords(
    List<payroll_model.PayrollRecordModel> records,
  ) async {
    final box = await _getBox();
    for (final record in records) {
      final json = jsonEncode(record.toJson());
      await box.put(record.id, json);
    }
  }

  @override
  Future<payroll_model.PayrollRecordModel?> getRecordById(
    String recordId,
  ) async {
    final box = await _getBox();
    final json = box.get(recordId);
    if (json == null) return null;
    final data = jsonDecode(json) as Map<String, dynamic>;
    return payroll_model.PayrollRecordModel.fromJson(data);
  }

  @override
  Future<List<payroll_model.PayrollRecordModel>> getUserRecords(
    String userId,
  ) async {
    final box = await _getBox();
    final allRecords = <payroll_model.PayrollRecordModel>[];

    for (final json in box.values) {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final record = payroll_model.PayrollRecordModel.fromJson(data);
      allRecords.add(record);
    }

    // Filter by userId
    return allRecords.where((record) => record.userId == userId).toList()
      ..sort((a, b) => b.periodStart.compareTo(a.periodStart));
  }

  @override
  Future<List<payroll_model.PayrollRecordModel>> getEmployeeRecords(
    String userId,
    String employeeId,
  ) async {
    final box = await _getBox();
    final allRecords = <payroll_model.PayrollRecordModel>[];

    for (final json in box.values) {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final record = payroll_model.PayrollRecordModel.fromJson(data);
      allRecords.add(record);
    }

    // Filter by userId and employeeId
    return allRecords
        .where(
          (record) =>
              record.userId == userId && record.employeeId == employeeId,
        )
        .toList()
      ..sort((a, b) => b.periodStart.compareTo(a.periodStart));
  }

  @override
  Future<void> deleteRecord(String recordId) async {
    final box = await _getBox();
    await box.delete(recordId);
  }

  @override
  Future<void> clearAllRecords() async {
    final box = await _getBox();
    await box.clear();
  }
}
