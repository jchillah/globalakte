import 'package:flutter/material.dart';
import 'core/app_config.dart';
import 'core/app_theme.dart';

void main() {
  runApp(const GlobalAkteApp());
}

/// Haupt-App-Klasse für GlobalAkte
class GlobalAkteApp extends StatelessWidget {
  const GlobalAkteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Willkommens-Screen für GlobalAkte
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConfig.largePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon
              Container(
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
              ),
              
              const SizedBox(height: AppConfig.largePadding),
              
              // App Name
              Text(
                AppConfig.appName,
                style: AppConfig.headlineStyle.copyWith(fontSize: 32),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConfig.smallPadding),
              
              // App Description
              Text(
                AppConfig.appDescription,
                style: AppConfig.bodyStyle.copyWith(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConfig.largePadding * 2),
              
              // Features List
              _buildFeatureItem(
                icon: Icons.security,
                title: 'Sichere Authentifizierung',
                description: 'PIN & biometrische Sicherheit',
              ),
              
              const SizedBox(height: AppConfig.defaultPadding),
              
              _buildFeatureItem(
                icon: Icons.folder,
                title: 'Fallakten-Verwaltung',
                description: 'Digitale Akten mit ePA-Integration',
              ),
              
              const SizedBox(height: AppConfig.defaultPadding),
              
              _buildFeatureItem(
                icon: Icons.psychology,
                title: 'KI-gestützte Hilfe',
                description: 'LLM-Integration für rechtliche Beratung',
              ),
              
              const SizedBox(height: AppConfig.largePadding * 2),
              
              // Start Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigation zur Authentifizierung
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Authentifizierung wird implementiert...'),
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
              ),
              
              const SizedBox(height: AppConfig.defaultPadding),
              
              // Version Info
              Text(
                'Version ${AppConfig.appVersion}',
                style: AppConfig.bodyStyle.copyWith(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      decoration: BoxDecoration(
        color: AppConfig.surfaceColor,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppConfig.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
            ),
            child: Icon(
              icon,
              color: AppConfig.primaryColor,
              size: 24,
            ),
          ),
          
          const SizedBox(width: AppConfig.defaultPadding),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppConfig.titleStyle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppConfig.bodyStyle.copyWith(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
