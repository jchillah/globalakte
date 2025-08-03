// features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';

/// Home Screen - Hauptseite nach erfolgreicher Anmeldung
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('GlobalAkte'),
        centerTitle: true,
        elevation: 0,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWelcomeHeader(),
              const SizedBox(height: AppConfig.largePadding * 2),
              _buildFeatureGrid(),
              const SizedBox(height: AppConfig.largePadding),
              _buildQuickActions(),
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
        gradient: LinearGradient(
          colors: [
            AppConfig.primaryColor,
            AppConfig.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConfig.largeRadius),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.gavel,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: AppConfig.defaultPadding),
          const Text(
            'Willkommen bei GlobalAkte',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConfig.smallPadding),
          const Text(
            'Ihre sichere Plattform für Fallakten-Management',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppConfig.defaultPadding,
      mainAxisSpacing: AppConfig.defaultPadding,
      childAspectRatio: 1.2,
      children: [
        _buildFeatureCard(
          icon: Icons.folder,
          title: 'Fallakten',
          subtitle: 'Verwalten Sie Ihre Fälle',
          color: Colors.blue,
          onTap: _handleCaseFiles,
        ),
        _buildFeatureCard(
          icon: Icons.security,
          title: 'Verschlüsselung',
          subtitle: 'Sichere Datenübertragung',
          color: Colors.green,
          onTap: _handleEncryption,
        ),
        _buildFeatureCard(
          icon: Icons.timeline,
          title: 'Timeline',
          subtitle: 'Fallverlauf verfolgen',
          color: Colors.orange,
          onTap: _handleTimeline,
        ),
        _buildFeatureCard(
          icon: Icons.people,
          title: 'Kontakte',
          subtitle: 'Netzwerk verwalten',
          color: Colors.purple,
          onTap: _handleContacts,
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConfig.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConfig.defaultPadding),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: AppConfig.defaultPadding),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConfig.smallPadding),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlobalButton(
          text: 'Neue Fallakte erstellen',
          onPressed: _handleCreateCase,
          icon: Icons.add,
        ),
        const SizedBox(height: AppConfig.defaultPadding),
        GlobalButton(
          text: 'Schnellzugriff',
          onPressed: _handleQuickAccess,
          icon: Icons.speed,
        ),
      ],
    );
  }

  void _handleCaseFiles() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Fallakten-Verwaltung wird implementiert...',
    );
  }

  void _handleEncryption() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Verschlüsselungs-Demo wird geöffnet...',
    );
  }

  void _handleTimeline() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Timeline-Feature wird implementiert...',
    );
  }

  void _handleContacts() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Kontakte-Verwaltung wird implementiert...',
    );
  }

  void _handleCreateCase() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Neue Fallakte erstellen wird implementiert...',
    );
  }

  void _handleQuickAccess() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Schnellzugriff wird implementiert...',
    );
  }

  void _handleLogout() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Abmeldung wird implementiert...',
    );
    // TODO: Implementiere Logout-Logik
    Navigator.of(context).pushReplacementNamed('/welcome');
  }
} 