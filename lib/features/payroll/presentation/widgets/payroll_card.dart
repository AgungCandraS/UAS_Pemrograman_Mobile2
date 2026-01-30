import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/payroll_model.dart';

class PayrollCard extends StatelessWidget {
  final PayrollRecord payroll;
  final String? employeeName;
  final VoidCallback? onApprove;
  final VoidCallback? onMarkPaid;
  final VoidCallback? onRefresh;

  const PayrollCard({
    super.key,
    required this.payroll,
    this.employeeName,
    this.onApprove,
    this.onMarkPaid,
    this.onRefresh,
  });

  Color _statusColor(ColorScheme colorScheme) {
    switch (payroll.status) {
      case 'approved':
        return const Color(0xFF2563EB); // Blue
      case 'paid':
        return const Color(0xFF059669); // Green
      default:
        return const Color(0xFFF59E0B); // Amber
    }
  }

  String _statusLabel() {
    switch (payroll.status) {
      case 'approved':
        return 'Disetujui';
      case 'paid':
        return 'Dibayar';
      default:
        return 'Menunggu';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final dateFmt = DateFormat('dd MMM yyyy');

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(colorScheme).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: _statusColor(colorScheme),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _statusLabel(),
                        style: textTheme.labelSmall?.copyWith(
                          color: _statusColor(colorScheme),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.refresh, color: colorScheme.primary),
                  onPressed: onRefresh,
                  tooltip: 'Hitung ulang',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              employeeName ?? payroll.employeeId,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${dateFmt.format(payroll.periodStart)} - ${dateFmt.format(payroll.periodEnd)}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: 'Gaji Pokok',
                    value: currency.format(payroll.baseSalary),
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    type: 'primary',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Metric(
                    label: 'Bonus',
                    value: currency.format(payroll.productionBonus),
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    type: 'success',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: 'Potongan',
                    value: currency.format(payroll.deductions),
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    type: 'error',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Metric(
                    label: 'Total Gaji',
                    value: currency.format(payroll.totalEarnings),
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    type: 'total',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (payroll.notes != null && payroll.notes!.isNotEmpty) ...[
              Text(
                payroll.notes!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (payroll.status == 'pending' && onApprove != null) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onApprove,
                  icon: const Icon(Icons.verified_outlined),
                  label: const Text('Setujui Penggajian'),
                ),
              ),
            ] else if (payroll.status == 'approved' && onMarkPaid != null) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onMarkPaid,
                  icon: const Icon(Icons.payments_outlined),
                  label: const Text('Tandai Sudah Dibayar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String type; // 'primary', 'success', 'error', 'total'

  const _Metric({
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
    required this.type,
  });

  Color _getColor() {
    switch (type) {
      case 'success':
        return const Color(0xFF10B981);
      case 'error':
        return const Color(0xFFEF4444);
      case 'total':
        return const Color(0xFF1E40AF);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
