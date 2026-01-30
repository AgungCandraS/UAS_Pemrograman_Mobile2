import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bisnisku/features/reports/domain/entities/finance_report.dart';
import 'package:bisnisku/features/reports/domain/entities/report_filters.dart';
import 'package:bisnisku/features/reports/data/repositories/finance_report_repository_impl.dart';
import 'sales_report_provider.dart';

final financeReportRepositoryProvider = Provider((ref) {
  final supabase = ref.watch(supabaseProvider);
  return FinanceReportRepositoryImpl(supabase);
});

class FinanceReportState {
  final FinanceReport? report;
  final bool isLoading;
  final String? error;
  final ReportFilters? filters;

  FinanceReportState({
    this.report,
    this.isLoading = false,
    this.error,
    this.filters,
  });

  FinanceReportState copyWith({
    FinanceReport? report,
    bool? isLoading,
    String? error,
    ReportFilters? filters,
  }) {
    return FinanceReportState(
      report: report ?? this.report,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filters: filters ?? this.filters,
    );
  }
}

class FinanceReportNotifier extends StateNotifier<FinanceReportState> {
  final FinanceReportRepositoryImpl _repository;

  FinanceReportNotifier(this._repository) : super(FinanceReportState());

  Future<void> generateReport(ReportFilters filters) async {
    state = state.copyWith(isLoading: true, error: null, filters: filters);
    try {
      final report = await _repository.generateFinanceReport(filters);
      state = state.copyWith(report: report, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void setFilters(ReportFilters filters) {
    state = state.copyWith(filters: filters);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final financeReportProvider =
    StateNotifierProvider<FinanceReportNotifier, FinanceReportState>((ref) {
      final repository = ref.watch(financeReportRepositoryProvider);
      return FinanceReportNotifier(repository);
    });
