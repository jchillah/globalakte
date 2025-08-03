// features/accessibility/domain/repositories/accessibility_repository.dart

import '../entities/accessibility_settings.dart';

/// Repository-Interface für Barrierefreiheit
abstract class AccessibilityRepository {
  /// Accessibility-Einstellungen laden
  Future<AccessibilitySettings> getSettings();

  /// Accessibility-Einstellungen speichern
  Future<AccessibilitySettings> saveSettings(AccessibilitySettings settings);

  /// Accessibility-Einstellungen zurücksetzen
  Future<AccessibilitySettings> resetSettings();

  /// Screen Reader Status prüfen
  Future<bool> isScreenReaderEnabled();

  /// Voice Control Status prüfen
  Future<bool> isVoiceControlEnabled();

  /// High Contrast Mode aktivieren/deaktivieren
  Future<void> toggleHighContrast();

  /// Schriftgröße ändern
  Future<void> updateFontSize(double scale);

  /// Keyboard Navigation aktivieren/deaktivieren
  Future<void> toggleKeyboardNavigation();

  /// Motion Reduction aktivieren/deaktivieren
  Future<void> toggleReduceMotion();

  /// Focus Indicators anzeigen/verstecken
  Future<void> toggleFocusIndicators();

  /// Sprache ändern
  Future<void> updatePreferredLanguage(String languageCode);

  /// Accessibility-Tests ausführen
  Future<List<AccessibilityTestResult>> runAccessibilityTests();

  /// WCAG-Konformität prüfen
  Future<bool> checkWCAGCompliance();

  /// Accessibility-Report generieren
  Future<String> generateAccessibilityReport();
} 