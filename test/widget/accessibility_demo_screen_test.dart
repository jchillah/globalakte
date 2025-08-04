// test/widget/accessibility_demo_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:globalakte/features/accessibility/presentation/screens/accessibility_demo_screen.dart';

void main() {
  group('AccessibilityDemoScreen Widget Tests', () {
    testWidgets('should display accessibility demo screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AccessibilityDemoScreen(),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify that the screen title is displayed (multiple instances expected)
      expect(find.text('Barrierefreiheit & Accessibility'), findsAtLeastNWidgets(1));

      // Verify that accessibility info is displayed (partial match)
      expect(find.textContaining('GlobalAkte ist für alle Benutzer zugänglich'),
          findsOneWidget);

      // Verify that accessibility features are listed (partial matches)
      expect(find.textContaining('Screen Reader'), findsAtLeastNWidgets(1));
      expect(find.textContaining('Voice Control'), findsAtLeastNWidgets(1));
      expect(find.textContaining('High Contrast'), findsAtLeastNWidgets(1));
    });

    testWidgets('should show help dialog when help button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AccessibilityDemoScreen(),
        ),
      );

      // Find and tap the help button
      final helpButton = find.byIcon(Icons.help_outline);
      expect(helpButton, findsOneWidget);

      await tester.tap(helpButton);
      await tester.pumpAndSettle();

      // Verify that the help dialog is displayed
      expect(find.text('Accessibility-Informationen'), findsOneWidget);
      expect(
          find.textContaining(
              'GlobalAkte ist vollständig barrierefrei gestaltet'),
          findsOneWidget);
    });

    testWidgets('should display accessibility settings widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AccessibilityDemoScreen(),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify that accessibility settings are displayed
      expect(find.text('Accessibility-Einstellungen'), findsOneWidget);
      expect(find.text('Screen Reader'), findsOneWidget);
      expect(find.text('Voice Control'), findsOneWidget);
      expect(find.text('High Contrast Mode'), findsOneWidget);
    });

    testWidgets('should display accessibility test widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AccessibilityDemoScreen(),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify that accessibility tests are displayed
      expect(find.text('Accessibility-Tests'), findsOneWidget);
      expect(find.text('Tests ausführen'), findsOneWidget);
    });

    testWidgets('should display accessibility report widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AccessibilityDemoScreen(),
        ),
      );

      // Wait for the screen to load
      await tester.pumpAndSettle();

      // Verify that accessibility report is displayed
      expect(find.text('Accessibility-Report'), findsOneWidget);
      expect(find.text('Report generieren'), findsOneWidget);
    });
  });
}
