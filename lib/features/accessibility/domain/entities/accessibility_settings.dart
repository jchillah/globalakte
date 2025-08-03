// features/accessibility/domain/entities/accessibility_settings.dart

/// Accessibility Settings Entity für das Barrierefreiheit-System
class AccessibilitySettings {
  final String id;
  final bool screenReaderEnabled;
  final bool voiceControlEnabled;
  final bool highContrastEnabled;
  final double fontSizeScale;
  final bool keyboardNavigationEnabled;
  final bool reduceMotionEnabled;
  final bool showFocusIndicators;
  final String preferredLanguage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AccessibilitySettings({
    required this.id,
    required this.screenReaderEnabled,
    required this.voiceControlEnabled,
    required this.highContrastEnabled,
    required this.fontSizeScale,
    required this.keyboardNavigationEnabled,
    required this.reduceMotionEnabled,
    required this.showFocusIndicators,
    required this.preferredLanguage,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Kopie mit geänderten Werten erstellen
  AccessibilitySettings copyWith({
    String? id,
    bool? screenReaderEnabled,
    bool? voiceControlEnabled,
    bool? highContrastEnabled,
    double? fontSizeScale,
    bool? keyboardNavigationEnabled,
    bool? reduceMotionEnabled,
    bool? showFocusIndicators,
    String? preferredLanguage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccessibilitySettings(
      id: id ?? this.id,
      screenReaderEnabled: screenReaderEnabled ?? this.screenReaderEnabled,
      voiceControlEnabled: voiceControlEnabled ?? this.voiceControlEnabled,
      highContrastEnabled: highContrastEnabled ?? this.highContrastEnabled,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
      keyboardNavigationEnabled:
          keyboardNavigationEnabled ?? this.keyboardNavigationEnabled,
      reduceMotionEnabled: reduceMotionEnabled ?? this.reduceMotionEnabled,
      showFocusIndicators: showFocusIndicators ?? this.showFocusIndicators,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// JSON-Serialisierung
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'screenReaderEnabled': screenReaderEnabled,
      'voiceControlEnabled': voiceControlEnabled,
      'highContrastEnabled': highContrastEnabled,
      'fontSizeScale': fontSizeScale,
      'keyboardNavigationEnabled': keyboardNavigationEnabled,
      'reduceMotionEnabled': reduceMotionEnabled,
      'showFocusIndicators': showFocusIndicators,
      'preferredLanguage': preferredLanguage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// JSON-Deserialisierung
  factory AccessibilitySettings.fromJson(Map<String, dynamic> json) {
    return AccessibilitySettings(
      id: json['id'] as String,
      screenReaderEnabled: json['screenReaderEnabled'] as bool,
      voiceControlEnabled: json['voiceControlEnabled'] as bool,
      highContrastEnabled: json['highContrastEnabled'] as bool,
      fontSizeScale: (json['fontSizeScale'] as num).toDouble(),
      keyboardNavigationEnabled: json['keyboardNavigationEnabled'] as bool,
      reduceMotionEnabled: json['reduceMotionEnabled'] as bool,
      showFocusIndicators: json['showFocusIndicators'] as bool,
      preferredLanguage: json['preferredLanguage'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Standard-Einstellungen
  factory AccessibilitySettings.defaultSettings() {
    final now = DateTime.now();
    return AccessibilitySettings(
      id: 'default',
      screenReaderEnabled: true,
      voiceControlEnabled: false,
      highContrastEnabled: false,
      fontSizeScale: 1.0,
      keyboardNavigationEnabled: true,
      reduceMotionEnabled: false,
      showFocusIndicators: true,
      preferredLanguage: 'de_DE',
      createdAt: now,
      updatedAt: now,
    );
  }
}

/// Accessibility Test Result Entity
class AccessibilityTestResult {
  final String id;
  final String testName;
  final bool passed;
  final String description;
  final String? errorMessage;
  final DateTime testDate;

  const AccessibilityTestResult({
    required this.id,
    required this.testName,
    required this.passed,
    required this.description,
    this.errorMessage,
    required this.testDate,
  });

  /// JSON-Serialisierung
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testName': testName,
      'passed': passed,
      'description': description,
      'errorMessage': errorMessage,
      'testDate': testDate.toIso8601String(),
    };
  }

  /// JSON-Deserialisierung
  factory AccessibilityTestResult.fromJson(Map<String, dynamic> json) {
    return AccessibilityTestResult(
      id: json['id'] as String,
      testName: json['testName'] as String,
      passed: json['passed'] as bool,
      description: json['description'] as String,
      errorMessage: json['errorMessage'] as String?,
      testDate: DateTime.parse(json['testDate'] as String),
    );
  }
}
