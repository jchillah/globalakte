// features/home/presentation/screens/social_worker_home_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../authentication/data/repositories/auth_repository_impl.dart';

/// Sozialarbeiter Home Screen für Benutzer mit der 'social_worker' Rolle
class SocialWorkerHomeScreen extends StatefulWidget {
  const SocialWorkerHomeScreen({super.key});

  @override
  State<SocialWorkerHomeScreen> createState() => _SocialWorkerHomeScreenState();
}

class _SocialWorkerHomeScreenState extends State<SocialWorkerHomeScreen> {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Sozialarbeiter Dashboard'),
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
              _buildSocialWorkerFeatures(),
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
                Icons.people,
                size: 32,
                color: AppConfig.primaryColor,
              ),
              const SizedBox(width: AppConfig.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Willkommen beim Sozialdienst',
                      style: AppConfig.headlineStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Verwalten Sie Klienten, Beratungen und Hilfsangebote',
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

  Widget _buildSocialWorkerFeatures() {
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
            'Klienten',
            'Klientenverwaltung',
            Icons.person,
            _handleClients,
          ),
          _buildFeatureCard(
            'Beratungen',
            'Beratungstermine',
            Icons.psychology,
            _handleCounseling,
          ),
          _buildFeatureCard(
            'Hilfsangebote',
            'Hilfsangebote verwalten',
            Icons.help,
            _handleSupport,
          ),
          _buildFeatureCard(
            'Dokumentation',
            'Fall-Dokumentation',
            Icons.folder,
            _handleDocumentation,
          ),
          _buildFeatureCard(
            'Netzwerk',
            'Netzwerk-Partner',
            Icons.network_check,
            _handleNetwork,
          ),
          _buildFeatureCard(
            'Einstellungen',
            'Sozialarbeiter-Einstellungen',
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

  void _handleClients() {
    SnackBarUtils.showInfoSnackBar(context, 'Klientenverwaltung - Coming Soon');
  }

  void _handleCounseling() {
    SnackBarUtils.showInfoSnackBar(context, 'Beratungstermine - Coming Soon');
  }

  void _handleSupport() {
    SnackBarUtils.showInfoSnackBar(context, 'Hilfsangebote - Coming Soon');
  }

  void _handleDocumentation() {
    SnackBarUtils.showInfoSnackBar(context, 'Fall-Dokumentation - Coming Soon');
  }

  void _handleNetwork() {
    SnackBarUtils.showInfoSnackBar(context, 'Netzwerk-Partner - Coming Soon');
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
