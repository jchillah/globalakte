// shared/utils/format_utils.dart
import 'package:intl/intl.dart';

/// Utility-Klasse für Formatierungen
/// Verbessert die Wartbarkeit durch zentrale Formatierungs-Funktionen
class FormatUtils {
  static final DateFormat _dateFormatter = DateFormat('dd.MM.yyyy');
  static final DateFormat _timeFormatter = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormatter = DateFormat('dd.MM.yyyy HH:mm');
  static final DateFormat _fullDateTimeFormatter =
      DateFormat('dd.MM.yyyy HH:mm:ss');
  static final DateFormat _isoFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  /// Formatiert ein Datum im deutschen Format
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Formatiert eine Zeit im deutschen Format
  static String formatTime(DateTime time) {
    return _timeFormatter.format(time);
  }

  /// Formatiert Datum und Zeit im deutschen Format
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  /// Formatiert Datum und Zeit mit Sekunden
  static String formatFullDateTime(DateTime dateTime) {
    return _fullDateTimeFormatter.format(dateTime);
  }

  /// Formatiert Datum und Zeit im ISO-Format
  static String formatIsoDateTime(DateTime dateTime) {
    return _isoFormatter.format(dateTime);
  }

  /// Formatiert eine relative Zeit (z.B. "vor 2 Stunden")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'vor ${difference.inDays} Tag${difference.inDays == 1 ? '' : 'en'}';
    } else if (difference.inHours > 0) {
      return 'vor ${difference.inHours} Stunde${difference.inHours == 1 ? '' : 'n'}';
    } else if (difference.inMinutes > 0) {
      return 'vor ${difference.inMinutes} Minute${difference.inMinutes == 1 ? '' : 'n'}';
    } else {
      return 'gerade eben';
    }
  }

  /// Formatiert eine Dauer in lesbarer Form
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}min';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}min ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Formatiert eine Dateigröße
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Formatiert eine Prozentangabe
  static String formatPercentage(double value, {int decimalPlaces = 1}) {
    return '${(value * 100).toStringAsFixed(decimalPlaces)}%';
  }

  /// Formatiert eine Währungsangabe
  static String formatCurrency(double amount, {String currency = 'EUR'}) {
    final formatter = NumberFormat.currency(
      locale: 'de_DE',
      symbol: currency == 'EUR' ? '€' : currency,
    );
    return formatter.format(amount);
  }

  /// Formatiert eine Telefonnummer
  static String formatPhoneNumber(String phoneNumber) {
    // Entferne alle nicht-numerischen Zeichen
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length == 11 && digits.startsWith('0')) {
      // Deutsche Mobilnummer
      return '${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5, 8)} ${digits.substring(8)}';
    } else if (digits.length == 10 && digits.startsWith('0')) {
      // Deutsche Festnetznummer
      return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    } else if (digits.startsWith('49')) {
      // Internationale deutsche Nummer
      return '+49 ${digits.substring(2, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    }

    return phoneNumber;
  }

  /// Formatiert eine E-Mail-Adresse für Anzeige
  static String formatEmailForDisplay(String email) {
    final parts = email.split('@');
    if (parts.length == 2) {
      final username = parts[0];
      final domain = parts[1];

      if (username.length > 10) {
        return '${username.substring(0, 7)}...@$domain';
      }
    }
    return email;
  }

  /// Formatiert einen Namen für Anzeige
  static String formatNameForDisplay(String firstName, String lastName) {
    return '$firstName $lastName';
  }

  /// Formatiert eine Adresse
  static String formatAddress({
    required String street,
    required String houseNumber,
    required String postalCode,
    required String city,
    String? country,
  }) {
    final address = '$street $houseNumber\n$postalCode $city';
    if (country != null && country != 'Deutschland') {
      return '$address\n$country';
    }
    return address;
  }

  /// Formatiert eine Fallnummer
  static String formatCaseNumber(String caseNumber) {
    // Entferne alle nicht-alphanumerischen Zeichen
    final clean = caseNumber.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

    if (clean.length >= 8) {
      return '${clean.substring(0, 4)}-${clean.substring(4, 8)}-${clean.substring(8)}';
    } else if (clean.length >= 4) {
      return '${clean.substring(0, 4)}-${clean.substring(4)}';
    }

    return caseNumber;
  }

  /// Formatiert einen Zeitstempel für Logs
  static String formatTimestamp(DateTime timestamp) {
    return '[${_isoFormatter.format(timestamp)}]';
  }

  /// Formatiert eine Priorität
  static String formatPriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'Hoch';
      case 'medium':
        return 'Mittel';
      case 'low':
        return 'Niedrig';
      default:
        return priority;
    }
  }

  /// Formatiert einen Status
  static String formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Offen';
      case 'in_progress':
        return 'In Bearbeitung';
      case 'completed':
        return 'Abgeschlossen';
      case 'cancelled':
        return 'Abgebrochen';
      case 'pending':
        return 'Ausstehend';
      case 'verified':
        return 'Verifiziert';
      case 'rejected':
        return 'Abgelehnt';
      case 'archived':
        return 'Archiviert';
      default:
        return status;
    }
  }

  /// Formatiert eine Kategorie
  static String formatCategory(String category) {
    switch (category.toLowerCase()) {
      case 'civil_law':
        return 'Zivilrecht';
      case 'criminal_law':
        return 'Strafrecht';
      case 'family_law':
        return 'Familienrecht';
      case 'labor_law':
        return 'Arbeitsrecht';
      case 'social_law':
        return 'Sozialrecht';
      case 'administrative_law':
        return 'Verwaltungsrecht';
      default:
        return category;
    }
  }

  /// Formatiert eine Bewertung (1-5 Sterne)
  static String formatRating(double rating) {
    final stars = '★' * rating.floor();
    final halfStar = rating % 1 >= 0.5 ? '☆' : '';
    return '$stars$halfStar';
  }

  /// Formatiert eine Versionsnummer
  static String formatVersion(String version) {
    return 'v$version';
  }

  /// Formatiert eine UUID für Anzeige
  static String formatUuid(String uuid) {
    if (uuid.length >= 8) {
      return '${uuid.substring(0, 8)}...';
    }
    return uuid;
  }
}
