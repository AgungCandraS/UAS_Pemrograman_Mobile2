import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/production_repository.dart';
import '../domain/production_record_model.dart';

// Repository Provider
final productionRepositoryProvider = Provider((ref) => ProductionRepository());

// ==================== PRODUCTION PROVIDERS ====================

/// Fetch all production records (with optional filters)
final productionRecordsProvider = FutureProvider.autoDispose
    .family<
        List<ProductionRecord>,
        ({
          String? employeeId,
          DateTime? startDate,
          DateTime? endDate,
        })>((ref, params) async {
  final repo = ref.watch(productionRepositoryProvider);
  return repo.fetchProductionRecords(
    employeeId: params.employeeId,
    startDate: params.startDate,
    endDate: params.endDate,
  );
});

/// Fetch employee's monthly production records
final employeeMonthlyProductionProvider = FutureProvider.autoDispose
    .family<
        List<ProductionRecord>,
        ({
          String employeeId,
          DateTime month,
        })>((ref, params) async {
  final repo = ref.watch(productionRepositoryProvider);
  return repo.fetchEmployeeMonthlyRecords(params.employeeId, params.month);
});

/// Create production record
final createProductionRecordProvider = FutureProvider.autoDispose
    .family<
        ProductionRecord,
        ({
          String employeeId,
          String productName,
          String department,
          int pcs,
          DateTime date,
          double ratePerPcs,
          String? losin,
          String? notes,
        })>((ref, params) async {
  final repo = ref.watch(productionRepositoryProvider);
  final record = await repo.createProductionRecord(
    employeeId: params.employeeId,
    productName: params.productName,
    department: params.department,
    pcs: params.pcs,
    date: params.date,
    ratePerPcs: params.ratePerPcs,
    losin: params.losin,
    notes: params.notes,
  );
  // Invalidate relevant providers
  ref.invalidate(productionRecordsProvider);
  ref.invalidate(employeeMonthlyProductionProvider);
  return record;
});

/// Update production record
final updateProductionRecordProvider = FutureProvider.autoDispose
    .family<
        ProductionRecord,
        ({
          String id,
          String? productName,
          String? department,
          int? pcs,
          DateTime? date,
          double? ratePerPcs,
          String? losin,
          String? notes,
        })>((ref, params) async {
  final repo = ref.watch(productionRepositoryProvider);
  final record = await repo.updateProductionRecord(
    id: params.id,
    productName: params.productName,
    department: params.department,
    pcs: params.pcs,
    date: params.date,
    ratePerPcs: params.ratePerPcs,
    losin: params.losin,
    notes: params.notes,
  );
  ref.invalidate(productionRecordsProvider);
  ref.invalidate(employeeMonthlyProductionProvider);
  return record;
});

/// Delete production record
final deleteProductionRecordProvider = FutureProvider.autoDispose
    .family<void, String>((ref, id) async {
  final repo = ref.watch(productionRepositoryProvider);
  await repo.deleteProductionRecord(id);
  ref.invalidate(productionRecordsProvider);
  ref.invalidate(employeeMonthlyProductionProvider);
});
