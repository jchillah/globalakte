// features/home/presentation/screens/lawyer_home_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../authentication/data/repositories/auth_repository_impl.dart';

/// Home-Screen für Anwälte
class LawyerHomeScreen extends StatefulWidget {
  const LawyerHomeScreen({super.key});

  @override
  State<LawyerHomeScreen> createState() => _LawyerHomeScreenState();
}

class _LawyerHomeScreenState extends State<LawyerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Verhindert Zurück-Button
        title: const Text('GlobalAkte - Anwalt'),
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
              _buildLawyerFeatures(),
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
            'Willkommen Anwalt',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConfig.smallPadding),
          const Text(
            'Verwalten Sie Ihre Mandanten und Fälle',
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

  Widget _buildLawyerFeatures() {
    return SizedBox(
      height: 400, // Feste Höhe für scrollbaren Bereich
      child: GridView.count(
        physics: const BouncingScrollPhysics(), // Scrollbar machen
        crossAxisCount: 2,
        crossAxisSpacing: AppConfig.defaultPadding,
        mainAxisSpacing: AppConfig.defaultPadding,
        childAspectRatio: 1.4,
        children: [
          _buildFeatureCard(
            icon: Icons.folder,
            title: 'Mandanten',
            subtitle: 'Kunden verwalten',
            color: Colors.blue,
            onTap: _handleClients,
          ),
          _buildFeatureCard(
            icon: Icons.description,
            title: 'Fälle',
            subtitle: 'Aktive Verfahren',
            color: Colors.green,
            onTap: _handleCases,
          ),
          _buildFeatureCard(
            icon: Icons.calendar_today,
            title: 'Termine',
            subtitle: 'Gerichtstermine',
            color: Colors.orange,
            onTap: _handleAppointments,
          ),
          _buildFeatureCard(
            icon: Icons.account_balance,
            title: 'Gerichte',
            subtitle: 'Kontakte & Adressen',
            color: Colors.purple,
            onTap: _handleCourts,
          ),
          // Zusätzliche Features für Anwälte
          _buildFeatureCard(
            icon: Icons.gavel,
            title: 'Rechtsmittel',
            subtitle: 'Einspruch & Revision',
            color: Colors.indigo,
            onTap: _handleLegalRemedies,
          ),
          _buildFeatureCard(
            icon: Icons.payment,
            title: 'Honorare',
            subtitle: 'Abrechnung',
            color: Colors.red,
            onTap: _handleFees,
          ),
          _buildFeatureCard(
            icon: Icons.message,
            title: 'Kommunikation',
            subtitle: 'Mandantenkontakt',
            color: Colors.teal,
            onTap: _handleCommunication,
          ),
          _buildFeatureCard(
            icon: Icons.settings,
            title: 'Einstellungen',
            subtitle: 'App-Konfiguration',
            color: Colors.amber,
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
          text: 'Neuen Mandanten',
          onPressed: _handleNewClient,
          icon: Icons.person_add,
        ),
        const SizedBox(height: AppConfig.defaultPadding),
        GlobalButton(
          text: 'Fall erstellen',
          onPressed: _handleNewCase,
          icon: Icons.folder_open,
        ),
      ],
    );
  }

  void _handleClients() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Mandanten-Verwaltung wird implementiert...',
    );
  }

  void _handleCases() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Fall-Verwaltung wird implementiert...',
    );
  }

  void _handleAppointments() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Termin-Verwaltung wird implementiert...',
    );
  }

  void _handleCourts() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Gerichte-Verwaltung wird implementiert...',
    );
  }

  void _handleNewClient() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Neuen Mandanten erstellen wird implementiert...',
    );
  }

  void _handleNewCase() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Neuen Fall erstellen wird implementiert...',
    );
  }

  void _handleLegalRemedies() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Rechtsmittel-Verwaltung wird implementiert...',
    );
  }

  void _handleFees() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Honorar-Verwaltung wird implementiert...',
    );
  }

  void _handleCommunication() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Kommunikation wird implementiert...',
    );
  }

  void _handleSettings() {
    SnackBarUtils.showInfoSnackBar(
      context,
      'Einstellungen werden implementiert...',
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
