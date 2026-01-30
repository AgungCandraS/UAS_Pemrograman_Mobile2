import 'package:freezed_annotation/freezed_annotation.dart';

part 'finance_report.freezed.dart';
part 'finance_report.g.dart';

@freezed
class FinanceReport with _$FinanceReport {
  const factory FinanceReport({
    required String id,
    required DateTime startDate,
    required DateTime endDate,
    required double totalIncome,
    required double totalExpense,
    required double netBalance,
    required List<IncomeCategory> incomeCategories,
    required List<ExpenseCategory> expenseCategories,
    required List<DailyBalance> dailyBalance,
    required DateTime generatedAt,
  }) = _FinanceReport;

  factory FinanceReport.fromJson(Map<String, dynamic> json) =>
      _$FinanceReportFromJson(json);
}

@freezed
class IncomeCategory with _$IncomeCategory {
  const factory IncomeCategory({
    required String name,
    required double amount,
    required double percentage,
    required int transactionCount,
  }) = _IncomeCategory;

  factory IncomeCategory.fromJson(Map<String, dynamic> json) =>
      _$IncomeCategoryFromJson(json);
}

@freezed
class ExpenseCategory with _$ExpenseCategory {
  const factory ExpenseCategory({
    required String name,
    required double amount,
    required double percentage,
    required int transactionCount,
  }) = _ExpenseCategory;

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryFromJson(json);
}

@freezed
class DailyBalance with _$DailyBalance {
  const factory DailyBalance({
    required DateTime date,
    required double income,
    required double expense,
    required double balance,
  }) = _DailyBalance;

  factory DailyBalance.fromJson(Map<String, dynamic> json) =>
      _$DailyBalanceFromJson(json);
}
