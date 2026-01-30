import '../entities/production_report.dart';
import '../entities/report_filters.dart';

abstract class ProductionReportRepository {
  Future<ProductionReport> generateProductionReport(ReportFilters filters);
  Future<List<DailyProduction>> getDailyProduction(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<ProductionByStatus>> getProductionByStatus(
    DateTime startDate,
    DateTime endDate,
  );
}
