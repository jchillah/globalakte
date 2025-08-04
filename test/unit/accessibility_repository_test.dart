// test/unit/accessibility_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:globalakte/features/accessibility/data/repositories/accessibility_repository_impl.dart';
import 'package:globalakte/features/accessibility/domain/entities/accessibility_settings.dart';

void main() {
  group('AccessibilityRepositoryImpl Tests', () {
    late AccessibilityRepositoryImpl repository;

    setUp(() {
      repository = AccessibilityRepositoryImpl();
    });

    test('should load default settings', () async {
      final settings = await repository.getSettings();
      
      expect(settings, isA<AccessibilitySettings>());
      expect(settings.screenReaderEnabled, isTrue);
      expect(settings.fontSizeScale, equals(1.0));
      expect(settings.preferredLanguage, equals('de_DE'));
    });

    test('should save and retrieve settings', () async {
      final originalSettings = await repository.getSettings();
      final updatedSettings = originalSettings.copyWith(
        fontSizeScale: 1.5,
        highContrastEnabled: true,
      );

      final savedSettings = await repository.saveSettings(updatedSettings);
      
      expect(savedSettings.fontSizeScale, equals(1.5));
      expect(savedSettings.highContrastEnabled, isTrue);
      expect(savedSettings.updatedAt, isNot(equals(originalSettings.updatedAt)));
    });

    test('should reset settings to default', () async {
      // First, change some settings
      final originalSettings = await repository.getSettings();
      await repository.saveSettings(originalSettings.copyWith(
        fontSizeScale: 2.0,
        voiceControlEnabled: true,
      ));

      // Then reset
      final resetSettings = await repository.resetSettings();
      
      expect(resetSettings.fontSizeScale, equals(1.0));
      expect(resetSettings.voiceControlEnabled, isFalse);
    });

    test('should run accessibility tests', () async {
      final testResults = await repository.runAccessibilityTests();
      
      expect(testResults, isA<List<AccessibilityTestResult>>());
      expect(testResults.length, greaterThan(0));
      
      for (final result in testResults) {
        expect(result.id, isNotEmpty);
        expect(result.testName, isNotEmpty);
        expect(result.description, isNotEmpty);
        expect(result.testDate, isA<DateTime>());
      }
    });

    test('should check WCAG compliance', () async {
      final isCompliant = await repository.checkWCAGCompliance();
      
      expect(isCompliant, isA<bool>());
    });

    test('should generate accessibility report', () async {
      final report = await repository.generateAccessibilityReport();
      
      expect(report, isA<String>());
      expect(report, contains('Accessibility Report'));
      expect(report, contains('GlobalAkte'));
    });
  });
} 