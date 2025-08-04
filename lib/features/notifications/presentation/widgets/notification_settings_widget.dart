// features/notifications/presentation/widgets/notification_settings_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../domain/entities/push_settings.dart';
import '../../domain/usecases/notification_usecases.dart';

/// Widget für Benachrichtigungseinstellungen
class NotificationSettingsWidget extends StatefulWidget {
  final NotificationUseCases useCases;

  const NotificationSettingsWidget({
    super.key,
    required this.useCases,
  });

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  PushSettings _settings = PushSettings.defaultSettings();
  bool _isLoading = true;
  String? _deviceToken;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final settings = await widget.useCases.getPushSettings();
      final deviceToken = await widget.useCases.getDeviceToken();

      setState(() {
        _settings = settings;
        _deviceToken = deviceToken;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden: $e')),
        );
      }
    }
  }

  Future<void> _togglePushNotifications(bool enabled) async {
    try {
      await widget.useCases.togglePushNotifications(enabled);
      setState(() {
        _settings = _settings.copyWith(isEnabled: enabled);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(enabled
                ? 'Push-Benachrichtigungen aktiviert'
                : 'Push-Benachrichtigungen deaktiviert'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    }
  }

  Future<void> _updateNotificationPreferences({
    bool? caseNotifications,
    bool? documentNotifications,
    bool? appointmentNotifications,
    bool? systemNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) async {
    try {
      await widget.useCases.updateNotificationPreferences(
        caseNotifications: caseNotifications,
        documentNotifications: documentNotifications,
        appointmentNotifications: appointmentNotifications,
        systemNotifications: systemNotifications,
        soundEnabled: soundEnabled,
        vibrationEnabled: vibrationEnabled,
      );

      setState(() {
        _settings = _settings.copyWith(
          caseNotifications: caseNotifications,
          documentNotifications: documentNotifications,
          appointmentNotifications: appointmentNotifications,
          systemNotifications: systemNotifications,
          soundEnabled: soundEnabled,
          vibrationEnabled: vibrationEnabled,
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Einstellungen aktualisiert')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    }
  }

  Future<void> _requestDeviceToken() async {
    try {
      // Mock Device Token generieren
      final mockToken =
          'mock_device_token_${DateTime.now().millisecondsSinceEpoch}';
      await widget.useCases.saveDeviceToken(mockToken);

      setState(() {
        _deviceToken = mockToken;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Device Token generiert')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Generieren: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainSettings(),
                const SizedBox(height: 24),
                _buildNotificationTypes(),
                const SizedBox(height: 24),
                _buildDeviceSettings(),
                const SizedBox(height: 24),
                _buildAdvancedSettings(),
              ],
            ),
          );
  }

  Widget _buildMainSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications, color: AppConfig.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Push-Benachrichtigungen',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Push-Benachrichtigungen aktivieren'),
              subtitle:
                  const Text('Erhalten Sie Benachrichtigungen auf Ihrem Gerät'),
              value: _settings.isEnabled,
              onChanged: _togglePushNotifications,
            ),
            if (_settings.isEnabled) ...[
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Sound aktivieren'),
                subtitle:
                    const Text('Spielt einen Ton bei neuen Benachrichtigungen'),
                value: _settings.soundEnabled,
                onChanged: (value) =>
                    _updateNotificationPreferences(soundEnabled: value),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Vibration aktivieren'),
                subtitle: const Text('Vibriert bei neuen Benachrichtigungen'),
                value: _settings.vibrationEnabled,
                onChanged: (value) =>
                    _updateNotificationPreferences(vibrationEnabled: value),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTypes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: AppConfig.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Benachrichtigungstypen',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Fallakten-Benachrichtigungen'),
              subtitle:
                  const Text('Benachrichtigungen zu Fallakten und Verfahren'),
              value: _settings.caseNotifications,
              onChanged: (value) =>
                  _updateNotificationPreferences(caseNotifications: value),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Dokumenten-Benachrichtigungen'),
              subtitle:
                  const Text('Benachrichtigungen zu Dokumenten und Uploads'),
              value: _settings.documentNotifications,
              onChanged: (value) =>
                  _updateNotificationPreferences(documentNotifications: value),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Termin-Benachrichtigungen'),
              subtitle:
                  const Text('Erinnerungen zu Terminen und Verhandlungen'),
              value: _settings.appointmentNotifications,
              onChanged: (value) => _updateNotificationPreferences(
                  appointmentNotifications: value),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('System-Benachrichtigungen'),
              subtitle: const Text('Wartung, Updates und System-Nachrichten'),
              value: _settings.systemNotifications,
              onChanged: (value) =>
                  _updateNotificationPreferences(systemNotifications: value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.device_hub, color: AppConfig.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Geräte-Einstellungen',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Device Token'),
              subtitle: Text(_deviceToken ?? 'Nicht verfügbar'),
              trailing: ElevatedButton(
                onPressed: _requestDeviceToken,
                child: const Text('Generieren'),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Letzte Aktualisierung'),
              subtitle: Text(_settings.lastUpdated.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, color: AppConfig.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Erweiterte Einstellungen',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Einstellungen zurücksetzen'),
              subtitle: const Text(
                  'Setzt alle Einstellungen auf Standardwerte zurück'),
              onTap: () => _showResetDialog(),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Über Push-Benachrichtigungen'),
              subtitle:
                  const Text('Informationen zu Datenschutz und Funktionalität'),
              onTap: () => _showInfoDialog(),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Einstellungen zurücksetzen'),
        content: const Text(
            'Sind Sie sicher, dass Sie alle Benachrichtigungseinstellungen auf Standardwerte zurücksetzen möchten?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetToDefaults();
            },
            child: const Text('Zurücksetzen'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Über Push-Benachrichtigungen'),
        content: const Text(
          'Push-Benachrichtigungen ermöglichen es Ihnen, wichtige Updates und Nachrichten '
          'zu erhalten, auch wenn die App nicht geöffnet ist.\n\n'
          '• Fallakten-Updates\n'
          '• Dokumenten-Uploads\n'
          '• Termin-Erinnerungen\n'
          '• System-Nachrichten\n\n'
          'Ihre Daten werden sicher übertragen und nur für die Benachrichtigungsfunktion verwendet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetToDefaults() async {
    try {
      final defaultSettings = PushSettings.defaultSettings();
      await widget.useCases.updatePushSettings(defaultSettings);

      setState(() {
        _settings = defaultSettings;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Einstellungen zurückgesetzt')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Zurücksetzen: $e')),
        );
      }
    }
  }
}
