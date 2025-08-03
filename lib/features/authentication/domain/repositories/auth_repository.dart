// features/authentication/domain/repositories/auth_repository.dart
import 'package:local_auth/local_auth.dart';

import '../entities/auth_user.dart';

/// AuthRepository Interface - Definiert die Authentifizierungs-Operationen
abstract class AuthRepository {
  /// Prüft, ob ein Benutzer bereits authentifiziert ist
  Future<bool> isAuthenticated();

  /// Authentifiziert einen Benutzer mit Email und Passwort
  Future<AuthUser> signInWithEmailAndPassword(String email, String password);

  /// Registriert einen neuen Benutzer
  Future<AuthUser> signUpWithEmailAndPassword(
      String email, String password, String name, String role);

  /// Meldet den aktuellen Benutzer ab
  Future<void> signOut();

  /// Authentifiziert mit PIN
  Future<AuthUser> signInWithPin(String pin);

  /// Setzt eine neue PIN
  Future<void> setPin(String pin);

  /// Prüft, ob PIN aktiviert ist
  Future<bool> isPinEnabled();

  /// Authentifiziert mit Biometrie
  Future<AuthUser> signInWithBiometrics();

  /// Authentifiziert mit Biometrie (Boolean-Rückgabe)
  Future<bool> authenticateWithBiometrics();

  /// Aktiviert/Deaktiviert Biometrie
  Future<void> setBiometricsEnabled(bool enabled);

  /// Prüft, ob Biometrie verfügbar ist
  Future<bool> isBiometricsAvailable();

  /// Prüft, ob Biometrie aktiviert ist
  Future<bool> isBiometricsEnabled();

  /// Holt verfügbare Biometrie-Typen
  Future<List<BiometricType>> getAvailableBiometrics();

  /// Holt den aktuellen authentifizierten Benutzer
  Future<AuthUser?> getCurrentUser();

  /// Aktualisiert Benutzerdaten
  Future<AuthUser> updateUser(AuthUser user);

  /// Löscht das Benutzerkonto
  Future<void> deleteAccount();

  /// Sendet Passwort-Reset Email
  Future<void> sendPasswordResetEmail(String email);

  /// Prüft, ob Email bereits registriert ist
  Future<bool> isEmailRegistered(String email);

  /// Validiert PIN-Format
  bool isValidPin(String pin);

  /// Validiert Email-Format
  bool isValidEmail(String email);

  /// Validiert Passwort-Stärke
  bool isValidPassword(String password);
}
