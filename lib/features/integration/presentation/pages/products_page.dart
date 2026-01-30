import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bisnisku/features/integration/application/integration_providers.dart';
import 'package:bisnisku/features/integration/domain/product.dart';
import 'package:intl/intl.dart';

final _currencyFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(
      productsProvider((department: null, isActive: null)),
    );

    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Produk'),
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(
              productsProvider((department: null, isActive: null)),
            ),
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return _buildEmptyState(context);
          }

          // Group by product name
          final grouped = <String, List<Product>>{};
          for (final product in products) {
            if (!grouped.containsKey(product.name)) {
              grouped[product.name] = [];
            }
            grouped[product.name]!.add(product);
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final productName = grouped.keys.elementAt(index);
              final productVariants = grouped[productName]!;

              return _buildProductCard(
                productName,
                productVariants,
                context,
                ref,
              ).animate().slideX(begin: 0.1, duration: 300.ms);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: grouped.length,
          );
        },
        loading: () => const Center(
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Terjadi Kesalahan',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(
                  productsProvider((department: null, isActive: null)),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, ref),
        tooltip: 'Tambah Produk Baru',
        icon: const Icon(Icons.add_rounded),
        label: const Text('Produk Baru'),
      ).animate().scale(duration: 300.ms),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.inventory_2, size: 64, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum ada produk',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai dengan menambahkan produk baru',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    String productName,
    List<Product> variants,
    BuildContext context,
    WidgetRef ref,
  ) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor.withValues(alpha: 0.08), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan icon dan menu
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withValues(alpha: 0.2),
                        primaryColor.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.inventory_2, color: primaryColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                      ),
                      Text(
                        '${variants.length} departemen',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  onSelected: (value) {
                    if (value == 'add_department') {
                      _showAddDepartmentDialog(context, ref, productName);
                    } else if (value == 'delete') {
                      _deleteProductName(context, ref, productName);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'add_department',
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            size: 20,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 8),
                          const Text('Tambah Departemen'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Hapus Produk',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // List departemen
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: variants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final variant = variants[index];
                return _buildVariantRow(variant, context, ref).animate().slideY(
                  begin: 0.05,
                  duration: Duration(milliseconds: 200 + (index * 50)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantRow(
    Product product,
    BuildContext context,
    WidgetRef ref,
  ) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.7),
            Colors.grey[50]?.withValues(alpha: 0.7) ?? Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200] ?? Colors.grey, width: 1),
      ),
      child: Row(
        children: [
          // Department Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withValues(alpha: 0.15),
                  primaryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              _getDepartmentLabel(product.department).split(' ').last,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Price & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _currencyFormat.format(product.defaultRatePerPcs),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '/pcs',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (product.description != null &&
                    product.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      product.description!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),

          // Status & Menu
          if (product.isActive)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Aktif',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz, color: Colors.grey[600], size: 20),
            onSelected: (value) {
              if (value == 'edit') {
                _showEditDialog(context, ref, product);
              } else if (value == 'delete') {
                if (product.id != null) {
                  _deleteProduct(context, ref, product.id!);
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit_outlined, size: 18),
                    const SizedBox(width: 8),
                    const Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    const Text('Hapus', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    String name = '';
    String department = '';
    double rate = 0;
    String description = '';
    bool isActive = true;
    final suggestedDepartments = ['sablon', 'obras', 'jahit', 'packing'];

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Tambah Produk Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: Nama Produk
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Informasi Produk',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TextField(
                    onChanged: (val) => name = val,
                    decoration: InputDecoration(
                      labelText: 'Nama Produk',
                      hintText: 'Contoh: Belle, K5, K4, Kulot',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Section: Departemen & Harga
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Departemen & Harga',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Departemen dengan autocomplete
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        onChanged: (val) => department = val,
                        decoration: InputDecoration(
                          labelText: 'Departemen',
                          hintText: 'Contoh: Sablon, Obras, Jahit, Packing',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          suffixIcon: department.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    setState(() => department = '');
                                  },
                                )
                              : null,
                        ),
                      ),
                      if (department.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            children: suggestedDepartments
                                .where(
                                  (d) => d.toLowerCase().contains(
                                    department.toLowerCase(),
                                  ),
                                )
                                .map(
                                  (d) => InkWell(
                                    onTap: () => setState(() => department = d),
                                    child: Chip(
                                      label: Text(d),
                                      backgroundColor: Colors.green.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Harga per PCS
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TextField(
                    onChanged: (val) => rate = double.tryParse(val) ?? 0,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Tarif per pcs (Rp)',
                      hintText: '500',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Text('Rp '),
                      ),
                      prefixIconConstraints: const BoxConstraints(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Section: Detail
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Detail Tambahan',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.purple.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TextField(
                    onChanged: (val) => description = val,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi (Opsional)',
                      hintText: 'Tambahkan catatan untuk produk ini',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Active Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Produk Aktif',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Switch(
                        value: isActive,
                        onChanged: (val) => setState(() => isActive = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                if (name.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Nama produk tidak boleh kosong'),
                    ),
                  );
                  return;
                }

                if (department.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Departemen tidak boleh kosong'),
                    ),
                  );
                  return;
                }

                if (rate <= 0) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Tarif per pcs harus lebih dari 0'),
                    ),
                  );
                  return;
                }

                try {
                  await ref.read(
                    upsertProductProvider(
                      Product(
                        id: null,
                        name: name,
                        department: department.toLowerCase().trim(),
                        defaultRatePerPcs: rate,
                        description: description.isEmpty ? null : description,
                        isActive: isActive,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                    ).future,
                  );

                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Produk berhasil ditambahkan'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) async {
    String name = product.name;
    String department = product.department;
    double rate = product.defaultRatePerPcs;
    String description = product.description ?? '';
    bool isActive = product.isActive;
    final suggestedDepartments = ['sablon', 'obras', 'jahit', 'packing'];

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: Nama Produk
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Informasi Produk',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TextField(
                    onChanged: (val) => name = val,
                    controller: TextEditingController(text: name),
                    decoration: InputDecoration(
                      labelText: 'Nama Produk',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Section: Departemen & Harga
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Departemen & Harga',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        onChanged: (val) => department = val,
                        controller: TextEditingController(text: department),
                        decoration: InputDecoration(
                          labelText: 'Departemen',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          suffixIcon: department.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    setState(() => department = '');
                                  },
                                )
                              : null,
                        ),
                      ),
                      if (department.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            children: suggestedDepartments
                                .where(
                                  (d) => d.toLowerCase().contains(
                                    department.toLowerCase(),
                                  ),
                                )
                                .map(
                                  (d) => InkWell(
                                    onTap: () => setState(() => department = d),
                                    child: Chip(
                                      label: Text(d),
                                      backgroundColor: Colors.green.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TextField(
                    onChanged: (val) => rate = double.tryParse(val) ?? 0,
                    controller: TextEditingController(
                      text: rate == 0 ? '' : rate.toStringAsFixed(0),
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Tarif per pcs (Rp)',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Text('Rp '),
                      ),
                      prefixIconConstraints: const BoxConstraints(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Section: Detail
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Detail Tambahan',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.purple.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TextField(
                    onChanged: (val) => description = val,
                    controller: TextEditingController(text: description),
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Produk Aktif',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Switch(
                        value: isActive,
                        onChanged: (val) => setState(() => isActive = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await ref.read(
                    upsertProductProvider(
                      Product(
                        id: product.id,
                        name: name,
                        department: department.toLowerCase().trim(),
                        defaultRatePerPcs: rate,
                        description: description.isEmpty ? null : description,
                        isActive: isActive,
                        createdAt: product.createdAt,
                        updatedAt: DateTime.now(),
                      ),
                    ).future,
                  );

                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Produk berhasil diperbarui'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddDepartmentDialog(
    BuildContext context,
    WidgetRef ref,
    String productName,
  ) async {
    String department = '';
    double rate = 0;
    String description = '';
    final suggestedDepartments = ['sablon', 'obras', 'jahit', 'packing'];

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Tambah Departemen - $productName'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Departemen & Harga',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        onChanged: (val) => department = val,
                        decoration: InputDecoration(
                          labelText: 'Departemen',
                          hintText: 'Contoh: Sablon, Obras, Jahit, Packing',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          suffixIcon: department.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    setState(() => department = '');
                                  },
                                )
                              : null,
                        ),
                      ),
                      if (department.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            children: suggestedDepartments
                                .where(
                                  (d) => d.toLowerCase().contains(
                                    department.toLowerCase(),
                                  ),
                                )
                                .map(
                                  (d) => InkWell(
                                    onTap: () => setState(() => department = d),
                                    child: Chip(
                                      label: Text(d),
                                      backgroundColor: Colors.green.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TextField(
                    onChanged: (val) => rate = double.tryParse(val) ?? 0,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Tarif per pcs (Rp)',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Text('Rp '),
                      ),
                      prefixIconConstraints: const BoxConstraints(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Detail Tambahan',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.purple.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TextField(
                    onChanged: (val) => description = val,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi (Opsional)',
                      hintText: 'Tambahkan catatan untuk departemen ini',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                if (department.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Departemen tidak boleh kosong'),
                    ),
                  );
                  return;
                }

                if (rate <= 0) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Tarif per pcs harus lebih dari 0'),
                    ),
                  );
                  return;
                }

                try {
                  await ref.read(
                    upsertProductProvider(
                      Product(
                        id: null,
                        name: productName,
                        department: department.toLowerCase().trim(),
                        defaultRatePerPcs: rate,
                        description: description.isEmpty ? null : description,
                        isActive: true,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                    ).future,
                  );

                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Departemen berhasil ditambahkan'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  String _getDepartmentLabel(String dept) {
    return switch (dept) {
      'sablon' => '🖨️ Sablon',
      'obras' => '✂️ Obras',
      'jahit' => '🧵 Jahit',
      'packing' => '📦 Packing',
      _ => dept,
    };
  }

  Future<void> _deleteProduct(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk?'),
        content: const Text('Produk ini akan dihapus. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(deleteProductProvider(id).future);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Produk berhasil dihapus')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _deleteProductName(
    BuildContext context,
    WidgetRef ref,
    String productName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Departemen?'),
        content: Text(
          'Semua departemen dari produk "$productName" akan dihapus. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Ambil semua produk dengan nama ini dan hapus
    final productsAsync = await ref.read(
      productsProvider((department: null, isActive: null)).future,
    );

    final productsToDelete = productsAsync
        .where((p) => p.name == productName)
        .toList();

    try {
      for (final product in productsToDelete) {
        if (product.id != null) {
          await ref.read(deleteProductProvider(product.id!).future);
        }
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Produk berhasil dihapus')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}
