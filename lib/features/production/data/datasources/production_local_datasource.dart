import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../models/production_record_model.dart' as production_model;

/// Local datasource untuk caching production records di device
abstract class ProductionLocalDataSource {
  Future<void> saveRecord(production_model.ProductionRecordModel record);
  Future<void> saveRecords(
    List<production_model.ProductionRecordModel> records,
  );
  Future<production_model.ProductionRecordModel?> getRecordById(
    String recordId,
  );
  Future<List<production_model.ProductionRecordModel>> getUserRecords(
    String userId,
  );
  Future<List<production_model.ProductionRecordModel>> getEmployeeRecords(
    String userId,
    String employeeId,
  );
  Future<void> deleteRecord(String recordId);
  Future<void> clearAllRecords();
}

class ProductionLocalDataSourceImpl implements ProductionLocalDataSource {
  static const _boxName = 'production_records';

  ProductionLocalDataSourceImpl();

  Future<Box<String>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }

  @override
  Future<void> saveRecord(production_model.ProductionRecordModel record) async {
    final box = await _getBox();
    final json = jsonEncode(record.toJson());
    await box.put(record.id, json);
  }

  @override
  Future<void> saveRecords(
    List<production_model.ProductionRecordModel> records,
  ) async {
    final box = await _getBox();
    for (final record in records) {
      final json = jsonEncode(record.toJson());
      await box.put(record.id, json);
    }
  }

  @override
  Future<production_model.ProductionRecordModel?> getRecordById(
    String recordId,
  ) async {
    final box = await _getBox();
    final json = box.get(recordId);
    if (json == null) return null;
    final data = jsonDecode(json) as Map<String, dynamic>;
    return production_model.ProductionRecordModel.fromJson(data);
  }

  @override
  Future<List<production_model.ProductionRecordModel>> getUserRecords(
    String userId,
  ) async {
    final box = await _getBox();
    final allRecords = <production_model.ProductionRecordModel>[];

    for (final json in box.values) {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final record = production_model.ProductionRecordModel.fromJson(data);
      allRecords.add(record);
    }

    // Filter by userId
    return allRecords.where((record) => record.userId == userId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<production_model.ProductionRecordModel>> getEmployeeRecords(
    String userId,
    String employeeId,
  ) async {
    final box = await _getBox();
    final allRecords = <production_model.ProductionRecordModel>[];

    for (final json in box.values) {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final record = production_model.ProductionRecordModel.fromJson(data);
      allRecords.add(record);
    }

    // Filter by userId and employeeId
    return allRecords
        .where(
          (record) =>
              record.userId == userId && record.employeeId == employeeId,
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
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
