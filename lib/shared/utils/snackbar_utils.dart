// shared/utils/snackbar_utils.dart
import 'package:flutter/material.dart';

/// Utility-Klasse für SnackBar-Nachrichten
class SnackBarUtils {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Kompatibilitätsmethoden für bestehende Aufrufe
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSuccess(context, message);
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    showError(context, message);
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    showInfo(context, message);
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    showWarning(context, message);
  }

  // Legacy-Methode für Kompatibilität
  static void showSnackBar(BuildContext context, String message) {
    showInfo(context, message);
  }
}

/// Einfache Logging-Utility für die App
class AppLogger {
  static void debug(String message) {
    // In Produktion sollte hier ein echtes Logging-Framework verwendet werden
    // ignore: avoid_print
    print('[DEBUG] $message');
  }

  static void info(String message) {
    // ignore: avoid_print
    print('[INFO] $message');
  }

  static void warning(String message) {
    // ignore: avoid_print
    print('[WARNING] $message');
  }

  static void error(String message) {
    // ignore: avoid_print
    print('[ERROR] $message');
  }
}
