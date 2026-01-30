import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bisnisku/features/home/domain/models/home_status.dart';
import 'package:intl/intl.dart';

/// Widget untuk menampilkan item aktivitas
class ActivityItem extends StatelessWidget {
  const ActivityItem({super.key, required this.activity, this.delay = 0});

  final RecentActivity activity;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final timeAgo = _getTimeAgo(activity.timestamp);

    return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getActivityColor(
                    activity.type,
                  ).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    activity.icon ?? _getDefaultIcon(activity.type),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeAgo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(
          duration: 300.ms,
          delay: Duration(milliseconds: delay),
        )
        .slideX(
          begin: 0.2,
          duration: 300.ms,
          delay: Duration(milliseconds: delay),
        );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return DateFormat('dd MMM yyyy').format(timestamp);
    }
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.inventory:
        return const Color(0xFF2563EB);
      case ActivityType.order:
        return const Color(0xFF16A34A);
      case ActivityType.payment:
        return const Color(0xFFF59E0B);
      case ActivityType.employee:
        return const Color(0xFF7C3AED);
      case ActivityType.production:
        return const Color(0xFFF97316);
      case ActivityType.other:
        return const Color(0xFF64748B);
    }
  }

  String _getDefaultIcon(ActivityType type) {
    switch (type) {
      case ActivityType.inventory:
        return '📦';
      case ActivityType.order:
        return '📋';
      case ActivityType.payment:
        return '💰';
      case ActivityType.employee:
        return '👤';
      case ActivityType.production:
        return '🏭';
      case ActivityType.other:
        return '📌';
    }
  }
}
