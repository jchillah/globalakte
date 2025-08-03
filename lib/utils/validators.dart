// utils/validators.dart
/// Validierungs-Utilities für GlobalAkte
class Validators {
  /// E-Mail Validierung
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-Mail ist erforderlich';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Bitte geben Sie eine gültige E-Mail-Adresse ein';
    }

    return null;
  }

  /// PIN Validierung
  static String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN ist erforderlich';
    }

    if (value.length < 6) {
      return 'PIN muss mindestens 6 Zeichen lang sein';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'PIN darf nur Zahlen enthalten';
    }

    return null;
  }

  /// Passwort Validierung
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Passwort ist erforderlich';
    }

    if (value.length < 8) {
      return 'Passwort muss mindestens 8 Zeichen lang sein';
    }

    // Mindestens ein Großbuchstabe, ein Kleinbuchstabe und eine Zahl
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Passwort muss Groß- und Kleinbuchstaben sowie Zahlen enthalten';
    }

    return null;
  }

  /// Name Validierung
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name ist erforderlich';
    }

    if (value.length < 2) {
      return 'Name muss mindestens 2 Zeichen lang sein';
    }

    if (!RegExp(r'^[a-zA-ZäöüÄÖÜß\s]+$').hasMatch(value)) {
      return 'Name darf nur Buchstaben enthalten';
    }

    return null;
  }

  /// Telefonnummer Validierung
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefonnummer ist erforderlich';
    }

    // Deutsche Telefonnummern (verschiedene Formate)
    final phoneRegex = RegExp(r'^(\+49|0)[0-9\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'Bitte geben Sie eine gültige Telefonnummer ein';
    }

    return null;
  }

  /// IBAN Validierung
  static String? validateIban(String? value) {
    if (value == null || value.isEmpty) {
      return 'IBAN ist erforderlich';
    }

    // Deutsche IBAN Format
    final ibanRegex = RegExp(r'^DE[0-9]{20}$');
    final cleanIban = value.replaceAll(RegExp(r'\s'), '').toUpperCase();

    if (!ibanRegex.hasMatch(cleanIban)) {
      return 'Bitte geben Sie eine gültige deutsche IBAN ein';
    }

    return null;
  }

  /// Postleitzahl Validierung
  static String? validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postleitzahl ist erforderlich';
    }

    // Deutsche Postleitzahlen
    final postalRegex = RegExp(r'^[0-9]{5}$');
    if (!postalRegex.hasMatch(value)) {
      return 'Bitte geben Sie eine gültige Postleitzahl ein';
    }

    return null;
  }

  /// Geburtsdatum Validierung
  static String? validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Geburtsdatum ist erforderlich';
    }

    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();
      final age = now.year - date.year;

      if (age < 18) {
        return 'Sie müssen mindestens 18 Jahre alt sein';
      }

      if (age > 120) {
        return 'Bitte geben Sie ein gültiges Geburtsdatum ein';
      }

      return null;
    } catch (e) {
      return 'Bitte geben Sie ein gültiges Datum ein (YYYY-MM-DD)';
    }
  }

  /// Allgemeine Text Validierung
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ist erforderlich';
    }

    return null;
  }

  /// Mindestlänge Validierung
  static String? validateMinLength(
      String? value, int minLength, String fieldName) {
    if (value == null || value.length < minLength) {
      return '$fieldName muss mindestens $minLength Zeichen lang sein';
    }

    return null;
  }

  /// Maximallänge Validierung
  static String? validateMaxLength(
      String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName darf maximal $maxLength Zeichen lang sein';
    }

    return null;
  }
}
