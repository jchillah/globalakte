// features/home/presentation/screens/citizen_home_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../authentication/data/repositories/auth_repository_impl.dart';

/// Home-Screen für Bürger
class CitizenHomeScreen extends StatefulWidget {
  const CitizenHomeScreen({super.key});

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Verhindert Zurück-Button
        title: const Text('GlobalAkte - Bürger'),
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
              _buildCitizenFeatures(),
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
            Icons.person,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: AppConfig.defaultPadding),
          const Text(
            'Willkommen Bürger',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConfig.smallPadding),
          const Text(
            'Verwalten Sie Ihre persönlichen Fallakten',
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

  Widget _buildCitizenFeatures() {
    return SizedBox(
      height: 400,
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: AppConfig.defaultPadding,
        mainAxisSpacing: AppConfig.defaultPadding,
        childAspectRatio: 1.4,
        children: [
          _buildFeatureCard(
            icon: Icons.folder,
            title: 'Meine Fälle',
            subtitle: 'Persönliche Fallakten',
            color: Colors.blue,
            onTap: _handleMyCases,
          ),
          _buildFeatureCard(
            icon: Icons.description,
            title: 'Dokumente',
            subtitle: 'Meine Unterlagen',
            color: Colors.green,
            onTap: _handleDocuments,
          ),
          _buildFeatureCard(
            icon: Icons.calendar_today,
            title: 'Termine',
            subtitle: 'Wichtige Fristen',
            color: Colors.orange,
            onTap: _handleAppointments,
          ),
          _buildFeatureCard(
            icon: Icons.message,
            title: 'Nachrichten',
            subtitle: 'Kommunikation',
            color: Colors.purple,
            onTap: _handleMessages,
          ),
          // Zusätzliche Features für Demo-Zwecke
          _buildFeatureCard(
            icon: Icons.security,
            title: 'Sicherheit',
            subtitle: 'Datenschutz',
            color: Colors.indigo,
            onTap: _handleSecurity,
          ),
          _buildFeatureCard(
            icon: Icons.settings,
            title: 'Einstellungen',
            subtitle: 'App-Konfiguration',
            color: Colors.red,
            onTap: _handleSettings,
          ),
          _buildFeatureCard(
            icon: Icons.help,
            title: 'Hilfe',
            subtitle: 'Support & FAQ',
            color: Colors.teal,
            onTap: _handleHelp,
          ),
          _buildFeatureCard(
            icon: Icons.notifications,
            title: 'Benachrichtigungen',
            subtitle: 'Aktuelle Updates',
            color: Colors.amber,
            onTap: _handleNotifications,
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
                  size: 24,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 9,
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

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlobalButton(
          text: 'Neuen Fall melden',
          onPressed: _handleReportCase,
          icon: Icons.add_alert,
        ),
        const SizedBox(height: AppConfig.defaultPadding),
        GlobalButton(
          text: 'Hilfe & Support',
          onPressed: _handleHelpSupport,
          icon: Icons.help_outline,
        ),
      ],
    );
  }

  void _handleMyCases() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Meine Fälle wird implementiert...',
    );
  }

  void _handleDocuments() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Dokumente-Verwaltung wird implementiert...',
    );
  }

  void _handleAppointments() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Termin-Verwaltung wird implementiert...',
    );
  }

  void _handleMessages() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Nachrichten-System wird implementiert...',
    );
  }

  void _handleReportCase() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Fall melden wird implementiert...',
    );
  }

  void _handleHelpSupport() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Hilfe & Support wird implementiert...',
    );
  }

  void _handleSecurity() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Sicherheit & Datenschutz wird implementiert...',
    );
  }

  void _handleSettings() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Einstellungen werden implementiert...',
    );
  }

  void _handleHelp() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Hilfe & FAQ wird implementiert...',
    );
  }

  void _handleNotifications() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Benachrichtigungen werden implementiert...',
    );
  }

  Future<void> _handleLogout() async {
    try {
      final authRepository = AuthRepositoryImpl();
      await authRepository.signOut();

      if (!mounted) return;

      SnackBarUtils.showSuccessSnackBar(
        context,
        'Erfolgreich abgemeldet',
      );

      Navigator.of(context).pushReplacementNamed('/welcome');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
        context,
        'Abmeldung fehlgeschlagen: ${e.toString()}',
      );
    }
  }
}
