// shared/utils/snackbar_utils.dart
import 'package:flutter/material.dart';

import '../../core/app_config.dart';

/// Utility-Klasse für konsistente SnackBar-Anzeige auf allen Plattformen
class SnackBarUtils {
  /// Zeigt eine SnackBar mit Standard-Konfiguration an
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    final scaffoldMessenger = _getScaffoldMessenger(context);
    final snackBar = _createSnackBar(
      message: message,
      duration: duration,
      action: action,
      backgroundColor: backgroundColor,
    );

    scaffoldMessenger.showSnackBar(snackBar);
  }

  /// Erstellt eine SnackBar mit den angegebenen Parametern
  static SnackBar _createSnackBar({
    required String message,
    Duration? duration,
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    return SnackBar(
      content: _createSnackBarContent(message),
      backgroundColor: backgroundColor ?? AppConfig.primaryColor,
      duration: duration ?? AppConfig.snackBarDefaultDuration,
      behavior: SnackBarBehavior.floating, // Bessere Android-Kompatibilität
      shape: _createSnackBarShape(),
      margin: const EdgeInsets.all(AppConfig.defaultPadding),
      action: action,
    );
  }

  /// Erstellt den Text-Inhalt für die SnackBar
  static Widget _createSnackBarContent(String message) {
    return Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  /// Erstellt die Form der SnackBar
  static RoundedRectangleBorder _createSnackBarShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
    );
  }

  /// Holt den ScaffoldMessenger aus dem Context
  static ScaffoldMessengerState _getScaffoldMessenger(BuildContext context) {
    return ScaffoldMessenger.of(context);
  }

  /// Zeigt eine SnackBar mit OK-Button an
  static void showSnackBarWithAction(
    BuildContext context,
    String message, {
    String actionLabel = 'OK',
    Duration duration = AppConfig.snackBarDefaultDuration,
    Color? backgroundColor,
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: backgroundColor,
      action: _createSnackBarAction(context, actionLabel),
    );
  }

  /// Erstellt eine SnackBarAction
  static SnackBarAction _createSnackBarAction(
    BuildContext context,
    String label,
  ) {
    return SnackBarAction(
      label: label,
      textColor: Colors.white,
      onPressed: () => _hideCurrentSnackBar(context),
    );
  }

  /// Versteckt die aktuelle SnackBar
  static void _hideCurrentSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Zeigt eine Erfolgs-SnackBar an
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: AppConfig.secondaryColor,
    );
  }

  /// Zeigt eine Fehler-SnackBar an
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: AppConfig.accentColor,
    );
  }

  /// Zeigt eine Info-SnackBar an
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.blue,
    );
  }

  /// Versteckt die aktuelle SnackBar
  static void hideCurrentSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
