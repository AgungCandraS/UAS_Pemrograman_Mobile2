import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../integration/application/integration_providers.dart';
import '../../../integration/domain/admin_fee.dart';
import '../../data/datasources/sales_remote_datasource.dart';
import '../../data/models/sale_model.dart';
import '../../data/repositories/sales_repository_impl.dart';
import '../../domain/entities/sale.dart';
import '../../domain/repositories/sales_repository.dart';

// Datasource provider
final salesRemoteDataSourceProvider = Provider((ref) {
  final supabaseClient = Supabase.instance.client;
  return SalesRemoteDataSourceImpl(supabaseClient);
});

// Repository provider
final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  final remoteDataSource = ref.watch(salesRemoteDataSourceProvider);
  final supabaseClient = Supabase.instance.client;
  return SalesRepositoryImpl(remoteDataSource, supabaseClient);
});

// Sales list by date
final salesByDateProvider = FutureProvider.family<List<Sale>, DateTime>((
  ref,
  date,
) async {
  final repository = ref.watch(salesRepositoryProvider);
  return repository.getSalesByDate(date);
});

// Sales summary
final salesSummaryProvider =
    FutureProvider.family<SaleSummary, (DateTime, DateTime)>((
      ref,
      dates,
    ) async {
      final repository = ref.watch(salesRepositoryProvider);
      return repository.getSalesSummary(dates.$1, dates.$2);
    });

// Current sale being recorded (temp)
final currentSaleItemsProvider = StateProvider<List<SaleItemModel>>(
  (ref) => [],
);

final totalRevenueProvider = Provider<double>((ref) {
  final items = ref.watch(currentSaleItemsProvider);
  return items.fold(0, (sum, item) => sum + item.subtotal);
});

final totalCostProvider = Provider<double>((ref) {
  final items = ref.watch(currentSaleItemsProvider);
  return items.fold(0, (sum, item) => sum + (item.costPrice * item.quantity));
});

final totalProfitProvider = Provider<double>((ref) {
  final revenue = ref.watch(totalRevenueProvider);
  final cost = ref.watch(totalCostProvider);
  return revenue - cost;
});

// Fetch admin fee by channel from integration
final adminFeeByChannelProvider = FutureProvider.family<double, String?>((
  ref,
  channel,
) async {
  if (channel == null || channel == 'offline') return 0;

  try {
    final fees = await ref.watch(activeAdminFeesProvider.future);
    // Map channel names to sales_channel in admin fees
    final channelMap = {
      'tiktokshop': 'TikTokShop',
      'shopee': 'Shopee',
      'lazada': 'Lazada',
      'instagram': 'Instagram',
    };

    final searchChannel = channelMap[channel] ?? channel;
    final fee = fees.firstWhere(
      (f) => f.salesChannel.toLowerCase() == searchChannel.toLowerCase(),
      orElse: () => AdminFee(
        salesChannel: channel,
        feePercent: 0,
        processingFee: 0,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    return fee
        .feePercent; // Return percentage only (processing fee handled separately if needed)
  } catch (e) {
    return 0; // Default to 0 if fetch fails
  }
});

// Recording sale
final recordingSaleProvider =
    StateNotifierProvider<RecordingSaleNotifier, AsyncValue<void>>((ref) {
      return RecordingSaleNotifier(ref.watch(salesRepositoryProvider));
    });

class RecordingSaleNotifier extends StateNotifier<AsyncValue<void>> {
  final SalesRepository _repository;

  RecordingSaleNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> recordSale({
    required String saleType,
    required String channel,
    required List<SaleItemModel> items,
    required double adminFee,
    required String notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Convert models to domain entities
      final saleItems = items.map((e) => e.toDomain()).toList();

      await _repository.recordSale(
        saleType: saleType,
        channel: channel,
        items: saleItems,
        adminFee: adminFee,
        notes: notes,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
