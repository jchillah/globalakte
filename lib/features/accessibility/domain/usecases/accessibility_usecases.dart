// features/accessibility/domain/usecases/accessibility_usecases.dart

import '../entities/accessibility_settings.dart';
import '../repositories/accessibility_repository.dart';

/// Use Case: Accessibility-Einstellungen laden
class GetAccessibilitySettingsUseCase {
  final AccessibilityRepository _repository;

  GetAccessibilitySettingsUseCase(this._repository);

  Future<AccessibilitySettings> call() async {
    return await _repository.getSettings();
  }
}

/// Use Case: Accessibility-Einstellungen speichern
class SaveAccessibilitySettingsUseCase {
  final AccessibilityRepository _repository;

  SaveAccessibilitySettingsUseCase(this._repository);

  Future<AccessibilitySettings> call(AccessibilitySettings settings) async {
    // Validierung
    if (settings.fontSizeScale < 0.5 || settings.fontSizeScale > 3.0) {
      throw ArgumentError('Schriftgröße muss zwischen 0.5 und 3.0 liegen');
    }
    if (settings.preferredLanguage.isEmpty) {
      throw ArgumentError('Sprache ist erforderlich');
    }

    return await _repository.saveSettings(settings);
  }
}

/// Use Case: Accessibility-Einstellungen zurücksetzen
class ResetAccessibilitySettingsUseCase {
  final AccessibilityRepository _repository;

  ResetAccessibilitySettingsUseCase(this._repository);

  Future<AccessibilitySettings> call() async {
    return await _repository.resetSettings();
  }
}

/// Use Case: Screen Reader Status prüfen
class CheckScreenReaderUseCase {
  final AccessibilityRepository _repository;

  CheckScreenReaderUseCase(this._repository);

  Future<bool> call() async {
    return await _repository.isScreenReaderEnabled();
  }
}

/// Use Case: Voice Control Status prüfen
class CheckVoiceControlUseCase {
  final AccessibilityRepository _repository;

  CheckVoiceControlUseCase(this._repository);

  Future<bool> call() async {
    return await _repository.isVoiceControlEnabled();
  }
}

/// Use Case: High Contrast Mode umschalten
class ToggleHighContrastUseCase {
  final AccessibilityRepository _repository;

  ToggleHighContrastUseCase(this._repository);

  Future<void> call() async {
    await _repository.toggleHighContrast();
  }
}

/// Use Case: Schriftgröße ändern
class UpdateFontSizeUseCase {
  final AccessibilityRepository _repository;

  UpdateFontSizeUseCase(this._repository);

  Future<void> call(double scale) async {
    // Validierung
    if (scale < 0.5 || scale > 3.0) {
      throw ArgumentError('Schriftgröße muss zwischen 0.5 und 3.0 liegen');
    }

    await _repository.updateFontSize(scale);
  }
}

/// Use Case: Keyboard Navigation umschalten
class ToggleKeyboardNavigationUseCase {
  final AccessibilityRepository _repository;

  ToggleKeyboardNavigationUseCase(this._repository);

  Future<void> call() async {
    await _repository.toggleKeyboardNavigation();
  }
}

/// Use Case: Motion Reduction umschalten
class ToggleReduceMotionUseCase {
  final AccessibilityRepository _repository;

  ToggleReduceMotionUseCase(this._repository);

  Future<void> call() async {
    await _repository.toggleReduceMotion();
  }
}

/// Use Case: Focus Indicators umschalten
class ToggleFocusIndicatorsUseCase {
  final AccessibilityRepository _repository;

  ToggleFocusIndicatorsUseCase(this._repository);

  Future<void> call() async {
    await _repository.toggleFocusIndicators();
  }
}

/// Use Case: Sprache ändern
class UpdateLanguageUseCase {
  final AccessibilityRepository _repository;

  UpdateLanguageUseCase(this._repository);

  Future<void> call(String languageCode) async {
    // Validierung
    if (languageCode.isEmpty) {
      throw ArgumentError('Sprachcode ist erforderlich');
    }

    await _repository.updatePreferredLanguage(languageCode);
  }
}

/// Use Case: Accessibility-Tests ausführen
class RunAccessibilityTestsUseCase {
  final AccessibilityRepository _repository;

  RunAccessibilityTestsUseCase(this._repository);

  Future<List<AccessibilityTestResult>> call() async {
    return await _repository.runAccessibilityTests();
  }
}

/// Use Case: WCAG-Konformität prüfen
class CheckWCAGComplianceUseCase {
  final AccessibilityRepository _repository;

  CheckWCAGComplianceUseCase(this._repository);

  Future<bool> call() async {
    return await _repository.checkWCAGCompliance();
  }
}

/// Use Case: Accessibility-Report generieren
class GenerateAccessibilityReportUseCase {
  final AccessibilityRepository _repository;

  GenerateAccessibilityReportUseCase(this._repository);

  Future<String> call() async {
    return await _repository.generateAccessibilityReport();
  }
}
