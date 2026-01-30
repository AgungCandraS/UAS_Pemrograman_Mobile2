import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:bisnisku/features/inventory/application/providers.dart';
import 'package:bisnisku/features/sales/data/models/sale_model.dart';
import '../../application/providers/sales_provider.dart';
import '../../domain/constants/sales_constants.dart';
import '../../../integration/application/integration_providers.dart';
import '../../../integration/domain/admin_fee.dart';

class NewSalePage extends ConsumerStatefulWidget {
  const NewSalePage({super.key});

  @override
  ConsumerState<NewSalePage> createState() => _NewSalePageState();
}

class _NewSalePageState extends ConsumerState<NewSalePage> {
  final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  String _category = 'offline'; // 'offline' atau 'online'
  String? _selectedMarketplaceId; // ID dari admin_fee yang dipilih
  AdminFee? _selectedMarketplace; // Data marketplace yang dipilih
  String _notes = '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final items = ref.watch(currentSaleItemsProvider);
    final totalRevenue = ref.watch(totalRevenueProvider);
    final totalCost = ref.watch(totalCostProvider);
    final totalProfit = ref.watch(totalProfitProvider);
    final recordingState = ref.watch(recordingSaleProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        title: Text(
          'Penjualan Baru',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onPrimary),
          onPressed: () {
            ref.read(currentSaleItemsProvider.notifier).state = [];
            setState(() {
              _category = 'offline';
              _selectedMarketplaceId = null;
              _selectedMarketplace = null;
              _notes = '';
            });
            context.pop();
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth > 600
                    ? 600
                    : constraints.maxWidth,
              ),
              child: Padding(
                padding: EdgeInsets.all(constraints.maxWidth > 600 ? 24 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sale Category Card
                    _buildCategoryCard(colorScheme, textTheme),
                    const SizedBox(height: 24),

                    // Marketplace Selector (jika online)
                    if (_category == 'online') ...[
                      _buildMarketplaceSelector(colorScheme, textTheme, ref),
                      const SizedBox(height: 24),
                    ],

                    // Add Product Section
                    _buildAddProductCard(colorScheme, textTheme),
                    const SizedBox(height: 20),

                    // Items List
                    if (items.isNotEmpty) ...[
                      _buildProductsHeader(
                        items.length,
                        colorScheme,
                        textTheme,
                      ),
                      const SizedBox(height: 12),
                      ...items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return _buildItemCard(
                          index,
                          item,
                          colorScheme,
                          textTheme,
                        );
                      }),
                      const SizedBox(height: 24),
                    ],

                    // Admin Fee Info (if online)
                    if (_category == 'online') ...[
                      _buildAdminFeeInfo(ref, colorScheme, textTheme),
                      const SizedBox(height: 24),
                    ],

                    // Notes Section
                    _buildNotesCard(colorScheme, textTheme),
                    const SizedBox(height: 24),

                    // Summary & Calculation (will use actual fees if online)
                    Consumer(
                      builder: (context, ref, child) {
                        if (_category == 'online') {
                          final adminFeesAsync = ref.watch(
                            activeAdminFeesProvider,
                          );
                          return adminFeesAsync.when(
                            data: (fees) {
                              double feePercent = 0;
                              double processingFee = 0;
                              if (fees.isNotEmpty) {
                                feePercent = fees.first.feePercent;
                                processingFee = fees.first.processingFee;
                              }
                              return _buildModernSummary(
                                totalRevenue,
                                totalCost,
                                totalProfit,
                                colorScheme,
                                textTheme,
                                feePercent,
                                processingFee,
                              );
                            },
                            loading: () => _buildModernSummary(
                              totalRevenue,
                              totalCost,
                              totalProfit,
                              colorScheme,
                              textTheme,
                              0,
                              0,
                            ),
                            error: (e, st) => _buildModernSummary(
                              totalRevenue,
                              totalCost,
                              totalProfit,
                              colorScheme,
                              textTheme,
                              0,
                              0,
                            ),
                          );
                        }
                        return _buildModernSummary(
                          totalRevenue,
                          totalCost,
                          totalProfit,
                          colorScheme,
                          textTheme,
                          0,
                          0,
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    _buildSaveButton(
                      items.isEmpty,
                      recordingState,
                      ref,
                      colorScheme,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Kategori Penjualan',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🏪'),
                        SizedBox(width: 6),
                        Text('Offline'),
                      ],
                    ),
                    value: 'offline',
                  ),
                  ButtonSegment(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('📱'),
                        SizedBox(width: 6),
                        Text('Online'),
                      ],
                    ),
                    value: 'online',
                  ),
                ],
                selected: {_category},
                onSelectionChanged: (value) {
                  setState(() {
                    _category = value.first;
                    // Reset marketplace selection saat ganti kategori
                    if (_category == 'offline') {
                      _selectedMarketplaceId = null;
                      _selectedMarketplace = null;
                    }
                  });
                },
                style: ButtonStyle(visualDensity: VisualDensity.comfortable),
              ),
            ),
            if (_category == 'online')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Harga akan dikurangi admin fees',
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketplaceSelector(
    ColorScheme colorScheme,
    TextTheme textTheme,
    WidgetRef ref,
  ) {
    final adminFeesAsync = ref.watch(activeAdminFeesProvider);

    return adminFeesAsync.when(
      data: (fees) {
        // Filter: hanya tampilkan yang sales_channel = 'Online' untuk kategori online
        final onlineFees = fees
            .where((fee) => fee.salesChannel == 'Online')
            .toList();

        if (onlineFees.isEmpty) {
          return Card(
            elevation: 1,
            color: Colors.orange.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_outlined,
                    color: Colors.orange.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Belum ada marketplace',
                          style: textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tambahkan marketplace di menu Integrasi > Fees Admin',
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.orange.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.store_outlined,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pilih Marketplace',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedMarketplaceId,
                  hint: Text(
                    'Pilih marketplace...',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  items: onlineFees.map((fee) {
                    return DropdownMenuItem<String>(
                      value: fee.id,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                CHANNEL_DISPLAY_WITH_ICON[fee.salesChannel]
                                        ?.split(' ')
                                        .first ??
                                    '📱',
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                fee.salesChannel,
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${fee.feePercent}%',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMarketplaceId = value;
                      _selectedMarketplace = onlineFees.firstWhere(
                        (fee) => fee.id == value,
                      );
                    });
                  },
                ),
                if (_selectedMarketplace != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.percent,
                                  size: 16,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Biaya Admin',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${_selectedMarketplace!.feePercent}%',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.payments_outlined,
                                  size: 16,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Potongan Proses',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              _currencyFormat.format(
                                _selectedMarketplace!.processingFee,
                              ),
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text('Memuat marketplace...', style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
      error: (error, stack) => Card(
        elevation: 1,
        color: Colors.red.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Error memuat marketplace',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      error.toString(),
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.red.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddProductCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () => _showProductPicker(colorScheme),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.15),
                ),
                child: Icon(
                  Icons.add_shopping_cart,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tambah Produk',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Pilih dari inventori',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsHeader(
    int count,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(Icons.shopping_bag, size: 14, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'Produk ($count)',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(
    int index,
    SaleItemModel item,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.3),
                    colorScheme.primary.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${item.quantity}x',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        _currencyFormat.format(item.sellingPrice),
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Total: ${_currencyFormat.format(item.subtotal)}',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Delete Button
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              onPressed: () {
                final currentItems = ref.read(currentSaleItemsProvider);
                final updatedItems = List<SaleItemModel>.from(currentItems)
                  ..removeAt(index);
                ref.read(currentSaleItemsProvider.notifier).state =
                    updatedItems;
              },
              tooltip: 'Hapus',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminFeeInfo(
    WidgetRef ref,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final adminFeesAsync = ref.watch(activeAdminFeesProvider);

    return adminFeesAsync.when(
      data: (fees) {
        if (fees.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_outlined,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Biaya Admin',
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      Text(
                        'Belum ada data dari integrasi',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.orange.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final activeFees = fees.where((f) => f.isActive).toList();
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withValues(alpha: 0.1),
                Colors.blue.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Biaya Admin (dari Integrasi)',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...activeFees.map(
                (fee) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.2),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          fee.salesChannel,
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${fee.feePercent}%',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (fee.processingFee > 0)
                              Text(
                                '+ ${_currencyFormat.format(fee.processingFee)}',
                                style: textTheme.labelSmall?.copyWith(
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [CircularProgressIndicator()],
            ),
          ),
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Gagal memuat biaya admin',
          style: textTheme.labelSmall?.copyWith(color: Colors.red.shade700),
        ),
      ),
    );
  }

  Widget _buildNotesCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        maxLines: 3,
        decoration: InputDecoration(
          labelText: 'Catatan (Opsional)',
          hintText: 'Tambahkan catatan penjualan...',
          labelStyle: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          contentPadding: const EdgeInsets.all(14),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Icon(Icons.note_outlined, color: colorScheme.primary),
          ),
        ),
        onChanged: (value) => setState(() => _notes = value),
      ),
    );
  }

  Widget _buildModernSummary(
    double totalRevenue,
    double totalCost,
    double totalProfit,
    ColorScheme colorScheme,
    TextTheme textTheme,
    double adminFeePercent,
    double processingFeeAmount,
  ) {
    // Calculate admin fee and processing fee if online
    double adminFeeAmount = 0;

    if (_category == 'online') {
      // Use actual fee percentage from database
      adminFeeAmount = totalRevenue * (adminFeePercent / 100);
    }

    final finalProfit = _category == 'online'
        ? totalProfit - adminFeeAmount - processingFeeAmount
        : totalProfit;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.15),
            colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Ringkasan Penjualan',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Revenue Section
          _buildModernSummaryRow(
            label: 'Total Penjualan',
            value: _currencyFormat.format(totalRevenue),
            textTheme: textTheme,
            icon: Icons.shopping_cart_outlined,
            color: Colors.blue,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),

          // Cost Section
          _buildModernSummaryRow(
            label: 'Total Modal',
            value: _currencyFormat.format(totalCost),
            textTheme: textTheme,
            icon: Icons.local_offer_outlined,
            color: Colors.orange,
            colorScheme: colorScheme,
          ),

          if (_category == 'online') ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Admin Fee Percent
            _buildModernSummaryRow(
              label: adminFeePercent > 0
                  ? 'Biaya Admin (${adminFeePercent.toStringAsFixed(1)}%)'
                  : 'Biaya Admin (Tidak ada)',
              value: '- ${_currencyFormat.format(adminFeeAmount)}',
              textTheme: textTheme,
              icon: Icons.attach_money,
              color: Colors.red,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),

            // Processing Fee
            _buildModernSummaryRow(
              label: 'Potongan Proses',
              value: '- ${_currencyFormat.format(processingFeeAmount)}',
              textTheme: textTheme,
              icon: Icons.payments_outlined,
              color: Colors.red,
              colorScheme: colorScheme,
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Final Profit
          _buildModernSummaryRow(
            label: _category == 'online'
                ? 'Laba Bersih (Setelah Potongan)'
                : 'Laba Bersih',
            value: _currencyFormat.format(
              _category == 'online' ? finalProfit : totalProfit,
            ),
            textTheme: textTheme,
            icon: Icons.trending_up,
            color: Colors.green,
            colorScheme: colorScheme,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildModernSummaryRow({
    required String label,
    required String value,
    required TextTheme textTheme,
    required IconData icon,
    required Color color,
    required ColorScheme colorScheme,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: isBold
                ? textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  )
                : textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
          ),
        ),
        Text(
          value,
          style: isBold
              ? textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                )
              : textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(
    bool isDisabled,
    AsyncValue<void> recordingState,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isDisabled ? null : () => _recordSale(ref),
        icon: recordingState.isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.onPrimary,
                  ),
                ),
              )
            : const Icon(Icons.check_circle_outline),
        label: Text(
          recordingState.isLoading ? 'Menyimpan...' : 'Simpan Penjualan',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: recordingState.isLoading ? 2 : 8,
          shadowColor: colorScheme.primary.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  void _showProductPicker(ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ProductPickerSheet(
        colorScheme: colorScheme,
        onProductSelected: _addProductToSale,
      ),
    );
  }

  void _addProductToSale({
    required String productId,
    required String productName,
    required String sku,
    required double sellingPrice,
    required double costPrice,
    required int quantity,
  }) {
    final subtotal = sellingPrice * quantity;
    final profit = (sellingPrice - costPrice) * quantity;

    final newItem = SaleItemModel(
      productId: productId,
      productName: productName,
      sku: sku,
      quantity: quantity,
      sellingPrice: sellingPrice,
      costPrice: costPrice,
      subtotal: subtotal,
      profit: profit,
    );

    ref.read(currentSaleItemsProvider.notifier).state = [
      ...ref.read(currentSaleItemsProvider),
      newItem,
    ];

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$productName ditambahkan ke penjualan')),
    );
  }

  Future<void> _recordSale(WidgetRef ref) async {
    final items = ref.read(currentSaleItemsProvider);
    if (items.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tambahkan minimal 1 produk'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Langsung gunakan channel dari admin_fees (tanpa mapping!)
    String channel = CHANNEL_OFFLINE; // Default offline
    double adminFeePercent = 0;
    double processingFee = 0;
    double totalAdminFee = 0;

    if (_category == 'online') {
      // Validasi: harus pilih marketplace dulu
      if (_selectedMarketplace == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pilih marketplace terlebih dahulu'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      try {
        // Gunakan data dari marketplace yang dipilih user
        adminFeePercent = _selectedMarketplace!.feePercent;
        processingFee = _selectedMarketplace!.processingFee;

        // Hitung total admin fee = (revenue * percent / 100) + processing fee
        final totalRevenue = items.fold<double>(
          0,
          (sum, item) => sum + (item.sellingPrice * item.quantity),
        );

        totalAdminFee = (totalRevenue * adminFeePercent / 100) + processingFee;

        // LANGSUNG gunakan sales_channel dari admin_fees, TANPA mapping!
        // Database sudah pakai tabel lookup yang sama
        channel = _selectedMarketplace!.salesChannel;

        debugPrint('📱 Online Sale Selected:');
        debugPrint('   Marketplace: ${_selectedMarketplace!.salesChannel}');
        debugPrint('   Channel (to DB): $channel');
        debugPrint('   Fee: $adminFeePercent%');
        debugPrint('   Processing: ${_currencyFormat.format(processingFee)}');
        debugPrint(
          '   Total Admin Fee: ${_currencyFormat.format(totalAdminFee)}',
        );
      } catch (e) {
        debugPrint('⚠️ Error preparing online sale: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    } else {
      debugPrint('🏪 Offline Sale');
    }

    try {
      debugPrint(
        '🔍 Starting sale record - Category: $_category, Channel: $channel',
      );
      debugPrint('🔍 Items count: ${items.length}');
      debugPrint('🔍 Admin fee: $totalAdminFee');

      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Text('Menyimpan penjualan...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );
      }

      // Call repository and wait
      debugPrint('🔍 Final values before recordSale:');
      debugPrint('   saleType: $_category');
      debugPrint('   channel: $channel');
      debugPrint('   adminFee: $totalAdminFee');

      await ref
          .read(recordingSaleProvider.notifier)
          .recordSale(
            saleType: _category,
            channel: channel,
            items: items,
            adminFee: totalAdminFee,
            notes: _notes,
          );

      // Check provider state for errors
      final providerState = ref.read(recordingSaleProvider);

      if (mounted) {
        // Hide loading
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Check if there was an error
        providerState.when(
          data: (_) {
            debugPrint('✅ Sale recorded successfully');

            // FORCE REFRESH LIST SALES untuk hari ini
            final _ = ref.refresh(salesByDateProvider(DateTime.now()));

            // Clear form
            ref.read(currentSaleItemsProvider.notifier).state = [];
            setState(() {
              _category = 'offline';
              _selectedMarketplaceId = null;
              _selectedMarketplace = null;
              _notes = '';
            });

            // Show success & close
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('✅ Penjualan berhasil disimpan'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            context.pop();

            // Update inventory di background (tidak block UI)
            Future.delayed(Duration.zero, () async {
              try {
                final repository = ref.read(inventoryRepositoryProvider);
                for (final item in items) {
                  try {
                    final product = await repository.getItemById(
                      item.productId,
                    );
                    if (product != null && product.variants.isNotEmpty) {
                      final variant = product.variants.first;
                      final newStock = (variant.stockQuantity - item.quantity)
                          .clamp(0, double.infinity)
                          .toInt();
                      final updatedVariant = variant.copyWith(
                        stockQuantity: newStock,
                      );
                      await repository.updateVariant(variant: updatedVariant);
                      debugPrint(
                        '📦 Stock updated: ${item.productName} → $newStock',
                      );
                    }
                  } catch (e) {
                    debugPrint(
                      '⚠️ Error updating stock for ${item.productName}: $e',
                    );
                  }
                }
              } catch (e) {
                debugPrint('⚠️ Error in inventory deduction: $e');
              }
            });
          },
          loading: () {
            // Still loading, shouldn't happen
            debugPrint('⚠️ Still loading after await');
          },
          error: (error, stack) {
            debugPrint('❌ Error from provider: $error');
            debugPrint('Stack trace: $stack');

            // Show error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text('Gagal menyimpan: ${error.toString()}'),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          },
        );
      }
    } catch (e, stack) {
      debugPrint('❌ Exception in _recordSale: $e');
      debugPrint('Stack trace: $stack');

      if (mounted) {
        // Hide loading
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(child: Text('Gagal menyimpan: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}

// Product picker sheet for selecting products from inventory
class _ProductPickerSheet extends ConsumerStatefulWidget {
  final ColorScheme colorScheme;
  final Function({
    required String productId,
    required String productName,
    required String sku,
    required double sellingPrice,
    required double costPrice,
    required int quantity,
  })
  onProductSelected;

  const _ProductPickerSheet({
    required this.colorScheme,
    required this.onProductSelected,
  });

  @override
  ConsumerState<_ProductPickerSheet> createState() =>
      _ProductPickerSheetState();
}

class _ProductPickerSheetState extends ConsumerState<_ProductPickerSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Produk',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Search field
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari produk atau SKU...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Products list
              Expanded(
                child: ref
                    .watch(_inventoryProductsProvider)
                    .when(
                      data: (products) {
                        final filteredProducts = _searchQuery.isEmpty
                            ? products
                            : products
                                  .where(
                                    (p) =>
                                        p.title.toLowerCase().contains(
                                          _searchQuery.toLowerCase(),
                                        ) ||
                                        p.sku.toLowerCase().contains(
                                          _searchQuery.toLowerCase(),
                                        ),
                                  )
                                  .toList();

                        if (filteredProducts.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isEmpty
                                      ? 'Tidak ada produk'
                                      : 'Produk tidak ditemukan',
                                  style: textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: filteredProducts.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            // Get the first active variant or the first variant
                            final variant = product.variants.isNotEmpty
                                ? product.variants.first
                                : null;

                            if (variant == null) {
                              return const SizedBox.shrink();
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: GestureDetector(
                                onTap: () => _showQuantityDialog(
                                  product.title,
                                  product.id,
                                  product.sku,
                                  variant.sellingPrice,
                                  variant.initialPrice,
                                  currencyFormat,
                                ),
                                child: Card(
                                  elevation: 0,
                                  color: widget.colorScheme.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: widget.colorScheme.outline
                                          .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.title,
                                                    style: textTheme.titleSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'SKU: ${product.sku}',
                                                    style: textTheme.bodySmall
                                                        ?.copyWith(
                                                          color: Colors.grey,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Chip(
                                              label: Text(
                                                '${variant.stockQuantity} pcs',
                                              ),
                                              backgroundColor:
                                                  variant.stockQuantity > 0
                                                  ? widget
                                                        .colorScheme
                                                        .primaryContainer
                                                  : Colors.red.withValues(
                                                      alpha: 0.1,
                                                    ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Harga Jual',
                                                    style: textTheme.labelSmall,
                                                  ),
                                                  Text(
                                                    currencyFormat.format(
                                                      variant.sellingPrice,
                                                    ),
                                                    style: textTheme.titleSmall
                                                        ?.copyWith(
                                                          color: widget
                                                              .colorScheme
                                                              .primary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Harga Beli',
                                                    style: textTheme.labelSmall,
                                                  ),
                                                  Text(
                                                    currencyFormat.format(
                                                      variant.initialPrice,
                                                    ),
                                                    style: textTheme.titleSmall
                                                        ?.copyWith(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ],
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
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text('Error: $error', style: textTheme.bodyLarge),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                final _ = ref.refresh(
                                  _inventoryProductsProvider.future,
                                );
                                if (mounted) setState(() {});
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQuantityDialog(
    String productName,
    String productId,
    String sku,
    double sellingPrice,
    double costPrice,
    NumberFormat currencyFormat,
  ) {
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Jumlah - $productName'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'SKU: $sku',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Harga Jual: ${currencyFormat.format(sellingPrice)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: quantity > 1
                          ? () => setState(() => quantity--)
                          : null,
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: quantity.toString(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          final parsed = int.tryParse(value) ?? 1;
                          if (parsed > 0) setState(() => quantity = parsed);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => quantity++),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Total: ${currencyFormat.format(sellingPrice * quantity)}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onProductSelected(
                    productId: productId,
                    productName: productName,
                    sku: sku,
                    sellingPrice: sellingPrice,
                    costPrice: costPrice,
                    quantity: quantity,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Tambah'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Provider for inventory products
final _inventoryProductsProvider = FutureProvider((ref) {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getAllItems();
});
