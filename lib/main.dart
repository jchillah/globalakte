// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';

/// Einstiegspunkt der GlobalAkte App
/// Verantwortlich für die App-Initialisierung
void main() async {
  // Fehlerbehandlung für bessere Stabilität
  FlutterError.onError = (FlutterErrorDetails details) {
    // Logging für bessere Stabilität
    debugPrint('Flutter Error: ${details.exceptionAsString()}');
    // Zusätzliche Android-spezifische Fehlerbehandlung
    if (details.exception is Exception) {
      debugPrint('Exception caught: ${details.exception}');
    }
  };

  // Platform-spezifische Konfiguration
  WidgetsFlutterBinding.ensureInitialized();

  // Locale-Daten für intl initialisieren
  await initializeDateFormatting('de_DE', null);

  // System UI Konfiguration
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const GlobalAkteApp());
}
