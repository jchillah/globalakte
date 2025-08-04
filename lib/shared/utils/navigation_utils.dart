// shared/utils/navigation_utils.dart
import 'package:flutter/material.dart';

/// Utility-Klasse für Navigation und Routing
/// Verbessert die Wartbarkeit durch zentrale Navigations-Funktionen
class NavigationUtils {
  /// Zentrale Route-Definitionen
  static const Map<String, String> _routes = {
    'welcome': '/welcome',
    'home': '/home',
    'register': '/register',
    'citizen': '/citizen',
    'lawyer': '/lawyer',
    'admin': '/admin',
    'court': '/court',
    'school': '/school',
    'kindergarten': '/kindergarten',
    'police': '/police',
    'hospital': '/hospital',
    'social_worker': '/social_worker',
    'communication': '/communication',
    'document_management': '/document-management',
    'accessibility_demo': '/accessibility-demo',
    'encryption_demo': '/encryption-demo',
    'legal_ai_demo': '/legal-ai-demo',
    'help_network_demo': '/help-network-demo',
    'evidence_collection_demo': '/evidence-collection-demo',
    'notification_demo': '/notification-demo',
    'appointment_demo': '/appointment-demo',
    'case_files_demo': '/case-files-demo',
    'epa_integration_demo': '/epa-integration-demo',
    'pdf_generator_demo': '/pdf-generator-demo',
  };

  /// Navigiert zu einer Route
  static Future<T?> navigateTo<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamed<T>(
      _routes[routeName] ?? routeName,
      arguments: arguments,
    );
  }

  /// Navigiert zu einer Route und ersetzt die aktuelle Route
  static Future<T?> navigateToReplacement<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushReplacementNamed<T, void>(
      _routes[routeName] ?? routeName,
      arguments: arguments,
    );
  }

  /// Navigiert zu einer Route und löscht alle vorherigen Routen
  static Future<T?> navigateToAndClear<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamedAndRemoveUntil<T>(
      _routes[routeName] ?? routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Geht zurück zur vorherigen Route
  static void goBack<T extends Object?>(
    BuildContext context, [
    T? result,
  ]) {
    Navigator.of(context).pop<T>(result);
  }

  /// Geht zurück zur vorherigen Route wenn möglich
  static Future<bool> maybeGoBack<T extends Object?>(
    BuildContext context, [
    T? result,
  ]) {
    return Navigator.of(context).maybePop<T>(result);
  }

  /// Prüft ob Navigation zurück möglich ist
  static bool canGoBack(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  /// Zeigt einen Dialog
  static Future<T?> showDialog<T extends Object?>(
    BuildContext context,
    Widget dialog, {
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => dialog,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Zeigt einen Bestätigungs-Dialog
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Bestätigen',
    String cancelText = 'Abbrechen',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context,
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => goBack(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => goBack(context, true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Zeigt einen Informations-Dialog
  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog<void>(
      context,
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => goBack(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Zeigt einen Fehler-Dialog
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog<void>(
      context,
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => goBack(context),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Zeigt einen Loading-Dialog
  static Future<void> showLoadingDialog(
    BuildContext context, {
    String message = 'Laden...',
  }) {
    return showDialog<void>(
      context,
      PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Versteckt den Loading-Dialog
  static void hideLoadingDialog(BuildContext context) {
    if (canGoBack(context)) {
      goBack(context);
    }
  }

  /// Zeigt einen Bottom Sheet
  static Future<T?> showBottomSheet<T extends Object?>(
    BuildContext context,
    Widget bottomSheet, {
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => bottomSheet,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );
  }

  /// Zeigt einen Snackbar
  static void showSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }

  /// Zeigt einen Erfolgs-Snackbar
  static void showSuccessSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      context,
      message: message,
      duration: duration,
    );
  }

  /// Zeigt einen Fehler-Snackbar
  static void showErrorSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 5),
  }) {
    showSnackBar(
      context,
      message: message,
      duration: duration,
    );
  }

  /// Zeigt einen Info-Snackbar
  static void showInfoSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      context,
      message: message,
      duration: duration,
    );
  }

  /// Zeigt einen Warnung-Snackbar
  static void showWarningSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    showSnackBar(
      context,
      message: message,
      duration: duration,
    );
  }

  /// Navigiert zu einer Route mit Argumenten
  static Future<T?> navigateWithArguments<T extends Object?>(
    BuildContext context,
    String routeName,
    Map<String, dynamic> arguments,
  ) {
    return navigateTo<T>(context, routeName, arguments: arguments);
  }

  /// Navigiert zu einer Route mit Query-Parametern
  static Future<T?> navigateWithQuery<T extends Object?>(
    BuildContext context,
    String routeName,
    Map<String, String> queryParameters,
  ) {
    final uri = Uri(
      path: _routes[routeName] ?? routeName,
      queryParameters: queryParameters,
    );
    return Navigator.of(context).pushNamed<T>(uri.toString());
  }

  /// Prüft ob eine Route existiert
  static bool routeExists(String routeName) {
    return _routes.containsKey(routeName);
  }

  /// Gibt alle verfügbaren Routen zurück
  static Map<String, String> getAvailableRoutes() {
    return Map.unmodifiable(_routes);
  }

  /// Gibt den aktuellen Route-Namen zurück
  static String? getCurrentRouteName(BuildContext context) {
    final route = ModalRoute.of(context);
    return route?.settings.name;
  }

  /// Gibt die Route-Argumente zurück
  static Object? getRouteArguments(BuildContext context) {
    final route = ModalRoute.of(context);
    return route?.settings.arguments;
  }

  /// Prüft ob der aktuelle Route ein bestimmter Route ist
  static bool isCurrentRoute(BuildContext context, String routeName) {
    final currentRoute = getCurrentRouteName(context);
    return currentRoute == (_routes[routeName] ?? routeName);
  }

  /// Navigiert zu einer Route nur wenn es nicht die aktuelle Route ist
  static Future<T?> navigateIfNotCurrent<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    if (!isCurrentRoute(context, routeName)) {
      return navigateTo<T>(context, routeName, arguments: arguments);
    }
    return Future.value(null);
  }

  /// Zeigt einen Dialog mit benutzerdefinierten Optionen
  static Future<String?> showCustomDialog(
    BuildContext context, {
    required String title,
    required String message,
    required List<String> options,
    String? cancelText,
  }) {
    return showDialog<String>(
      context,
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => goBack(context),
              child: Text(cancelText),
            ),
          ...options.map((option) => TextButton(
            onPressed: () => goBack(context, option),
            child: Text(option),
          )),
        ],
      ),
    );
  }

  /// Zeigt einen Dialog mit Eingabefeld
  static Future<String?> showInputDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? initialValue,
    String confirmText = 'OK',
    String cancelText = 'Abbrechen',
    TextInputType? keyboardType,
  }) {
    final controller = TextEditingController(text: initialValue);
    
    return showDialog<String>(
      context,
      AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: message,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => goBack(context),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => goBack(context, controller.text),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
} 