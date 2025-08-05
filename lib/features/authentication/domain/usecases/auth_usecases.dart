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

  /// Alternative execute-Methode für konsistente API
  Future<AuthUser> execute(String email, String password) async {
    return call(email, password);
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

  /// Alternative execute-Methode für konsistente API
  Future<AuthUser> execute(String email, String password, String name, String role) async {
    return call(email, password, name, role);
  }
}

/// Use Case: Benutzer abmelden
class SignOutUseCase {
  final AuthRepository _authRepository;

  const SignOutUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.signOut();
  }

  /// Alternative execute-Methode für konsistente API
  Future<void> execute() async {
    return call();
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

  /// Alternative execute-Methode für konsistente API
  Future<AuthUser> execute(String pin) async {
    return call(pin);
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

  /// Alternative execute-Methode für konsistente API
  Future<void> execute(String pin) async {
    return call(pin);
  }
}

/// Use Case: Mit Biometrie anmelden
class SignInWithBiometricsUseCase {
  final AuthRepository _authRepository;

  const SignInWithBiometricsUseCase(this._authRepository);

  Future<AuthUser> call() async {
    return await _authRepository.signInWithBiometrics();
  }

  /// Alternative execute-Methode für konsistente API
  Future<AuthUser> execute() async {
    return call();
  }
}

/// Use Case: Passwort zurücksetzen
class SendPasswordResetEmailUseCase {
  final AuthRepository _authRepository;

  const SendPasswordResetEmailUseCase(this._authRepository);

  Future<void> call(String email) async {
    if (!_authRepository.isValidEmail(email)) {
      throw ArgumentError('Ungültige Email-Adresse');
    }

    await _authRepository.sendPasswordResetEmail(email);
  }

  /// Alternative execute-Methode für konsistente API
  Future<void> execute(String email) async {
    return call(email);
  }
}

/// Use Case: Aktuellen Benutzer abrufen
class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  const GetCurrentUserUseCase(this._authRepository);

  Future<AuthUser?> call() async {
    return await _authRepository.getCurrentUser();
  }

  /// Alternative execute-Methode für konsistente API
  Future<AuthUser?> execute() async {
    return call();
  }
} 