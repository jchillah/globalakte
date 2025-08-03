// features/home/presentation/screens/police_home_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../authentication/data/repositories/auth_repository_impl.dart';

/// Polizei Home Screen für Benutzer mit der 'police' Rolle
class PoliceHomeScreen extends StatefulWidget {
  const PoliceHomeScreen({super.key});

  @override
  State<PoliceHomeScreen> createState() => _PoliceHomeScreenState();
}

class _PoliceHomeScreenState extends State<PoliceHomeScreen> {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Polizei Dashboard'),
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
              _buildPoliceFeatures(),
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
                Icons.local_police,
                size: 32,
                color: AppConfig.primaryColor,
              ),
              const SizedBox(width: AppConfig.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Willkommen bei der Polizei',
                      style: AppConfig.headlineStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Verwalten Sie Fälle, Berichte und Einsätze',
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

  Widget _buildPoliceFeatures() {
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
            'Fälle',
            'Fallverwaltung',
            Icons.folder,
            _handleCases,
          ),
          _buildFeatureCard(
            'Berichte',
            'Berichte erstellen',
            Icons.description,
            _handleReports,
          ),
          _buildFeatureCard(
            'Einsätze',
            'Einsatzverwaltung',
            Icons.emergency,
            _handleOperations,
          ),
          _buildFeatureCard(
            'Zeugen',
            'Zeugenvernehmung',
            Icons.person_search,
            _handleWitnesses,
          ),
          _buildFeatureCard(
            'Beweise',
            'Beweismittel',
            Icons.photo_camera,
            _handleEvidence,
          ),
          _buildFeatureCard(
            'Einstellungen',
            'Polizei-Einstellungen',
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

  void _handleCases() {
    SnackBarUtils.showInfoSnackBar(context, 'Fallverwaltung - Coming Soon');
  }

  void _handleReports() {
    SnackBarUtils.showInfoSnackBar(context, 'Berichtserstellung - Coming Soon');
  }

  void _handleOperations() {
    SnackBarUtils.showInfoSnackBar(context, 'Einsatzverwaltung - Coming Soon');
  }

  void _handleWitnesses() {
    SnackBarUtils.showInfoSnackBar(context, 'Zeugenvernehmung - Coming Soon');
  }

  void _handleEvidence() {
    SnackBarUtils.showInfoSnackBar(
        context, 'Beweismittelverwaltung - Coming Soon');
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
