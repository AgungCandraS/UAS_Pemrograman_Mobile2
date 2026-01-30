import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/finance_report.dart';
import '../../domain/entities/report_filters.dart';
import '../../domain/repositories/finance_report_repository.dart';

class FinanceReportRepositoryImpl implements FinanceReportRepository {
  final SupabaseClient _supabaseClient;

  FinanceReportRepositoryImpl(this._supabaseClient);

  @override
  Future<FinanceReport> generateFinanceReport(ReportFilters filters) async {
    try {
      // Get transactions data
      final response = await _supabaseClient
          .from('transactions')
          .select()
          .gte('date', filters.startDate.toIso8601String())
          .lte('date', filters.endDate.toIso8601String());

      final transactions = response as List<dynamic>;

      double totalIncome = 0;
      double totalExpense = 0;
      final Map<String, double> incomeByCategory = {};
      final Map<String, double> expenseByCategory = {};
      final Map<String, int> incomeCounts = {};
      final Map<String, int> expenseCounts = {};
      final Map<String, DailyBalanceData> dailyBalance = {};

      for (var transaction in transactions) {
        final amount = (transaction['amount'] as num?)?.toDouble() ?? 0;
        final type = transaction['type'] as String? ?? 'expense';
        final category = transaction['category'] as String? ?? 'Uncategorized';
        final dateStr = (transaction['date'] as String? ?? '').split('T')[0];

        if (type == 'income') {
          totalIncome += amount;
          incomeByCategory.update(
            category,
            (v) => v + amount,
            ifAbsent: () => amount,
          );
          incomeCounts.update(category, (v) => v + 1, ifAbsent: () => 1);
        } else {
          totalExpense += amount;
          expenseByCategory.update(
            category,
            (v) => v + amount,
            ifAbsent: () => amount,
          );
          expenseCounts.update(category, (v) => v + 1, ifAbsent: () => 1);
        }

        // Daily balance
        if (dateStr.isNotEmpty) {
          dailyBalance.putIfAbsent(
            dateStr,
            () => DailyBalanceData(
              date: DateTime.parse(dateStr),
              income: 0,
              expense: 0,
            ),
          );
          if (type == 'income') {
            dailyBalance[dateStr]!.income += amount;
          } else {
            dailyBalance[dateStr]!.expense += amount;
          }
        }
      }

      final netBalance = totalIncome - totalExpense;

      final incomeCategories = incomeByCategory.entries
          .map(
            (e) => IncomeCategory(
              name: e.key,
              amount: e.value,
              percentage: totalIncome > 0 ? (e.value / totalIncome) * 100 : 0,
              transactionCount: incomeCounts[e.key] ?? 0,
            ),
          )
          .toList();

      final expenseCategories = expenseByCategory.entries
          .map(
            (e) => ExpenseCategory(
              name: e.key,
              amount: e.value,
              percentage: totalExpense > 0 ? (e.value / totalExpense) * 100 : 0,
              transactionCount: expenseCounts[e.key] ?? 0,
            ),
          )
          .toList();

      final dailyBalances = dailyBalance.values
          .map(
            (d) => DailyBalance(
              date: d.date,
              income: d.income,
              expense: d.expense,
              balance: d.income - d.expense,
            ),
          )
          .toList();

      return FinanceReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        startDate: filters.startDate,
        endDate: filters.endDate,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        netBalance: netBalance,
        incomeCategories: incomeCategories,
        expenseCategories: expenseCategories,
        dailyBalance: dailyBalances,
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to generate finance report: $e');
    }
  }

  @override
  Future<List<IncomeCategory>> getIncomeCategories(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _supabaseClient
          .from('transactions')
          .select()
          .eq('type', 'income')
          .gte('date', startDate.toIso8601String())
          .lte('date', endDate.toIso8601String());

      final transactions = response as List<dynamic>;
      final Map<String, double> categoryAmount = {};
      final Map<String, int> categoryCounts = {};
      double totalIncome = 0;

      for (var transaction in transactions) {
        final amount = (transaction['amount'] as num?)?.toDouble() ?? 0;
        final category = transaction['category'] as String? ?? 'Uncategorized';
        categoryAmount.update(
          category,
          (v) => v + amount,
          ifAbsent: () => amount,
        );
        categoryCounts.update(category, (v) => v + 1, ifAbsent: () => 1);
        totalIncome += amount;
      }

      return categoryAmount.entries
          .map(
            (e) => IncomeCategory(
              name: e.key,
              amount: e.value,
              percentage: totalIncome > 0 ? (e.value / totalIncome) * 100 : 0,
              transactionCount: categoryCounts[e.key] ?? 0,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get income categories: $e');
    }
  }

  @override
  Future<List<ExpenseCategory>> getExpenseCategories(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _supabaseClient
          .from('transactions')
          .select()
          .eq('type', 'expense')
          .gte('date', startDate.toIso8601String())
          .lte('date', endDate.toIso8601String());

      final transactions = response as List<dynamic>;
      final Map<String, double> categoryAmount = {};
      final Map<String, int> categoryCounts = {};
      double totalExpense = 0;

      for (var transaction in transactions) {
        final amount = (transaction['amount'] as num?)?.toDouble() ?? 0;
        final category = transaction['category'] as String? ?? 'Uncategorized';
        categoryAmount.update(
          category,
          (v) => v + amount,
          ifAbsent: () => amount,
        );
        categoryCounts.update(category, (v) => v + 1, ifAbsent: () => 1);
        totalExpense += amount;
      }

      return categoryAmount.entries
          .map(
            (e) => ExpenseCategory(
              name: e.key,
              amount: e.value,
              percentage: totalExpense > 0 ? (e.value / totalExpense) * 100 : 0,
              transactionCount: categoryCounts[e.key] ?? 0,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get expense categories: $e');
    }
  }

  @override
  Future<List<DailyBalance>> getDailyBalance(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _supabaseClient
          .from('transactions')
          .select()
          .gte('date', startDate.toIso8601String())
          .lte('date', endDate.toIso8601String());

      final transactions = response as List<dynamic>;
      final Map<String, DailyBalanceData> dailyData = {};

      for (var transaction in transactions) {
        final amount = (transaction['amount'] as num?)?.toDouble() ?? 0;
        final type = transaction['type'] as String? ?? 'expense';
        final dateStr = (transaction['date'] as String? ?? '').split('T')[0];

        if (dateStr.isNotEmpty) {
          dailyData.putIfAbsent(
            dateStr,
            () => DailyBalanceData(
              date: DateTime.parse(dateStr),
              income: 0,
              expense: 0,
            ),
          );
          if (type == 'income') {
            dailyData[dateStr]!.income += amount;
          } else {
            dailyData[dateStr]!.expense += amount;
          }
        }
      }

      return dailyData.values
          .map(
            (d) => DailyBalance(
              date: d.date,
              income: d.income,
              expense: d.expense,
              balance: d.income - d.expense,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get daily balance: $e');
    }
  }
}

class DailyBalanceData {
  final DateTime date;
  double income;
  double expense;

  DailyBalanceData({
    required this.date,
    required this.income,
    required this.expense,
  });
}
