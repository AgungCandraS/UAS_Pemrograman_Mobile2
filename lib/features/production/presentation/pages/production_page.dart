import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/production_providers.dart';
import '../../application/product_providers.dart';
import '../../../employees/application/employee_providers.dart';
import '../../../employees/domain/employee_model.dart';
import '../../domain/product_model.dart';
import '../../domain/production_record_model.dart';
import '../widgets/production_record_card.dart';
import '../widgets/production_form_dialog.dart';

class ProductionPage extends ConsumerStatefulWidget {
  const ProductionPage({super.key});

  @override
  ConsumerState<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends ConsumerState<ProductionPage> {
  String? _selectedEmployeeId;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesProvider);
    final productsAsync = ref.watch(activeProductsProvider);
    final recordsAsync = ref.watch(
      productionRecordsProvider((
        employeeId: _selectedEmployeeId,
        startDate: _startDate,
        endDate: _endDate,
      )),
    );
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Handle pop if needed
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'Pencatatan Produksi',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            _buildFilters(employeesAsync),
            Expanded(
              child: recordsAsync.when(
                loading: () => Center(
                  child: CircularProgressIndicator(color: colorScheme.primary),
                ),
                error: (err, _) => _ErrorState(
                  message: err.toString(),
                  colorScheme: colorScheme,
                  onRetry: () => ref.refresh(
                    productionRecordsProvider((
                      employeeId: _selectedEmployeeId,
                      startDate: _startDate,
                      endDate: _endDate,
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
                      ref.invalidate(productionRecordsProvider);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ProductionRecordCard(
                            record: record,
                            employeeName: employeeMap[record.employeeId],
                            onEdit: () => _openForm(
                              employeesAsync,
                              productsAsync,
                              existing: record,
                            ),
                            onDelete: () => _confirmDelete(record),
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
          icon: const Icon(Icons.add),
          label: const Text('Tambah Produksi'),
          onPressed: () => _openForm(employeesAsync, productsAsync),
        ),
      ),
    );
  }

  Widget _buildFilters(AsyncValue employeesAsync) {
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
                      labelText: 'Filter Karyawan',
                      prefixIcon: Icon(
                        Icons.person,
                        color: colorScheme.primary,
                      ),
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
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedEmployeeId = null;
                    _startDate = null;
                    _endDate = null;
                  });
                },
                icon: Icon(Icons.refresh, color: colorScheme.primary),
                tooltip: 'Reset filter',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _DateFilterChip(
                  label: _startDate == null
                      ? 'Mulai'
                      : DateFormat('dd/MM').format(_startDate!),
                  icon: Icons.calendar_today,
                  onTap: () async {
                    final picked = await _pickDate(
                      _startDate ?? DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _startDate = picked);
                    }
                  },
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DateFilterChip(
                  label: _endDate == null
                      ? 'Selesai'
                      : DateFormat('dd/MM').format(_endDate!),
                  icon: Icons.event,
                  onTap: () async {
                    final picked = await _pickDate(_endDate ?? DateTime.now());
                    if (picked != null) {
                      setState(() => _endDate = picked);
                    }
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

  Future<void> _openForm(
    AsyncValue employeesAsync,
    AsyncValue productsAsync, {
    ProductionRecord? existing,
  }) async {
    final employees = employeesAsync.maybeWhen(
      data: (data) => data,
      orElse: () => <Employee>[],
    );
    final products = productsAsync.maybeWhen(
      data: (data) => data,
      orElse: () => <Product>[],
    );

    if (employees.isEmpty || products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data karyawan atau produk belum tersedia'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ProductionFormDialog(
        record: existing,
        employees: List<Employee>.from(employees),
        products: List<Product>.from(products),
        onSave:
            ({
              required String employeeId,
              required String productName,
              required String department,
              required int pcs,
              required DateTime date,
              required double ratePerPcs,
              String? losin,
              String? notes,
            }) async {
              try {
                if (existing == null) {
                  final future = ref.read(
                    createProductionRecordProvider((
                      employeeId: employeeId,
                      productName: productName,
                      department: department,
                      pcs: pcs,
                      date: date,
                      ratePerPcs: ratePerPcs,
                      losin: losin,
                      notes: notes,
                    )).future,
                  );
                  await future;
                } else {
                  final future = ref.read(
                    updateProductionRecordProvider((
                      id: existing.id,
                      productName: productName,
                      department: department,
                      pcs: pcs,
                      date: date,
                      ratePerPcs: ratePerPcs,
                      losin: losin,
                      notes: notes,
                    )).future,
                  );
                  await future;
                }
                ref.invalidate(productionRecordsProvider);
                if (mounted) {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 200), () {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            existing == null
                                ? 'Rekam produksi berhasil dibuat'
                                : 'Rekam produksi berhasil diperbarui',
                          ),
                          backgroundColor: Colors.green.shade400,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  });
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red.shade400,
                    ),
                  );
                }
              }
            },
      ),
    );
  }

  void _confirmDelete(ProductionRecord record) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus data'),
        content: const Text('Yakin ingin menghapus pencatatan ini?'),
        actions: [
          TextButton(
            onPressed: () {
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(
                  deleteProductionRecordProvider(record.id).future,
                );
                if (mounted) {
                  Navigator.pop(context);
                  ref.invalidate(productionRecordsProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Pencatatan berhasil dihapus'),
                      backgroundColor: Colors.green.shade400,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red.shade400,
                    ),
                  );
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _DateFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _DateFilterChip({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: colorScheme.primary),
            const SizedBox(width: 6),
            Text(label),
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
            Icons.inventory_outlined,
            size: 56,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada data produksi',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambah catatan pertama untuk mulai menghitung gaji',
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
