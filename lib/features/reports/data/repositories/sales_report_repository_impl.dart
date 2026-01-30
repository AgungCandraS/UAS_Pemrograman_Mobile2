import 'package:uuid/uuid.dart';
import '../../domain/entities/sales_report.dart';
import '../../domain/repositories/sales_report_repository.dart';
import '../../../sales/data/datasources/sales_remote_datasource.dart';

class SalesReportRepositoryImpl implements SalesReportRepository {
  final SalesRemoteDataSource salesDataSource;

  SalesReportRepositoryImpl(this.salesDataSource);

  @override
  Future<SalesReport> generateSalesReport({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async {
    // Ambil semua sales data dalam rentang waktu
    final salesModels = await salesDataSource.getSalesByDateRange(
      userId,
      startDate,
      endDate,
    );

    // Konversi model ke entity
    final sales = salesModels.map((model) => model.toDomain()).toList();

    // Hitung total
    double totalRevenue = 0;
    double totalCost = 0;
    double totalAdminFee = 0;
    double totalProfit = 0;

    // Map untuk menggabungkan data per produk
    final Map<String, ProductSalesSummary> productMap = {};

    // Map untuk menggabungkan data per hari
    final Map<String, DailySalesStats> dailyMap = {};

    for (final sale in sales) {
      // Hitung total keseluruhan
      totalRevenue += sale.totalRevenue;
      totalCost += sale.totalCost;
      totalAdminFee += sale.totalAdminFee;
      totalProfit += sale.totalProfit;

      // Agregasi per produk
      for (final item in sale.items) {
        final productName = item.productName;
        final itemRevenue = item.subtotal;
        final itemCost = item.costPrice * item.quantity;
        final itemProfit = item.profit;

        if (productMap.containsKey(productName)) {
          final existing = productMap[productName]!;
          productMap[productName] = ProductSalesSummary(
            productName: productName,
            totalQuantity: existing.totalQuantity + item.quantity,
            totalRevenue: existing.totalRevenue + itemRevenue,
            totalCost: existing.totalCost + itemCost,
            totalProfit: existing.totalProfit + itemProfit,
            averagePrice:
                (existing.totalRevenue + itemRevenue) /
                (existing.totalQuantity + item.quantity).toDouble(),
          );
        } else {
          productMap[productName] = ProductSalesSummary(
            productName: productName,
            totalQuantity: item.quantity,
            totalRevenue: itemRevenue,
            totalCost: itemCost,
            totalProfit: itemProfit,
            averagePrice: item.sellingPrice,
          );
        }
      }

      // Agregasi per hari
      final dateKey = '${sale.date.year}-${sale.date.month}-${sale.date.day}';
      if (dailyMap.containsKey(dateKey)) {
        final existing = dailyMap[dateKey]!;
        dailyMap[dateKey] = DailySalesStats(
          date: existing.date,
          transactionCount: existing.transactionCount + 1,
          revenue: existing.revenue + sale.totalRevenue,
          cost: existing.cost + sale.totalCost,
          adminFee: existing.adminFee + sale.totalAdminFee,
          profit: existing.profit + sale.totalProfit,
        );
      } else {
        dailyMap[dateKey] = DailySalesStats(
          date: DateTime(sale.date.year, sale.date.month, sale.date.day),
          transactionCount: 1,
          revenue: sale.totalRevenue,
          cost: sale.totalCost,
          adminFee: sale.totalAdminFee,
          profit: sale.totalProfit,
        );
      }
    }

    // Sort produk berdasarkan total revenue (terbesar)
    final productSummaries = productMap.values.toList()
      ..sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));

    // Sort daily stats berdasarkan tanggal
    final dailyStats = dailyMap.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return SalesReport(
      id: const Uuid().v4(),
      startDate: startDate,
      endDate: endDate,
      totalTransactions: sales.length,
      totalRevenue: totalRevenue,
      totalCost: totalCost,
      totalAdminFee: totalAdminFee,
      totalProfit: totalProfit,
      productSummaries: productSummaries,
      dailyStats: dailyStats,
      generatedAt: DateTime.now(),
    );
  }
}
