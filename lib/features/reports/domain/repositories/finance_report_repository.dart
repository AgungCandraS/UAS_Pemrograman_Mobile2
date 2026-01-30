import '../entities/finance_report.dart';
import '../entities/report_filters.dart';

abstract class FinanceReportRepository {
  Future<FinanceReport> generateFinanceReport(ReportFilters filters);
  Future<List<IncomeCategory>> getIncomeCategories(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<ExpenseCategory>> getExpenseCategories(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<DailyBalance>> getDailyBalance(
    DateTime startDate,
    DateTime endDate,
  );
}
