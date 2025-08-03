// features/authentication/data/repositories/auth_repository_impl.dart
import 'dart:convert';

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
    final prefs = await SharedPreferences.getInstance();
    final storedPinHash = prefs.getString(_pinHashKey);

    if (storedPinHash == null) {
      throw ArgumentError('Keine PIN gesetzt');
    }

    // Vereinfachte PIN-Validierung (in der echten App würde hier ein Hash-Vergleich stehen)
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
    final prefs = await SharedPreferences.getInstance();
    final pinHash = _hashPin(pin);
    await prefs.setString(_pinHashKey, pinHash);
  }

  @override
  Future<bool> isPinEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinHashKey) != null;
  }

  @override
  Future<AuthUser> signInWithBiometrics() async {
    // Simulierte Biometrie-Authentifizierung
    await Future.delayed(const Duration(milliseconds: 500));

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
  Future<void> setBiometricsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricsEnabledKey, enabled);
  }

  @override
  Future<bool> isBiometricsAvailable() async {
    // Simulierte Biometrie-Verfügbarkeit
    return true; // In der echten App würde hier eine echte Prüfung stehen
  }

  @override
  Future<bool> isBiometricsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricsEnabledKey) ?? false;
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
    // Simulierte Email-Prüfung
    await Future.delayed(const Duration(milliseconds: 500));
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

  /// Erstellt einen Hash für die PIN (vereinfacht)
  String _hashPin(String pin) {
    // In der echten App würde hier ein sicherer Hash verwendet werden
    return base64Encode(utf8.encode(pin));
  }
}
