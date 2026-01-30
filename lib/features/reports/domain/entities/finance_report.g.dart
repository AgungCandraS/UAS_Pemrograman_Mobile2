// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinanceReportImpl _$$FinanceReportImplFromJson(Map<String, dynamic> json) =>
    _$FinanceReportImpl(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpense: (json['totalExpense'] as num).toDouble(),
      netBalance: (json['netBalance'] as num).toDouble(),
      incomeCategories: (json['incomeCategories'] as List<dynamic>)
          .map((e) => IncomeCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      expenseCategories: (json['expenseCategories'] as List<dynamic>)
          .map((e) => ExpenseCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyBalance: (json['dailyBalance'] as List<dynamic>)
          .map((e) => DailyBalance.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$FinanceReportImplToJson(_$FinanceReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'netBalance': instance.netBalance,
      'incomeCategories': instance.incomeCategories,
      'expenseCategories': instance.expenseCategories,
      'dailyBalance': instance.dailyBalance,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };

_$IncomeCategoryImpl _$$IncomeCategoryImplFromJson(Map<String, dynamic> json) =>
    _$IncomeCategoryImpl(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      transactionCount: (json['transactionCount'] as num).toInt(),
    );

Map<String, dynamic> _$$IncomeCategoryImplToJson(
        _$IncomeCategoryImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'percentage': instance.percentage,
      'transactionCount': instance.transactionCount,
    };

_$ExpenseCategoryImpl _$$ExpenseCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ExpenseCategoryImpl(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      transactionCount: (json['transactionCount'] as num).toInt(),
    );

Map<String, dynamic> _$$ExpenseCategoryImplToJson(
        _$ExpenseCategoryImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'percentage': instance.percentage,
      'transactionCount': instance.transactionCount,
    };

_$DailyBalanceImpl _$$DailyBalanceImplFromJson(Map<String, dynamic> json) =>
    _$DailyBalanceImpl(
      date: DateTime.parse(json['date'] as String),
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$$DailyBalanceImplToJson(_$DailyBalanceImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'income': instance.income,
      'expense': instance.expense,
      'balance': instance.balance,
    };
