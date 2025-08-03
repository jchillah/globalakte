// test/widget_test.dart
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:globalakte/app.dart';

void main() {
  testWidgets('GlobalAkte Welcome Screen Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GlobalAkteApp());

    // Verify that the app title is displayed.
    expect(find.text('GlobalAkte'), findsOneWidget);

    // Verify that the app description is displayed.
    expect(find.text('Sichere App für rechtliche Selbsthilfe'), findsOneWidget);

    // Verify that the start button is displayed.
    expect(find.text('Jetzt starten'), findsOneWidget);

    // Verify that the version info is displayed.
    expect(find.text('Version 1.0.0'), findsOneWidget);

    // Verify that feature items are displayed.
    expect(find.text('Sichere Authentifizierung'), findsOneWidget);
    expect(find.text('Fallakten-Verwaltung'), findsOneWidget);
    expect(find.text('KI-gestützte Hilfe'), findsOneWidget);
  });
}
