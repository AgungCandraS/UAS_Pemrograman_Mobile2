import 'package:bisnisku/features/profile/application/providers/profile_providers.dart';
import 'package:bisnisku/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:bisnisku/features/profile/presentation/pages/account_settings_page.dart';
import 'package:bisnisku/features/profile/presentation/pages/company_info_page.dart';
import 'package:bisnisku/features/profile/presentation/pages/preferences_page.dart';
import 'package:bisnisku/features/profile/presentation/pages/help_center_page.dart';
import 'package:bisnisku/features/profile/presentation/pages/about_app_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);

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
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              child: const Icon(Icons.person_outline, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Kelola akun dan preferensi',
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          const _ProfileBackground(),
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(currentUserProfileProvider);
              ref.invalidate(companyInfoProvider);
              ref.invalidate(profileSettingsProvider);
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
                        _ProfileHeader(userProfileAsync: userProfileAsync),
                        const SizedBox(height: 20),
                        _AccountSection(),
                        const SizedBox(height: 12),
                        _SupportSection(),
                        const SizedBox(height: 12),
                        _DangerZoneSection(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Profile background with gradient
class _ProfileBackground extends StatelessWidget {
  const _ProfileBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade400,
            Colors.cyan.shade300,
          ],
        ),
      ),
    );
  }
}

/// Profile header with avatar and info
class _ProfileHeader extends ConsumerWidget {
  final AsyncValue userProfileAsync;

  const _ProfileHeader({required this.userProfileAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return userProfileAsync.when(
      data: (profile) =>
          Card(
                elevation: 8,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildAvatar(profile.avatarUrl),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.fullName ?? 'Pengguna',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile.email,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (profile.companyName != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.business,
                                        size: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        profile.companyName!,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditProfilePage(userProfile: profile),
                              ),
                            ).then((_) {
                              ref.invalidate(currentUserProfileProvider);
                            });
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Profil'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms),
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.cyan.shade300],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: avatarUrl != null && avatarUrl.isNotEmpty
          ? ClipOval(
              child: Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, size: 40, color: Colors.white),
              ),
            )
          : const Icon(Icons.person, size: 40, color: Colors.white),
    );
  }
}

/// Account section
class _AccountSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildMenuItem(
                context,
                icon: Icons.verified_user_outlined,
                iconColor: Colors.blue,
                title: 'Akun & Keamanan',
                subtitle: 'Password, autentikasi, dan keamanan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AccountSettingsPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                context,
                icon: Icons.apartment_outlined,
                iconColor: Colors.green,
                title: 'Info Perusahaan',
                subtitle: 'Legal name, NPWP, alamat',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CompanyInfoPage()),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                context,
                icon: Icons.settings_outlined,
                iconColor: Colors.orange,
                title: 'Preferensi',
                subtitle: 'Bahasa, notifikasi, tema',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PreferencesPage()),
                  );
                },
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 100.ms)
        .slideY(begin: 0.2, end: 0, duration: 400.ms);
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 68, color: Colors.grey.shade200);
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
    );
  }
}

/// Support section
class _SupportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildMenuItem(
                context,
                icon: Icons.contact_support_outlined,
                iconColor: Colors.purple,
                title: 'Pusat Bantuan',
                subtitle: 'FAQ, tutorial, dan dukungan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpCenterPage()),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                context,
                icon: Icons.integration_instructions_outlined,
                iconColor: Colors.teal,
                title: 'Integrasi',
                subtitle: 'Marketplace, akunting, pembayaran',
                onTap: () {
                  context.push('/integration');
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                context,
                icon: Icons.info_outline,
                iconColor: Colors.indigo,
                title: 'Tentang Aplikasi',
                subtitle: 'Versi 1.0.0',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutAppPage()),
                  );
                },
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideY(begin: 0.2, end: 0, duration: 400.ms);
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 68, color: Colors.grey.shade200);
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
    );
  }
}

/// Danger zone section
class _DangerZoneSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
          elevation: 2,
          color: Colors.red.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            onTap: () => _showLogoutDialog(context, ref),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.logout, color: Colors.red, size: 24),
            ),
            title: const Text(
              'Keluar',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            subtitle: Text(
              'Sign out dari perangkat ini',
              style: TextStyle(color: Colors.red.shade700, fontSize: 13),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.red.shade300),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 300.ms)
        .slideY(begin: 0.2, end: 0, duration: 400.ms);
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              // Show loading indicator
              if (context.mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );
              }

              try {
                await Supabase.instance.client.auth.signOut();

                if (context.mounted) {
                  Navigator.of(context).pop(); // Close loading
                  context.go('/login'); // Redirect to login page
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.of(context).pop(); // Close loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal keluar: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
