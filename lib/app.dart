// app.dart
import 'package:flutter/material.dart';

import 'core/app_config.dart';
import 'core/app_theme.dart';
import 'features/welcome/presentation/screens/welcome_screen.dart';

/// Haupt-App-Klasse für GlobalAkte
/// Verantwortlich für die App-Konfiguration und das Theme-Setup
class GlobalAkteApp extends StatelessWidget {
  const GlobalAkteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
      // ScaffoldMessenger für bessere SnackBar-Unterstützung
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
    );
  }
}
