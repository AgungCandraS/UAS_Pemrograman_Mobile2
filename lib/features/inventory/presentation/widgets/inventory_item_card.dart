import 'package:bisnisku/features/inventory/application/inventory_state.dart';
import 'package:bisnisku/features/profile/application/providers/profile_providers.dart';
import 'package:bisnisku/features/inventory/domain/entities/index.dart';
import 'package:bisnisku/shared/constants/app_colors.dart';
import 'package:bisnisku/shared/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class InventoryItemCard extends ConsumerStatefulWidget {
  const InventoryItemCard({
    super.key,
    required this.item,
    this.onEdit,
    this.onTap,
  });

  final InventoryItem item;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;

  @override
  ConsumerState<InventoryItemCard> createState() => _InventoryItemCardState();
}

class _InventoryItemCardState extends ConsumerState<InventoryItemCard> {
  bool _expanded = false;
  final _currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  @override
  Widget build(BuildContext context) {
    // Watch theme to rebuild when theme changes
    ref.watch(immediateThemeProvider);
    final brightness = Theme.of(context).brightness;

    final selectedVariants = ref.watch(selectedVariantsProvider);
    final selectionMode = selectedVariants.isNotEmpty;
    final totalStock = widget.item.getTotalStock();
    final avgPrice = widget.item.getAverageSellingPrice();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.getSurfaceColor(brightness),
            AppColors.getSurfaceVariantColor(brightness),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: widget.item.hasLowStock()
              ? AppColors.warning
              : AppColors.getBorderColor(brightness),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.onTap ?? () => setState(() => _expanded = !_expanded),
            onLongPress: _handleLongPress,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildThumbnail(),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _buildHeader(brightness, totalStock, avgPrice)),
                Column(
                  children: [
                    IconButton(
                      onPressed: widget.onEdit,
                      icon: Icon(
                        Icons.edit_outlined,
                        color: AppColors.getTextSecondaryColor(brightness),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _expanded = !_expanded),
                      icon: AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more,
                          color: AppColors.getTextSecondaryColor(brightness),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildBadges(),
          const SizedBox(height: AppSpacing.sm),
          AnimatedCrossFade(
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(color: AppColors.getBorderColor(brightness)),
                const SizedBox(height: AppSpacing.sm),
                ...widget.item.variants.map((variant) {
                  final isSelected = selectedVariants.contains(variant.id);
                  return _VariantRow(
                    variant: variant,
                    selectionMode: selectionMode,
                    isSelected: isSelected,
                    onToggle: () => _toggleVariantSelection(variant.id),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      height: 72,
      width: 72,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        color: AppColors.primary,
        size: 32,
      ),
    );
  }

  Widget _buildHeader(Brightness brightness, int totalStock, double avgPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.item.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimaryColor(brightness),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            _chip('SKU: ${widget.item.sku}'),
            if (widget.item.category != null &&
                widget.item.category!.trim().isNotEmpty) ...[
              const SizedBox(width: AppSpacing.xs),
              _chip(widget.item.category!),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _stat(
              Icons.layers_outlined,
              '${widget.item.variants.length} Varian',
            ),
            const SizedBox(width: AppSpacing.md),
            _stat(Icons.inventory_outlined, '$totalStock Stok'),
            const SizedBox(width: AppSpacing.md),
            _stat(Icons.sell_outlined, _currency.format(avgPrice)),
          ],
        ),
      ],
    );
  }

  Widget _chip(String label) {
    final brightness = Theme.of(context).brightness;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceVariantColor(brightness),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.getBorderColor(brightness)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.getTextSecondaryColor(brightness),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String label) {
    final brightness = Theme.of(context).brightness;
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.getTextSecondaryColor(brightness),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            color: AppColors.getTextSecondaryColor(brightness),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBadges() {
    return Row(
      children: [
        if (widget.item.hasLowStock())
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: AppColors.warning,
                  size: 16,
                ),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'Stok rendah',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _handleLongPress() {
    if (widget.item.variants.isEmpty) return;
    final firstVariantId = widget.item.variants.first.id;
    final notifier = ref.read(selectedVariantsProvider.notifier);
    final current = {...notifier.state};
    if (current.contains(firstVariantId)) {
      current.remove(firstVariantId);
    } else {
      current.add(firstVariantId);
    }
    notifier.state = current;
  }

  void _toggleVariantSelection(String variantId) {
    final notifier = ref.read(selectedVariantsProvider.notifier);
    final current = {...notifier.state};
    if (current.contains(variantId)) {
      current.remove(variantId);
    } else {
      current.add(variantId);
    }
    notifier.state = current;
  }
}

class _VariantRow extends StatelessWidget {
  const _VariantRow({
    required this.variant,
    required this.selectionMode,
    required this.isSelected,
    required this.onToggle,
  });

  final InventoryVariant variant;
  final bool selectionMode;
  final bool isSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (selectionMode)
              Checkbox(
                value: isSelected,
                onChanged: (_) => onToggle(),
                activeColor: AppColors.primary,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variant.colorName,
                    style: TextStyle(
                      color: AppColors.getTextPrimaryColor(brightness),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Text(
                        currency.format(variant.sellingPrice),
                        style: TextStyle(
                          color: AppColors.getTextSecondaryColor(brightness),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'HPP ${currency.format(variant.initialPrice)}',
                        style: TextStyle(
                          color: AppColors.getTextTertiaryColor(brightness),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _StockBadge(
              stock: variant.stockQuantity,
              minStock: variant.minStockLevel,
            ),
          ],
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.stock, required this.minStock});

  final int stock;
  final int minStock;

  @override
  Widget build(BuildContext context) {
    final isLow = stock <= minStock;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isLow
            ? AppColors.error.withValues(alpha: 0.1)
            : AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Text(
        'Stok $stock',
        style: TextStyle(
          color: isLow ? AppColors.error : AppColors.success,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
