// features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../authentication/data/repositories/auth_repository_impl.dart';
import 'admin_home_screen.dart';
import 'citizen_home_screen.dart';
import 'court_home_screen.dart';
import 'hospital_home_screen.dart';
import 'kindergarten_home_screen.dart';
import 'lawyer_home_screen.dart';
import 'police_home_screen.dart';
import 'school_home_screen.dart';
import 'social_worker_home_screen.dart';

/// Home Screen - Hauptseite nach erfolgreicher Anmeldung
/// Zeigt rollenspezifische Dashboards basierend auf der Benutzerrolle
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppConfig.backgroundColor,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: AppConfig.backgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: AppConfig.defaultPadding),
                  const Text(
                    'Fehler beim Laden des Dashboards',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: AppConfig.defaultPadding),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Erneut versuchen'),
                  ),
                ],
              ),
            ),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          // Fallback für Demo-Zwecke
          return const CitizenHomeScreen();
        }

        // Rollenspezifische Navigation
        switch (user.role) {
          case 'citizen':
            return const CitizenHomeScreen();
          case 'lawyer':
            return const LawyerHomeScreen();
          case 'court':
            return const CourtHomeScreen();
          case 'school':
            return const SchoolHomeScreen();
          case 'kindergarten':
            return const KindergartenHomeScreen();
          case 'police':
            return const PoliceHomeScreen();
          case 'hospital':
            return const HospitalHomeScreen();
          case 'social_worker':
            return const SocialWorkerHomeScreen();
          case 'admin':
            return const AdminHomeScreen();
          default:
            return const CitizenHomeScreen();
        }
      },
    );
  }

  Future<dynamic> _getCurrentUser() async {
    try {
      return await _authRepository.getCurrentUser();
    } catch (e) {
      return null;
    }
  }
}
