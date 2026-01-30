import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Widget untuk menampilkan informasi cuaca
class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    super.key,
    required this.temperature,
    required this.condition,
  });

  final double temperature;
  final String condition;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getWeatherIcon(condition),
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${temperature.toStringAsFixed(0)}°C',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            condition,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8));
  }

  IconData _getWeatherIcon(String condition) {
    final lowerCondition = condition.toLowerCase();
    if (lowerCondition.contains('cerah') || lowerCondition.contains('sunny')) {
      return Icons.wb_sunny;
    } else if (lowerCondition.contains('hujan') ||
        lowerCondition.contains('rain')) {
      return Icons.umbrella;
    } else if (lowerCondition.contains('berawan') ||
        lowerCondition.contains('cloud')) {
      return Icons.cloud;
    } else if (lowerCondition.contains('badai') ||
        lowerCondition.contains('storm')) {
      return Icons.thunderstorm;
    }
    return Icons.wb_cloudy;
  }
}
