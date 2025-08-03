// features/home/presentation/screens/kindergarten_home_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../authentication/data/repositories/auth_repository_impl.dart';

/// Kindergarten Home Screen für Benutzer mit der 'kindergarten' Rolle
class KindergartenHomeScreen extends StatefulWidget {
  const KindergartenHomeScreen({super.key});

  @override
  State<KindergartenHomeScreen> createState() => _KindergartenHomeScreenState();
}

class _KindergartenHomeScreenState extends State<KindergartenHomeScreen> {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Kindergarten Dashboard'),
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
              _buildKindergartenFeatures(),
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
                Icons.child_care,
                size: 32,
                color: AppConfig.primaryColor,
              ),
              const SizedBox(width: AppConfig.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Willkommen im Kindergarten',
                      style: AppConfig.headlineStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Verwalten Sie Kinder, Aktivitäten und Kommunikation',
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

  Widget _buildKindergartenFeatures() {
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
            'Kinder',
            'Kinder verwalten',
            Icons.child_care,
            _handleChildren,
          ),
          _buildFeatureCard(
            'Gruppen',
            'Gruppen organisieren',
            Icons.group,
            _handleGroups,
          ),
          _buildFeatureCard(
            'Aktivitäten',
            'Aktivitäten planen',
            Icons.games,
            _handleActivities,
          ),
          _buildFeatureCard(
            'Termine',
            'Termine verwalten',
            Icons.event,
            _handleEvents,
          ),
          _buildFeatureCard(
            'Eltern',
            'Elternkommunikation',
            Icons.family_restroom,
            _handleParents,
          ),
          _buildFeatureCard(
            'Einstellungen',
            'Kindergarten-Einstellungen',
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

  void _handleChildren() {
    SnackBarUtils.showInfoSnackBar(context, 'Kinderverwaltung - Coming Soon');
  }

  void _handleGroups() {
    SnackBarUtils.showInfoSnackBar(context, 'Gruppenverwaltung - Coming Soon');
  }

  void _handleActivities() {
    SnackBarUtils.showInfoSnackBar(context, 'Aktivitätenplanung - Coming Soon');
  }

  void _handleEvents() {
    SnackBarUtils.showInfoSnackBar(context, 'Terminverwaltung - Coming Soon');
  }

  void _handleParents() {
    SnackBarUtils.showInfoSnackBar(
        context, 'Elternkommunikation - Coming Soon');
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
