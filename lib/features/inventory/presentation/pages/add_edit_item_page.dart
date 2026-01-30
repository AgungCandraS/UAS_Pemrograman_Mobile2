import 'package:bisnisku/features/inventory/application/inventory_controller.dart';
import 'package:bisnisku/features/inventory/application/inventory_state.dart';
import 'package:bisnisku/features/inventory/application/providers.dart';
import 'package:bisnisku/features/inventory/domain/entities/index.dart';
import 'package:bisnisku/shared/constants/app_colors.dart';
import 'package:bisnisku/shared/constants/app_spacing.dart';
import 'package:bisnisku/shared/widgets/buttons.dart';
import 'package:bisnisku/shared/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditItemPage extends ConsumerStatefulWidget {
  const AddEditItemPage({super.key, this.itemId});

  final String? itemId;

  @override
  ConsumerState<AddEditItemPage> createState() => _AddEditItemPageState();
}

class _AddEditItemPageState extends ConsumerState<AddEditItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _skuController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<_VariantFormState> _variantForms = [];
  final Set<String> _removedVariantIds = {};
  bool _isSubmitting = false;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _addVariantForm();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    for (final variant in _variantForms) {
      variant.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.itemId != null;
    final itemAsync = isEditing
        ? ref.watch(inventoryItemByIdProvider(widget.itemId!))
        : null;

    if (isEditing) {
      itemAsync?.whenData((item) {
        if (item != null && !_seeded) {
          _seedFromItem(item);
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Barang' : 'Tambah Barang'),
        backgroundColor: AppColors.background,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, AppColors.surface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child:
              itemAsync?.when(
                data: (_) => _buildForm(isEditing),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (error, _) => Center(
                  child: Text(
                    'Gagal memuat data: $error',
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ) ??
              _buildForm(isEditing),
        ),
      ),
    );
  }

  Widget _buildForm(bool isEditing) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildCard(
            title: 'Informasi Barang',
            child: Column(
              children: [
                AppTextField(
                  controller: _titleController,
                  label: 'Nama barang *',
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _skuController,
                  label: 'SKU *',
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _descriptionController,
                  label: 'Deskripsi',
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _categoryController,
                  label: 'Kategori',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildCard(
            title: 'Varian Warna',
            trailing: FilledButton.icon(
              onPressed: _addVariantForm,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Tambah warna',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            child: Column(
              children: [
                ..._variantForms.map((variant) {
                  final isRemovable = _variantForms.length > 1;
                  return _VariantForm(
                    key: ValueKey(variant.localId),
                    state: variant,
                    onRemove: isRemovable
                        ? () => _removeVariantForm(variant)
                        : null,
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            text: isEditing ? 'Simpan Perubahan' : 'Simpan Barang',
            isLoading: _isSubmitting,
            onPressed: _isSubmitting ? null : () => _submit(isEditing),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }

  void _addVariantForm() {
    setState(() {
      _variantForms.add(_VariantFormState());
    });
  }

  void _removeVariantForm(_VariantFormState form) {
    setState(() {
      if (form.variantId?.isNotEmpty == true) {
        _removedVariantIds.add(form.variantId!);
      }
      _variantForms.remove(form);
    });
  }

  void _seedFromItem(InventoryItem item) {
    _seeded = true;
    _titleController.text = item.title;
    _skuController.text = item.sku;
    _descriptionController.text = item.description ?? '';
    _categoryController.text = item.category ?? '';
    _variantForms.clear();
    for (final variant in item.variants) {
      _variantForms.add(_VariantFormState.fromVariant(variant));
    }
    if (_variantForms.isEmpty) _addVariantForm();
    setState(() {});
  }

  Future<void> _submit(bool isEditing) async {
    if (!_formKey.currentState!.validate()) return;
    final userId = ref.read(supabaseServiceProvider).currentUser?.id;
    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login untuk menyimpan.')),
      );
      return;
    }

    final now = DateTime.now();
    final variants = _variantForms.map((form) {
      return InventoryVariant(
        id: form.variantId ?? '',
        inventoryItemId: widget.itemId ?? '',
        userId: userId,
        colorName: form.colorNameController.text.trim(),
        initialPrice: double.tryParse(form.hppController.text) ?? 0,
        sellingPrice: double.tryParse(form.sellPriceController.text) ?? 0,
        stockQuantity: int.tryParse(form.stockController.text) ?? 0,
        minStockLevel: int.tryParse(form.minStockController.text) ?? 0,
        createdAt: now,
        updatedAt: now,
      );
    }).toList();

    setState(() => _isSubmitting = true);
    try {
      final controller = ref.read(inventoryControllerProvider);
      if (isEditing) {
        await controller.updateInventoryItem(
          itemId: widget.itemId!,
          title: _titleController.text.trim(),
          sku: _skuController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          category: _categoryController.text.trim().isEmpty
              ? null
              : _categoryController.text.trim(),
          imageUrl: null,
          variants: variants,
          removedVariantIds: _removedVariantIds.toList(),
        );
      } else {
        await controller.createInventoryItem(
          title: _titleController.text.trim(),
          sku: _skuController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          category: _categoryController.text.trim().isEmpty
              ? null
              : _categoryController.text.trim(),
          imageUrl: null,
          variants: variants,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? 'Perubahan disimpan' : 'Barang ditambahkan',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class _VariantFormState {
  _VariantFormState()
    : variantId = null,
      localId = UniqueKey().toString(),
      colorNameController = TextEditingController(),
      hppController = TextEditingController(),
      sellPriceController = TextEditingController(),
      stockController = TextEditingController(),
      minStockController = TextEditingController();

  _VariantFormState.fromVariant(InventoryVariant variant)
    : localId = UniqueKey().toString(),
      variantId = variant.id,
      colorNameController = TextEditingController(text: variant.colorName),
      hppController = TextEditingController(
        text: variant.initialPrice.toString(),
      ),
      sellPriceController = TextEditingController(
        text: variant.sellingPrice.toString(),
      ),
      stockController = TextEditingController(
        text: variant.stockQuantity.toString(),
      ),
      minStockController = TextEditingController(
        text: variant.minStockLevel.toString(),
      );

  final String localId;
  final String? variantId;
  final TextEditingController colorNameController;
  final TextEditingController hppController;
  final TextEditingController sellPriceController;
  final TextEditingController stockController;
  final TextEditingController minStockController;

  void dispose() {
    colorNameController.dispose();
    hppController.dispose();
    sellPriceController.dispose();
    stockController.dispose();
    minStockController.dispose();
  }
}

class _VariantForm extends StatelessWidget {
  const _VariantForm({super.key, required this.state, this.onRemove});

  final _VariantFormState state;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Warna',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: state.colorNameController,
            label: 'Nama warna *',
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: state.hppController,
                  label: 'Harga modal (HPP) *',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Wajib diisi' : null,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppTextField(
                  controller: state.sellPriceController,
                  label: 'Harga jual *',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Wajib diisi' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: state.stockController,
                  label: 'Stok',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppTextField(
                  controller: state.minStockController,
                  label: 'Minimum stok',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
