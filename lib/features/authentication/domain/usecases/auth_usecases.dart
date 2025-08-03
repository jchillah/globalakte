import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Use Cases für die Authentifizierung - Geschäftslogik-Schicht

/// Use Case: Benutzer mit Email und Passwort anmelden
class SignInWithEmailAndPasswordUseCase {
  final AuthRepository _authRepository;

  const SignInWithEmailAndPasswordUseCase(this._authRepository);

  Future<AuthUser> call(String email, String password) async {
    // Validierung
    if (!_authRepository.isValidEmail(email)) {
      throw ArgumentError('Ungültige Email-Adresse');
    }
    if (!_authRepository.isValidPassword(password)) {
      throw ArgumentError('Passwort entspricht nicht den Sicherheitsanforderungen');
    }

    return await _authRepository.signInWithEmailAndPassword(email, password);
  }
}

/// Use Case: Neuen Benutzer registrieren
class SignUpWithEmailAndPasswordUseCase {
  final AuthRepository _authRepository;

  const SignUpWithEmailAndPasswordUseCase(this._authRepository);

  Future<AuthUser> call(String email, String password, String name, String role) async {
    // Validierung
    if (!_authRepository.isValidEmail(email)) {
      throw ArgumentError('Ungültige Email-Adresse');
    }
    if (!_authRepository.isValidPassword(password)) {
      throw ArgumentError('Passwort entspricht nicht den Sicherheitsanforderungen');
    }
    if (name.trim().isEmpty) {
      throw ArgumentError('Name ist erforderlich');
    }
    if (role.trim().isEmpty) {
      throw ArgumentError('Rolle ist erforderlich');
    }

    // Prüfen, ob Email bereits registriert ist
    final isRegistered = await _authRepository.isEmailRegistered(email);
    if (isRegistered) {
      throw ArgumentError('Email ist bereits registriert');
    }

    return await _authRepository.signUpWithEmailAndPassword(email, password, name, role);
  }
}

/// Use Case: Benutzer abmelden
class SignOutUseCase {
  final AuthRepository _authRepository;

  const SignOutUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.signOut();
  }
}

/// Use Case: Mit PIN anmelden
class SignInWithPinUseCase {
  final AuthRepository _authRepository;

  const SignInWithPinUseCase(this._authRepository);

  Future<AuthUser> call(String pin) async {
    if (!_authRepository.isValidPin(pin)) {
      throw ArgumentError('Ungültige PIN');
    }

    return await _authRepository.signInWithPin(pin);
  }
}

/// Use Case: PIN setzen
class SetPinUseCase {
  final AuthRepository _authRepository;

  const SetPinUseCase(this._authRepository);

  Future<void> call(String pin) async {
    if (!_authRepository.isValidPin(pin)) {
      throw ArgumentError('PIN muss mindestens 6 Ziffern haben');
    }

    await _authRepository.setPin(pin);
  }
}

/// Use Case: Mit Biometrie anmelden
class SignInWithBiometricsUseCase {
  final AuthRepository _authRepository;

  const SignInWithBiometricsUseCase(this._authRepository);

  Future<AuthUser> call() async {
    final isAvailable = await _authRepository.isBiometricsAvailable();
    if (!isAvailable) {
      throw ArgumentError('Biometrie ist nicht verfügbar');
    }

    final isEnabled = await _authRepository.isBiometricsEnabled();
    if (!isEnabled) {
      throw ArgumentError('Biometrie ist nicht aktiviert');
    }

    return await _authRepository.signInWithBiometrics();
  }
}

/// Use Case: Biometrie aktivieren/deaktivieren
class SetBiometricsEnabledUseCase {
  final AuthRepository _authRepository;

  const SetBiometricsEnabledUseCase(this._authRepository);

  Future<void> call(bool enabled) async {
    if (enabled) {
      final isAvailable = await _authRepository.isBiometricsAvailable();
      if (!isAvailable) {
        throw ArgumentError('Biometrie ist auf diesem Gerät nicht verfügbar');
      }
    }

    await _authRepository.setBiometricsEnabled(enabled);
  }
}

/// Use Case: Authentifizierungsstatus prüfen
class IsAuthenticatedUseCase {
  final AuthRepository _authRepository;

  const IsAuthenticatedUseCase(this._authRepository);

  Future<bool> call() async {
    return await _authRepository.isAuthenticated();
  }
}

/// Use Case: Aktuellen Benutzer abrufen
class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  const GetCurrentUserUseCase(this._authRepository);

  Future<AuthUser?> call() async {
    return await _authRepository.getCurrentUser();
  }
}

/// Use Case: Benutzerdaten aktualisieren
class UpdateUserUseCase {
  final AuthRepository _authRepository;

  const UpdateUserUseCase(this._authRepository);

  Future<AuthUser> call(AuthUser user) async {
    return await _authRepository.updateUser(user);
  }
}

/// Use Case: Passwort-Reset Email senden
class SendPasswordResetEmailUseCase {
  final AuthRepository _authRepository;

  const SendPasswordResetEmailUseCase(this._authRepository);

  Future<void> call(String email) async {
    if (!_authRepository.isValidEmail(email)) {
      throw ArgumentError('Ungültige Email-Adresse');
    }

    await _authRepository.sendPasswordResetEmail(email);
  }
}

/// Use Case: PIN-Status prüfen
class IsPinEnabledUseCase {
  final AuthRepository _authRepository;

  const IsPinEnabledUseCase(this._authRepository);

  Future<bool> call() async {
    return await _authRepository.isPinEnabled();
  }
}

/// Use Case: Biometrie-Status prüfen
class IsBiometricsEnabledUseCase {
  final AuthRepository _authRepository;

  const IsBiometricsEnabledUseCase(this._authRepository);

  Future<bool> call() async {
    return await _authRepository.isBiometricsEnabled();
  }
}

/// Use Case: Biometrie-Verfügbarkeit prüfen
class IsBiometricsAvailableUseCase {
  final AuthRepository _authRepository;

  const IsBiometricsAvailableUseCase(this._authRepository);

  Future<bool> call() async {
    return await _authRepository.isBiometricsAvailable();
  }
} 