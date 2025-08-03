// features/home/presentation/screens/hospital_home_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../authentication/data/repositories/auth_repository_impl.dart';

/// Krankenhaus Home Screen für Benutzer mit der 'hospital' Rolle
class HospitalHomeScreen extends StatefulWidget {
  const HospitalHomeScreen({super.key});

  @override
  State<HospitalHomeScreen> createState() => _HospitalHomeScreenState();
}

class _HospitalHomeScreenState extends State<HospitalHomeScreen> {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Krankenhaus Dashboard'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConfig.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(),
              const SizedBox(height: AppConfig.largePadding),
              _buildHospitalFeatures(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConfig.largePadding),
      decoration: BoxDecoration(
        color: AppConfig.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConfig.largeRadius),
        border: Border.all(
          color: AppConfig.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_hospital,
                size: 32,
                color: AppConfig.primaryColor,
              ),
              const SizedBox(width: AppConfig.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Willkommen im Krankenhaus',
                      style: AppConfig.headlineStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Verwalten Sie Patienten, Behandlungen und Dokumentation',
                      style: AppConfig.bodyStyle.copyWith(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalFeatures() {
    return SizedBox(
      height: 400,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: AppConfig.defaultPadding,
        mainAxisSpacing: AppConfig.defaultPadding,
        physics: const BouncingScrollPhysics(),
        childAspectRatio: 1.4,
        children: [
          _buildFeatureCard(
            'Patienten',
            'Patientenverwaltung',
            Icons.person,
            _handlePatients,
          ),
          _buildFeatureCard(
            'Behandlungen',
            'Behandlungsplanung',
            Icons.medical_services,
            _handleTreatments,
          ),
          _buildFeatureCard(
            'Termine',
            'Terminverwaltung',
            Icons.event,
            _handleAppointments,
          ),
          _buildFeatureCard(
            'Dokumentation',
            'Patientendokumentation',
            Icons.folder,
            _handleDocumentation,
          ),
          _buildFeatureCard(
            'Medikamente',
            'Medikamentenverwaltung',
            Icons.medication,
            _handleMedications,
          ),
          _buildFeatureCard(
            'Einstellungen',
            'Krankenhaus-Einstellungen',
            Icons.settings,
            _handleSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConfig.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26,
                color: AppConfig.primaryColor,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: AppConfig.bodyStyle.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppConfig.bodyStyle.copyWith(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePatients() {
    SnackBarUtils.showInfoSnackBar(
        context, 'Patientenverwaltung - Coming Soon');
  }

  void _handleTreatments() {
    SnackBarUtils.showInfoSnackBar(context, 'Behandlungsplanung - Coming Soon');
  }

  void _handleAppointments() {
    SnackBarUtils.showInfoSnackBar(context, 'Terminverwaltung - Coming Soon');
  }

  void _handleDocumentation() {
    SnackBarUtils.showInfoSnackBar(
        context, 'Patientendokumentation - Coming Soon');
  }

  void _handleMedications() {
    SnackBarUtils.showInfoSnackBar(
        context, 'Medikamentenverwaltung - Coming Soon');
  }

  void _handleSettings() {
    SnackBarUtils.showInfoSnackBar(context, 'Einstellungen - Coming Soon');
  }

  void _handleLogout() async {
    try {
      await _authRepository.signOut();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/welcome',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
          context,
          'Fehler beim Abmelden: $e',
        );
      }
    }
  }
}
