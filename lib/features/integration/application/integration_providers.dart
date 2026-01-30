import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/supabase_service.dart';
import '../data/integration_repository.dart';
import '../domain/accounting_category.dart';
import '../domain/admin_fee.dart';
import '../domain/payment_fee.dart';
import '../domain/product.dart';

// Supabase Service Provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.instance;
});

// Repository Provider
final integrationRepositoryProvider = Provider<IntegrationRepository>((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  return IntegrationRepository(supabase);
});

// ==========================================
// 1. ACCOUNTING CATEGORIES PROVIDERS
// ==========================================

/// Provider untuk list kategori akuntansi
final accountingCategoriesProvider =
    FutureProvider.family<List<AccountingCategory>, String?>((ref, type) async {
      final repo = ref.watch(integrationRepositoryProvider);
      return repo.fetchAccountingCategories(type: type);
    });

/// Provider untuk list kategori income
final incomeAccountingCategoriesProvider =
    FutureProvider<List<AccountingCategory>>((ref) async {
      final repo = ref.watch(integrationRepositoryProvider);
      return repo.fetchAccountingCategories(type: 'income');
    });

/// Provider untuk list kategori expense
final expenseAccountingCategoriesProvider =
    FutureProvider<List<AccountingCategory>>((ref) async {
      final repo = ref.watch(integrationRepositoryProvider);
      return repo.fetchAccountingCategories(type: 'expense');
    });

/// Provider untuk upsert kategori akuntansi
final upsertAccountingCategoryProvider =
    FutureProvider.family<AccountingCategory, AccountingCategory>((
      ref,
      category,
    ) async {
      final repo = ref.watch(integrationRepositoryProvider);
      final result = await repo.upsertAccountingCategory(category);

      // Invalidate cache untuk refresh data
      ref.invalidate(accountingCategoriesProvider);
      ref.invalidate(incomeAccountingCategoriesProvider);
      ref.invalidate(expenseAccountingCategoriesProvider);

      return result;
    });

/// Provider untuk delete kategori akuntansi
final deleteAccountingCategoryProvider = FutureProvider.family<void, String>((
  ref,
  id,
) async {
  final repo = ref.watch(integrationRepositoryProvider);
  await repo.deleteAccountingCategory(id);

  // Invalidate cache
  ref.invalidate(accountingCategoriesProvider);
  ref.invalidate(incomeAccountingCategoriesProvider);
  ref.invalidate(expenseAccountingCategoriesProvider);
});

// ==========================================
// 2. PAYMENT FEES PROVIDERS
// ==========================================

/// Provider untuk list payment fees
final paymentFeesProvider =
    FutureProvider.family<
      List<PaymentFee>,
      ({String? productName, String? paymentType})
    >((ref, filter) async {
      final repo = ref.watch(integrationRepositoryProvider);
      return repo.fetchPaymentFees(
        productName: filter.productName,
        paymentType: filter.paymentType,
      );
    });

/// Provider untuk semua payment fees (tanpa filter)
final allPaymentFeesProvider = FutureProvider<List<PaymentFee>>((ref) async {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.fetchPaymentFees();
});

/// Provider untuk upsert payment fee
final upsertPaymentFeeProvider = FutureProvider.family<PaymentFee, PaymentFee>((
  ref,
  fee,
) async {
  final repo = ref.watch(integrationRepositoryProvider);
  final result = await repo.upsertPaymentFee(fee);

  // Invalidate cache
  ref.invalidate(paymentFeesProvider);
  ref.invalidate(allPaymentFeesProvider);

  return result;
});

/// Provider untuk delete payment fee
final deletePaymentFeeProvider = FutureProvider.family<void, String>((
  ref,
  id,
) async {
  final repo = ref.watch(integrationRepositoryProvider);
  await repo.deletePaymentFee(id);

  // Invalidate cache
  ref.invalidate(paymentFeesProvider);
  ref.invalidate(allPaymentFeesProvider);
});

// ==========================================
// 3. PRODUCTS PROVIDERS
// ==========================================

/// Provider untuk list produk
final productsProvider =
    FutureProvider.family<
      List<Product>,
      ({String? department, bool? isActive})
    >((ref, filter) async {
      final repo = ref.watch(integrationRepositoryProvider);
      return repo.fetchProducts(
        department: filter.department,
        isActive: filter.isActive,
      );
    });

/// Provider untuk semua produk aktif
final activeProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.fetchProducts(isActive: true);
});

/// Provider untuk produk berdasarkan nama
final productsByNameProvider = FutureProvider.family<List<Product>, String>((
  ref,
  name,
) async {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.fetchProductsByName(name);
});

/// Provider untuk upsert produk
final upsertProductProvider = FutureProvider.family<Product, Product>((
  ref,
  product,
) async {
  final repo = ref.watch(integrationRepositoryProvider);
  final result = await repo.upsertProduct(product);

  // Invalidate cache
  ref.invalidate(productsProvider);
  ref.invalidate(activeProductsProvider);
  ref.invalidate(productsByNameProvider);
  ref.invalidate(productNamesProvider);

  return result;
});

/// Provider untuk delete produk
final deleteProductProvider = FutureProvider.family<void, String>((
  ref,
  id,
) async {
  final repo = ref.watch(integrationRepositoryProvider);
  await repo.deleteProduct(id);

  // Invalidate cache
  ref.invalidate(productsProvider);
  ref.invalidate(activeProductsProvider);
  ref.invalidate(productNamesProvider);
});

/// Provider untuk toggle status aktif produk
final toggleProductActiveProvider =
    FutureProvider.family<void, ({String id, bool isActive})>((
      ref,
      params,
    ) async {
      final repo = ref.watch(integrationRepositoryProvider);
      await repo.toggleProductActive(params.id, params.isActive);

      // Invalidate cache
      ref.invalidate(productsProvider);
      ref.invalidate(activeProductsProvider);
    });

// ==========================================
// 3. ADMIN FEES PROVIDERS
// ==========================================

/// Provider untuk list admin fees
final adminFeesProvider =
    FutureProvider.family<
      List<AdminFee>,
      ({bool? isActive, String? salesChannel})
    >((ref, filter) async {
      final repo = ref.watch(integrationRepositoryProvider);
      return repo.fetchAdminFees(
        isActive: filter.isActive,
        salesChannel: filter.salesChannel,
      );
    });

/// Provider untuk semua admin fees (tanpa filter)
final allAdminFeesProvider = FutureProvider<List<AdminFee>>((ref) async {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.fetchAdminFees();
});

/// Provider untuk admin fees yang aktif
final activeAdminFeesProvider = FutureProvider<List<AdminFee>>((ref) async {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.fetchAdminFees(isActive: true);
});

/// Provider untuk upsert admin fee
final upsertAdminFeeProvider = FutureProvider.family<AdminFee, AdminFee>((
  ref,
  fee,
) async {
  final repo = ref.watch(integrationRepositoryProvider);
  final result = await repo.upsertAdminFee(fee);

  // Invalidate cache untuk refresh data
  ref.invalidate(allAdminFeesProvider);
  ref.invalidate(activeAdminFeesProvider);
  ref.invalidate(adminFeesProvider);

  return result;
});

/// Provider untuk delete admin fee
final deleteAdminFeeProvider = FutureProvider.family<void, String>((
  ref,
  id,
) async {
  final repo = ref.watch(integrationRepositoryProvider);
  await repo.deleteAdminFee(id);

  // Invalidate cache
  ref.invalidate(allAdminFeesProvider);
  ref.invalidate(activeAdminFeesProvider);
  ref.invalidate(adminFeesProvider);
});

/// Provider untuk toggle admin fee active status
final toggleAdminFeeActiveProvider =
    FutureProvider.family<void, (String id, bool isActive)>((
      ref,
      params,
    ) async {
      final repo = ref.watch(integrationRepositoryProvider);
      await repo.toggleAdminFeeActive(params.$1, params.$2);

      // Invalidate cache
      ref.invalidate(allAdminFeesProvider);
      ref.invalidate(activeAdminFeesProvider);
      ref.invalidate(adminFeesProvider);
    });

// ==========================================
// 4. UTILITY PROVIDERS
// ==========================================

/// Provider untuk dropdown sales channels
final salesChannelsProvider = Provider<List<String>>((ref) {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.getSalesChannels();
});

/// Provider untuk default fee percent
final defaultFeePercentProvider = Provider.family<double, String>((
  ref,
  channel,
) {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.getDefaultFeePercent(channel);
});

/// Provider untuk default processing fee
final defaultProcessingFeeProvider = Provider.family<double, String>((
  ref,
  channel,
) {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.getDefaultProcessingFee(channel);
});

/// Provider untuk sync salary rates dari products
final syncSalaryRatesFromProductsProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(integrationRepositoryProvider);
  await repo.syncSalaryRatesFromProducts();

  // Invalidate salary rates provider dari HR module
  // ref.invalidate(salaryRatesProvider); // Uncomment jika diperlukan
});

/// Provider untuk list nama produk unik
final productNamesProvider = FutureProvider.family<List<String>, bool?>((
  ref,
  isActive,
) async {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.fetchProductNames(isActive: isActive);
});

/// Provider untuk dropdown departments
final departmentsProvider = Provider<List<String>>((ref) {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.getDepartments();
});

/// Provider untuk dropdown payment types
final paymentTypesProvider = Provider<List<String>>((ref) {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.getPaymentTypes();
});

/// Provider untuk dropdown accounting types
final accountingTypesProvider = Provider<List<String>>((ref) {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.getAccountingTypes();
});
