import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF0061FF);
  static const Color secondary = Color(0xFF00C6FF);
  static const Color accent = Color(0xFFFFB100);

  // Background Colors
  static const Color background = Color(0xFFF8FAFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1C1C1C);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textDark = Color(0xFF111827);

  // Role Colors
  static const Color studentRole = Color(0xFF0061FF);
  static const Color staffRole = Color(0xFF10B981);
  static const Color adminRole = Color(0xFFEF4444);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0061FF), Color(0xFF00C6FF)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB100), Color(0xFFFF8A00)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8FAFF), Color(0xFFE0E7FF)],
  );

  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.05);
  static Color shadowMedium = Colors.black.withOpacity(0.1);
  static Color shadowDark = Colors.black.withOpacity(0.15);

  // Glassmorphism Colors
  static Color glassBackground = Colors.white.withOpacity(0.25);
  static Color glassBorder = Colors.white.withOpacity(0.18);
}




