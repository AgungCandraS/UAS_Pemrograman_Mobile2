import 'package:bisnisku/features/inventory/application/inventory_controller.dart';
import 'package:bisnisku/features/inventory/domain/entities/index.dart';
import 'package:bisnisku/shared/constants/app_colors.dart';
import 'package:bisnisku/shared/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BulkEditModal extends ConsumerStatefulWidget {
  const BulkEditModal({super.key, required this.selectedVariants});

  final List<InventoryVariant> selectedVariants;

  static Future<bool?> show(
    BuildContext context, {
    required List<InventoryVariant> selectedVariants,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.86,
        child: BulkEditModal(selectedVariants: selectedVariants),
      ),
    );
  }

  @override
  ConsumerState<BulkEditModal> createState() => _BulkEditModalState();
}

class _BulkEditModalState extends ConsumerState<BulkEditModal>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _minStockController = TextEditingController();
  bool _incrementStock = false;
  bool _isSaving = false;
  final _currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_fix_high,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Massal',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${widget.selectedVariants.length} varian dipilih',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TabBar(
            controller: _tabController,
            labelColor: AppColors.textPrimary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Harga'),
              Tab(text: 'Stok'),
              Tab(text: 'Preview'),
            ],
          ),
          const Divider(color: AppColors.border, height: 1),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPriceTab(),
                _buildStockTab(),
                _buildPreviewTab(),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).maybePop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSaving ? null : _apply,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Terapkan',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTab() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Update harga jual untuk semua varian terpilih.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Harga jual baru',
              border: OutlineInputBorder(),
              prefixText: 'Rp ',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _infoBox(
            icon: Icons.lightbulb_outline,
            text:
                'Jika dibiarkan kosong, harga tidak akan berubah untuk varian terpilih.',
          ),
        ],
      ),
    );
  }

  Widget _buildStockTab() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile.adaptive(
            value: _incrementStock,
            onChanged: (value) => setState(() => _incrementStock = value),
            trackColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : AppColors.border,
            ),
            thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            title: const Text(
              'Tambah stok (increment)',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: const Text(
              'Matikan jika ingin set stok secara langsung.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _stockController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: _incrementStock
                  ? 'Tambah jumlah stok'
                  : 'Set jumlah stok',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _minStockController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Minimum stok',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _infoBox(
            icon: Icons.warning_amber_outlined,
            text:
                'Minimum stok opsional. Dibiarkan kosong tidak akan mengubah nilai minimal.',
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewTab() {
    final newPrice = _priceController.text.isNotEmpty
        ? double.tryParse(_priceController.text)
        : null;
    final stockChange = _stockController.text.isNotEmpty
        ? int.tryParse(_stockController.text)
        : null;
    final minStock = _minStockController.text.isNotEmpty
        ? int.tryParse(_minStockController.text)
        : null;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _previewTile(
            title: 'Harga',
            value: newPrice != null
                ? 'Set harga jual ke ${_currency.format(newPrice)}'
                : 'Tidak ada perubahan',
            icon: Icons.sell_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _previewTile(
            title: 'Stok',
            value: stockChange != null
                ? _incrementStock
                      ? 'Tambah stok +$stockChange'
                      : 'Set stok ke $stockChange'
                : 'Tidak ada perubahan',
            icon: Icons.inventory_2_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _previewTile(
            title: 'Minimum stok',
            value: minStock != null
                ? 'Set minimum ke $minStock'
                : 'Tidak ada perubahan',
            icon: Icons.shield_moon_outlined,
          ),
          const SizedBox(height: AppSpacing.lg),
          _infoBox(
            icon: Icons.info_outline,
            text:
                'Perubahan akan diterapkan ke ${widget.selectedVariants.length} varian.',
          ),
        ],
      ),
    );
  }

  Widget _previewTile({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoBox({required IconData icon, required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _apply() async {
    final price = _priceController.text.trim();
    final stock = _stockController.text.trim();
    final minStock = _minStockController.text.trim();

    if (price.isEmpty && stock.isEmpty && minStock.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi salah satu field untuk melanjutkan.'),
        ),
      );
      _tabController.animateTo(0);
      return;
    }

    final payload = BulkEditPayload(
      variantIds: widget.selectedVariants.map((v) => v.id).toList(),
      newSellingPrice: price.isNotEmpty ? double.tryParse(price) : null,
      incrementStock: _incrementStock,
      stockQuantity: stock.isNotEmpty ? int.tryParse(stock) : null,
      minStockLevel: minStock.isNotEmpty ? int.tryParse(minStock) : null,
    );

    setState(() => _isSaving = true);
    try {
      await ref.read(inventoryControllerProvider).bulkEditVariants(payload);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
