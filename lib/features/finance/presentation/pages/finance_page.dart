import 'dart:math';

import 'package:bisnisku/features/finance/application/finance_providers.dart';
import 'package:bisnisku/features/finance/domain/finance_models.dart';
import 'package:bisnisku/features/finance/data/finance_repository.dart';
import 'package:bisnisku/features/integration/application/integration_providers.dart';
import 'package:bisnisku/features/profile/application/providers/profile_providers.dart';
import 'package:bisnisku/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class FinancePage extends ConsumerWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme to rebuild when theme changes
    ref.watch(immediateThemeProvider);
    final brightness = Theme.of(context).brightness;

    final summary = ref.watch(financeSummaryProvider);
    final txAsync = ref.watch(filteredTransactionsProvider);
    final filter = ref.watch(financeFilterProvider);
    final daily = ref.watch(financeDailyPointsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.08),
              child: const Icon(Icons.account_circle_outlined),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keuangan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Ringkasan keuangan bulan ini',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_chart_outlined),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          const _FinanceBackground(),
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(financeTransactionsProvider);
              await Future<void>.delayed(const Duration(milliseconds: 300));
            },
            edgeOffset: kToolbarHeight + 16,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      kToolbarHeight + 12,
                      16,
                      16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SummaryCard(summary: summary),
                        const SizedBox(height: 12),
                        _ChartCard(points: daily),
                        const SizedBox(height: 12),
                        _FilterSegment(
                          current: filter,
                          onChanged: (f) =>
                              ref.read(financeFilterProvider.notifier).state =
                                  f,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: txAsync.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return const SliverToBoxAdapter(child: _EmptyState());
                      }
                      return SliverList.builder(
                        itemCount: min(items.length, 12),
                        itemBuilder: (context, index) {
                          final t = items[index];
                          return _TransactionTile(transaction: t)
                              .animate()
                              .fadeIn(delay: (80 * index).ms, duration: 320.ms)
                              .slideY(
                                begin: 0.08,
                                end: 0,
                                curve: Curves.easeOut,
                              );
                        },
                      );
                    },
                    loading: () => const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    error: (e, _) => SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e is AuthExpiredException
                                  ? 'Sesi masuk sudah kedaluwarsa.'
                                  : 'Terjadi kesalahan: $e',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              e is AuthExpiredException
                                  ? 'Silakan masuk kembali untuk melanjutkan.'
                                  : 'Tarik untuk menyegarkan atau coba lagi.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    ref.invalidate(financeTransactionsProvider);
                                  },
                                  child: const Text('Coba Lagi'),
                                ),
                                const SizedBox(width: 8),
                                if (e is AuthExpiredException)
                                  OutlinedButton(
                                    onPressed: () async {
                                      await SupabaseService.instance.signOut();
                                    },
                                    child: const Text('Masuk Ulang'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 12,
            child: _PrimaryButton(
              label: '+ Catatan Baru',
              onPressed: () => _showAddSheet(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceBackground extends StatelessWidget {
  const _FinanceBackground();
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.surfaceContainerHighest.withValues(alpha: 0.3),
            colors.surface,
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});
  final FinanceSummary? summary;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final income = summary?.income ?? 0;
    final expense = summary?.expense ?? 0;
    final profit = summary?.profit ?? 0;
    final balance = summary?.balance ?? 0;
    final balanceText = fmt.format(balance);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.withValues(alpha: 0.35),
            Colors.blueGrey.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 26,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      balanceText,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_outward, color: Colors.greenAccent),
                    const SizedBox(width: 6),
                    Text(
                      'Profit',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      fmt.format(profit),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatPill(
                label: 'Omzet',
                value: fmt.format(income),
                color: Colors.blueAccent,
              ),
              const SizedBox(width: 12),
              _StatPill(
                label: 'Pemasukan',
                value: fmt.format(income),
                color: Colors.greenAccent,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _StatPill(
                label: 'Pengeluaran',
                value: fmt.format(expense),
                color: Colors.redAccent,
              ),
              const SizedBox(width: 12),
              _StatPill(
                label: 'Profit',
                value: fmt.format(profit),
                color: scheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(label, style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.points});
  final List<FinanceDailyPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Text('Belum ada data grafik')),
      );
    }

    final maxY = points
        .map((e) => max(e.income, e.expense))
        .fold<double>(0, (p, e) => max(p, e))
        .clamp(0, double.infinity);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: SizedBox(
        height: 110,
        child: BarChart(
          BarChartData(
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(show: false),
            barGroups: [
              for (var i = 0; i < points.length; i++)
                BarChartGroupData(
                  x: i,
                  barsSpace: 2,
                  barRods: [
                    BarChartRodData(
                      toY: points[i].income,
                      width: 6,
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.greenAccent,
                    ),
                    BarChartRodData(
                      toY: points[i].expense,
                      width: 6,
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.redAccent,
                    ),
                  ],
                ),
            ],
            maxY: maxY == 0 ? 10 : maxY * 1.2,
          ),
          swapAnimationDuration: 400.ms,
          swapAnimationCurve: Curves.easeOut,
        ),
      ),
    );
  }
}

class _FilterSegment extends StatelessWidget {
  const _FilterSegment({required this.current, required this.onChanged});
  final FinanceFilter current;
  final ValueChanged<FinanceFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = FinanceFilter.values;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Row(
        children: [
          for (final option in options) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(option),
                child: AnimatedContainer(
                  duration: 200.ms,
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: current == option
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      _label(option),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: current == option
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (option != options.last) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }

  String _label(FinanceFilter f) {
    switch (f) {
      case FinanceFilter.income:
        return 'Pemasukan';
      case FinanceFilter.expense:
        return 'Pengeluaran';
      case FinanceFilter.all:
        return 'Semua';
    }
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});
  final FinanceTransaction transaction;

  Color get _color =>
      transaction.isIncome ? Colors.greenAccent : Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final brightness = Theme.of(context).brightness;

    final bgColor = brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.04);
    final borderColor = brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);
    final secondaryTextColor = brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    final tertiaryTextColor = brightness == Brightness.dark
        ? Colors.white60
        : Colors.black45;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.isIncome ? Icons.call_received : Icons.call_made,
              color: _color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        transaction.category,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _StatusBadge(status: transaction.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.note ?? transaction.description ?? '-',
                  style: textTheme.bodySmall?.copyWith(
                    color: secondaryTextColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      transaction.timeLabel,
                      style: textTheme.labelMedium?.copyWith(
                        color: tertiaryTextColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${transaction.isIncome ? '+' : '-'} ${transaction.formattedAmount}',
                      style: textTheme.labelLarge?.copyWith(
                        color: _color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final FinanceStatus status;

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String label;
    switch (status) {
      case FinanceStatus.tertunda:
        color = Colors.amber;
        label = 'Tertunda';
        break;
      case FinanceStatus.sebagian:
        color = Colors.orangeAccent;
        label = 'Sebagian';
        break;
      case FinanceStatus.selesai:
        color = Colors.greenAccent;
        label = 'Selesai';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 12,
        shadowColor: Colors.blueAccent.withValues(alpha: 0.35),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 36, color: Colors.white54),
          const SizedBox(height: 8),
          Text(
            'Belum ada transaksi',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Catat pemasukan atau pengeluaran pertama Anda.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

Future<void> _showAddSheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _NewTransactionSheet(),
  );
}

class _NewTransactionSheet extends ConsumerStatefulWidget {
  const _NewTransactionSheet();

  @override
  ConsumerState<_NewTransactionSheet> createState() =>
      _NewTransactionSheetState();
}

class _NewTransactionSheetState extends ConsumerState<_NewTransactionSheet> {
  String type = 'income';
  String? selectedCategory;
  String? selectedAccount;
  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  DateTime date = DateTime.now();
  bool saving = false;

  @override
  void dispose() {
    amountCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.74,
        minChildSize: 0.55,
        maxChildSize: 0.9,
        builder: (ctx, scroll) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0E1A2B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              controller: scroll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Catatan Baru',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _TypeChip(
                        label: 'Pemasukan',
                        selected: type == 'income',
                        onTap: () => setState(() => type = 'income'),
                      ),
                      const SizedBox(width: 8),
                      _TypeChip(
                        label: 'Pengeluaran',
                        selected: type == 'expense',
                        onTap: () => setState(() => type = 'expense'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _FieldLabel('Tanggal'),
                  _InputTile(
                    icon: Icons.event,
                    label: DateFormat('dd MMM yyyy').format(date),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => date = picked);
                    },
                  ),
                  _FieldLabel('Kategori'),
                  _CategoryDropdown(
                    type: type,
                    selectedCategory: selectedCategory,
                    onChanged: (value) =>
                        setState(() => selectedCategory = value),
                  ),
                  _FieldLabel('Nominal'),
                  _TextField(
                    controller: amountCtrl,
                    hint: 'Rp 0',
                    keyboardType: TextInputType.number,
                  ),
                  _FieldLabel('Akun (opsional)'),
                  _AccountDropdown(
                    selectedAccount: selectedAccount,
                    onChanged: (value) =>
                        setState(() => selectedAccount = value),
                  ),
                  _FieldLabel('Catatan'),
                  _TextField(
                    controller: noteCtrl,
                    hint: 'Tambahkan catatan...',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: saving ? null : _submit,
                      child: saving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Simpan'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    final amount = double.tryParse(
      amountCtrl.text.replaceAll('.', '').replaceAll(',', ''),
    );
    if (amount == null || amount <= 0 || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nominal dan pilih kategori yang valid'),
        ),
      );
      return;
    }
    setState(() => saving = true);
    try {
      await ref.read(
        addTransactionProvider(
          AddTransactionParams(
            type: type,
            category: selectedCategory!,
            amount: amount,
            note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
            account: selectedAccount,
            date: date,
          ),
        ).future,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } on AuthExpiredException catch (e) {
      if (!mounted) return;
      await SupabaseService.instance.signOut();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 10),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.06),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.04)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.blueAccent.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

class _InputTile extends StatelessWidget {
  const _InputTile({required this.icon, required this.label, this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? Colors.blueAccent.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? Colors.blueAccent.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.04),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// CATEGORY DROPDOWN WIDGET
// ==========================================
class _CategoryDropdown extends ConsumerWidget {
  const _CategoryDropdown({
    required this.type,
    required this.selectedCategory,
    required this.onChanged,
  });

  final String type;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(
      accountingCategoriesProvider(type == 'income' ? 'income' : 'expense'),
    );

    return categoriesAsync.when(
      data: (categories) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedCategory,
            hint: Text(
              'Pilih kategori...',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            underline: const SizedBox(),
            dropdownColor: const Color(0xFF0E1A2B),
            items: categories
                .map(
                  (cat) => DropdownMenuItem(
                    value: cat.name,
                    child: Text(
                      cat.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: const SizedBox(
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (err, _) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Text(
          'Error: ${err.toString()}',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.red[400]),
        ),
      ),
    );
  }
}

// ==========================================
// ACCOUNT DROPDOWN WIDGET
// ==========================================
class _AccountDropdown extends StatelessWidget {
  const _AccountDropdown({
    required this.selectedAccount,
    required this.onChanged,
  });

  final String? selectedAccount;
  final ValueChanged<String?> onChanged;

  static const List<String> accountOptions = [
    'Bank BCA',
    'Bank Mandiri',
    'Bank Transfer',
    'Dompet Digital',
    'Kas Kecil',
    'Custom Account',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedAccount,
        hint: Text(
          'Pilih akun... (opsional)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        underline: const SizedBox(),
        dropdownColor: const Color(0xFF0E1A2B),
        items: accountOptions
            .map(
              (account) => DropdownMenuItem(
                value: account,
                child: Text(
                  account,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
