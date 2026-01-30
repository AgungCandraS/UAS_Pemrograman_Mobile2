import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/sales_report_repository_impl.dart';
import '../../domain/entities/sales_report.dart';
import '../../domain/repositories/sales_report_repository.dart';
import '../../../sales/data/datasources/sales_remote_datasource.dart';

// Supabase client provider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Sales datasource provider
final salesDatasourceProvider = Provider<SalesRemoteDataSource>((ref) {
  return SalesRemoteDataSourceImpl(ref.watch(supabaseProvider));
});

// Sales report repository provider
final salesReportRepositoryProvider = Provider<SalesReportRepository>((ref) {
  return SalesReportRepositoryImpl(ref.watch(salesDatasourceProvider));
});

// Sales report state notifier
class SalesReportNotifier extends StateNotifier<AsyncValue<SalesReport?>> {
  final SalesReportRepository repository;
  final String userId;

  SalesReportNotifier(this.repository, this.userId)
    : super(const AsyncValue.data(null));

  Future<void> generateReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await repository.generateSalesReport(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
      );
    });
  }
}

// Sales report provider
final salesReportProvider =
    StateNotifierProvider.family<
      SalesReportNotifier,
      AsyncValue<SalesReport?>,
      String
    >((ref, userId) {
      final repository = ref.watch(salesReportRepositoryProvider);
      return SalesReportNotifier(repository, userId);
    });
