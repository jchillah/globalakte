// features/home/presentation/screens/school_home_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';

/// School Home Screen für Schulmitarbeiter
class SchoolHomeScreen extends StatefulWidget {
  const SchoolHomeScreen({super.key});

  @override
  State<SchoolHomeScreen> createState() => _SchoolHomeScreenState();
}

class _SchoolHomeScreenState extends State<SchoolHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Schule'),
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
              _buildSchoolFeatures(),
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
            'Willkommen in der Schule',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConfig.smallPadding),
          const Text(
            'Verwaltung von Schülerakten und Bildungsprozessen',
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

  Widget _buildSchoolFeatures() {
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
            icon: Icons.school,
            title: 'Schüler',
            subtitle: 'Schülerakten verwalten',
            color: Colors.blue,
            onTap: _handleStudents,
          ),
          _buildFeatureCard(
            icon: Icons.class_,
            title: 'Klassen',
            subtitle: 'Klassenverwaltung',
            color: Colors.green,
            onTap: _handleClasses,
          ),
          _buildFeatureCard(
            icon: Icons.assignment,
            title: 'Noten',
            subtitle: 'Leistungsbewertung',
            color: Colors.orange,
            onTap: _handleGrades,
          ),
          _buildFeatureCard(
            icon: Icons.event,
            title: 'Termine',
            subtitle: 'Schulveranstaltungen',
            color: Colors.purple,
            onTap: _handleEvents,
          ),
          _buildFeatureCard(
            icon: Icons.people,
            title: 'Lehrer',
            subtitle: 'Lehrerkollegium',
            color: Colors.indigo,
            onTap: _handleTeachers,
          ),
          _buildFeatureCard(
            icon: Icons.settings,
            title: 'Einstellungen',
            subtitle: 'Schul-Konfiguration',
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

  void _handleStudents() {
    SnackBarUtils.showInfoSnackBar(context, 'Schülerakten - Coming Soon');
  }

  void _handleClasses() {
    SnackBarUtils.showInfoSnackBar(context, 'Klassenverwaltung - Coming Soon');
  }

  void _handleGrades() {
    SnackBarUtils.showInfoSnackBar(context, 'Notenverwaltung - Coming Soon');
  }

  void _handleEvents() {
    SnackBarUtils.showInfoSnackBar(
        context, 'Schulveranstaltungen - Coming Soon');
  }

  void _handleTeachers() {
    SnackBarUtils.showInfoSnackBar(context, 'Lehrerkollegium - Coming Soon');
  }

  void _handleSettings() {
    SnackBarUtils.showInfoSnackBar(context, 'Einstellungen - Coming Soon');
  }
}
