import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bisnisku/features/production/domain/production_record_model.dart';
import 'package:bisnisku/features/production/domain/product_model.dart';
import 'package:bisnisku/features/employees/domain/employee_model.dart';
import 'package:bisnisku/config/theme/colors.dart';

class ProductionFormDialog extends StatefulWidget {
  final ProductionRecord? record;
  final List<Employee> employees;
  final List<Product> products;
  final void Function({
    required String employeeId,
    required String productName,
    required String department,
    required int pcs,
    required DateTime date,
    required double ratePerPcs,
    String? losin,
    String? notes,
  })
  onSave;

  const ProductionFormDialog({
    super.key,
    this.record,
    required this.employees,
    required this.products,
    required this.onSave,
  });

  @override
  State<ProductionFormDialog> createState() => _ProductionFormDialogState();
}

class _ProductionFormDialogState extends State<ProductionFormDialog>
    with TickerProviderStateMixin {
  late TextEditingController _losinController;
  late TextEditingController _pcsController;
  late TextEditingController _dateController;
  late TextEditingController _notesController;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  String? _selectedEmployeeId;
  String? _selectedDepartment;
  Product? _selectedProduct;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  double _calculatedPrice = 0.0;

  List<String> get _departments {
    final depts = widget.products.map((p) => p.department).toSet().toList();
    depts.sort();
    return depts;
  }

  List<Product> get _filteredProducts {
    if (_selectedDepartment == null) return [];
    return widget.products
        .where((p) => p.department == _selectedDepartment)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _losinController = TextEditingController(text: widget.record?.losin ?? '');
    _pcsController = TextEditingController(
      text: widget.record?.pcs.toString() ?? '',
    );
    _notesController = TextEditingController(text: widget.record?.notes ?? '');
    _selectedDate = widget.record?.date ?? DateTime.now();
    _dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_selectedDate),
    );

    _selectedEmployeeId =
        widget.record?.employeeId ??
        (widget.employees.isNotEmpty ? widget.employees.first.id : null);

    if (widget.record != null) {
      _selectedDepartment = widget.record!.department;
      _selectedProduct = widget.products.firstWhere(
        (p) => p.name == widget.record!.productName,
        orElse: () => widget.products.isNotEmpty
            ? widget.products.first
            : Product(
                id: '',
                name: widget.record!.productName,
                department: widget.record!.department,
                defaultRatePerPcs: widget.record!.ratePerPcs,
                isActive: true,
              ),
      );
    } else {
      _selectedDepartment = _departments.isNotEmpty ? _departments.first : null;
      _selectedProduct = _filteredProducts.isNotEmpty
          ? _filteredProducts.first
          : null;
    }

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _slideController.forward();

    // Calculate initial price
    Future.microtask(() => _updateCalculatedPrice());
  }

  @override
  void dispose() {
    _slideController.dispose();
    _losinController.dispose();
    _pcsController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(_selectedDate.year - 1),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _onProductChanged(Product? product) {
    if (product == null) return;
    setState(() {
      _selectedProduct = product;
    });
    _updateCalculatedPrice();
  }

  void _onDepartmentChanged(String? department) {
    if (department == null) return;
    setState(() {
      _selectedDepartment = department;
      // Reset product selection when department changes
      _selectedProduct = _filteredProducts.isNotEmpty
          ? _filteredProducts.first
          : null;
    });
    _updateCalculatedPrice();
  }

  void _updateCalculatedPrice() {
    setState(() {
      final losin = int.tryParse(_losinController.text) ?? 0;
      final pcs = int.tryParse(_pcsController.text) ?? 0;
      final totalQuantity = (losin * 12) + pcs;

      if (totalQuantity <= 0 || _selectedProduct == null) {
        _calculatedPrice = 0.0;
      } else {
        _calculatedPrice =
            totalQuantity * (_selectedProduct?.defaultRatePerPcs ?? 0.0);
      }
    });
  }

  void _save() async {
    if (_selectedEmployeeId == null || _selectedEmployeeId!.isEmpty) {
      _showError('Pilih karyawan terlebih dahulu');
      return;
    }
    if (_selectedProduct == null) {
      _showError('Pilih produk terlebih dahulu');
      return;
    }

    final losin = int.tryParse(_losinController.text) ?? 0;
    final pcs = int.tryParse(_pcsController.text) ?? 0;

    if (losin == 0 && pcs == 0) {
      _showError('Isi minimal Losin atau PCS');
      return;
    }

    final totalQuantity = (losin * 12) + pcs;
    final ratePerPcs = _selectedProduct!.defaultRatePerPcs;

    setState(() => _isLoading = true);
    try {
      widget.onSave(
        employeeId: _selectedEmployeeId!,
        productName: _selectedProduct!.name,
        department: _selectedProduct!.department,
        pcs: totalQuantity,
        date: _selectedDate,
        ratePerPcs: ratePerPcs,
        losin: _losinController.text.isNotEmpty ? _losinController.text : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _showError('Gagal menyimpan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Dialog(
        elevation: 24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [AppColors.surface, AppColors.surfaceVariant],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.record == null
                            ? Icons.add_circle_outline
                            : Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.record == null
                                ? 'Tambah Produksi'
                                : 'Edit Produksi',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            widget.record == null
                                ? 'Catat produksi baru'
                                : 'Perbarui data produksi',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textSecondary,
                      ),
                      tooltip: 'Tutup',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Karyawan
                DropdownButtonFormField<String>(
                  initialValue: _selectedEmployeeId,
                  decoration: _modernInputDecoration(
                    'Karyawan',
                    Icons.person_outline,
                  ),
                  dropdownColor: AppColors.surface,
                  items: widget.employees
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e.id,
                          child: Text(
                            e.nama,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _isLoading
                      ? null
                      : (val) => setState(() => _selectedEmployeeId = val),
                ),
                const SizedBox(height: 16),

                // Departemen Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedDepartment,
                  decoration: _modernInputDecoration(
                    'Departemen',
                    Icons.domain,
                  ),
                  dropdownColor: AppColors.surface,
                  items: _departments
                      .map(
                        (dept) => DropdownMenuItem<String>(
                          value: dept,
                          child: Text(
                            dept,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _isLoading ? null : _onDepartmentChanged,
                ),
                const SizedBox(height: 16),

                // Produk Dropdown (filtered by department)
                DropdownButtonFormField<Product>(
                  initialValue: _selectedProduct,
                  decoration: _modernInputDecoration(
                    'Produk',
                    Icons.inventory_2_outlined,
                  ),
                  dropdownColor: AppColors.surface,
                  items: _filteredProducts
                      .map(
                        (p) => DropdownMenuItem<Product>(
                          value: p,
                          child: Text(
                            p.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _isLoading ? null : _onProductChanged,
                ),
                const SizedBox(height: 16),

                // Kuantitas Header
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Losin (×12)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'PCS (Satuan)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Losin dan PCS Input
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _losinController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _updateCalculatedPrice(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: _modernInputDecoration(
                          'Jumlah Losin',
                          Icons.widgets,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _pcsController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _updateCalculatedPrice(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: _modernInputDecoration(
                          'Jumlah PCS',
                          Icons.inventory,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tanggal
                GestureDetector(
                  onTap: _isLoading ? null : _pickDate,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      decoration: _modernInputDecoration(
                        'Tanggal',
                        Icons.calendar_today,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Harga Display
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Harga Total',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rp${_calculatedPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '(${((int.tryParse(_losinController.text) ?? 0) * 12) + (int.tryParse(_pcsController.text) ?? 0)} pcs × Rp${(_selectedProduct?.defaultRatePerPcs.toStringAsFixed(0)) ?? "0"})',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Catatan
                TextField(
                  controller: _notesController,
                  enabled: !_isLoading,
                  minLines: 2,
                  maxLines: 4,
                  decoration: _modernInputDecoration(
                    'Catatan (opsional)',
                    Icons.note_alt,
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(
                            color: AppColors.border,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _save,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.primary.withValues(
                            alpha: 0.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.check_circle_outline),
                        label: const Text(
                          'Simpan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _modernInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      prefixIcon: Icon(icon, color: AppColors.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: AppColors.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }
}
