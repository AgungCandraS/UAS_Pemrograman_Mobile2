import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:bisnisku/features/integration/application/integration_providers.dart';
import 'package:bisnisku/features/integration/domain/admin_fee.dart';

final _currencyFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

class AdminFeesPage extends ConsumerWidget {
  const AdminFeesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feesAsync = ref.watch(allAdminFeesProvider);
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fees Admin'),
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(allAdminFeesProvider),
          ),
        ],
      ),
      body: feesAsync.when(
        data: (fees) {
          if (fees.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final fee = fees[index];
              return _buildFeeCard(
                fee,
                context,
                ref,
                primaryColor,
              ).animate().slideX(begin: 0.1, duration: 300.ms);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: fees.length,
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
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(allAdminFeesProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        tooltip: 'Tambah Fees Admin',
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
            'Belum ada fees admin',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan fees admin untuk setiap sales channel',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildFeeCard(
    AdminFee fee,
    BuildContext context,
    WidgetRef ref,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan channel name dan status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fee.salesChannel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (fee.notes != null && fee.notes!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          fee.notes!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditDialog(context, ref, fee);
                  } else if (value == 'delete') {
                    _showDeleteDialog(context, ref, fee);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20, color: primaryColor),
                        const SizedBox(width: 8),
                        const Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: const Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Fee details
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Persen Admin',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${fee.feePercent.toStringAsFixed(2)}%',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Biaya Pemrosesan',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currencyFormat.format(fee.processingFee),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Active status toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Channel Aktif',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Switch(
                  value: fee.isActive,
                  onChanged: (value) {
                    if (fee.id != null) {
                      ref.read(toggleAdminFeeActiveProvider((fee.id!, value)));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    String selectedChannel = '';
    double feePercent = 0;
    double processingFee = 0;
    String notes = '';
    bool isActive = true;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          final salesChannels = ref.watch(salesChannelsProvider);
          final defaultFeePercent = selectedChannel.isNotEmpty
              ? ref.watch(defaultFeePercentProvider(selectedChannel))
              : 0.0;
          final defaultProcessingFee = selectedChannel.isNotEmpty
              ? ref.watch(defaultProcessingFeeProvider(selectedChannel))
              : 0.0;

          return AlertDialog(
            title: const Text('Tambah Fees Admin'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sales Channel Selection
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Pilih Sales Channel',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton<String>(
                          isExpanded: true,
                          value: selectedChannel.isEmpty
                              ? null
                              : selectedChannel,
                          hint: const Text('Pilih channel...'),
                          items: salesChannels
                              .map(
                                (channel) => DropdownMenuItem(
                                  value: channel,
                                  child: Text(channel),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedChannel = value;
                                // Auto-fill default values
                                feePercent = ref.read(
                                  defaultFeePercentProvider(value),
                                );
                                processingFee = ref.read(
                                  defaultProcessingFeeProvider(value),
                                );
                              });
                            }
                          },
                          underline: const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fee Percent
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Pengaturan Biaya',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          onChanged: (val) =>
                              feePercent = double.tryParse(val) ?? 0,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Persen Admin Fee (%)',
                            hintText: defaultFeePercent.toStringAsFixed(2),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            labelStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                          controller: TextEditingController(
                            text: feePercent > 0 ? feePercent.toString() : '',
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (defaultFeePercent > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Default: ${defaultFeePercent.toStringAsFixed(2)}%',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: Colors.orange[700]),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Processing Fee
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
                          onChanged: (val) =>
                              processingFee = double.tryParse(val) ?? 0,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Biaya Pemrosesan (Rp) - Fixed',
                            hintText: defaultProcessingFee.toStringAsFixed(0),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            labelStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Text('Rp '),
                            ),
                            prefixIconConstraints: const BoxConstraints(),
                          ),
                          controller: TextEditingController(
                            text: processingFee > 0
                                ? processingFee.toStringAsFixed(0)
                                : '',
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (defaultProcessingFee > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Default: Rp ${defaultProcessingFee.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: Colors.green[700]),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notes & Status
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
                      onChanged: (val) => notes = val,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Catatan (Opsional)',
                        hintText: 'Contoh: Default marketplace fee',
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
                          'Channel Aktif',
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
                  if (selectedChannel.isEmpty) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                        content: Text('Pilih sales channel terlebih dahulu'),
                      ),
                    );
                    return;
                  }

                  try {
                    await ref.read(
                      upsertAdminFeeProvider(
                        AdminFee(
                          id: null,
                          salesChannel: selectedChannel,
                          feePercent: feePercent,
                          processingFee: processingFee,
                          isActive: isActive,
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
                        content: Text('Fees admin berhasil ditambahkan'),
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
          );
        },
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    AdminFee fee,
  ) async {
    String selectedChannel = fee.salesChannel;
    double feePercent = fee.feePercent;
    double processingFee = fee.processingFee;
    String notes = fee.notes ?? '';
    bool isActive = fee.isActive;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Fees Admin'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Sales Channel',
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
                    child: Text(
                      selectedChannel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Pengaturan Biaya',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
                      onChanged: (val) =>
                          feePercent = double.tryParse(val) ?? 0,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Persen Admin Fee (%)',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                      controller: TextEditingController(
                        text: feePercent.toStringAsFixed(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.1),
                      ),
                    ),
                    child: TextField(
                      onChanged: (val) =>
                          processingFee = double.tryParse(val) ?? 0,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Biaya Pemrosesan (Rp) - Fixed',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Text('Rp '),
                        ),
                        prefixIconConstraints: const BoxConstraints(),
                      ),
                      controller: TextEditingController(
                        text: processingFee.toStringAsFixed(0),
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
                      onChanged: (val) => notes = val,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Catatan (Opsional)',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                      controller: TextEditingController(text: notes),
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
                          'Channel Aktif',
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
                      upsertAdminFeeProvider(
                        fee.copyWith(
                          salesChannel: selectedChannel,
                          feePercent: feePercent,
                          processingFee: processingFee,
                          isActive: isActive,
                          notes: notes.isEmpty ? null : notes,
                          updatedAt: DateTime.now(),
                        ),
                      ).future,
                    );

                    if (!dialogContext.mounted) return;
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fees admin berhasil diperbarui'),
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
          );
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    AdminFee fee,
  ) async {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Fees Admin'),
        content: Text(
          'Apakah Anda yakin ingin menghapus fees admin untuk "${fee.salesChannel}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await ref.read(deleteAdminFeeProvider(fee.id!).future);

                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fees admin berhasil dihapus'),
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
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
