import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bisnisku/core/theme/app_themes.dart';
import 'package:bisnisku/features/profile/application/providers/profile_providers.dart';
import 'package:bisnisku/core/router/app_router.dart';

/// Main app widget
class BisniskuApp extends ConsumerWidget {
  const BisniskuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch immediate theme provider - this is the source of truth for current theme
    final theme = ref.watch(immediateThemeProvider);

    // Convert theme string to ThemeMode
    final themeMode = _getThemeMode(theme);

    return MaterialApp.router(
      title: 'Bisnisku',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }

  /// Convert theme string to ThemeMode
  static ThemeMode _getThemeMode(String theme) {
    switch (theme.toLowerCase().trim()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
