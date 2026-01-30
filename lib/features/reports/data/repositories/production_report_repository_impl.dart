import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/production_report.dart';
import '../../domain/entities/report_filters.dart';
import '../../domain/repositories/production_report_repository.dart';

class ProductionReportRepositoryImpl implements ProductionReportRepository {
  final SupabaseClient _supabaseClient;

  ProductionReportRepositoryImpl(this._supabaseClient);

  @override
  Future<ProductionReport> generateProductionReport(
    ReportFilters filters,
  ) async {
    try {
      // Get production data
      final response = await _supabaseClient
          .from('production_records')
          .select()
          .gte('date', filters.startDate.toIso8601String().split('T')[0])
          .lte('date', filters.endDate.toIso8601String().split('T')[0]);

      final productions = response as List<dynamic>;

      int totalItems = 0;
      int completedItems = 0;
      int pendingItems = 0;
      int cancelledItems = 0;
      final Map<String, ProductionStatusData> dailyData = {};
      final Map<String, int> statusCount = {};

      for (var production in productions) {
        // production_records table has pcs field instead of quantity
        final pcs = ((production['pcs'] as num?)?.toInt() ?? 0).toDouble();
        final dateStr = production['date'] as String;

        totalItems += pcs.toInt();

        // All records in production_records are completed by default
        completedItems += pcs.toInt();

        // Daily breakdown
        dailyData.putIfAbsent(
          dateStr,
          () => ProductionStatusData(
            date: DateTime.parse(dateStr),
            totalItems: 0,
            completedItems: 0,
            pendingItems: 0,
          ),
        );

        dailyData[dateStr]!.totalItems += pcs.toInt();
        dailyData[dateStr]!.completedItems += pcs.toInt();

        // Status count (semua completed)
        statusCount.update(
          'completed',
          (v) => v + pcs.toInt(),
          ifAbsent: () => pcs.toInt(),
        );
      }

      final completionRate = totalItems > 0
          ? ((completedItems.toDouble() / totalItems.toDouble()) * 100)
                .toDouble()
          : 0.0;

      final dailyProduction = dailyData.values
          .map(
            (d) => DailyProduction(
              date: d.date,
              totalItems: d.totalItems,
              completedItems: d.completedItems,
              pendingItems: d.pendingItems,
              completionRate: d.totalItems > 0
                  ? ((d.completedItems / d.totalItems) * 100).toDouble()
                  : 0.0,
            ),
          )
          .toList();

      final statusBreakdown = statusCount.entries
          .map(
            (e) => ProductionByStatus(
              status: e.key,
              count: e.value,
              percentage: totalItems > 0
                  ? ((e.value / totalItems) * 100).toDouble()
                  : 0.0,
            ),
          )
          .toList();

      // Calculate average completion time (production_records tidak punya field ini, set to 0)
      double averageCompletionTime = 0.0;

      // Get employee production data
      final employeeProductions = await _getEmployeeProductions(
        filters.startDate,
        filters.endDate,
      );

      return ProductionReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        startDate: filters.startDate,
        endDate: filters.endDate,
        totalItems: totalItems,
        completedItems: completedItems,
        pendingItems: pendingItems,
        cancelledItems: cancelledItems,
        completionRate: completionRate,
        dailyProduction: dailyProduction,
        statusBreakdown: statusBreakdown,
        employeeProductions: employeeProductions,
        averageCompletionTime: averageCompletionTime,
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to generate production report: $e');
    }
  }

  @override
  Future<List<DailyProduction>> getDailyProduction(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _supabaseClient
          .from('production_records')
          .select()
          .gte('date', startDate.toIso8601String().split('T')[0])
          .lte('date', endDate.toIso8601String().split('T')[0]);

      final productions = response as List<dynamic>;
      final Map<String, ProductionStatusData> dailyData = {};

      for (var production in productions) {
        final pcs = (production['pcs'] as num?)?.toInt() ?? 0;
        final dateStr = production['date'] as String;

        dailyData.putIfAbsent(
          dateStr,
          () => ProductionStatusData(
            date: DateTime.parse(dateStr),
            totalItems: 0,
            completedItems: 0,
            pendingItems: 0,
          ),
        );

        dailyData[dateStr]!.totalItems += pcs;
        dailyData[dateStr]!.completedItems += pcs;
      }

      return dailyData.values
          .map(
            (d) => DailyProduction(
              date: d.date,
              totalItems: d.totalItems,
              completedItems: d.completedItems,
              pendingItems: d.pendingItems,
              completionRate: d.totalItems > 0
                  ? (d.completedItems / d.totalItems) * 100
                  : 0,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get daily production: $e');
    }
  }

  @override
  Future<List<ProductionByStatus>> getProductionByStatus(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _supabaseClient
          .from('production_records')
          .select()
          .gte('date', startDate.toIso8601String().split('T')[0])
          .lte('date', endDate.toIso8601String().split('T')[0]);

      final productions = response as List<dynamic>;
      final Map<String, int> statusCount = {};
      int totalItems = 0;

      for (var production in productions) {
        final pcs = (production['pcs'] as num?)?.toInt() ?? 0;
        totalItems += pcs;
        statusCount.update('completed', (v) => v + pcs, ifAbsent: () => pcs);
      }

      return statusCount.entries
          .map(
            (e) => ProductionByStatus(
              status: e.key,
              count: e.value,
              percentage: totalItems > 0 ? (e.value / totalItems) * 100 : 0,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get production by status: $e');
    }
  }

  Future<List<EmployeeProduction>> _getEmployeeProductions(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Get production records with employee info
      final response = await _supabaseClient
          .from('production_records')
          .select('*, employees!inner(id, nama, department)')
          .gte('date', startDate.toIso8601String().split('T')[0])
          .lte('date', endDate.toIso8601String().split('T')[0]);

      final productions = response as List<dynamic>;

      // Group by employee
      final Map<String, List<Map<String, dynamic>>> employeeData = {};

      for (var production in productions) {
        final employeeId = production['employee_id'] as String;
        final employeeInfo = production['employees'] as Map<String, dynamic>;
        final employeeName = employeeInfo['nama'] as String? ?? 'Unknown';

        final key = '$employeeId|$employeeName';
        employeeData.putIfAbsent(key, () => []);
        employeeData[key]!.add(production);
      }

      // Create EmployeeProduction objects
      final List<EmployeeProduction> result = [];

      for (var entry in employeeData.entries) {
        final parts = entry.key.split('|');
        final employeeId = parts[0];
        final employeeName = parts[1];
        final records = entry.value;

        int totalPcs = 0;
        double totalEarnings = 0.0;
        String mainDepartment = '';
        final List<ProductionItem> items = [];

        // Group by product + department + losin
        final Map<String, ProductionItemData> productData = {};

        for (var record in records) {
          final productName = record['product_name'] as String? ?? 'Unknown';
          final pcs = (record['pcs'] as num?)?.toInt() ?? 0;
          final ratePerPcs =
              ((record['rate_per_pcs'] as num?)?.toDouble() ?? 0.0);
          final losin = record['losin'] as String?;
          final department = record['department'] as String? ?? '';

          // Set main department (bisa dari department karyawan atau yang paling sering)
          if (mainDepartment.isEmpty) {
            final empInfo = records.first['employees'] as Map<String, dynamic>?;
            mainDepartment = empInfo?['department'] as String? ?? department;
          }

          // Key includes department so we can see different departments
          final key = '$productName|$department|${losin ?? ''}';
          if (productData.containsKey(key)) {
            productData[key]!.pcs += pcs;
            productData[key]!.earnings += pcs * ratePerPcs;
          } else {
            productData[key] = ProductionItemData(
              productName: productName,
              department: department,
              pcs: pcs,
              ratePerPcs: ratePerPcs,
              earnings: pcs * ratePerPcs,
              losin: losin,
            );
          }

          totalPcs += pcs;
          totalEarnings += pcs * ratePerPcs;
        }

        // Convert to ProductionItem list
        for (var item in productData.values) {
          items.add(
            ProductionItem(
              productName: item.productName,
              department: item.department,
              pcs: item.pcs,
              ratePerPcs: item.ratePerPcs,
              earnings: item.earnings,
              losin: item.losin,
            ),
          );
        }

        // Sort items by department then product name
        items.sort((a, b) {
          final deptCompare = a.department.compareTo(b.department);
          if (deptCompare != 0) return deptCompare;
          return a.productName.compareTo(b.productName);
        });

        result.add(
          EmployeeProduction(
            employeeId: employeeId,
            employeeName: employeeName,
            department: mainDepartment,
            totalPcs: totalPcs,
            items: items,
            totalEarnings: totalEarnings,
          ),
        );
      }

      // Sort by employee name
      result.sort((a, b) => a.employeeName.compareTo(b.employeeName));

      return result;
    } catch (e) {
      throw Exception('Failed to get employee productions: $e');
    }
  }
}

class ProductionStatusData {
  final DateTime date;
  int totalItems;
  int completedItems;
  int pendingItems;

  ProductionStatusData({
    required this.date,
    required this.totalItems,
    required this.completedItems,
    required this.pendingItems,
  });
}

class ProductionItemData {
  final String productName;
  final String department;
  int pcs;
  final double ratePerPcs;
  double earnings;
  final String? losin;

  ProductionItemData({
    required this.productName,
    required this.department,
    required this.pcs,
    required this.ratePerPcs,
    required this.earnings,
    this.losin,
  });
}
