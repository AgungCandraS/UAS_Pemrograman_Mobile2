import 'package:freezed_annotation/freezed_annotation.dart';

part 'production_report.freezed.dart';
part 'production_report.g.dart';

@freezed
class ProductionReport with _$ProductionReport {
  const factory ProductionReport({
    required String id,
    required DateTime startDate,
    required DateTime endDate,
    required int totalItems,
    required int completedItems,
    required int pendingItems,
    required int cancelledItems,
    required double completionRate,
    required List<DailyProduction> dailyProduction,
    required List<ProductionByStatus> statusBreakdown,
    required List<EmployeeProduction> employeeProductions,
    required double averageCompletionTime,
    required DateTime generatedAt,
  }) = _ProductionReport;

  factory ProductionReport.fromJson(Map<String, dynamic> json) =>
      _$ProductionReportFromJson(json);
}

@freezed
class DailyProduction with _$DailyProduction {
  const factory DailyProduction({
    required DateTime date,
    required int totalItems,
    required int completedItems,
    required int pendingItems,
    required double completionRate,
  }) = _DailyProduction;

  factory DailyProduction.fromJson(Map<String, dynamic> json) =>
      _$DailyProductionFromJson(json);
}

@freezed
class ProductionByStatus with _$ProductionByStatus {
  const factory ProductionByStatus({
    required String status,
    required int count,
    required double percentage,
  }) = _ProductionByStatus;

  factory ProductionByStatus.fromJson(Map<String, dynamic> json) =>
      _$ProductionByStatusFromJson(json);
}

@freezed
class EmployeeProduction with _$EmployeeProduction {
  const factory EmployeeProduction({
    required String employeeId,
    required String employeeName,
    required String department,
    required int totalPcs,
    required List<ProductionItem> items,
    required double totalEarnings,
  }) = _EmployeeProduction;

  factory EmployeeProduction.fromJson(Map<String, dynamic> json) =>
      _$EmployeeProductionFromJson(json);
}

@freezed
class ProductionItem with _$ProductionItem {
  const factory ProductionItem({
    required String productName,
    required String department,
    required int pcs,
    required double ratePerPcs,
    required double earnings,
    required String? losin,
  }) = _ProductionItem;

  factory ProductionItem.fromJson(Map<String, dynamic> json) =>
      _$ProductionItemFromJson(json);
}
