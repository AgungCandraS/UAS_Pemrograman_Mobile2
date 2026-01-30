import 'package:bisnisku/features/inventory/application/inventory_state.dart';
import 'package:bisnisku/features/profile/application/providers/profile_providers.dart';
import 'package:bisnisku/features/inventory/domain/entities/index.dart';
import 'package:bisnisku/features/inventory/presentation/pages/bulk_edit_modal.dart';
import 'package:bisnisku/features/inventory/presentation/widgets/inventory_item_card.dart';
import 'package:bisnisku/shared/constants/app_colors.dart';
import 'package:bisnisku/shared/constants/app_spacing.dart';
import 'package:bisnisku/shared/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InventoryListPage extends ConsumerStatefulWidget {
  const InventoryListPage({super.key});

  @override
  ConsumerState<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends ConsumerState<InventoryListPage>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(inventorySearchQueryProvider.notifier).state =
          _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch theme to rebuild when theme changes
    ref.watch(immediateThemeProvider);

    // Get current brightness based on theme
    final brightness = Theme.of(context).brightness;
    final searchQuery = ref.watch(inventorySearchQueryProvider);
    final lowStockOnly = ref.watch(lowStockOnlyProvider);
    final selectedVariants = ref.watch(selectedVariantsProvider);
    final isSelecting = selectedVariants.isNotEmpty;

    final itemsAsync = searchQuery.trim().isEmpty
        ? ref.watch(inventoryItemsProvider)
        : ref.watch(inventorySearchProvider(searchQuery));

    final summary = itemsAsync.maybeWhen(
      data: (items) {
        final lowStocks = items.where((item) => item.hasLowStock()).length;
        final totalVariants = items.fold<int>(
          0,
          (sum, item) => sum + item.variants.length,
        );
        return (
          totalItems: items.length,
          lowStocks: lowStocks,
          totalVariants: totalVariants,
        );
      },
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(brightness),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getBackgroundGradient(brightness),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refresh,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(
                    isSelecting: isSelecting,
                    totalItems: summary?.totalItems,
                    lowStocks: summary?.lowStocks,
                    totalVariants: summary?.totalVariants,
                  ),
                ),
                SliverToBoxAdapter(child: _buildSearchAndFilters(lowStockOnly)),
                itemsAsync.when(
                  data: (items) {
                    final filteredItems = lowStockOnly
                        ? items.where((item) => item.hasLowStock()).toList()
                        : items;
                    if (filteredItems.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: true,
                        child: _EmptyState(onReset: _resetFilters),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = filteredItems[index];
                        return InventoryItemCard(
                          item: item,
                          onEdit: () =>
                              context.push('/inventory/item/${item.id}'),
                        );
                      }, childCount: filteredItems.length),
                    );
                  },
                  loading: () => const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  error: (error, _) => SliverFillRemaining(
                    hasScrollBody: true,
                    child: _ErrorState(message: '$error', onRetry: _refresh),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl * 2)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isSelecting
                ? Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: FloatingActionButton.extended(
                      heroTag: 'bulk-edit',
                      backgroundColor: AppColors.secondary,
                      icon: const Icon(
                        Icons.auto_fix_high,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Edit ${selectedVariants.length} varian',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () =>
                          _openBulkEdit(itemsAsync, selectedVariants),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          FloatingActionButton.extended(
            heroTag: 'add-item',
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Tambah', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              final result = await context.push('/inventory/add');
              if (result == true && mounted) {
                _refresh();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required bool isSelecting,
    int? totalItems,
    int? lowStocks,
    int? totalVariants,
  }) {
    return Builder(
      builder: (context) {
        final brightness = Theme.of(context).brightness;
        final selectionBanner = AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isSelecting
              ? Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          '${ref.read(selectedVariantsProvider).length} varian dipilih',
                          style: TextStyle(
                            color: AppColors.getTextPrimaryColor(brightness),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _clearSelection,
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              gradient: LinearGradient(
                colors: brightness == Brightness.dark
                    ? const [Color(0xFF0F172A), Color(0xFF1E293B)]
                    : const [Color(0xFF3B82F6), Color(0xFF06B6D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: 18,
                  offset: Offset(0, 12),
                ),
              ],
              border: Border.all(
                color: AppColors.getBorderColor(
                  brightness,
                ).withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_graph_outlined,
                      color: brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.white,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Inventory',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: brightness == Brightness.dark
                            ? Colors.white
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Pantau stok, harga, dan varian warna dengan sekali pandang.',
                  style: TextStyle(
                    color: brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (totalItems != null)
                  _buildSummaryChips(totalItems, lowStocks, totalVariants),
                const SizedBox(height: AppSpacing.sm),
                selectionBanner,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryChips(
    int totalItems,
    int? lowStocks,
    int? totalVariants,
  ) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _summaryPill(
          icon: Icons.inventory_2_outlined,
          label: 'Barang',
          value: totalItems.toString(),
          color: AppColors.primary,
        ),
        _summaryPill(
          icon: Icons.color_lens_outlined,
          label: 'Varian',
          value: (totalVariants ?? 0).toString(),
          color: AppColors.secondary,
        ),
        _summaryPill(
          icon: Icons.warning_amber_rounded,
          label: 'Stok rendah',
          value: (lowStocks ?? 0).toString(),
          color: AppColors.warning,
        ),
      ],
    );
  }

  Widget _summaryPill({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Builder(
      builder: (context) {
        final brightness = Theme.of(context).brightness;
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: brightness == Brightness.dark
                    ? Colors.white
                    : Colors.white,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$value $label',
                style: TextStyle(
                  color: brightness == Brightness.dark
                      ? Colors.white
                      : Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilters(bool lowStockOnly) {
    return Builder(
      builder: (context) {
        final brightness = Theme.of(context).brightness;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.getSurfaceColor(brightness),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  border: Border.all(
                    color: AppColors.getBorderColor(brightness),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.getTextSecondaryColor(brightness),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Cari nama atau SKU',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: AppColors.getTextPrimaryColor(brightness),
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          _searchController.clear();
                          ref
                                  .read(inventorySearchQueryProvider.notifier)
                                  .state =
                              '';
                        },
                        icon: Icon(
                          Icons.close,
                          color: AppColors.getTextSecondaryColor(brightness),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  FilterChip(
                    label: const Text('Stok rendah'),
                    selected: lowStockOnly,
                    onSelected: (value) =>
                        ref.read(lowStockOnlyProvider.notifier).state = value,
                    selectedColor: AppColors.warning.withValues(alpha: 0.2),
                    backgroundColor: AppColors.getSurfaceVariantColor(
                      brightness,
                    ),
                    labelStyle: TextStyle(
                      color: lowStockOnly
                          ? AppColors.warning
                          : AppColors.getTextSecondaryColor(brightness),
                      fontWeight: FontWeight.w700,
                    ),
                    side: BorderSide(
                      color: AppColors.getBorderColor(brightness),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilterChip(
                    label: const Text('Clear'),
                    selected: false,
                    onSelected: (_) => _resetFilters(),
                    backgroundColor: AppColors.getSurfaceVariantColor(
                      brightness,
                    ),
                    side: BorderSide(
                      color: AppColors.getBorderColor(brightness),
                    ),
                    labelStyle: TextStyle(
                      color: AppColors.getTextSecondaryColor(brightness),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _refresh() async {
    ref.invalidate(inventoryItemsProvider);
    final query = ref.read(inventorySearchQueryProvider);
    if (query.trim().isNotEmpty) {
      ref.invalidate(inventorySearchProvider(query));
    }
  }

  void _resetFilters() {
    ref.read(lowStockOnlyProvider.notifier).state = false;
    _searchController.clear();
    ref.read(inventorySearchQueryProvider.notifier).state = '';
  }

  void _clearSelection() {
    ref.read(selectedVariantsProvider.notifier).state = <String>{};
  }

  Future<void> _openBulkEdit(
    AsyncValue<List<InventoryItem>> itemsAsync,
    Set<String> selectedVariants,
  ) async {
    final items = itemsAsync.whenData((value) => value).valueOrNull;
    if (items == null) return;
    final variantMap = <String, InventoryVariant>{};
    for (final item in items) {
      for (final variant in item.variants) {
        variantMap[variant.id] = variant;
      }
    }
    final variants = selectedVariants
        .map((id) => variantMap[id])
        .whereType<InventoryVariant>()
        .toList();
    if (variants.isEmpty) return;

    final result = await BulkEditModal.show(
      context,
      selectedVariants: variants,
    );
    if (!mounted) return;
    if (result == true && mounted) {
      _clearSelection();
      await _refresh();
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.getSurfaceColor(brightness),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: AppColors.getTextSecondaryColor(brightness),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Belum ada barang',
              style: TextStyle(
                color: AppColors.getTextPrimaryColor(brightness),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Tambah barang baru atau reset filter pencarian.',
              style: TextStyle(
                color: AppColors.getTextSecondaryColor(brightness),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: SecondaryButton(text: 'Reset filter', onPressed: onReset),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.getSurfaceColor(brightness),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowMedium,
                    blurRadius: 18,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Gagal memuat data',
              style: TextStyle(
                color: AppColors.getTextPrimaryColor(brightness),
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.getTextSecondaryColor(brightness),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Jika sesi login sudah kedaluwarsa, buka ulang aplikasi atau login kembali.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.getTextTertiaryColor(brightness),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Coba lagi',
                onPressed: () => onRetry(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
