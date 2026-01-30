import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_report.freezed.dart';
part 'sales_report.g.dart';

/// Laporan penjualan dengan detail barang dan laba
@freezed
class SalesReport with _$SalesReport {
  const factory SalesReport({
    required String id,
    required DateTime startDate,
    required DateTime endDate,
    required int totalTransactions,
    required double totalRevenue,
    required double totalCost,
    required double totalAdminFee,
    required double totalProfit,
    required List<ProductSalesSummary> productSummaries,
    required List<DailySalesStats> dailyStats,
    required DateTime generatedAt,
  }) = _SalesReport;

  factory SalesReport.fromJson(Map<String, dynamic> json) =>
      _$SalesReportFromJson(json);
}

@freezed
class ProductSalesSummary with _$ProductSalesSummary {
  const factory ProductSalesSummary({
    required String productName,
    required int totalQuantity,
    required double totalRevenue,
    required double totalCost,
    required double totalProfit,
    required double averagePrice,
  }) = _ProductSalesSummary;

  factory ProductSalesSummary.fromJson(Map<String, dynamic> json) =>
      _$ProductSalesSummaryFromJson(json);
}

@freezed
class DailySalesStats with _$DailySalesStats {
  const factory DailySalesStats({
    required DateTime date,
    required int transactionCount,
    required double revenue,
    required double cost,
    required double adminFee,
    required double profit,
  }) = _DailySalesStats;

  factory DailySalesStats.fromJson(Map<String, dynamic> json) =>
      _$DailySalesStatsFromJson(json);
}
