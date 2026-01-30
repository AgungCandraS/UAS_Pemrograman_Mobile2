import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../employees/application/employee_providers.dart';
import '../../../employees/domain/employee_model.dart';
import '../../application/payroll_providers.dart';
import '../widgets/payroll_card.dart';

class PayrollPage extends ConsumerStatefulWidget {
  const PayrollPage({super.key});

  @override
  ConsumerState<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends ConsumerState<PayrollPage> {
  String? _selectedEmployeeId;
  String? _statusFilter;
  late DateTime _periodStart;
  late DateTime _periodEnd;
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    _periodStart = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );
    final endOfWeek = _periodStart.add(const Duration(days: 6));
    _periodEnd = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesProvider);
    final payrollAsync = ref.watch(
      payrollRecordsProvider((
        employeeId: _selectedEmployeeId,
        status: _statusFilter,
        startDate: _periodStart,
        endDate: _periodEnd,
      )),
    );
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Penggajian',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          _buildFilters(employeesAsync),
          Expanded(
            child: payrollAsync.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              ),
              error: (err, _) => _ErrorState(
                message: err.toString(),
                colorScheme: colorScheme,
                onRetry: () => ref.refresh(
                  payrollRecordsProvider((
                    employeeId: _selectedEmployeeId,
                    status: _statusFilter,
                    startDate: _periodStart,
                    endDate: _periodEnd,
                  )),
                ),
              ),
              data: (records) {
                if (records.isEmpty) {
                  return _EmptyState(colorScheme: colorScheme);
                }

                final employeeMap = employeesAsync.maybeWhen(
                  data: (emps) => {for (final e in emps) e.id: e.nama},
                  orElse: () => <String, String>{},
                );

                return RefreshIndicator(
                  onRefresh: () async {
                    // Refresh dengan parameter yang tepat untuk family provider
                    // ignore: unused_result
                    await ref.refresh(
                      payrollRecordsProvider((
                        employeeId: _selectedEmployeeId,
                        status: _statusFilter,
                        startDate: _periodStart,
                        endDate: _periodEnd,
                      )).future,
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final payroll = records[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PayrollCard(
                          payroll: payroll,
                          employeeName: employeeMap[payroll.employeeId],
                          onApprove: payroll.status == 'pending'
                              ? () => _approve(payroll.id)
                              : null,
                          onMarkPaid: payroll.status == 'approved'
                              ? () => _markPaid(payroll.id)
                              : null,
                          onRefresh: () => _regenerate(payroll.employeeId),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.calculate),
        label: const Text('Generate Gaji'),
        onPressed: () => _generatePayroll(employeesAsync),
      ),
    );
  }

  Widget _buildFilters(AsyncValue employeesAsync) {
    final dateFmt = DateFormat('dd MMM yyyy');
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: employeesAsync.when(
                  data: (emps) => DropdownButtonFormField<String?>(
                    initialValue: _selectedEmployeeId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Karyawan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Semua'),
                      ),
                      ...emps.map(
                        (e) => DropdownMenuItem<String?>(
                          value: e.id,
                          child: Text(e.nama),
                        ),
                      ),
                    ],
                    onChanged: (val) =>
                        setState(() => _selectedEmployeeId = val),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const SizedBox(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: _statusFilter,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    prefixIcon: Icon(
                      Icons.filter_alt,
                      color: colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Semua'),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'pending',
                      child: Text('Pending'),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'approved',
                      child: Text('Approved'),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'paid',
                      child: Text('Paid'),
                    ),
                  ],
                  onChanged: (val) => setState(() => _statusFilter = val),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedEmployeeId = null;
                    _statusFilter = null;
                    final now = DateTime.now();
                    final startOfWeek = now.subtract(
                      Duration(days: now.weekday - 1),
                    );
                    _periodStart = DateTime(
                      startOfWeek.year,
                      startOfWeek.month,
                      startOfWeek.day,
                    );
                    final endOfWeek = _periodStart.add(const Duration(days: 6));
                    _periodEnd = DateTime(
                      endOfWeek.year,
                      endOfWeek.month,
                      endOfWeek.day,
                    );
                  });
                },
                icon: Icon(Icons.refresh, color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _DateBox(
                  label: 'Mulai',
                  value: dateFmt.format(_periodStart),
                  onTap: () async {
                    final picked = await _pickDate(_periodStart);
                    if (picked != null) setState(() => _periodStart = picked);
                  },
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DateBox(
                  label: 'Selesai',
                  value: dateFmt.format(_periodEnd),
                  onTap: () async {
                    final picked = await _pickDate(_periodEnd);
                    if (picked != null) setState(() => _periodEnd = picked);
                  },
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _pickDate(DateTime initial) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(initial.year - 1),
      lastDate: DateTime(initial.year + 1),
    );
  }

  Future<void> _generatePayroll(AsyncValue employeesAsync) async {
    final employees = employeesAsync.maybeWhen(
      data: (data) => data,
      orElse: () => <Employee>[],
    );
    if (employees.isEmpty) {
      _showError('Data karyawan belum tersedia');
      return;
    }
    if (_selectedEmployeeId == null) {
      _showError('Pilih karyawan yang akan digenerate');
      return;
    }

    try {
      await ref.read(
        generatePayrollProvider((
          employeeId: _selectedEmployeeId!,
          periodStart: _periodStart,
          periodEnd: _periodEnd,
        )).future,
      );
      if (mounted) {
        // Refresh data dengan parameter yang tepat agar UI terupdate
        // ignore: unused_result
        await ref.refresh(
          payrollRecordsProvider((
            employeeId: _selectedEmployeeId,
            status: _statusFilter,
            startDate: _periodStart,
            endDate: _periodEnd,
          )).future,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Payroll berhasil digenerate'),
            backgroundColor: Colors.green.shade400,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _showError('Gagal generate payroll: $e');
    }
  }

  Future<void> _approve(String id) async {
    try {
      await ref.read(approvePayrollProvider(id).future);
      if (mounted) {
        // Refresh data dengan parameter yang tepat agar UI terupdate
        // ignore: unused_result
        await ref.refresh(
          payrollRecordsProvider((
            employeeId: _selectedEmployeeId,
            status: _statusFilter,
            startDate: _periodStart,
            endDate: _periodEnd,
          )).future,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Penggajian berhasil disetujui'),
            backgroundColor: Colors.green.shade400,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _showError('Gagal setujui: $e');
    }
  }

  Future<void> _markPaid(String id) async {
    try {
      await ref.read(
        markPayrollAsPaidProvider((id: id, paidDate: DateTime.now())).future,
      );
      if (mounted) {
        // Refresh data dengan parameter yang tepat agar UI terupdate
        // ignore: unused_result
        await ref.refresh(
          payrollRecordsProvider((
            employeeId: _selectedEmployeeId,
            status: _statusFilter,
            startDate: _periodStart,
            endDate: _periodEnd,
          )).future,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Penggajian berhasil ditandai dibayar'),
            backgroundColor: Colors.green.shade400,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _showError('Gagal tandai dibayar: $e');
    }
  }

  Future<void> _regenerate(String employeeId) async {
    try {
      await ref.read(
        generatePayrollProvider((
          employeeId: employeeId,
          periodStart: _periodStart,
          periodEnd: _periodEnd,
        )).future,
      );
      if (mounted) {
        // Refresh data dengan parameter yang tepat agar UI terupdate
        // ignore: unused_result
        await ref.refresh(
          payrollRecordsProvider((
            employeeId: _selectedEmployeeId,
            status: _statusFilter,
            startDate: _periodStart,
            endDate: _periodEnd,
          )).future,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Penggajian berhasil dihitung ulang'),
            backgroundColor: Colors.green.shade400,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _showError('Gagal hitung ulang: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _DateBox({
    required this.label,
    required this.value,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Icon(Icons.date_range, size: 18, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ColorScheme colorScheme;

  const _EmptyState({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payments_outlined,
            size: 56,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada payroll',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate payroll dari catatan produksi karyawan',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final ColorScheme colorScheme;

  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 12),
            Text(
              'Terjadi kesalahan',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: colorScheme.error),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
