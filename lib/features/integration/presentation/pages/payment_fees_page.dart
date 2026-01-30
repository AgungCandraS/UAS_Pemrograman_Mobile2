import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bisnisku/features/integration/application/integration_providers.dart';
import 'package:bisnisku/features/integration/domain/payment_fee.dart';

class PaymentFeesPage extends ConsumerWidget {
  const PaymentFeesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feesAsync = ref.watch(allPaymentFeesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Pembayaran'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(allPaymentFeesProvider),
          ),
        ],
      ),
      body: feesAsync.when(
        data: (fees) {
          if (fees.isEmpty) {
            return _buildEmptyState(context);
          }

          // Group by product
          final grouped = <String, List<PaymentFee>>{};
          for (final fee in fees) {
            if (!grouped.containsKey(fee.productName)) {
              grouped[fee.productName] = [];
            }
            grouped[fee.productName]!.add(fee);
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final productName = grouped.keys.elementAt(index);
              final productFees = grouped[productName]!;

              return _buildProductCard(
                productName,
                productFees,
                context,
                ref,
              ).animate().slideX(begin: 0.1, duration: 300.ms);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: grouped.length,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(allPaymentFeesProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        tooltip: 'Tambah Fee',
        child: const Icon(Icons.add),
      ).animate().scale(duration: 300.ms),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada fee pembayaran',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan fee pembayaran untuk setiap produk',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    String productName,
    List<PaymentFee> fees,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                  child: const Icon(Icons.shopping_bag, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...fees.map((fee) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fee.paymentType,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          if (fee.notes != null)
                            Text(
                              fee.notes!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${fee.feePercent.toStringAsFixed(2)}%',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Hapus'),
                          onTap: () {
                            if (fee.id != null) {
                              _deleteFee(context, ref, fee.id!);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    String? productName;
    String paymentType = 'marketplace';
    double feePercent = 0;
    String notes = '';

    final productsAsync = ref.read(
      productsProvider((department: null, isActive: true)).future,
    );

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => FutureBuilder(
          future: productsAsync,
          builder: (context, snapshot) {
            final products = snapshot.data ?? [];
            final productNames = products.map((p) => p.name).toSet().toList()
              ..sort();

            return AlertDialog(
              title: const Text('Tambah Fee Pembayaran'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String?>(
                      initialValue: productName,
                      items: productNames
                          .map(
                            (name) => DropdownMenuItem<String?>(
                              value: name,
                              child: Text(name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() => productName = val);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Produk',
                        hintText: 'Pilih Produk',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: paymentType,
                      items: ['marketplace', 'transfer', 'cod', 'cash']
                          .map(
                            (type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(_getPaymentTypeLabel(type)),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) paymentType = val;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tipe Pembayaran',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (val) =>
                          feePercent = double.tryParse(val) ?? 0,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Fee (%)',
                        hintText: '2.5',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (val) => notes = val,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Catatan (Opsional)',
                        border: OutlineInputBorder(),
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
                    if (productName == null || productName!.isEmpty) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text('Pilih produk')),
                      );
                      return;
                    }

                    try {
                      await ref.read(
                        upsertPaymentFeeProvider(
                          PaymentFee(
                            id: null,
                            productName: productName ?? '',
                            paymentType: paymentType,
                            feePercent: feePercent,
                            notes: notes.isEmpty ? null : notes,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                        ).future,
                      );

                      if (!dialogContext.mounted) return;
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fee berhasil ditambahkan'),
                        ),
                      );
                      if (!context.mounted) return;
                      // ignore: unused_result
                      ref.refresh(allPaymentFeesProvider);
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
            );
          },
        ),
      ),
    );
  }

  String _getPaymentTypeLabel(String type) {
    return switch (type) {
      'marketplace' => '🏪 Marketplace',
      'transfer' => '🏦 Transfer Bank',
      'cod' => '🚚 Cash on Delivery',
      'cash' => '💵 Tunai',
      _ => type,
    };
  }

  Future<void> _deleteFee(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Fee?'),
        content: const Text('Fee ini akan dihapus. Lanjutkan?'),
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
      await ref.read(deletePaymentFeeProvider(id).future);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fee berhasil dihapus')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}
