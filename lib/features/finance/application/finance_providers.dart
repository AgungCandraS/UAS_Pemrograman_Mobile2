import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/finance_repository.dart';
import '../domain/finance_models.dart';

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepository();
});

enum FinanceFilter { all, income, expense }

final financeFilterProvider = StateProvider<FinanceFilter>((ref) {
  return FinanceFilter.all;
});

final financeTransactionsProvider = FutureProvider<List<FinanceTransaction>>((
  ref,
) async {
  final repo = ref.watch(financeRepositoryProvider);
  return repo.fetchTransactions(limit: 200);
});

final filteredTransactionsProvider =
    Provider<AsyncValue<List<FinanceTransaction>>>((ref) {
      final filter = ref.watch(financeFilterProvider);
      final txAsync = ref.watch(financeTransactionsProvider);
      return txAsync.whenData((txs) {
        switch (filter) {
          case FinanceFilter.income:
            return txs.where((t) => t.isIncome).toList();
          case FinanceFilter.expense:
            return txs.where((t) => t.isExpense).toList();
          case FinanceFilter.all:
            return txs;
        }
      });
    });

final financeSummaryProvider = Provider<FinanceSummary?>((ref) {
  final txs = ref.watch(financeTransactionsProvider).valueOrNull;
  if (txs == null) return null;
  return FinanceSummary.fromTransactions(txs, month: DateTime.now());
});

final financeDailyPointsProvider = Provider<List<FinanceDailyPoint>>((ref) {
  final txs = ref.watch(financeTransactionsProvider).valueOrNull ?? [];
  final now = DateTime.now();
  final start = now.subtract(const Duration(days: 14));
  final buckets = <DateTime, FinanceDailyPoint>{};

  for (var i = 0; i <= 14; i++) {
    final date = DateTime(start.year, start.month, start.day + i);
    buckets[DateTime(date.year, date.month, date.day)] = FinanceDailyPoint(
      date: date,
      income: 0,
      expense: 0,
    );
  }

  for (final t in txs) {
    if (t.date.isBefore(start)) continue;
    final key = DateTime(t.date.year, t.date.month, t.date.day);
    final existing = buckets[key];
    if (existing == null) continue;
    buckets[key] = FinanceDailyPoint(
      date: existing.date,
      income: existing.income + (t.isIncome ? t.amount : 0),
      expense: existing.expense + (t.isExpense ? t.amount : 0),
    );
  }

  final list = buckets.values.toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  return list;
});

final addTransactionProvider =
    FutureProvider.family<FinanceTransaction?, AddTransactionParams>((
      ref,
      params,
    ) async {
      final repo = ref.read(financeRepositoryProvider);
      final result = await repo.addTransaction(
        type: params.type,
        category: params.category,
        amount: params.amount,
        note: params.note,
        account: params.account,
        date: params.date,
      );
      // Stream provider will emit new data automatically, but ensure refresh for safety.
      ref.invalidate(financeTransactionsProvider);
      return result;
    });

class AddTransactionParams {
  AddTransactionParams({
    required this.type,
    required this.category,
    required this.amount,
    this.note,
    this.account,
    this.date,
  });

  final String type; // 'income' or 'expense'
  final String category;
  final double amount;
  final String? note;
  final String? account;
  final DateTime? date;
}
