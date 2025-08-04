// features/welcome/presentation/screens/welcome_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/feature_card.dart';
import '../../../authentication/presentation/screens/login_screen.dart';

/// Willkommens-Screen für GlobalAkte
/// Verantwortlich für die Darstellung der App-Übersicht und Navigation
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConfig.largePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon
              _buildAppLogo(),

              const SizedBox(height: AppConfig.largePadding),

              // App Name
              _buildAppTitle(),

              const SizedBox(height: AppConfig.smallPadding),

              // App Description
              _buildAppDescription(),

              const SizedBox(height: AppConfig.largePadding * 2),

              // Features List
              _buildFeaturesList(),

              const SizedBox(height: AppConfig.largePadding * 2),

              // Start Button
              _buildStartButton(context),

              const SizedBox(height: AppConfig.defaultPadding),

              // Demo Buttons (nur im Debug-Modus)
              if (kDebugMode) ...[
                _buildDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
                _buildEncryptionDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
                _buildCaseFilesDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
                _buildCommunicationDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
                _buildDocumentManagementDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
                _buildAccessibilityDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
                _buildLegalAiDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
                _buildHelpNetworkDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
                _buildNotificationDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
                _buildEvidenceCollectionDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
                _buildAppointmentDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
                _buildEpaIntegrationDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
                _buildPdfGeneratorDemoButton(context),
                const SizedBox(height: AppConfig.defaultPadding),
              ],

              // Version Info
              _buildVersionInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppConfig.primaryColor,
        borderRadius: BorderRadius.circular(AppConfig.largeRadius),
      ),
      child: const Icon(
        Icons.gavel,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAppTitle() {
    return Text(
      AppConfig.appName,
      style: AppConfig.headlineStyle.copyWith(fontSize: 32),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAppDescription() {
    return Text(
      AppConfig.appDescription,
      style: AppConfig.bodyStyle.copyWith(
        fontSize: 18,
        color: Colors.grey[600],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      children: [
        FeatureCard(
          icon: Icons.security,
          title: 'Sichere Authentifizierung',
          description: 'PIN & biometrische Sicherheit',
        ),
        const SizedBox(height: AppConfig.defaultPadding),
        FeatureCard(
          icon: Icons.folder,
          title: 'Fallakten-Verwaltung',
          description: 'Digitale Akten mit ePA-Integration',
        ),
        const SizedBox(height: AppConfig.defaultPadding),
        FeatureCard(
          icon: Icons.psychology,
          title: 'KI-gestützte Hilfe',
          description: 'LLM-Integration für rechtliche Beratung',
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: AppConfig.defaultPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
        ),
        child: const Text(
          'Jetzt starten',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDemoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showSnackBarDemo(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.secondaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: AppConfig.defaultPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
        ),
        child: const Text(
          'SnackBar Demo testen',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEncryptionDemoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/encryption-demo');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: AppConfig.defaultPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
        ),
        child: const Text(
          '🔐 Verschlüsselung Demo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showSnackBarDemo(BuildContext context) {
    const String standardSnackBarMessage = 'Dies ist eine Standard-SnackBar';
    const String successSnackBarMessage =
        'Operation erfolgreich abgeschlossen!';
    const String errorSnackBarMessage = 'Ein Fehler ist aufgetreten!';
    const String longSnackBarMessage =
        'Dies ist eine sehr lange SnackBar-Nachricht, um zu testen, wie sich die SnackBar auf verschiedenen Bildschirmgrößen und Plattformen verhält. Sie sollte sowohl auf iOS als auch auf Android korrekt angezeigt werden.';
    const Duration longSnackBarDuration = AppConfig.snackBarLongDuration;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SnackBar Demo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSnackBarDemoTile(
              context: context,
              icon: Icons.info,
              title: 'Standard SnackBar',
              message: standardSnackBarMessage,
            ),
            _buildSnackBarDemoTile(
              context: context,
              icon: Icons.check_circle,
              title: 'Erfolgs-SnackBar',
              message: successSnackBarMessage,
              isSuccess: true,
            ),
            _buildSnackBarDemoTile(
              context: context,
              icon: Icons.error,
              title: 'Fehler-SnackBar',
              message: errorSnackBarMessage,
              isError: true,
            ),
            _buildSnackBarDemoTile(
              context: context,
              icon: Icons.warning,
              title: 'Lange SnackBar',
              message: longSnackBarMessage,
              duration: longSnackBarDuration,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }

  Widget _buildSnackBarDemoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String message,
    bool isSuccess = false,
    bool isError = false,
    Duration? duration,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => _handleSnackBarDemoTap(
        context: context,
        message: message,
        isSuccess: isSuccess,
        isError: isError,
        duration: duration,
      ),
    );
  }

  void _handleSnackBarDemoTap({
    required BuildContext context,
    required String message,
    required bool isSuccess,
    required bool isError,
    Duration? duration,
  }) {
    Navigator.of(context).pop();

    if (isSuccess) {
      SnackBarUtils.showSuccessSnackBar(context, message);
    } else if (isError) {
      SnackBarUtils.showErrorSnackBar(context, message);
    } else {
      SnackBarUtils.showSnackBar(context, message);
    }
  }

  Widget _buildCaseFilesDemoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/case-files-demo');
        },
        icon: const Icon(Icons.folder),
        label: const Text('📁 Fallakten Demo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(vertical: AppConfig.defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildCommunicationDemoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/communication');
        },
        icon: const Icon(Icons.chat),
        label: const Text('💬 Kommunikation Demo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(vertical: AppConfig.defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentManagementDemoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/document-management');
        },
        icon: const Icon(Icons.description),
        label: const Text('📄 Dokumentenverwaltung Demo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(vertical: AppConfig.defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildAccessibilityDemoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/accessibility-demo');
        },
        icon: const Icon(Icons.accessibility_new),
        label: const Text('♿ Barrierefreiheit Demo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(vertical: AppConfig.defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildLegalAiDemoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/legal-ai-demo');
        },
        icon: const Icon(Icons.psychology),
        label: const Text('🤖 Legal AI Demo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(vertical: AppConfig.defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpNetworkDemoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/help-network-demo');
        },
        icon: const Icon(Icons.people),
        label: const Text('🤝 Hilfe-Netzwerk Demo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(vertical: AppConfig.defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationDemoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/notification-demo');
        },
        icon: const Icon(Icons.notifications),
        label: const Text('🔔 Benachrichtigungen Demo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(vertical: AppConfig.defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildEvidenceCollectionDemoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/evidence-collection-demo');
        },
        icon: const Icon(Icons.photo_camera),
        label: const Text('📸 Beweismittel Demo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(vertical: AppConfig.defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentDemoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/appointment-demo');
        },
        icon: const Icon(Icons.calendar_month),
        label: const Text('📅 Terminverwaltung Demo'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(vertical: AppConfig.defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildEpaIntegrationDemoButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, '/epa-integration-demo'),
      icon: const Icon(Icons.cloud_sync, color: Colors.white),
      label: const Text(
        'ePA-Integration Demo',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConfig.largePadding,
          vertical: AppConfig.defaultPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        ),
      ),
    );
  }

  Widget _buildPdfGeneratorDemoButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, '/pdf-generator-demo'),
      icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
      label: const Text(
        'PDF-Generator Demo',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConfig.largePadding,
          vertical: AppConfig.defaultPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Text(
      'Version ${AppConfig.appVersion}',
      style: AppConfig.bodyStyle.copyWith(
        fontSize: 12,
        color: Colors.grey[500],
      ),
    );
  }
}
