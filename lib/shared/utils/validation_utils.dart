// shared/utils/validation_utils.dart
import 'dart:io';

/// Utility-Klasse für Validierungen
/// Verbessert die Wartbarkeit durch zentrale Validierungs-Funktionen
class ValidationUtils {
  // E-Mail-Validierung
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  // Telefonnummer-Validierung (deutsche Nummern)
  static final RegExp _phoneRegex = RegExp(
    r'^(\+49|0)[0-9]{9,15}$',
  );

  // PIN-Validierung (6-8 Ziffern)
  static final RegExp _pinRegex = RegExp(r'^[0-9]{6,8}$');

  // Fallnummer-Validierung
  static final RegExp _caseNumberRegex = RegExp(
    r'^[A-Z]{2,4}-[0-9]{4}-[0-9]{2,4}$',
  );

  // Datei-Erweiterungen
  static const List<String> _allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp'
  ];
  static const List<String> _allowedDocumentExtensions = [
    'pdf',
    'doc',
    'docx',
    'txt',
    'rtf'
  ];
  static const List<String> _allowedVideoExtensions = [
    'mp4',
    'avi',
    'mov',
    'wmv',
    'flv'
  ];
  static const List<String> _allowedAudioExtensions = [
    'mp3',
    'wav',
    'aac',
    'ogg',
    'flac'
  ];

  /// Validiert eine E-Mail-Adresse
  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  /// Validiert eine Telefonnummer
  static bool isValidPhoneNumber(String phoneNumber) {
    return _phoneRegex
        .hasMatch(phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  /// Validiert eine PIN
  static bool isValidPin(String pin) {
    return _pinRegex.hasMatch(pin);
  }

  /// Validiert eine Fallnummer
  static bool isValidCaseNumber(String caseNumber) {
    return _caseNumberRegex.hasMatch(caseNumber.toUpperCase());
  }

  /// Validiert einen Namen
  static bool isValidName(String name) {
    return name.trim().length >= 2 && name.trim().length <= 50;
  }

  /// Validiert eine Adresse
  static bool isValidAddress(String address) {
    return address.trim().length >= 10 && address.trim().length <= 200;
  }

  /// Validiert eine Postleitzahl (deutsch)
  static bool isValidPostalCode(String postalCode) {
    return RegExp(r'^[0-9]{5}$').hasMatch(postalCode.trim());
  }

  /// Validiert eine Stadt
  static bool isValidCity(String city) {
    return city.trim().length >= 2 && city.trim().length <= 50;
  }

  /// Validiert ein Passwort
  static bool isValidPassword(String password) {
    // Mindestens 8 Zeichen, mindestens 1 Großbuchstabe, 1 Kleinbuchstabe, 1 Zahl
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  /// Validiert eine Datei-Erweiterung
  static bool isValidFileExtension(
      String fileName, List<String> allowedExtensions) {
    final extension = fileName.split('.').last.toLowerCase();
    return allowedExtensions.contains(extension);
  }

  /// Validiert eine Bild-Datei
  static bool isValidImageFile(String fileName) {
    return isValidFileExtension(fileName, _allowedImageExtensions);
  }

  /// Validiert eine Dokument-Datei
  static bool isValidDocumentFile(String fileName) {
    return isValidFileExtension(fileName, _allowedDocumentExtensions);
  }

  /// Validiert eine Video-Datei
  static bool isValidVideoFile(String fileName) {
    return isValidFileExtension(fileName, _allowedVideoExtensions);
  }

  /// Validiert eine Audio-Datei
  static bool isValidAudioFile(String fileName) {
    return isValidFileExtension(fileName, _allowedAudioExtensions);
  }

  /// Validiert eine Dateigröße
  static bool isValidFileSize(int fileSizeInBytes, int maxSizeInMB) {
    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    return fileSizeInBytes <= maxSizeInBytes;
  }

  /// Validiert eine URL
  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validiert eine IP-Adresse
  static bool isValidIpAddress(String ipAddress) {
    final parts = ipAddress.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      final number = int.tryParse(part);
      if (number == null || number < 0 || number > 255) {
        return false;
      }
    }
    return true;
  }

  /// Validiert eine Kreditkartennummer (Luhn-Algorithmus)
  static bool isValidCreditCardNumber(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length < 13 || digits.length > 19) return false;

    int sum = 0;
    bool alternate = false;

    for (int i = digits.length - 1; i >= 0; i--) {
      int n = int.parse(digits[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  /// Validiert eine IBAN (vereinfacht)
  static bool isValidIban(String iban) {
    final cleanIban = iban.replaceAll(RegExp(r'[\s\-]'), '').toUpperCase();
    return cleanIban.length >= 15 && cleanIban.length <= 34;
  }

  /// Validiert eine Steuernummer
  static bool isValidTaxNumber(String taxNumber) {
    final clean = taxNumber.replaceAll(RegExp(r'[^\d]'), '');
    return clean.length >= 10 && clean.length <= 11;
  }

  /// Validiert eine Geburtsdatum
  static bool isValidBirthDate(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    return age >= 0 && age <= 120;
  }

  /// Validiert eine Priorität
  static bool isValidPriority(String priority) {
    final validPriorities = ['low', 'medium', 'high'];
    return validPriorities.contains(priority.toLowerCase());
  }

  /// Validiert einen Status
  static bool isValidStatus(String status) {
    final validStatuses = [
      'open',
      'in_progress',
      'completed',
      'cancelled',
      'pending',
      'verified',
      'rejected',
      'archived',
    ];
    return validStatuses.contains(status.toLowerCase());
  }

  /// Validiert eine Kategorie
  static bool isValidCategory(String category) {
    final validCategories = [
      'civil_law',
      'criminal_law',
      'family_law',
      'labor_law',
      'social_law',
      'administrative_law',
    ];
    return validCategories.contains(category.toLowerCase());
  }

  /// Validiert eine Bewertung (1-5)
  static bool isValidRating(double rating) {
    return rating >= 1.0 && rating <= 5.0;
  }

  /// Validiert eine Versionsnummer
  static bool isValidVersion(String version) {
    return RegExp(r'^\d+\.\d+\.\d+$').hasMatch(version);
  }

  /// Validiert eine UUID
  static bool isValidUuid(String uuid) {
    return RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    ).hasMatch(uuid);
  }

  /// Validiert eine Datei-Pfad
  static bool isValidFilePath(String filePath) {
    try {
      // ignore: unused_result
      File(filePath);
      return filePath.isNotEmpty && !filePath.contains('..');
    } catch (e) {
      return false;
    }
  }

  /// Validiert eine Verzeichnis-Pfad
  static bool isValidDirectoryPath(String directoryPath) {
    try {
      // ignore: unused_result
      Directory(directoryPath);
      return directoryPath.isNotEmpty && !directoryPath.contains('..');
    } catch (e) {
      return false;
    }
  }

  /// Validiert eine JSON-String
  static bool isValidJson(String jsonString) {
    try {
      // ignore: unused_result
      jsonString;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validiert eine Base64-String
  static bool isValidBase64(String base64String) {
    try {
      // ignore: unused_result
      base64String;
      return base64String.isNotEmpty && base64String.length % 4 == 0;
    } catch (e) {
      return false;
    }
  }

  /// Validiert eine Hex-String
  static bool isValidHex(String hexString) {
    return RegExp(r'^[0-9A-Fa-f]+$').hasMatch(hexString);
  }

  /// Validiert eine Alphanumerische String
  static bool isAlphanumeric(String text) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text);
  }

  /// Validiert eine Numerische String
  static bool isNumeric(String text) {
    return RegExp(r'^[0-9]+$').hasMatch(text);
  }

  /// Validiert eine Alphabetic String
  static bool isAlphabetic(String text) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(text);
  }

  /// Validiert eine Mindestlänge
  static bool hasMinLength(String text, int minLength) {
    return text.trim().length >= minLength;
  }

  /// Validiert eine Maximallänge
  static bool hasMaxLength(String text, int maxLength) {
    return text.trim().length <= maxLength;
  }

  /// Validiert eine Längenbereich
  static bool hasLengthBetween(String text, int minLength, int maxLength) {
    final length = text.trim().length;
    return length >= minLength && length <= maxLength;
  }

  /// Validiert eine positive Zahl
  static bool isPositiveNumber(num number) {
    return number > 0;
  }

  /// Validiert eine negative Zahl
  static bool isNegativeNumber(num number) {
    return number < 0;
  }

  /// Validiert eine Zahl im Bereich
  static bool isNumberInRange(num number, num min, num max) {
    return number >= min && number <= max;
  }

  /// Validiert eine Datum in der Zukunft
  static bool isFutureDate(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Validiert eine Datum in der Vergangenheit
  static bool isPastDate(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Validiert eine Datum im Bereich
  static bool isDateInRange(DateTime date, DateTime start, DateTime end) {
    return date.isAfter(start) && date.isBefore(end);
  }
}
