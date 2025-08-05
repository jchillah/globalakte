// core/app_theme.dart

import 'package:flutter/material.dart';

/// App Theme Manager
class AppTheme {
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF42A5F5);
  static const Color accentColor = Color(0xFF2196F3);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);

  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: Color(0xFFF5F5F5),
        onSurface: Colors.black87,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Colors.black87),
        headlineMedium: TextStyle(color: Colors.black87),
        headlineSmall: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(color: Colors.black87),
        titleMedium: TextStyle(color: Colors.black87),
        titleSmall: TextStyle(color: Colors.black87),
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: Colors.black87),
        labelLarge: TextStyle(color: Colors.black87),
        labelMedium: TextStyle(color: Colors.black87),
        labelSmall: TextStyle(color: Colors.black87),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        labelStyle: const TextStyle(color: Colors.black87),
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIconColor: Colors.grey,
        suffixIconColor: Colors.grey,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[200],
        selectedColor: primaryColor,
        labelStyle: const TextStyle(color: Colors.black87),
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.grey,
        thickness: 1,
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: Colors.white),
        labelMedium: TextStyle(color: Colors.white),
        labelSmall: TextStyle(color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: const Color(0xFF2D2D2D),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIconColor: Colors.grey,
        suffixIconColor: Colors.grey,
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: Color(0xFF3D3D3D),
        selectedColor: primaryColor,
        labelStyle: TextStyle(color: Colors.white),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3D3D3D),
        thickness: 1,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }

  /// Theme Mode Toggle
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }

  /// Custom Colors für verschiedene Features
  static const Map<String, Color> featureColors = {
    'evidence': Color(0xFF4CAF50),
    'document': Color(0xFF2196F3),
    'communication': Color(0xFF9C27B0),
    'help': Color(0xFFFF9800),
    'epa': Color(0xFF607D8B),
    'legal': Color(0xFF795548),
    'notification': Color(0xFFE91E63),
    'encryption': Color(0xFF673AB7),
  };

  /// Status Colors
  static const Map<String, Color> statusColors = {
    'pending': Color(0xFFFF9800),
    'verified': Color(0xFF4CAF50),
    'rejected': Color(0xFFF44336),
    'completed': Color(0xFF4CAF50),
    'in_progress': Color(0xFF2196F3),
    'failed': Color(0xFFF44336),
    'archived': Color(0xFF9E9E9E),
  };

  /// Priority Colors
  static const Map<String, Color> priorityColors = {
    'low': Color(0xFF4CAF50),
    'medium': Color(0xFFFF9800),
    'high': Color(0xFFF44336),
    'urgent': Color(0xFF9C27B0),
  };

  /// Get Feature Color
  static Color getFeatureColor(String feature) {
    return featureColors[feature] ?? Colors.grey;
  }

  /// Get Status Color
  static Color getStatusColor(String status) {
    return statusColors[status] ?? Colors.grey;
  }

  /// Get Priority Color
  static Color getPriorityColor(String priority) {
    return priorityColors[priority] ?? Colors.grey;
  }

  /// Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Get Responsive Layout
  static bool isMobile(double width) => width < mobileBreakpoint;
  static bool isTablet(double width) =>
      width >= mobileBreakpoint && width < tabletBreakpoint;
  static bool isDesktop(double width) => width >= desktopBreakpoint;

  /// Spacing Constants
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;
  static const double spacingXXL = 48;

  /// Border Radius Constants
  static const double radiusS = 4;
  static const double radiusM = 8;
  static const double radiusL = 12;
  static const double radiusXL = 16;
  static const double radiusXXL = 24;
}
