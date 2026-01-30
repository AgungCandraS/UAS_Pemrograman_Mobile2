import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bisnisku/features/reports/domain/entities/production_report.dart';
import 'package:bisnisku/features/reports/domain/entities/report_filters.dart';
import 'package:bisnisku/features/reports/data/repositories/production_report_repository_impl.dart';
import 'sales_report_provider.dart';

final productionReportRepositoryProvider = Provider((ref) {
  final supabase = ref.watch(supabaseProvider);
  return ProductionReportRepositoryImpl(supabase);
});

class ProductionReportState {
  final ProductionReport? report;
  final bool isLoading;
  final String? error;
  final ReportFilters? filters;

  ProductionReportState({
    this.report,
    this.isLoading = false,
    this.error,
    this.filters,
  });

  ProductionReportState copyWith({
    ProductionReport? report,
    bool? isLoading,
    String? error,
    ReportFilters? filters,
  }) {
    return ProductionReportState(
      report: report ?? this.report,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filters: filters ?? this.filters,
    );
  }
}

class ProductionReportNotifier extends StateNotifier<ProductionReportState> {
  final ProductionReportRepositoryImpl _repository;

  ProductionReportNotifier(this._repository) : super(ProductionReportState());

  Future<void> generateReport(ReportFilters filters) async {
    state = state.copyWith(isLoading: true, error: null, filters: filters);
    try {
      final report = await _repository.generateProductionReport(filters);
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

final productionReportProvider =
    StateNotifierProvider<ProductionReportNotifier, ProductionReportState>((
      ref,
    ) {
      final repository = ref.watch(productionReportRepositoryProvider);
      return ProductionReportNotifier(repository);
    });
