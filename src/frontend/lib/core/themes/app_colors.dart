import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1976D2); // Blue
  static const Color primaryLight = Color(0xFF63A4FF);
  static const Color primaryDark = Color(0xFF004BA0);

  // Secondary Colors
  static const Color secondary = Color(0xFF424242); // Gray
  static const Color secondaryLight = Color(0xFF6D6D6D);
  static const Color secondaryDark = Color(0xFF1B1B1B);

  // Accent Colors
  static const Color accent = Color(0xFFFF9800); // Orange

  // Background
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // On Colors (for text/icons on colored backgrounds)
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF212121);
  static const Color onBackground = Color(0xFF212121);
  static const Color onError = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color warning = Color(0xFFFFC107); // Yellow
  static const Color error = Color(0xFFF44336); // Red
  static const Color info = Color(0xFF2196F3); // Blue

  // Border
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFBDBDBD);

  // Status Badge Colors (for incident status)
  static const Color statusPending = Color(0xFFFFC107); // Yellow
  static const Color statusInProgress = Color(0xFF2196F3); // Blue
  static const Color statusResolved = Color(0xFF4CAF50); // Green
  static const Color statusCancelled = Color(0xFF9E9E9E); // Gray

  // Hover/Focus
  static const Color hover = Color(0xFFE3F2FD);
  static const Color focus = Color(0xFFBBDEFB);

  // Shadow
  static const Color shadow = Color(0x1F000000);
}
