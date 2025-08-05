// core/app_config.dart
import 'package:flutter/material.dart';

/// Zentrale Konfiguration für die GlobalAkte App
class AppConfig {
  // App Metadaten
  static const String appName = 'GlobalAkte';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Sichere App für rechtliche Selbsthilfe';

  // Farben - Beschreibende Namen für bessere Lesbarkeit
  static const Color primaryColor = Color(0xFF1E3A8A); // Dunkelblau - Vertrauen
  static const Color secondaryColor = Color(0xFF059669); // Grün - Sicherheit
  static const Color accentColor = Color(0xFFDC2626); // Rot - Wichtig
  static const Color backgroundColor = Color(0xFFF8FAFC); // Hellgrau
  static const Color surfaceColor = Color(0xFFFFFFFF); // Weiß

  // Text Styles
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 8,
    color: Color(0xFF374151),
  );

  // Padding & Spacing
  static const double defaultPadding = 12.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Border Radius
  static const double defaultRadius = 8.0;
  static const double smallRadius = 4.0;
  static const double largeRadius = 16.0;

  // Animation Duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Security Settings - Suchbare Namen für bessere Wartbarkeit
  static const int maxLoginAttempts = 3;
  static const Duration sessionTimeout = Duration(hours: 2);
  static const int minPinLength = 6;

  // Timeout-Konstanten für bessere Lesbarkeit
  static const Duration snackBarDefaultDuration = Duration(seconds: 3);
  static const Duration snackBarLongDuration = Duration(seconds: 5);
  static const Duration buttonPressDelay = Duration(milliseconds: 200);

  // Feature Flags
  static const bool enableBiometrics = true;
  static const bool enableEncryption = true;
  static const bool enableOfflineMode = true;

  // API Endpoints (für spätere Integration)
  static const String baseUrl = 'https://api.globalakte.de';
  static const String apiVersion = 'v1';

  // Local Storage Keys
  static const String userPrefsKey = 'user_preferences';
  static const String authTokenKey = 'auth_token';
  static const String pinHashKey = 'pin_hash';
  static const String biometricsEnabledKey = 'biometrics_enabled';
}
