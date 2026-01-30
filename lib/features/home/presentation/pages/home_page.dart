import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:bisnisku/features/home/data/providers/home_provider.dart';
import 'package:bisnisku/features/home/domain/models/feature_menu.dart';
import 'package:bisnisku/features/home/presentation/widgets/status_card.dart';
import 'package:bisnisku/features/home/presentation/widgets/feature_card.dart';
import 'package:bisnisku/features/home/presentation/widgets/activity_item.dart';
import 'package:bisnisku/features/home/presentation/widgets/weather_widget.dart';
import 'package:bisnisku/features/home/presentation/widgets/alert_notification.dart';

/// Halaman Home - Dashboard utama aplikasi Bisnisku
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);
    final inventoryStatus = ref.watch(inventoryStatusProvider);
    final recentActivities = ref.watch(recentActivitiesProvider);
    final weatherInfo = ref.watch(weatherInfoProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final now = DateTime.now();
    final dayName = DateFormat('EEEE', 'id_ID').format(now);
    final dateFormatted = DateFormat('dd MMM yyyy', 'id_ID').format(now);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(inventoryStatusProvider);
            ref.invalidate(recentActivitiesProvider);
            ref.invalidate(weatherInfoProvider);
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: colorScheme.surface,
                elevation: 0,
                title: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E40AF), Color(0xFF6D28D9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF1E40AF,
                            ).withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.store_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Bisnisku',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),
              ),

              // Content
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Header - Greeting
                    _buildGreetingSection(
                      context,
                      userName,
                      dayName,
                      dateFormatted,
                    ),
                    const SizedBox(height: 20),

                    // Status Cards
                    _buildStatusSection(context, inventoryStatus),
                    const SizedBox(height: 20),

                    // Alert Notification
                    inventoryStatus.maybeWhen(
                      data: (status) {
                        if (status.menipis > 0 || status.habis > 0) {
                          return Column(
                            children: [
                              AlertNotification(
                                message:
                                    'Beberapa produk perlu restock, cek inventori Anda →',
                                icon: Icons.inventory_2_outlined,
                                color: const Color(0xFFF59E0B),
                                onTap: () => context.go('/inventory'),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      orElse: () => const SizedBox.shrink(),
                    ),

                    // Feature Menu Grid
                    _buildFeatureSection(context),
                    const SizedBox(height: 24),

                    // Recent Activities
                    _buildActivitiesSection(context, recentActivities),
                    const SizedBox(height: 20),

                    // Weather Info
                    weatherInfo.maybeWhen(
                      data: (weather) => Row(
                        children: [
                          const Icon(
                            Icons.cloud_outlined,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 8),
                          WeatherWidget(
                            temperature: weather.temperature,
                            condition: weather.condition,
                          ),
                        ],
                      ),
                      orElse: () => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection(
    BuildContext context,
    AsyncValue<String> userNameAsync,
    String dayName,
    String dateFormatted,
  ) {
    final userName = userNameAsync.maybeWhen(
      data: (name) => name,
      orElse: () => 'Pengguna',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat datang, $userName!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hari ini $dayName, $dateFormatted',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: 100.ms)
            .slideX(begin: -0.2, duration: 400.ms, delay: 100.ms),
      ],
    );
  }

  Widget _buildStatusSection(
    BuildContext context,
    AsyncValue<dynamic> inventoryStatus,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inventoryStatus.when(
          data: (status) => Row(
            children: [
              Expanded(
                child: StatusCard(
                  icon: Icons.check_circle_outline,
                  label: 'Stok Aman',
                  value: status.stokAman,
                  color: const Color(0xFF16A34A),
                  delay: 200,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatusCard(
                  icon: Icons.warning_amber_outlined,
                  label: 'Menipis',
                  value: status.menipis,
                  color: const Color(0xFFF59E0B),
                  delay: 280,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatusCard(
                  icon: Icons.cancel_outlined,
                  label: 'Habis',
                  value: status.habis,
                  color: const Color(0xFFEF4444),
                  delay: 360,
                ),
              ),
            ],
          ),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ],
    );
  }

  Widget _buildFeatureSection(BuildContext context) {
    final menus = FeatureMenuData.allMenus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fitur Utama',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 1000.ms),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: menus.length,
          itemBuilder: (context, index) {
            return FeatureCard(menu: menus[index], delay: 400 + (index * 80));
          },
        ),
      ],
    );
  }

  Widget _buildActivitiesSection(
    BuildContext context,
    AsyncValue<dynamic> recentActivities,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Aktivitas Terbaru',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all activities
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Lihat semua aktivitas'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  child: const Text('Lihat Semua'),
                ),
              ],
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: 1200.ms)
            .slideY(begin: 0.2, duration: 400.ms, delay: 1200.ms),
        const SizedBox(height: 12),
        recentActivities.when(
          data: (activities) {
            if (activities.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Belum ada aktivitas',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: List.generate(
                activities.length > 5 ? 5 : activities.length,
                (index) => ActivityItem(
                  activity: activities[index],
                  delay: 1300 + (index * 100),
                ),
              ),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ],
    );
  }
}
