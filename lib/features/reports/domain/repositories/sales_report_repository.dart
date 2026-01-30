import '../entities/sales_report.dart';

abstract class SalesReportRepository {
  Future<SalesReport> generateSalesReport({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  });
}
