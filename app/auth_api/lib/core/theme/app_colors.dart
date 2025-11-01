import 'package:flutter/material.dart';

/// Centralized color definitions for the AuthAPI Mobile app.
/// Keep palette minimal (security-oriented: calm blues, grays, whites).
class AppColors {
  // Primary brand color
  static const Color primary = Color(0xFF1565C0); // deep blue
  static const Color primaryLight = Color(0xFF5E92F3);
  static const Color primaryDark = Color(0xFF003C8F);

  // Secondary / accent colors
  static const Color accent = Color(0xFF26A69A); // teal accent
  static const Color success = Color(0xFF2E7D32); // green
  static const Color error = Color(0xFFD32F2F); // red
  static const Color warning = Color(0xFFF9A825); // amber

  // Neutral shades
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1C1C1C);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color divider = Color(0xFFE0E0E0);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFB0BEC5);
}
