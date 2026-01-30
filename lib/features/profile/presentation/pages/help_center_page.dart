import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  String _selectedCategory = 'faq';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pusat Bantuan'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
                  onChanged: (value) {
                    setState(() => _searchQuery = value.toLowerCase());
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari bantuan...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: -0.2, end: 0, duration: 300.ms),
            const SizedBox(height: 20),

            // Category tabs
            SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryTab('faq', 'FAQ', Icons.help_outline),
                      const SizedBox(width: 12),
                      _buildCategoryTab(
                        'tutorial',
                        'Tutorial',
                        Icons.school_outlined,
                      ),
                      const SizedBox(width: 12),
                      _buildCategoryTab(
                        'troubleshoot',
                        'Troubleshoot',
                        Icons.bug_report_outlined,
                      ),
                      const SizedBox(width: 12),
                      _buildCategoryTab(
                        'guide',
                        'Panduan',
                        Icons.help_center_outlined,
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 100.ms)
                .slideY(begin: -0.2, end: 0, duration: 400.ms),
            const SizedBox(height: 24),

            // Content based on category
            if (_selectedCategory == 'faq') _buildFAQSection(),
            if (_selectedCategory == 'tutorial') _buildTutorialSection(),
            if (_selectedCategory == 'troubleshoot')
              _buildTroubleshootSection(),
            if (_selectedCategory == 'guide') _buildGuideSection(),

            const SizedBox(height: 32),

            // Contact section
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
                              color: Colors.blue,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hubungi Admin',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tim kami siap membantu 24/7',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _launchEmail('agungcandra627@gmail.com'),
                            icon: const Icon(Icons.email),
                            label: const Text('Kirim Email ke Admin'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'agungcandra627@gmail.com',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 300.ms)
                .slideY(begin: 0.2, end: 0, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String category, String label, IconData icon) {
    final isSelected = _selectedCategory == category;

    return FilterChip(
      selected: isSelected,
      onSelected: (_) {
        setState(() => _selectedCategory = category);
      },
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: Colors.grey.shade100,
      selectedColor: Colors.blue.shade100,
      showCheckmark: false,
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = <Map<String, String>>[
      {
        'q': 'Bagaimana cara membuat akun baru?',
        'a':
            r'Untuk membuat akun, klik tombol "Daftar" di layar login, kemudian masukkan email dan password Anda. Verifikasi email Anda untuk menyelesaikan pendaftaran.',
      },
      {
        'q': 'Bagaimana cara mengubah password?',
        'a':
            'Buka Profil > Akun & Keamanan > Ubah Password. Masukkan password lama, password baru, dan konfirmasi password baru Anda.',
      },
      {
        'q': 'Apa itu Autentikasi 2FA?',
        'a':
            'Autentikasi 2FA (Two-Factor Authentication) adalah fitur keamanan tambahan yang memerlukan kode verifikasi saat login. Buka Akun & Keamanan untuk mengaktifkannya.',
      },
      {
        'q': 'Bagaimana cara menghubungkan marketplace?',
        'a':
            'Buka Integrasi di profil, pilih marketplace yang ingin dihubungkan, kemudian ikuti petunjuk untuk menyelesaikan proses autentikasi.',
      },
      {
        'q': 'Bagaimana cara export laporan penjualan?',
        'a':
            r'Di menu Laporan, pilih jenis laporan yang diinginkan, kemudian klik tombol "Export" untuk mengunduh dalam format PDF atau Excel.',
      },
    ];

    final filteredFaqs = faqs
        .where(
          (faq) =>
              faq['q']!.toLowerCase().contains(_searchQuery) ||
              faq['a']!.toLowerCase().contains(_searchQuery),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pertanyaan yang Sering Diajukan',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (filteredFaqs.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Tidak ada FAQ yang cocok',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredFaqs.length,
            itemBuilder: (context, index) {
              final faq = filteredFaqs[index];
              return _buildFAQItem(faq['q']!, faq['a']!, index)
                  .animate()
                  .fadeIn(duration: 300.ms, delay: (100 * index).ms)
                  .slideY(begin: 0.2, end: 0, duration: 300.ms);
            },
          ),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer, int index) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: const Text('Klik untuk melihat jawaban'),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(answer, style: const TextStyle(height: 1.6)),
        ),
      ],
    );
  }

  Widget _buildTutorialSection() {
    final tutorials = [
      {
        'title': 'Membuat Produk Baru',
        'description': 'Pelajari cara menambahkan produk ke inventori Anda',
        'icon': Icons.inventory,
      },
      {
        'title': 'Mengelola Pesanan',
        'description':
            'Lihat cara membuat, mengedit, dan menyelesaikan pesanan',
        'icon': Icons.shopping_cart,
      },
      {
        'title': 'Mengelola Stok',
        'description': 'Pelajari cara mengupdate dan melacak stok produk',
        'icon': Icons.warehouse,
      },
      {
        'title': 'Membuat Laporan Keuangan',
        'description': 'Pahami cara membuat dan menganalisis laporan keuangan',
        'icon': Icons.trending_up,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tutorial Video & Panduan',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tutorials.length,
          itemBuilder: (context, index) {
            final tutorial = tutorials[index];
            return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        tutorial['icon'] as IconData,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(tutorial['title'] as String),
                    subtitle: Text(tutorial['description'] as String),
                    trailing: const Icon(Icons.play_arrow),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Tutorial: ${tutorial['title']} - Coming Soon',
                          ),
                        ),
                      );
                    },
                  ),
                )
                .animate()
                .fadeIn(duration: 300.ms, delay: (100 * index).ms)
                .slideY(begin: 0.2, end: 0, duration: 300.ms);
          },
        ),
      ],
    );
  }

  Widget _buildTroubleshootSection() {
    final issues = [
      {
        'title': 'Lupa Password',
        'solution':
            r'Klik "Lupa Password" di layar login, masukkan email Anda, dan ikuti instruksi reset yang dikirim ke email.',
      },
      {
        'title': 'Tidak Bisa Login',
        'solution':
            'Pastikan email dan password sudah benar. Jika sudah benar namun tetap tidak bisa, coba clear cache browser atau gunakan browser lain.',
      },
      {
        'title': 'Data Tidak Tersimpan',
        'solution':
            'Pastikan koneksi internet stabil. Jika masalah tetap berlanjut, refresh halaman atau logout dan login kembali.',
      },
      {
        'title': 'Integrasi Marketplace Gagal',
        'solution':
            'Periksa bahwa API key dan kredensial sudah benar. Pastikan akun marketplace Anda aktif dan memiliki permission yang tepat.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Troubleshooting & Solusi',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: issues.length,
          itemBuilder: (context, index) {
            final issue = issues[index];
            return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.bug_report, color: Colors.orange),
                    ),
                    title: Text(
                      issue['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          issue['solution'] as String,
                          style: const TextStyle(height: 1.6),
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 300.ms, delay: (100 * index).ms)
                .slideY(begin: 0.2, end: 0, duration: 300.ms);
          },
        ),
      ],
    );
  }

  Widget _buildGuideSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Panduan Lengkap',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panduan Pengguna - Bisnisku Versi 1.0',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Panduan lengkap mencakup:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    _buildGuideItem('Memulai dengan Bisnisku'),
                    _buildGuideItem('Mengatur Profil & Preferensi'),
                    _buildGuideItem('Mengelola Inventori'),
                    _buildGuideItem('Proses Penjualan & Pesanan'),
                    _buildGuideItem('Laporan Keuangan & Analitik'),
                    _buildGuideItem('Integrasi Marketplace'),
                    _buildGuideItem('Manajemen HR & Payroll'),
                    _buildGuideItem('Keamanan & Privacy'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Download: Panduan Pengguna Bisnisku v1.0.pdf',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download Panduan PDF'),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms),
      ],
    );
  }

  Widget _buildGuideItem(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(item, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent('Bantuan Aplikasi Bisnisku')}',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tidak dapat membuka email client. Email: $email'),
            action: SnackBarAction(
              label: 'Salin',
              onPressed: () {
                // Copy email to clipboard would go here
              },
            ),
          ),
        );
      }
    }
  }
}
