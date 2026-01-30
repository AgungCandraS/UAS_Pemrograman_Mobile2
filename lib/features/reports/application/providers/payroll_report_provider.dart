import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bisnisku/features/reports/domain/entities/payroll_report.dart';
import 'package:bisnisku/features/reports/domain/entities/report_filters.dart';
import 'package:bisnisku/features/reports/data/repositories/payroll_report_repository_impl.dart';
import 'sales_report_provider.dart';

final payrollReportRepositoryProvider = Provider((ref) {
  final supabase = ref.watch(supabaseProvider);
  return PayrollReportRepositoryImpl(supabase);
});

class PayrollReportState {
  final PayrollReport? report;
  final bool isLoading;
  final String? error;
  final ReportFilters? filters;

  PayrollReportState({
    this.report,
    this.isLoading = false,
    this.error,
    this.filters,
  });

  PayrollReportState copyWith({
    PayrollReport? report,
    bool? isLoading,
    String? error,
    ReportFilters? filters,
  }) {
    return PayrollReportState(
      report: report ?? this.report,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filters: filters ?? this.filters,
    );
  }
}

class PayrollReportNotifier extends StateNotifier<PayrollReportState> {
  final PayrollReportRepositoryImpl _repository;

  PayrollReportNotifier(this._repository) : super(PayrollReportState());

  Future<void> generateReport(ReportFilters filters) async {
    state = state.copyWith(isLoading: true, error: null, filters: filters);
    try {
      final report = await _repository.generatePayrollReport(filters);
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

final payrollReportProvider =
    StateNotifierProvider<PayrollReportNotifier, PayrollReportState>((ref) {
      final repository = ref.watch(payrollReportRepositoryProvider);
      return PayrollReportNotifier(repository);
    });
