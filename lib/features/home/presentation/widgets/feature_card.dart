import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bisnisku/features/home/domain/models/feature_menu.dart';
import 'package:go_router/go_router.dart';

/// Widget untuk menampilkan card fitur menu
class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key, required this.menu, this.delay = 0});

  final FeatureMenu menu;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child:
          InkWell(
                onTap: () {
                  // Navigate ke halaman fitur
                  context.push(menu.route);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        menu.color.withValues(alpha: 0.1),
                        menu.color.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: menu.color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: menu.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(menu.icon, color: menu.color, size: 28),
                      ),
                      const Spacer(),
                      Text(
                        menu.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              menu.subtitle,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: menu.color,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(
                duration: 400.ms,
                delay: Duration(milliseconds: delay),
              )
              .scale(
                begin: const Offset(0.8, 0.8),
                duration: 400.ms,
                delay: Duration(milliseconds: delay),
              ),
    );
  }
}
