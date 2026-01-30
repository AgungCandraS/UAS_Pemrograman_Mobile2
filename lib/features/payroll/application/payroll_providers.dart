import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/payroll_repository.dart';
import '../domain/payroll_model.dart';
import '../../production/data/repositories/production_repository.dart';
import '../../employees/data/repositories/employee_repository.dart';

// Repository Providers
final productionRepositoryForPayrollProvider = Provider(
  (ref) => ProductionRepository(),
);
final employeeRepositoryForPayrollProvider = Provider(
  (ref) => EmployeeRepository(),
);

final payrollRepositoryProvider = Provider(
  (ref) => PayrollRepository(
    productionRepo: ref.watch(productionRepositoryForPayrollProvider),
    employeeRepo: ref.watch(employeeRepositoryForPayrollProvider),
  ),
);

// ==================== PAYROLL PROVIDERS ====================

/// Fetch all payroll records (with optional filters)
final payrollRecordsProvider = FutureProvider.autoDispose
    .family<
      List<PayrollRecord>,
      ({
        String? employeeId,
        String? status,
        DateTime? startDate,
        DateTime? endDate,
      })
    >((ref, params) async {
      final repo = ref.watch(payrollRepositoryProvider);
      return repo.fetchPayrollRecords(
        employeeId: params.employeeId,
        status: params.status,
        startDate: params.startDate,
        endDate: params.endDate,
      );
    });

/// Fetch payroll by specific period
final payrollByPeriodProvider = FutureProvider.autoDispose
    .family<
      PayrollRecord?,
      ({String employeeId, DateTime periodStart, DateTime periodEnd})
    >((ref, params) async {
      final repo = ref.watch(payrollRepositoryProvider);
      return repo.fetchPayrollByPeriod(
        params.employeeId,
        params.periodStart,
        params.periodEnd,
      );
    });

/// Generate payroll for employee and period
final generatePayrollProvider = FutureProvider.autoDispose
    .family<
      PayrollRecord,
      ({String employeeId, DateTime periodStart, DateTime periodEnd})
    >((ref, params) async {
      final repo = ref.watch(payrollRepositoryProvider);
      final payroll = await repo.generatePayroll(
        employeeId: params.employeeId,
        periodStart: params.periodStart,
        periodEnd: params.periodEnd,
      );
      ref.invalidate(payrollRecordsProvider);
      ref.invalidate(payrollByPeriodProvider);
      return payroll;
    });

/// Update payroll
final updatePayrollProvider = FutureProvider.autoDispose
    .family<
      PayrollRecord,
      ({
        String id,
        double? baseSalary,
        double? productionBonus,
        double? deductions,
        double? totalEarnings,
        String? status,
        DateTime? paidDate,
        String? notes,
      })
    >((ref, params) async {
      final repo = ref.watch(payrollRepositoryProvider);
      final payroll = await repo.updatePayroll(
        id: params.id,
        baseSalary: params.baseSalary,
        productionBonus: params.productionBonus,
        deductions: params.deductions,
        totalEarnings: params.totalEarnings,
        status: params.status,
        paidDate: params.paidDate,
        notes: params.notes,
      );
      ref.invalidate(payrollRecordsProvider);
      ref.invalidate(payrollByPeriodProvider);
      return payroll;
    });

/// Approve payroll
final approvePayrollProvider = FutureProvider.autoDispose.family<void, String>((
  ref,
  id,
) async {
  final repo = ref.watch(payrollRepositoryProvider);
  await repo.approvePayroll(id);
  ref.invalidate(payrollRecordsProvider);
  ref.invalidate(payrollByPeriodProvider);
});

/// Mark payroll as paid
final markPayrollAsPaidProvider = FutureProvider.autoDispose
    .family<void, ({String id, DateTime paidDate})>((ref, params) async {
      final repo = ref.watch(payrollRepositoryProvider);
      await repo.markAsPaid(params.id, params.paidDate);
      ref.invalidate(payrollRecordsProvider);
      ref.invalidate(payrollByPeriodProvider);
    });
