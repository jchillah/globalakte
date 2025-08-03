// features/home/presentation/screens/court_home_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';

/// Court Home Screen für Gerichtsmitarbeiter
class CourtHomeScreen extends StatefulWidget {
  const CourtHomeScreen({super.key});

  @override
  State<CourtHomeScreen> createState() => _CourtHomeScreenState();
}

class _CourtHomeScreenState extends State<CourtHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Gericht'),
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
              _buildCourtFeatures(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConfig.largePadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConfig.primaryColor,
            AppConfig.primaryColor.withValues(alpha: 0.8)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConfig.largeRadius),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppConfig.defaultPadding),
          const Text(
            'Willkommen beim Gericht',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConfig.smallPadding),
          const Text(
            'Verwaltung von Gerichtsverfahren und Urteilen',
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

  Widget _buildCourtFeatures() {
    return SizedBox(
      height: 300,
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: AppConfig.defaultPadding,
        mainAxisSpacing: AppConfig.defaultPadding,
        childAspectRatio: 1.4,
        children: [
          _buildFeatureCard(
            icon: Icons.gavel,
            title: 'Verfahren',
            subtitle: 'Gerichtsverfahren verwalten',
            color: Colors.blue,
            onTap: _handleProceedings,
          ),
          _buildFeatureCard(
            icon: Icons.description,
            title: 'Urteile',
            subtitle: 'Urteile und Beschlüsse',
            color: Colors.green,
            onTap: _handleJudgments,
          ),
          _buildFeatureCard(
            icon: Icons.calendar_today,
            title: 'Termine',
            subtitle: 'Verhandlungstermine',
            color: Colors.orange,
            onTap: _handleHearings,
          ),
          _buildFeatureCard(
            icon: Icons.people,
            title: 'Beteiligte',
            subtitle: 'Anwälte und Parteien',
            color: Colors.purple,
            onTap: _handleParties,
          ),
          _buildFeatureCard(
            icon: Icons.folder,
            title: 'Akten',
            subtitle: 'Gerichtsakten verwalten',
            color: Colors.indigo,
            onTap: _handleFiles,
          ),
          _buildFeatureCard(
            icon: Icons.settings,
            title: 'Einstellungen',
            subtitle: 'Gerichts-Konfiguration',
            color: Colors.red,
            onTap: _handleSettings,
          ),
        ],
      ),
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
                  size: 26,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppConfig.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
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

  void _handleLogout() {
    SnackBarUtils.showInfoSnackBar(context, 'Abmeldung - Coming Soon');
  }

  void _handleProceedings() {
    SnackBarUtils.showInfoSnackBar(context, 'Gerichtsverfahren - Coming Soon');
  }

  void _handleJudgments() {
    SnackBarUtils.showInfoSnackBar(context, 'Urteile - Coming Soon');
  }

  void _handleHearings() {
    SnackBarUtils.showInfoSnackBar(
        context, 'Verhandlungstermine - Coming Soon');
  }

  void _handleParties() {
    SnackBarUtils.showInfoSnackBar(context, 'Beteiligte - Coming Soon');
  }

  void _handleFiles() {
    SnackBarUtils.showInfoSnackBar(context, 'Gerichtsakten - Coming Soon');
  }

  void _handleSettings() {
    SnackBarUtils.showInfoSnackBar(context, 'Einstellungen - Coming Soon');
  }
}
