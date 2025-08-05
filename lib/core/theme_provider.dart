// core/theme_provider.dart
import 'package:flutter/material.dart';

/// Theme Provider für dynamischen Wechsel zwischen Light und Dark Mode
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      // Wenn system, dann basierend auf aktueller Systemeinstellung
      final isCurrentlyDark =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;
      _themeMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    }
    notifyListeners();
  }
}
