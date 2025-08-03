// features/home/presentation/screens/admin_home_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../authentication/data/repositories/auth_repository_impl.dart';

/// Home-Screen für Administratoren
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Verhindert Zurück-Button
        title: const Text('GlobalAkte - Admin'),
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
              _buildAdminFeatures(),
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
            Icons.admin_panel_settings,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: AppConfig.defaultPadding),
          const Text(
            'Willkommen Administrator',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConfig.smallPadding),
          const Text(
            'System-Verwaltung und Überwachung',
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

  Widget _buildAdminFeatures() {
    return SizedBox(
      height: 300, // Feste Höhe für scrollbaren Bereich
      child: GridView.count(
        physics: const BouncingScrollPhysics(), // Scrollbar machen
        crossAxisCount: 2,
        crossAxisSpacing: AppConfig.defaultPadding,
        mainAxisSpacing: AppConfig.defaultPadding,
        childAspectRatio: 1.4,
        children: [
          _buildFeatureCard(
            icon: Icons.people,
            title: 'Benutzer',
            subtitle: 'Verwaltung',
            color: Colors.blue,
            onTap: _handleUsers,
          ),
          _buildFeatureCard(
            icon: Icons.security,
            title: 'Sicherheit',
            subtitle: 'Verschlüsselung',
            color: Colors.green,
            onTap: _handleSecurity,
          ),
          _buildFeatureCard(
            icon: Icons.analytics,
            title: 'Statistiken',
            subtitle: 'System-Monitoring',
            color: Colors.orange,
            onTap: _handleStatistics,
          ),
          _buildFeatureCard(
            icon: Icons.settings,
            title: 'Einstellungen',
            subtitle: 'System-Konfiguration',
            color: Colors.purple,
            onTap: _handleSettings,
          ),
          // Zusätzliche Admin-Features
          _buildFeatureCard(
            icon: Icons.backup,
            title: 'Backup',
            subtitle: 'Daten-Sicherung',
            color: Colors.indigo,
            onTap: _handleBackup,
          ),
          _buildFeatureCard(
            icon: Icons.update,
            title: 'Updates',
            subtitle: 'System-Updates',
            color: Colors.red,
            onTap: _handleUpdates,
          ),
          _buildFeatureCard(
            icon: Icons.article,
            title: 'Logs',
            subtitle: 'System-Logs',
            color: Colors.teal,
            onTap: _handleLogs,
          ),
          _buildFeatureCard(
            icon: Icons.support,
            title: 'Support',
            subtitle: 'Technischer Support',
            color: Colors.amber,
            onTap: _handleSupport,
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
          text: 'System-Backup',
          onPressed: _handleSystemBackup,
          icon: Icons.backup,
        ),
        const SizedBox(height: AppConfig.defaultPadding),
        GlobalButton(
          text: 'Logs anzeigen',
          onPressed: _handleViewLogs,
          icon: Icons.list_alt,
        ),
      ],
    );
  }

  void _handleUsers() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Benutzer-Verwaltung wird implementiert...',
    );
  }

  void _handleSecurity() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Sicherheits-Verwaltung wird implementiert...',
    );
  }

  void _handleStatistics() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Statistik-Dashboard wird implementiert...',
    );
  }

  void _handleSettings() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'System-Einstellungen wird implementiert...',
    );
  }

  void _handleSystemBackup() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'System-Backup wird implementiert...',
    );
  }

  void _handleViewLogs() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'System-Logs werden implementiert...',
    );
  }

  void _handleBackup() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Backup-System wird implementiert...',
    );
  }

  void _handleUpdates() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'System-Updates werden implementiert...',
    );
  }

  void _handleLogs() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'System-Logs werden implementiert...',
    );
  }

  void _handleSupport() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Technischer Support wird implementiert...',
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
