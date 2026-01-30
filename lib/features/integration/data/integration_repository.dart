import '../../../services/supabase_service.dart';
import '../domain/accounting_category.dart';
import '../domain/admin_fee.dart';
import '../domain/payment_fee.dart';
import '../domain/product.dart';

/// Repository untuk integrasi modul:
/// 1. Accounting Categories
/// 2. Admin Fees (Fees Admin)
/// 3. Payment Fees (Legacy)
/// 4. Products (Master Produk Dinamis)
class IntegrationRepository {
  final SupabaseService _supabase;

  IntegrationRepository(this._supabase);

  // ==========================================
  // 1. ACCOUNTING CATEGORIES
  // ==========================================

  /// Fetch semua kategori akuntansi
  Future<List<AccountingCategory>> fetchAccountingCategories({
    String? type, // Filter: 'income' atau 'expense'
  }) async {
    try {
      dynamic query = _supabase.client.from('accounting_categories').select();

      if (type != null) {
        query = query.eq('type', type);
      }

      query = query.order('name', ascending: true);

      final response = await query;
      return (response as List)
          .map((json) => AccountingCategory.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat kategori akuntansi: $e');
    }
  }

  /// Tambah atau update kategori akuntansi
  Future<AccountingCategory> upsertAccountingCategory(
    AccountingCategory category,
  ) async {
    try {
      final data = category.toJson();

      final response = await _supabase.client
          .from('accounting_categories')
          .upsert(data)
          .select()
          .single();

      return AccountingCategory.fromJson(response);
    } catch (e) {
      throw Exception('Gagal menyimpan kategori akuntansi: $e');
    }
  }

  /// Hapus kategori akuntansi
  Future<void> deleteAccountingCategory(String id) async {
    try {
      await _supabase.client
          .from('accounting_categories')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus kategori akuntansi: $e');
    }
  }

  // ==========================================
  // 2. PAYMENT FEES
  // ==========================================

  /// Fetch semua payment fees
  Future<List<PaymentFee>> fetchPaymentFees({
    String? productName,
    String? paymentType,
  }) async {
    try {
      dynamic query = _supabase.client.from('payment_fees').select();

      if (productName != null) {
        query = query.eq('product_name', productName);
      }
      if (paymentType != null) {
        query = query.eq('payment_type', paymentType);
      }

      query = query
          .order('product_name', ascending: true)
          .order('payment_type', ascending: true);

      final response = await query;
      return (response as List)
          .map((json) => PaymentFee.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat payment fees: $e');
    }
  }

  /// Tambah atau update payment fee
  Future<PaymentFee> upsertPaymentFee(PaymentFee fee) async {
    try {
      final data = fee.toJson();

      final response = await _supabase.client
          .from('payment_fees')
          .upsert(data)
          .select()
          .single();

      return PaymentFee.fromJson(response);
    } catch (e) {
      throw Exception('Gagal menyimpan payment fee: $e');
    }
  }

  /// Hapus payment fee
  Future<void> deletePaymentFee(String id) async {
    try {
      await _supabase.client.from('payment_fees').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus payment fee: $e');
    }
  }

  // ==========================================
  // 3. PRODUCTS (Master Produk Dinamis)
  // ==========================================

  /// Fetch semua produk
  Future<List<Product>> fetchProducts({
    String? department,
    bool? isActive,
  }) async {
    try {
      dynamic query = _supabase.client.from('products').select();

      if (department != null) {
        query = query.eq('department', department);
      }
      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }

      query = query
          .order('name', ascending: true)
          .order('department', ascending: true);

      final response = await query;
      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal memuat produk: $e');
    }
  }

  /// Fetch produk berdasarkan nama
  Future<List<Product>> fetchProductsByName(String name) async {
    try {
      final response = await _supabase.client
          .from('products')
          .select()
          .eq('name', name)
          .order('department', ascending: true);

      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal memuat produk: $e');
    }
  }

  /// Tambah atau update produk
  Future<Product> upsertProduct(Product product) async {
    try {
      final data = product.toJson();

      final response = await _supabase.client
          .from('products')
          .upsert(data)
          .select()
          .single();

      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Gagal menyimpan produk: $e');
    }
  }

  /// Hapus produk
  Future<void> deleteProduct(String id) async {
    try {
      await _supabase.client.from('products').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }

  /// Toggle status aktif produk
  Future<void> toggleProductActive(String id, bool isActive) async {
    try {
      await _supabase.client
          .from('products')
          .update({
            'is_active': isActive,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      throw Exception('Gagal mengubah status produk: $e');
    }
  }

  // ==========================================
  // 3. ADMIN FEES (Fees Admin)
  // ==========================================

  /// Fetch semua admin fees untuk user
  Future<List<AdminFee>> fetchAdminFees({
    bool? isActive,
    String? salesChannel,
  }) async {
    try {
      final userId = _supabase.currentUser?.id;
      if (userId == null) {
        return []; // Return empty list jika tidak terautentikasi
      }

      dynamic query = _supabase.client
          .from('admin_fees')
          .select()
          .eq('user_id', userId); // Filter by current user

      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }
      if (salesChannel != null) {
        query = query.eq('sales_channel', salesChannel);
      }

      query = query.order('sales_channel', ascending: true);

      final response = await query;
      return (response as List).map((json) => AdminFee.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal memuat admin fees: $e');
    }
  }

  /// Tambah atau update admin fee
  Future<AdminFee> upsertAdminFee(AdminFee fee) async {
    try {
      // Get current user ID dari auth
      final userId = _supabase.currentUser?.id;
      if (userId == null) {
        throw Exception('User tidak terautentikasi');
      }

      // Prepare data with user_id
      final data = fee.toJson();
      data['user_id'] = userId; // Inject user_id untuk RLS policy

      final response = await _supabase.client
          .from('admin_fees')
          .upsert(data)
          .select()
          .single();

      return AdminFee.fromJson(response);
    } catch (e) {
      throw Exception('Gagal menyimpan admin fee: $e');
    }
  }

  /// Hapus admin fee
  Future<void> deleteAdminFee(String id) async {
    try {
      await _supabase.client.from('admin_fees').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus admin fee: $e');
    }
  }

  /// Toggle status aktif admin fee
  Future<void> toggleAdminFeeActive(String id, bool isActive) async {
    try {
      await _supabase.client
          .from('admin_fees')
          .update({
            'is_active': isActive,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      throw Exception('Gagal mengubah status admin fee: $e');
    }
  }

  // ==========================================
  // 4. UTILITY METHODS
  // ==========================================

  /// Get standard sales channels
  List<String> getSalesChannels() {
    return ['Marketplace', 'Direct Sale', 'Wholesale', 'Custom'];
  }

  /// Get default fee percent untuk sales channel (untuk auto-fill)
  double getDefaultFeePercent(String salesChannel) {
    switch (salesChannel.toLowerCase()) {
      case 'marketplace':
        return 2.5;
      case 'direct sale':
        return 0.0;
      case 'wholesale':
        return 1.0;
      default:
        return 0.0;
    }
  }

  /// Get default processing fee untuk sales channel
  double getDefaultProcessingFee(String salesChannel) {
    switch (salesChannel.toLowerCase()) {
      case 'marketplace':
        return 1500;
      case 'direct sale':
        return 0;
      case 'wholesale':
        return 500;
      default:
        return 0;
    }
  }

  /// Sync salary rates dari products table
  /// Berguna untuk memastikan salary_rates up-to-date dengan products
  Future<void> syncSalaryRatesFromProducts() async {
    try {
      // Fetch semua produk aktif
      final products = await fetchProducts(isActive: true);

      // Untuk setiap produk, pastikan ada salary_rate
      for (final product in products) {
        // Check apakah sudah ada salary_rate untuk kombinasi ini
        final existing = await _supabase.client
            .from('salary_rates')
            .select()
            .eq('product_name', product.name)
            .eq('department', product.department)
            .maybeSingle();

        if (existing == null) {
          // Belum ada, buat baru
          await _supabase.client.from('salary_rates').insert({
            'product_name': product.name,
            'department': product.department,
            'rate_per_pcs': product.defaultRatePerPcs,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          });
        }
      }
    } catch (e) {
      throw Exception('Gagal sync salary rates: $e');
    }
  }

  /// Get unique product names dari products table
  Future<List<String>> fetchProductNames({bool? isActive}) async {
    try {
      dynamic query = _supabase.client.from('products').select('name');

      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }

      query = query.order('name', ascending: true);

      final response = await query;

      // Distinct product names
      final names = <String>{};
      for (final item in response as List) {
        names.add(item['name'] as String);
      }

      return names.toList();
    } catch (e) {
      throw Exception('Gagal memuat nama produk: $e');
    }
  }

  /// Get departments untuk dropdown
  List<String> getDepartments() {
    return ['sablon', 'obras', 'jahit', 'packing'];
  }

  /// Get payment types untuk dropdown
  List<String> getPaymentTypes() {
    return ['marketplace', 'cod', 'transfer', 'qris'];
  }

  /// Get accounting types untuk dropdown
  List<String> getAccountingTypes() {
    return ['income', 'expense'];
  }
}
