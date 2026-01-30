import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bisnisku/features/home/domain/models/home_status.dart';
import 'package:bisnisku/features/inventory/application/providers.dart';
import 'package:bisnisku/features/auth/application/auth_providers.dart';

/// Provider untuk status inventori
final inventoryStatusProvider = FutureProvider<InventoryStatus>((ref) async {
  try {
    final supabase = ref.read(supabaseServiceProvider);
    final client = supabase.client;

    // Query untuk menghitung status stok dari variants
    final response = await client
        .from('inventory_item_variants')
        .select('stock_quantity, min_stock_level');

    int stokAman = 0;
    int menipis = 0;
    int habis = 0;

    for (final variant in response) {
      final stock = variant['stock_quantity'] as int? ?? 0;
      final minLevel = variant['min_stock_level'] as int? ?? 0;

      if (stock == 0) {
        habis++;
      } else if (stock <= minLevel) {
        menipis++;
      } else {
        stokAman++;
      }
    }

    return InventoryStatus(stokAman: stokAman, menipis: menipis, habis: habis);
  } catch (e) {
    // Fallback ke data mock jika error
    return const InventoryStatus(stokAman: 120, menipis: 18, habis: 6);
  }
});

/// Provider untuk aktivitas terbaru - mengambil dari berbagai tabel database sesuai aktivitas terakhir
final recentActivitiesProvider = FutureProvider<List<RecentActivity>>((
  ref,
) async {
  try {
    final supabase = ref.read(supabaseServiceProvider);
    final client = supabase.client;

    // Query aktivitas dari berbagai tabel
    final activities = <RecentActivity>[];

    // ========== PRODUCTION RECORDS ==========
    try {
      final completedProduction = await client
          .from('production_records')
          .select(
            'id, product_name, quantity, status, completed_at, created_at',
          )
          .eq('status', 'completed')
          .order('completed_at', ascending: false)
          .limit(5);

      for (final record in completedProduction) {
        final productName = record['product_name'] as String;
        final quantity = record['quantity'] as int;
        final completedAt = record['completed_at'] as String?;

        activities.add(
          RecentActivity(
            id: record['id'] as String,
            type: ActivityType.production,
            description: 'Produksi $productName ($quantity unit) selesai',
            timestamp: completedAt != null
                ? DateTime.parse(completedAt)
                : DateTime.parse(record['created_at'] as String),
            icon: '✓',
          ),
        );
      }
    } catch (e) {
      // Skip jika tabel atau field tidak ada
    }

    // ========== ORDERS ==========
    try {
      final completedOrders = await client
          .from('orders')
          .select('id, order_number, status, completed_at, created_at')
          .eq('status', 'delivered')
          .order('completed_at', ascending: false)
          .limit(5);

      for (final order in completedOrders) {
        final orderNumber = order['order_number'] as String;
        final completedAt = order['completed_at'] as String?;

        activities.add(
          RecentActivity(
            id: order['id'] as String,
            type: ActivityType.order,
            description: 'Pesanan $orderNumber sudah dikirim',
            timestamp: completedAt != null
                ? DateTime.parse(completedAt)
                : DateTime.parse(order['created_at'] as String),
            icon: '📦',
          ),
        );
      }
    } catch (e) {
      // Skip jika tabel atau field tidak ada
    }

    // ========== INVENTORY CHANGES ==========
    try {
      final restocks = await client
          .from('inventory_changes')
          .select(
            'id, inventory_item_id, quantity_change, change_type, created_at',
          )
          .eq('change_type', 'in')
          .order('created_at', ascending: false)
          .limit(5);

      for (final restock in restocks) {
        final itemId = restock['inventory_item_id'] as String;
        final quantity = restock['quantity_change'] as int;

        // Ambil nama item dari inventory_items
        try {
          final itemData = await client
              .from('inventory_items')
              .select('item_name')
              .eq('id', itemId)
              .single();

          final itemName = itemData['item_name'] as String;

          activities.add(
            RecentActivity(
              id: restock['id'] as String,
              type: ActivityType.inventory,
              description: '+$quantity $itemName ditambahkan',
              timestamp: DateTime.parse(restock['created_at'] as String),
              icon: '📥',
            ),
          );
        } catch (e) {
          // Skip jika item tidak ditemukan
          continue;
        }
      }
    } catch (e) {
      // Skip jika tabel tidak ada
    }

    // ========== PAYROLL RECORDS ==========
    try {
      final payrollRecords = await client
          .from('payroll_records')
          .select('id, employee_id, status, created_at, pay_period')
          .eq('status', 'paid')
          .order('created_at', ascending: false)
          .limit(5);

      for (final payroll in payrollRecords) {
        final employeeId = payroll['employee_id'] as String?;
        final payPeriod = payroll['pay_period'] as String?;

        // Skip jika employee_id null
        if (employeeId == null) continue;

        try {
          // Ambil nama employee
          final employeeData = await client
              .from('employees')
              .select('full_name')
              .eq('id', employeeId)
              .single();

          final employeeName = employeeData['full_name'] as String;
          final periodDisplay = payPeriod?.replaceAll('-', '/') ?? 'N/A';

          activities.add(
            RecentActivity(
              id: payroll['id'] as String,
              type: ActivityType.payment,
              description: 'Gaji $employeeName ($periodDisplay) telah diproses',
              timestamp: DateTime.parse(payroll['created_at'] as String),
              icon: '💰',
            ),
          );
        } catch (e) {
          // Skip jika employee tidak ditemukan
          continue;
        }
      }
    } catch (e) {
      // Skip jika tabel payroll atau employees tidak ada
    }

    // ========== EMPLOYEE ACTIVITIES ==========
    try {
      final employeeActivities = await client
          .from('employees')
          .select('id, full_name, hire_date')
          .order('hire_date', ascending: false)
          .limit(3);

      for (final emp in employeeActivities) {
        final empName = emp['full_name'] as String;
        final hireDate = emp['hire_date'] as String?;

        if (hireDate != null) {
          final hireDateParsed = DateTime.parse(hireDate);
          final now = DateTime.now();
          final duration = now.difference(hireDateParsed);

          // Hanya tampilkan jika karyawan baru (dalam 30 hari terakhir)
          if (duration.inDays <= 30 && duration.inDays >= 0) {
            activities.add(
              RecentActivity(
                id: emp['id'] as String,
                type: ActivityType.employee,
                description: 'Karyawan baru: $empName',
                timestamp: hireDateParsed,
                icon: '👤',
              ),
            );
          }
        }
      }
    } catch (e) {
      // Skip jika tabel employees tidak ada
    }

    // Sort by timestamp descending (paling baru dulu)
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return activities.take(10).toList();
  } catch (e) {
    // Fallback ke data mock jika error besar
    return [
      RecentActivity(
        id: '1',
        type: ActivityType.production,
        description: 'Produksi Kopi Arabika (50 unit) selesai',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        icon: '✓',
      ),
      RecentActivity(
        id: '2',
        type: ActivityType.order,
        description: 'Pesanan INV-243 sudah dikirim',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        icon: '📦',
      ),
      RecentActivity(
        id: '3',
        type: ActivityType.inventory,
        description: '+100 Gula ditambahkan',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        icon: '📥',
      ),
      RecentActivity(
        id: '4',
        type: ActivityType.payment,
        description: 'Gaji Agung Setiawan (Januari/2026) telah diproses',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        icon: '💰',
      ),
    ];
  }
});

/// Provider untuk weather info
final weatherInfoProvider = FutureProvider<WeatherInfo>((ref) async {
  // TODO: Integrate dengan API cuaca (OpenWeather, dll)
  // Untuk saat ini return data static
  return const WeatherInfo(
    temperature: 25,
    condition: 'Hujan ringan',
    location: 'Jakarta',
  );
});

/// Provider untuk user name dari auth state
final userNameProvider = FutureProvider<String>((ref) async {
  try {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    if (user != null) {
      // Cek full name terlebih dahulu
      if (user.fullName case String fullName when fullName.isNotEmpty) {
        return fullName.split(' ').first;
      }

      // Fallback ke email
      if (user.email case String email when email.isNotEmpty) {
        return email.split('@').first;
      }
    }

    return 'Pengguna';
  } catch (e) {
    return 'Pengguna';
  }
});
