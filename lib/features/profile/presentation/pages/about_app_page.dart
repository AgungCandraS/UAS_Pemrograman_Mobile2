import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

/// Halaman Tentang Aplikasi dengan informasi lengkap
class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi'), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with app icon and name
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.7),
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.business_center,
                      size: 56,
                      color: Colors.blue,
                    ),
                  ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bisnisku',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 8),
                  const Text(
                    'Versi 1.0.0',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ).animate().fadeIn(delay: 300.ms),
                ],
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  _buildSection(
                    context,
                    icon: Icons.info_outline,
                    title: 'Tentang Bisnisku',
                    content:
                        'Bisnisku adalah aplikasi manajemen bisnis terpadu '
                        'yang dirancang untuk membantu UMKM dan perusahaan kecil '
                        'mengelola seluruh aspek bisnis mereka dengan mudah dan efisien.',
                  ),

                  const SizedBox(height: 24),

                  // Features
                  _buildSection(
                    context,
                    icon: Icons.star_outline,
                    title: 'Fitur Utama',
                    content: '',
                    children: [
                      _buildFeatureItem(
                        Icons.dashboard_outlined,
                        'Dashboard',
                        'Pantau performa bisnis secara real-time',
                      ),
                      _buildFeatureItem(
                        Icons.inventory_2_outlined,
                        'Inventori',
                        'Kelola stok barang dan produk',
                      ),
                      _buildFeatureItem(
                        Icons.shopping_cart_outlined,
                        'Penjualan',
                        'Transaksi penjualan online & offline',
                      ),
                      _buildFeatureItem(
                        Icons.account_balance_wallet_outlined,
                        'Keuangan',
                        'Kelola transaksi keuangan',
                      ),
                      _buildFeatureItem(
                        Icons.people_outline,
                        'Karyawan',
                        'Manajemen data karyawan',
                      ),
                      _buildFeatureItem(
                        Icons.payment_outlined,
                        'Payroll',
                        'Sistem penggajian karyawan',
                      ),
                      _buildFeatureItem(
                        Icons.factory_outlined,
                        'Produksi',
                        'Kelola proses produksi barang',
                      ),
                      _buildFeatureItem(
                        Icons.sync_alt_outlined,
                        'Integrasi',
                        'Sinkronisasi dengan platform lain',
                      ),
                      _buildFeatureItem(
                        Icons.assessment_outlined,
                        'Laporan',
                        'Laporan lengkap per modul',
                      ),
                      _buildFeatureItem(
                        Icons.analytics_outlined,
                        'Analitik',
                        'Analisis mendalam bisnis Anda',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Technology Stack
                  _buildSection(
                    context,
                    icon: Icons.code_outlined,
                    title: 'Teknologi',
                    content: '',
                    children: [
                      _buildTechItem('Flutter', 'Framework UI cross-platform'),
                      _buildTechItem('Supabase', 'Backend & Database'),
                      _buildTechItem('Riverpod', 'State management'),
                      _buildTechItem('Clean Architecture', 'Code structure'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Contact & Support
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.contact_support,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Hubungi Kami',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildContactItem(
                            context,
                            icon: Icons.email_outlined,
                            title: 'Email Support',
                            subtitle: 'agungcandra627@gmail.com',
                            onTap: () =>
                                _launchEmail('agungcandra627@gmail.com'),
                          ),
                          const Divider(height: 24),
                          _buildContactItem(
                            context,
                            icon: Icons.bug_report_outlined,
                            title: 'Laporkan Bug',
                            subtitle: 'Bantu kami tingkatkan aplikasi',
                            onTap: () => _launchEmail(
                              'agungcandra627@gmail.com',
                              subject: 'Bug Report - Bisnisku',
                            ),
                          ),
                          const Divider(height: 24),
                          _buildContactItem(
                            context,
                            icon: Icons.lightbulb_outline,
                            title: 'Saran & Masukan',
                            subtitle: 'Berikan feedback Anda',
                            onTap: () => _launchEmail(
                              'agungcandra627@gmail.com',
                              subject: 'Feedback - Bisnisku',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 24),

                  // Copyright
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '© ${DateTime.now().year} Bisnisku',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dibuat dengan ❤️ untuk UMKM Indonesia',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    List<Widget>? children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (content.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
              ),
            ],
            if (children != null) ...[const SizedBox(height: 12), ...children],
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(String name, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                children: [
                  TextSpan(
                    text: '$name: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: description,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email, {String? subject}) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: subject != null ? 'subject=${Uri.encodeComponent(subject)}' : null,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
}
