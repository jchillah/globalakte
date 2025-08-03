// app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_config.dart';
import 'core/app_theme.dart';
import 'features/accessibility/presentation/screens/accessibility_demo_screen.dart';
import 'features/appointment/presentation/screens/appointment_demo_screen.dart';
import 'features/authentication/presentation/screens/register_screen.dart';
import 'features/communication/presentation/screens/communication_demo_screen.dart';
import 'features/document_management/presentation/screens/document_management_demo_screen.dart';
import 'features/encryption/presentation/screens/encryption_demo_screen.dart';
import 'features/legal_assistant_ai/presentation/screens/legal_ai_demo_screen.dart';
import 'features/home/presentation/screens/admin_home_screen.dart';
import 'features/home/presentation/screens/citizen_home_screen.dart';
import 'features/home/presentation/screens/court_home_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/home/presentation/screens/hospital_home_screen.dart';
import 'features/home/presentation/screens/kindergarten_home_screen.dart';
import 'features/home/presentation/screens/lawyer_home_screen.dart';
import 'features/home/presentation/screens/police_home_screen.dart';
import 'features/home/presentation/screens/school_home_screen.dart';
import 'features/home/presentation/screens/social_worker_home_screen.dart';
import 'features/welcome/presentation/screens/welcome_screen.dart';

/// Haupt-App-Klasse für GlobalAkte
/// Verantwortlich für die App-Konfiguration und das Theme-Setup
class GlobalAkteApp extends StatelessWidget {
  const GlobalAkteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'),
        Locale('en', 'US'),
      ],
      locale: const Locale('de', 'DE'),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/citizen': (context) => const CitizenHomeScreen(),
        '/lawyer': (context) => const LawyerHomeScreen(),
        '/admin': (context) => const AdminHomeScreen(),
        '/court': (context) => const CourtHomeScreen(),
        '/school': (context) => const SchoolHomeScreen(),
        '/kindergarten': (context) => const KindergartenHomeScreen(),
        '/police': (context) => const PoliceHomeScreen(),
        '/hospital': (context) => const HospitalHomeScreen(),
        '/social_worker': (context) => const SocialWorkerHomeScreen(),
        '/communication': (context) => const CommunicationDemoScreen(),
        '/document-management': (context) =>
            const DocumentManagementDemoScreen(),
        '/accessibility-demo': (context) => const AccessibilityDemoScreen(),
        '/encryption-demo': (context) => const EncryptionDemoScreen(),
        '/legal-ai-demo': (context) => const LegalAiDemoScreen(),
        '/appointment-demo': (context) => const AppointmentDemoScreen(),
      },
      debugShowCheckedModeBanner: false,
      // ScaffoldMessenger für bessere SnackBar-Unterstützung
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
      // Fehlerbehandlung für bessere Stabilität
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
