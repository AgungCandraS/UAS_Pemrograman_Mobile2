import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReportsHubPage extends ConsumerWidget {
  const ReportsHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final reportTypes = [
      {
        'title': 'Laporan Keuangan',
        'subtitle': 'Pengelolaan cash flow dan transaksi',
        'icon': Icons.wallet,
        'color': Colors.blue.shade400,
        'route': '/reports/finance',
      },
      {
        'title': 'Laporan Penggajian',
        'subtitle': 'Data gaji dan kompensasi karyawan',
        'icon': Icons.person_4,
        'color': Colors.purple.shade400,
        'route': '/reports/payroll',
      },
      {
        'title': 'Laporan Produksi',
        'subtitle': 'Status dan progress produksi',
        'icon': Icons.production_quantity_limits,
        'color': Colors.orange.shade400,
        'route': '/reports/production',
      },
      {
        'title': 'Laporan Penjualan',
        'subtitle': 'Analisis penjualan, produk, keuntungan, dan margin laba',
        'icon': Icons.point_of_sale,
        'color': Colors.teal.shade400,
        'route': '/reports/sales',
      },
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.surface,
            title: Text(
              'Laporan',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Intro Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analisis Bisnis Komprehensif',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Buat laporan detail untuk menganalisis performa bisnis Anda',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Report Type Grid
                ...reportTypes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final report = entry.value;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == reportTypes.length - 1 ? 0 : 16,
                    ),
                    child: _ReportTypeCard(
                      title: report['title'] as String,
                      subtitle: report['subtitle'] as String,
                      icon: report['icon'] as IconData,
                      color: report['color'] as Color,
                      onTap: () {
                        context.push(report['route'] as String);
                      },
                    ),
                  );
                }),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ReportTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
