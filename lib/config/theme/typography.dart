import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App typography configuration
class AppTypography {
  AppTypography._();

  /// Base text theme using Manrope font with fallback
  static TextTheme get textTheme {
    try {
      return GoogleFonts.manropeTextTheme();
    } catch (e) {
      // Fallback to default theme if Google Fonts fails to load
      return ThemeData.dark().textTheme;
    }
  }

  /// Headline styles
  static TextStyle get h1 => textTheme.displayLarge!.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static TextStyle get h2 => textTheme.displayMedium!.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static TextStyle get h3 => textTheme.displaySmall!.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get h4 => textTheme.headlineMedium!.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get h5 => textTheme.headlineSmall!.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  /// Body styles
  static TextStyle get bodyLarge =>
      textTheme.bodyLarge!.copyWith(fontSize: 16, fontWeight: FontWeight.w400);

  static TextStyle get bodyMedium =>
      textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle get bodySmall =>
      textTheme.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w400);

  /// Label styles
  static TextStyle get labelLarge =>
      textTheme.labelLarge!.copyWith(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get labelMedium => textTheme.labelMedium!.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelSmall =>
      textTheme.labelSmall!.copyWith(fontSize: 10, fontWeight: FontWeight.w600);

  /// Button styles
  static TextStyle get button => textTheme.labelLarge!.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}
