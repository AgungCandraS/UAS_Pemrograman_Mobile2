import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bisnisku/features/employees/application/employee_providers.dart';
import 'package:bisnisku/features/employees/domain/employee_model.dart';
import 'package:bisnisku/features/employees/presentation/widgets/employee_card.dart';
import 'package:bisnisku/features/employees/presentation/widgets/employee_form_modern.dart';
import 'package:bisnisku/config/theme/colors.dart';

class EmployeePage extends ConsumerStatefulWidget {
  const EmployeePage({super.key});

  @override
  ConsumerState<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends ConsumerState<EmployeePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String _searchQuery = '';
  final bool _isFormLoading = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _showEmployeeForm({Employee? employee}) {
    final pageContext = context;
    showDialog(
      context: context,
      barrierDismissible: !_isFormLoading,
      builder: (dialogContext) => EmployeeFormModern(
        employee: employee,
        onSave: (Employee emp) async {
          try {
            if (employee == null) {
              // Create
              await ref.read(
                createEmployeeProvider((
                  nama: emp.nama,
                  email: emp.email,
                  phone: emp.phone,
                  department: emp.department,
                  position: emp.position,
                  startDate: emp.startDate,
                  salaryBase: emp.salaryBase,
                  nik: (emp.nik ?? '').isEmpty ? null : emp.nik,
                )).future,
              );
            } else {
              // Update
              await ref.read(
                updateEmployeeProvider((
                  id: emp.id,
                  nik: (emp.nik ?? '').isEmpty ? null : emp.nik,
                  nama: emp.nama,
                  email: emp.email,
                  phone: emp.phone,
                  department: emp.department,
                  position: emp.position,
                  startDate: emp.startDate,
                  salaryBase: emp.salaryBase,
                  isActive: null,
                )).future,
              );
            }

            if (mounted) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(pageContext).showSnackBar(
                SnackBar(
                  content: Text(
                    employee == null
                        ? 'Karyawan berhasil ditambahkan'
                        : 'Karyawan berhasil diperbarui',
                  ),
                  backgroundColor: Colors.green.shade400,
                  duration: const Duration(seconds: 2),
                ),
              );
              // Refresh list
              ref.invalidate(employeesProvider);
            }
          } catch (e) {
            if (mounted) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(pageContext).showSnackBar(
                SnackBar(
                  content: Text('Error: $e'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _deleteEmployee(String id, String name) {
    final pageContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Hapus Karyawan',
          style: Theme.of(
            dialogContext,
          ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'Yakin ingin menghapus $name?',
          style: Theme.of(
            dialogContext,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: Text(
              'Batal',
              style: Theme.of(
                dialogContext,
              ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(deleteEmployeeProvider(id).future);
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(dialogContext);
                  ref.invalidate(employeesProvider);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(pageContext).showSnackBar(
                    SnackBar(
                      content: const Text('Karyawan berhasil dihapus'),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(dialogContext);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(pageContext).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              }
            },
            child: Text(
              'Hapus',
              style: Theme.of(
                dialogContext,
              ).textTheme.labelMedium?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesProvider);
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
            'Manajemen Karyawan',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari karyawan...',
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              child: employeesAsync.when(
                loading: () => Center(
                  child: CircularProgressIndicator(color: colorScheme.primary),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Terjadi kesalahan',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => ref.refresh(employeesProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
                data: (employees) {
                  final filtered = employees
                      .where(
                        (emp) =>
                            emp.nama.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ) ||
                            emp.position.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ) ||
                            emp.department.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ),
                      )
                      .toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Belum ada karyawan'
                                  : 'Tidak ada hasil pencarian',
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final employee = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: EmployeeCard(
                            employee: employee,
                            onEdit: () => _showEmployeeForm(employee: employee),
                            onDelete: () =>
                                _deleteEmployee(employee.id, employee.nama),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showEmployeeForm(),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          icon: const Icon(Icons.person_add),
          label: const Text('Tambah Karyawan'),
        ),
      ),
    );
  }
}
