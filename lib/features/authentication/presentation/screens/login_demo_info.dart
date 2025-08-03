// features/authentication/presentation/screens/login_demo_info.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/widgets/global_button.dart';

/// Demo-Info Screen mit Login-Daten
class LoginDemoInfo extends StatelessWidget {
  const LoginDemoInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Demo Login-Daten'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConfig.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: AppConfig.largePadding),
              _buildDemoAccounts(),
              const SizedBox(height: AppConfig.largePadding),
              _buildInstructions(),
              const SizedBox(height: AppConfig.largePadding),
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🔐 Demo Login-Daten',
          style: AppConfig.headlineStyle.copyWith(fontSize: 24),
        ),
        const SizedBox(height: AppConfig.smallPadding),
        Text(
          'Verwenden Sie diese Demo-Daten zum Testen der App:',
          style: AppConfig.bodyStyle.copyWith(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDemoAccounts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📧 Verfügbare Demo-Accounts:',
              style: AppConfig.bodyStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            _buildAccountCard(
              'demo@globalakte.de',
              'demo123',
              'Demo Benutzer',
              'citizen',
              Colors.blue,
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            _buildAccountCard(
              'test@globalakte.de',
              'test123',
              'Test Benutzer',
              'citizen',
              Colors.green,
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            _buildAccountCard(
              'admin@globalakte.de',
              'admin123',
              'Admin Benutzer',
              'admin',
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(
    String email,
    String password,
    String name,
    String role,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: color),
              const SizedBox(width: 8),
              Text(
                name,
                style: AppConfig.bodyStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  role,
                  style: AppConfig.bodyStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConfig.smallPadding),
          Text(
            'Email: $email',
            style: AppConfig.bodyStyle.copyWith(
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Passwort: $password',
            style: AppConfig.bodyStyle.copyWith(
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📋 Anleitung:',
              style: AppConfig.bodyStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            _buildInstructionStep(
              '1',
              'Gehen Sie zurück zum Login-Screen',
              Icons.arrow_back,
            ),
            const SizedBox(height: AppConfig.smallPadding),
            _buildInstructionStep(
              '2',
              'Geben Sie eine der Demo-Emails ein',
              Icons.email,
            ),
            const SizedBox(height: AppConfig.smallPadding),
            _buildInstructionStep(
              '3',
              'Geben Sie das zugehörige Passwort ein',
              Icons.lock,
            ),
            const SizedBox(height: AppConfig.smallPadding),
            _buildInstructionStep(
              '4',
              'Klicken Sie auf "Anmelden"',
              Icons.login,
            ),
            const SizedBox(height: AppConfig.smallPadding),
            _buildInstructionStep(
              '5',
              'Testen Sie die PIN- und Biometrie-Features',
              Icons.fingerprint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text, IconData icon) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppConfig.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              number,
              style: AppConfig.bodyStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppConfig.defaultPadding),
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppConfig.bodyStyle.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GlobalButton(
        onPressed: () => Navigator.of(context).pop(),
        text: 'Zurück zum Login',
      ),
    );
  }
}
