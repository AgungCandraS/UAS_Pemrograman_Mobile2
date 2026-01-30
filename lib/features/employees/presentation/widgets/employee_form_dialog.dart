import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bisnisku/features/employees/domain/employee_model.dart';

class EmployeeFormDialog extends StatefulWidget {
  final Employee? employee;
  final Function(Employee) onSave;

  const EmployeeFormDialog({super.key, this.employee, required this.onSave});

  @override
  State<EmployeeFormDialog> createState() => _EmployeeFormDialogState();
}

class _EmployeeFormDialogState extends State<EmployeeFormDialog>
    with TickerProviderStateMixin {
  late TextEditingController _nikController;
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _positionController;
  late TextEditingController _salaryController;
  late TextEditingController _startDateController;

  String _selectedDepartment = 'sablon';
  DateTime? _selectedStartDate;
  bool _isLoading = false;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<String> departments = [
    'sablon',
    'obras',
    'jahit',
    'packing',
    'management',
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _nikController = TextEditingController(text: widget.employee?.nik ?? '');
    _namaController = TextEditingController(text: widget.employee?.nama ?? '');
    _emailController = TextEditingController(
      text: widget.employee?.email ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.employee?.phone ?? '',
    );
    _positionController = TextEditingController(
      text: widget.employee?.position ?? '',
    );
    _salaryController = TextEditingController(
      text: widget.employee?.salaryBase.toStringAsFixed(0) ?? '0',
    );
    _startDateController = TextEditingController(
      text: widget.employee?.startDate != null
          ? DateFormat('dd/MM/yyyy').format(widget.employee!.startDate!)
          : '',
    );

    _selectedDepartment = widget.employee?.department ?? 'sablon';
    _selectedStartDate = widget.employee?.startDate;

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _nikController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _salaryController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
        _startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _handleSave() async {
    if (_namaController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _positionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama, Email, Telepon, dan Posisi wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final employee = Employee(
        id: widget.employee?.id ?? '',
        nik: _nikController.text.isEmpty ? null : _nikController.text,
        nama: _namaController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        department: _selectedDepartment,
        position: _positionController.text,
        startDate: _selectedStartDate,
        salaryBase: double.tryParse(_salaryController.text) ?? 0,
        isActive: true,
        createdAt: widget.employee?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSave(employee);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.employee == null
                  ? 'Karyawan berhasil ditambahkan'
                  : 'Karyawan berhasil diperbarui',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 800),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        widget.employee == null
                            ? Icons.person_add
                            : Icons.person_outline,
                        color: Colors.blue.shade600,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.employee == null
                              ? 'Tambah Karyawan Baru'
                              : 'Edit Data Karyawan',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!_isLoading)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
                  _buildTextField(
                    controller: _nikController,
                    label: 'NIK (Nomor Induk Karyawan)',
                    icon: Icons.badge,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _namaController,
                    label: 'Nama Lengkap',
                    icon: Icons.person,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Nomor Telepon',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Department Dropdown
                  _buildDepartmentDropdown(),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _positionController,
                    label: 'Posisi/Jabatan',
                    icon: Icons.work,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Start Date
                  _buildDateField(),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _salaryController,
                    label: 'Gaji Pokok (Rp)',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.blue.shade600,
                            disabledBackgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Simpan',
                                  style: TextStyle(color: Colors.white),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
      ),
    );
  }

  Widget _buildDepartmentDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedDepartment,
      decoration: InputDecoration(
        labelText: 'Departemen',
        prefixIcon: Icon(Icons.domain, color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
      ),
      items: departments
          .map(
            (dept) =>
                DropdownMenuItem(value: dept, child: Text(dept.toUpperCase())),
          )
          .toList(),
      onChanged: !_isLoading
          ? (value) {
              if (value != null) {
                setState(() => _selectedDepartment = value);
              }
            }
          : null,
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _isLoading ? null : _selectDate,
      child: TextField(
        controller: _startDateController,
        enabled: false,
        decoration: InputDecoration(
          labelText: 'Tanggal Mulai Kerja',
          prefixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade600),
          suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
        ),
      ),
    );
  }
}
