// core/app_localization.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Lokalisierung für die GlobalAkte App
class AppLocalization {
  static const Locale _defaultLocale = Locale('de', 'DE');
  static Locale _currentLocale = _defaultLocale;

  static Locale get currentLocale => _currentLocale;

  static void setLocale(Locale locale) {
    _currentLocale = locale;
  }

  static String getString(String key, [Map<String, dynamic>? args]) {
    final translations = _getTranslations();
    String text = translations[_currentLocale.languageCode]?[key] ??
        translations['de']?[key] ??
        key;

    if (args != null) {
      args.forEach((key, value) {
        text = text.replaceAll('{$key}', value.toString());
      });
    }

    return text;
  }

  static Map<String, Map<String, String>> _getTranslations() {
    return {
      'de': {
        // Allgemein
        'app_name': 'GlobalAkte',
        'loading': 'Laden...',
        'error': 'Fehler',
        'success': 'Erfolgreich',
        'cancel': 'Abbrechen',
        'save': 'Speichern',
        'delete': 'Löschen',
        'edit': 'Bearbeiten',
        'view': 'Anzeigen',
        'close': 'Schließen',
        'confirm': 'Bestätigen',
        'back': 'Zurück',
        'next': 'Weiter',
        'submit': 'Absenden',
        'search': 'Suchen',
        'filter': 'Filter',
        'refresh': 'Aktualisieren',
        'export': 'Exportieren',
        'import': 'Importieren',

        // Verschlüsselung
        'encryption': 'Verschlüsselung',
        'encrypt': 'Verschlüsseln',
        'decrypt': 'Entschlüsseln',
        'encryption_key': 'Verschlüsselungsschlüssel',
        'create_key': 'Schlüssel erstellen',
        'key_name': 'Schlüsselname',
        'key_type': 'Schlüsseltyp',
        'algorithm': 'Algorithmus',
        'encrypted_data': 'Verschlüsselte Daten',
        'encryption_success': 'Daten erfolgreich verschlüsselt',
        'decryption_success': 'Daten erfolgreich entschlüsselt',
        'encryption_error': 'Fehler bei der Verschlüsselung',
        'decryption_error': 'Fehler bei der Entschlüsselung',

        // Beweismittel
        'evidence': 'Beweismittel',
        'evidence_collection': 'Beweismittel-Sammlung',
        'evidence_verified': 'Beweismittel verifiziert',
        'evidence_rejected': 'Beweismittel abgelehnt',
        'evidence_pending': 'Beweismittel ausstehend',
        'verify_evidence': 'Beweismittel verifizieren',
        'reject_evidence': 'Beweismittel ablehnen',
        'evidence_verification_success': 'Beweismittel erfolgreich verifiziert',
        'evidence_deletion_success': 'Beweismittel erfolgreich gelöscht',
        'evidence_deletion_error': 'Fehler beim Löschen des Beweismittels',

        // Benachrichtigungen
        'notifications': 'Benachrichtigungen',
        'new_notification': 'Neue Benachrichtigung',
        'test_notification': 'Test-Benachrichtigung',
        'notification_sent': 'Benachrichtigung gesendet',
        'notification_error': 'Fehler beim Senden der Benachrichtigung',

        // Dokumente
        'documents': 'Dokumente',
        'document_preview': 'Dokument-Vorschau',
        'document_content': 'Dokument-Inhalt',
        'document_generated': 'Dokument generiert',
        'document_generation_error': 'Fehler bei der Dokument-Generierung',
        'template': 'Vorlage',
        'template_html_warning': 'HTML-Code wird nicht angezeigt',

        // EPA Integration
        'epa_integration': 'EPA-Integration',
        'epa_synchronized': 'EPA synchronisiert',
        'epa_sync_error': 'EPA-Synchronisation fehlgeschlagen',
        'mock_data_available': 'Mock-Daten verfügbar',

        // Rechtliche AI
        'legal_ai': 'Rechtliche KI',
        'legal_analysis': 'Rechtliche Analyse',
        'legal_recommendations': 'Rechtliche Empfehlungen',
        'legal_document': 'Rechtliches Dokument',

        // Hilfe-Netzwerk
        'help_network': 'Hilfe-Netzwerk',
        'help_request': 'Hilfe-Anfrage',
        'help_offer': 'Hilfe-Angebot',
        'help_chat': 'Hilfe-Chat',

        // Authentifizierung
        'login': 'Anmelden',
        'logout': 'Abmelden',
        'register': 'Registrieren',
        'email': 'E-Mail',
        'password': 'Passwort',
        'pin': 'PIN',
        'biometrics': 'Biometrie',

        // Barrierefreiheit
        'accessibility': 'Barrierefreiheit',
        'screen_reader': 'Bildschirmleser',
        'high_contrast': 'Hoher Kontrast',
        'font_size': 'Schriftgröße',
        'language': 'Sprache',
      },
      'en': {
        // General
        'app_name': 'GlobalAkte',
        'loading': 'Loading...',
        'error': 'Error',
        'success': 'Success',
        'cancel': 'Cancel',
        'save': 'Save',
        'delete': 'Delete',
        'edit': 'Edit',
        'view': 'View',
        'close': 'Close',
        'confirm': 'Confirm',
        'back': 'Back',
        'next': 'Next',
        'submit': 'Submit',
        'search': 'Search',
        'filter': 'Filter',
        'refresh': 'Refresh',
        'export': 'Export',
        'import': 'Import',

        // Encryption
        'encryption': 'Encryption',
        'encrypt': 'Encrypt',
        'decrypt': 'Decrypt',
        'encryption_key': 'Encryption Key',
        'create_key': 'Create Key',
        'key_name': 'Key Name',
        'key_type': 'Key Type',
        'algorithm': 'Algorithm',
        'encrypted_data': 'Encrypted Data',
        'encryption_success': 'Data encrypted successfully',
        'decryption_success': 'Data decrypted successfully',
        'encryption_error': 'Encryption error',
        'decryption_error': 'Decryption error',

        // Evidence
        'evidence': 'Evidence',
        'evidence_collection': 'Evidence Collection',
        'evidence_verified': 'Evidence verified',
        'evidence_rejected': 'Evidence rejected',
        'evidence_pending': 'Evidence pending',
        'verify_evidence': 'Verify evidence',
        'reject_evidence': 'Reject evidence',
        'evidence_verification_success': 'Evidence verified successfully',
        'evidence_deletion_success': 'Evidence deleted successfully',
        'evidence_deletion_error': 'Error deleting evidence',

        // Notifications
        'notifications': 'Notifications',
        'new_notification': 'New notification',
        'test_notification': 'Test notification',
        'notification_sent': 'Notification sent',
        'notification_error': 'Error sending notification',

        // Documents
        'documents': 'Documents',
        'document_preview': 'Document preview',
        'document_content': 'Document content',
        'document_generated': 'Document generated',
        'document_generation_error': 'Document generation error',
        'template': 'Template',
        'template_html_warning': 'HTML code not displayed',

        // EPA Integration
        'epa_integration': 'EPA Integration',
        'epa_synchronized': 'EPA synchronized',
        'epa_sync_error': 'EPA synchronization failed',
        'mock_data_available': 'Mock data available',

        // Legal AI
        'legal_ai': 'Legal AI',
        'legal_analysis': 'Legal analysis',
        'legal_recommendations': 'Legal recommendations',
        'legal_document': 'Legal document',

        // Help Network
        'help_network': 'Help Network',
        'help_request': 'Help request',
        'help_offer': 'Help offer',
        'help_chat': 'Help chat',

        // Authentication
        'login': 'Login',
        'logout': 'Logout',
        'register': 'Register',
        'email': 'Email',
        'password': 'Password',
        'pin': 'PIN',
        'biometrics': 'Biometrics',

        // Accessibility
        'accessibility': 'Accessibility',
        'screen_reader': 'Screen reader',
        'high_contrast': 'High contrast',
        'font_size': 'Font size',
        'language': 'Language',
      },
    };
  }

  static String formatDate(DateTime date) {
    return DateFormat.yMMMd(_currentLocale.languageCode).format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat.yMMMd(_currentLocale.languageCode).add_jm().format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: _currentLocale.toString(),
      symbol: _currentLocale.languageCode == 'de' ? '€' : '\$',
    ).format(amount);
  }
}
