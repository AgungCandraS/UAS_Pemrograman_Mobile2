import 'package:flutter/material.dart';

/// Modern color scheme for Bisnisku app - Supports both Light & Dark themes
class AppColors {
  // Primary colors - Modern Blue
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1E40AF);

  // Secondary colors - Cyan/Teal
  static const Color secondary = Color(0xFF06B6D4);
  static const Color secondaryLight = Color(0xFF22D3EE);
  static const Color secondaryDark = Color(0xFF0891B2);

  // Accent colors - Purple
  static const Color accent = Color(0xFF8B5CF6);
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentDark = Color(0xFF7C3AED);

  // Dark theme - Neutral colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1A273F);
  static const Color darkSurfaceVariant = Color(0xFF253549);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextTertiary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkDivider = Color(0xFF1E293B);

  // Light theme - Neutral colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF3F4F6);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightDivider = Color(0xFFF0F0F0);

  // Default (Dark theme) colors for backward compatibility
  @Deprecated('Use getBackgroundColor() for theme-aware colors')
  static const Color background = darkBackground;
  @Deprecated('Use getSurfaceColor() for theme-aware colors')
  static const Color surface = darkSurface;
  @Deprecated('Use getSurfaceVariantColor() for theme-aware colors')
  static const Color surfaceVariant = darkSurfaceVariant;
  @Deprecated('Use getTextPrimaryColor() for theme-aware colors')
  static const Color textPrimary = darkTextPrimary;
  @Deprecated('Use getTextSecondaryColor() for theme-aware colors')
  static const Color textSecondary = darkTextSecondary;
  @Deprecated('Use getTextTertiaryColor() for theme-aware colors')
  static const Color textTertiary = darkTextTertiary;
  @Deprecated('Use getBorderColor() for theme-aware colors')
  static const Color border = darkBorder;
  @Deprecated('Use getDividerColor() for theme-aware colors')
  static const Color divider = darkDivider;

  // Status Colors (Theme-independent)
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF06B6D4);

  // Text on primary
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Disabled color
  static const Color textDisabled = Color(0xFF64748B);

  // Shadows (Theme-independent)
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowHeavy = Color(0x4D000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Chart colors
  static const List<Color> chartColors = [
    Color(0xFF3B82F6),
    Color(0xFF06B6D4),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFF94A3B8),
    Color(0xFF22D3EE),
  ];

  // === THEME-AWARE COLOR GETTERS ===

  /// Get background color based on brightness
  static Color getBackgroundColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkBackground : lightBackground;

  /// Get surface color based on brightness
  static Color getSurfaceColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkSurface : lightSurface;

  /// Get surface variant color based on brightness
  static Color getSurfaceVariantColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkSurfaceVariant : lightSurfaceVariant;

  /// Get primary text color based on brightness
  static Color getTextPrimaryColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkTextPrimary : lightTextPrimary;

  /// Get secondary text color based on brightness
  static Color getTextSecondaryColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkTextSecondary : lightTextSecondary;

  /// Get tertiary text color based on brightness
  static Color getTextTertiaryColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkTextTertiary : lightTextTertiary;

  /// Get border color based on brightness
  static Color getBorderColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkBorder : lightBorder;

  /// Get divider color based on brightness
  static Color getDividerColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkDivider : lightDivider;

  /// Get gradient color based on theme (background to surface gradient)
  static LinearGradient getBackgroundGradient(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const LinearGradient(
        colors: [darkBackground, darkSurface],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [lightBackground, lightSurfaceVariant],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }
}
