import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/finance_providers.dart';
import '../../domain/finance_models.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(financeTransactionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keuangan'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Pemasukan'),
            Tab(text: 'Pengeluaran'),
            Tab(text: 'Semua'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          _LedgerList(txAsync: txAsync, filter: FinanceFilter.income),
          _LedgerList(txAsync: txAsync, filter: FinanceFilter.expense),
          _LedgerList(txAsync: txAsync, filter: FinanceFilter.all),
        ],
      ),
    );
  }
}

class _LedgerList extends StatelessWidget {
  const _LedgerList({required this.txAsync, required this.filter});
  final AsyncValue<List<FinanceTransaction>> txAsync;
  final FinanceFilter filter;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return txAsync.when(
      data: (items) {
        final filtered = switch (filter) {
          FinanceFilter.income => items.where((t) => t.isIncome).toList(),
          FinanceFilter.expense => items.where((t) => t.isExpense).toList(),
          _ => items,
        };
        if (filtered.isEmpty) {
          return const Center(child: Text('Belum ada data'));
        }
        final total = filtered.fold<double>(0, (p, e) => p + e.amount);
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          itemCount: filtered.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index == filtered.length) {
              return _TotalTile(label: 'Total', amount: fmt.format(total));
            }
            final t = filtered[index];
            return _LedgerTile(transaction: t)
                .animate()
                .fadeIn(duration: 300.ms, delay: (index * 40).ms)
                .slideY(begin: 0.05, end: 0, curve: Curves.easeOut);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _LedgerTile extends StatelessWidget {
  const _LedgerTile({required this.transaction});
  final FinanceTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final color = transaction.isIncome ? Colors.greenAccent : Colors.redAccent;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  transaction.isIncome ? Icons.call_received : Icons.call_made,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          transaction.timeLabel,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                        if (transaction.account != null) ...[
                          const SizedBox(width: 10),
                          Icon(
                            Icons.account_balance_wallet,
                            size: 14,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            transaction.account!,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: transaction.status),
            ],
          ),
          if ((transaction.note ?? transaction.description)?.isNotEmpty ??
              false) ...[
            const SizedBox(height: 6),
            Text(
              transaction.note ?? transaction.description ?? '',
              style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.isIncome ? 'Pemasukan' : 'Pengeluaran',
                style: textTheme.labelMedium?.copyWith(color: Colors.white70),
              ),
              Text(
                '${transaction.isIncome ? '+' : '-'} ${transaction.formattedAmount}',
                style: textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
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
    Color color;
    String label;
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
        ),
      ),
    );
  }
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({required this.label, required this.amount});
  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          Text(
            amount,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
