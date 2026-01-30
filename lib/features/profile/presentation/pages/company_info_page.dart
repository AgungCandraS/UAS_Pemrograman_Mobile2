import 'package:bisnisku/features/profile/application/providers/profile_providers.dart';
import 'package:bisnisku/features/profile/domain/entities/company_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompanyInfoPage extends ConsumerStatefulWidget {
  const CompanyInfoPage({super.key});

  @override
  ConsumerState<CompanyInfoPage> createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends ConsumerState<CompanyInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _legalNameController;
  late TextEditingController _taxIdController;
  late TextEditingController _businessTypeController;
  late TextEditingController _industryController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _provinceController;
  late TextEditingController _postalCodeController;
  late TextEditingController _websiteController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _legalNameController = TextEditingController();
    _taxIdController = TextEditingController();
    _businessTypeController = TextEditingController();
    _industryController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _provinceController = TextEditingController();
    _postalCodeController = TextEditingController();
    _websiteController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _legalNameController.dispose();
    _taxIdController.dispose();
    _businessTypeController.dispose();
    _industryController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _postalCodeController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadCompanyInfo(CompanyInfo? companyInfo) {
    if (companyInfo != null) {
      _legalNameController.text = companyInfo.legalName ?? '';
      _taxIdController.text = companyInfo.taxId ?? '';
      _businessTypeController.text = companyInfo.businessType ?? '';
      _industryController.text = companyInfo.industry ?? '';
      _addressController.text = companyInfo.address ?? '';
      _cityController.text = companyInfo.city ?? '';
      _provinceController.text = companyInfo.province ?? '';
      _postalCodeController.text = companyInfo.postalCode ?? '';
      _websiteController.text = companyInfo.website ?? '';
      _descriptionController.text = companyInfo.description ?? '';
    }
  }

  Future<void> _saveCompanyInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final companyInfo = CompanyInfo(
        userId: userId,
        legalName: _legalNameController.text.trim(),
        taxId: _taxIdController.text.trim(),
        businessType: _businessTypeController.text.trim(),
        industry: _industryController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        province: _provinceController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        website: _websiteController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      await ref
          .read(updateCompanyInfoProvider.notifier)
          .updateCompanyInfo(companyInfo);

      if (mounted) {
        ref.invalidate(companyInfoProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Info perusahaan berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: Colors.red,
          ),
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
    final companyInfoAsync = ref.watch(companyInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Perusahaan'),
        elevation: 0,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save_outlined),
              tooltip: 'Simpan',
              onPressed: _saveCompanyInfo,
            ),
        ],
      ),
      body: companyInfoAsync.when(
        data: (companyInfo) {
          // Load data once
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_legalNameController.text.isEmpty) {
              _loadCompanyInfo(companyInfo);
            }
          });

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.business,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Informasi Perusahaan',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Kelola data legal dan profil bisnis',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Data ini digunakan untuk dokumen legal, invoice, dan laporan resmi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Legal Information Section
                        _buildSectionCard(
                          icon: Icons.gavel,
                          title: 'Informasi Legal',
                          subtitle: 'Data resmi perusahaan untuk dokumen legal',
                          children: [
                            _buildTextField(
                              controller: _legalNameController,
                              label: 'Nama Legal Perusahaan *',
                              icon: Icons.business_outlined,
                              hint: 'PT. Nama Perusahaan Indonesia',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Nama legal wajib diisi';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _taxIdController,
                              label: 'NPWP',
                              icon: Icons.badge_outlined,
                              keyboardType: TextInputType.number,
                              hint: '12.345.678.9-012.000',
                              helperText: 'Nomor Pokok Wajib Pajak perusahaan',
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Business Type Section
                        _buildSectionCard(
                          icon: Icons.category_outlined,
                          title: 'Jenis Bisnis',
                          subtitle: 'Kategori dan tipe usaha Anda',
                          children: [
                            _buildTextField(
                              controller: _businessTypeController,
                              label: 'Tipe Bisnis',
                              icon: Icons.store_outlined,
                              hint: 'PT / CV / UD / Perorangan',
                              helperText: 'Bentuk badan usaha',
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _industryController,
                              label: 'Industri',
                              icon: Icons.work_outline,
                              hint: 'Retail, F&B, Manufacturing, dll',
                              helperText: 'Sektor industri bisnis Anda',
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Address Section
                        _buildSectionCard(
                          icon: Icons.location_on_outlined,
                          title: 'Alamat Perusahaan',
                          subtitle: 'Lokasi kantor atau tempat usaha',
                          children: [
                            _buildTextField(
                              controller: _addressController,
                              label: 'Alamat Lengkap',
                              icon: Icons.home_outlined,
                              maxLines: 3,
                              hint: 'Jalan, Nomor, RT/RW, Kelurahan',
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildTextField(
                                    controller: _cityController,
                                    label: 'Kota/Kabupaten',
                                    icon: Icons.location_city_outlined,
                                    hint: 'Jakarta',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _postalCodeController,
                                    label: 'Kode Pos',
                                    icon: Icons.markunread_mailbox_outlined,
                                    keyboardType: TextInputType.number,
                                    hint: '12345',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _provinceController,
                              label: 'Provinsi',
                              icon: Icons.map_outlined,
                              hint: 'DKI Jakarta',
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Additional Info Section
                        _buildSectionCard(
                          icon: Icons.info_outlined,
                          title: 'Informasi Tambahan',
                          subtitle: 'Website dan deskripsi perusahaan',
                          children: [
                            _buildTextField(
                              controller: _websiteController,
                              label: 'Website',
                              icon: Icons.language_outlined,
                              keyboardType: TextInputType.url,
                              hint: 'https://perusahaan.com',
                              helperText: 'Website resmi perusahaan (opsional)',
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _descriptionController,
                              label: 'Deskripsi Perusahaan',
                              icon: Icons.description_outlined,
                              maxLines: 4,
                              hint:
                                  'Jelaskan bisnis dan produk/layanan Anda...',
                              helperText:
                                  'Deskripsi singkat untuk profil perusahaan',
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _saveCompanyInfo,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              _isLoading ? 'Menyimpan...' : 'Simpan Perubahan',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Info footer
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lock_outline,
                                size: 20,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Data perusahaan disimpan dengan aman dan hanya digunakan untuk keperluan bisnis Anda',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade700,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Gagal memuat data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hint,
    String? helperText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 14,
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w300,
        ),
        helperText: helperText,
        helperMaxLines: 3,
        helperStyle: TextStyle(
          fontSize: 10.5,
          height: 1.5,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
