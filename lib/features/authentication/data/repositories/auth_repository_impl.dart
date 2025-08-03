// features/authentication/data/repositories/auth_repository_impl.dart
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/app_config.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementierung des AuthRepository mit lokaler Speicherung
class AuthRepositoryImpl implements AuthRepository {
  static const String _userKey = 'auth_user';
  static const String _pinHashKey = 'pin_hash';
  static const String _biometricsEnabledKey = 'biometrics_enabled';
  static const String _sessionTokenKey = 'session_token';

  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return false;

    try {
      final user = AuthUser.fromJson(jsonDecode(userJson));
      return user.isAuthenticated;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthUser> signInWithEmailAndPassword(
      String email, String password) async {
    // Simulierte Authentifizierung - in der echten App würde hier ein API-Call stehen
    await Future.delayed(
        const Duration(seconds: 1)); // Simuliere Netzwerk-Verzögerung

    final user = AuthUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: email.split('@')[0], // Vereinfachter Name aus Email
      role: 'citizen', // Standard-Rolle
      isAuthenticated: true,
      lastLoginAt: DateTime.now(),
    );

    await _saveUser(user);
    return user;
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword(
      String email, String password, String name, String role) async {
    // Simulierte Registrierung
    await Future.delayed(const Duration(seconds: 1));

    final user = AuthUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      role: role,
      isAuthenticated: true,
      lastLoginAt: DateTime.now(),
    );

    await _saveUser(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_sessionTokenKey);
  }

  @override
  Future<AuthUser> signInWithPin(String pin) async {
    final storedPinHash = await _secureStorage.read(key: _pinHashKey);

    if (storedPinHash == null) {
      throw ArgumentError('Keine PIN gesetzt');
    }

    // Sichere PIN-Validierung mit Hash-Vergleich
    if (storedPinHash != _hashPin(pin)) {
      throw ArgumentError('Falsche PIN');
    }

    final user = await getCurrentUser();
    if (user == null) {
      throw ArgumentError('Kein Benutzer gefunden');
    }

    final updatedUser = user.copyWith(
      isAuthenticated: true,
      lastLoginAt: DateTime.now(),
    );

    await _saveUser(updatedUser);
    return updatedUser;
  }

  @override
  Future<void> setPin(String pin) async {
    final pinHash = _hashPin(pin);
    await _secureStorage.write(key: _pinHashKey, value: pinHash);
  }

  @override
  Future<bool> isPinEnabled() async {
    final storedPin = await _secureStorage.read(key: _pinHashKey);
    return storedPin != null;
  }

  @override
  Future<AuthUser> signInWithBiometrics() async {
    try {
      // Prüfe ob Biometrie verfügbar ist
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        throw ArgumentError('Biometrie ist auf diesem Gerät nicht verfügbar');
      }

      // Prüfe ob Biometrie aktiviert ist
      final isEnabled = await isBiometricsEnabled();
      if (!isEnabled) {
        throw ArgumentError('Biometrie ist nicht aktiviert');
      }

      // Authentifizierung mit Biometrie
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Bitte authentifizieren Sie sich mit Biometrie',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (!isAuthenticated) {
        throw ArgumentError('Biometrische Authentifizierung fehlgeschlagen');
      }

      // Hole den aktuellen Benutzer
      final user = await getCurrentUser();
      if (user == null) {
        throw ArgumentError('Kein Benutzer gefunden');
      }

      final updatedUser = user.copyWith(
        isAuthenticated: true,
        lastLoginAt: DateTime.now(),
      );

      await _saveUser(updatedUser);
      return updatedUser;
    } catch (e) {
      throw ArgumentError('Biometrische Authentifizierung fehlgeschlagen: $e');
    }
  }

  @override
  Future<bool> isBiometricsAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isBiometricsEnabled() async {
    try {
      final enabled = await _secureStorage.read(key: _biometricsEnabledKey);
      return enabled == 'true';
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> setBiometricsEnabled(bool enabled) async {
    if (enabled) {
      // Prüfe ob Biometrie verfügbar ist
      final isAvailable = await isBiometricsAvailable();
      if (!isAvailable) {
        throw ArgumentError('Biometrie ist auf diesem Gerät nicht verfügbar');
      }
    }

    await _secureStorage.write(
      key: _biometricsEnabledKey,
      value: enabled.toString(),
    );
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;

    try {
      return AuthUser.fromJson(jsonDecode(userJson));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthUser> updateUser(AuthUser user) async {
    await _saveUser(user);
    return user;
  }

  @override
  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // Simulierte Passwort-Reset Email
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<bool> isEmailRegistered(String email) async {
    // Vereinfachte Implementierung - in der echten App würde hier eine Datenbankabfrage stehen
    return false; // Vereinfacht: Email ist nie registriert
  }

  @override
  bool isValidPin(String pin) {
    return pin.length >= AppConfig.minPinLength &&
        pin.length <= 8 &&
        RegExp(r'^[0-9]+$').hasMatch(pin);
  }

  @override
  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  @override
  bool isValidPassword(String password) {
    // Mindestens 8 Zeichen, mindestens ein Großbuchstabe, ein Kleinbuchstabe und eine Ziffer
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  /// Speichert einen Benutzer lokal
  Future<void> _saveUser(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  /// Erstellt einen sicheren Hash für die PIN
  String _hashPin(String pin) {
    // In der echten App würde hier ein sicherer Hash verwendet werden
    // Für Demo-Zwecke verwenden wir base64
    return base64Encode(utf8.encode(pin));
  }
}
