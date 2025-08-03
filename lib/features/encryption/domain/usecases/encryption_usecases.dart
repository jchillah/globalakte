import '../entities/encrypted_data.dart';
import '../entities/encryption_key.dart';
import '../repositories/encryption_repository.dart';

/// Use Cases für die Verschlüsselung - Geschäftslogik-Schicht

/// Use Case: Daten verschlüsseln
class EncryptDataUseCase {
  final EncryptionRepository _encryptionRepository;

  const EncryptDataUseCase(this._encryptionRepository);

  Future<EncryptedData> call(String data, String keyId) async {
    if (data.isEmpty) {
      throw ArgumentError('Daten dürfen nicht leer sein');
    }

    final isValid = await _encryptionRepository.isKeyValid(keyId);
    if (!isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    return await _encryptionRepository.encrypt(data, keyId);
  }
}

/// Use Case: Daten entschlüsseln
class DecryptDataUseCase {
  final EncryptionRepository _encryptionRepository;

  const DecryptDataUseCase(this._encryptionRepository);

  Future<String> call(EncryptedData encryptedData, String keyId) async {
    if (encryptedData.isExpired) {
      throw ArgumentError('Verschlüsselte Daten sind abgelaufen');
    }

    final isValid = await _encryptionRepository.isKeyValid(keyId);
    if (!isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    return await _encryptionRepository.decrypt(encryptedData, keyId);
  }
}

/// Use Case: Verschlüsselungsschlüssel erstellen
class CreateEncryptionKeyUseCase {
  final EncryptionRepository _encryptionRepository;

  const CreateEncryptionKeyUseCase(this._encryptionRepository);

  Future<EncryptionKey> call(String name, String keyType) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Schlüsselname ist erforderlich');
    }

    if (!_encryptionRepository.isValidKeyType(keyType)) {
      throw ArgumentError('Ungültiger Schlüsseltyp: $keyType');
    }

    return await _encryptionRepository.createKey(name, keyType);
  }
}

/// Use Case: Schlüssel abrufen
class GetEncryptionKeyUseCase {
  final EncryptionRepository _encryptionRepository;

  const GetEncryptionKeyUseCase(this._encryptionRepository);

  Future<EncryptionKey?> call(String keyId) async {
    return await _encryptionRepository.getKey(keyId);
  }
}

/// Use Case: Alle Schlüssel abrufen
class GetAllEncryptionKeysUseCase {
  final EncryptionRepository _encryptionRepository;

  const GetAllEncryptionKeysUseCase(this._encryptionRepository);

  Future<List<EncryptionKey>> call() async {
    return await _encryptionRepository.getAllKeys();
  }
}

/// Use Case: Schlüssel rotieren
class RotateEncryptionKeyUseCase {
  final EncryptionRepository _encryptionRepository;

  const RotateEncryptionKeyUseCase(this._encryptionRepository);

  Future<EncryptionKey> call(String keyId) async {
    final isValid = await _encryptionRepository.isKeyValid(keyId);
    if (!isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    return await _encryptionRepository.rotateKey(keyId);
  }
}

/// Use Case: Sicheren Schlüssel generieren
class GenerateSecureKeyUseCase {
  final EncryptionRepository _encryptionRepository;

  const GenerateSecureKeyUseCase(this._encryptionRepository);

  Future<String> call(int length) async {
    if (length < 16) {
      throw ArgumentError('Schlüssellänge muss mindestens 16 Zeichen betragen');
    }

    if (length > 512) {
      throw ArgumentError('Schlüssellänge darf maximal 512 Zeichen betragen');
    }

    return await _encryptionRepository.generateSecureKey(length);
  }
}

/// Use Case: Passwort hashen
class HashPasswordUseCase {
  final EncryptionRepository _encryptionRepository;

  const HashPasswordUseCase(this._encryptionRepository);

  Future<String> call(String password) async {
    if (password.isEmpty) {
      throw ArgumentError('Passwort darf nicht leer sein');
    }

    if (password.length < 8) {
      throw ArgumentError('Passwort muss mindestens 8 Zeichen haben');
    }

    return await _encryptionRepository.hashPassword(password);
  }
}

/// Use Case: Passwort verifizieren
class VerifyPasswordUseCase {
  final EncryptionRepository _encryptionRepository;

  const VerifyPasswordUseCase(this._encryptionRepository);

  Future<bool> call(String password, String hash) async {
    if (password.isEmpty || hash.isEmpty) {
      return false;
    }

    return await _encryptionRepository.verifyPassword(password, hash);
  }
}

/// Use Case: Datei verschlüsseln
class EncryptFileUseCase {
  final EncryptionRepository _encryptionRepository;

  const EncryptFileUseCase(this._encryptionRepository);

  Future<EncryptedData> call(String filePath, String keyId) async {
    if (filePath.isEmpty) {
      throw ArgumentError('Dateipfad ist erforderlich');
    }

    final isValid = await _encryptionRepository.isKeyValid(keyId);
    if (!isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    return await _encryptionRepository.encryptFile(filePath, keyId);
  }
}

/// Use Case: Datei entschlüsseln
class DecryptFileUseCase {
  final EncryptionRepository _encryptionRepository;

  const DecryptFileUseCase(this._encryptionRepository);

  Future<String> call(EncryptedData encryptedData, String keyId) async {
    if (encryptedData.isExpired) {
      throw ArgumentError('Verschlüsselte Datei ist abgelaufen');
    }

    final isValid = await _encryptionRepository.isKeyValid(keyId);
    if (!isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    return await _encryptionRepository.decryptFile(encryptedData, keyId);
  }
}

/// Use Case: AES Verschlüsselung
class EncryptWithAESUseCase {
  final EncryptionRepository _encryptionRepository;

  const EncryptWithAESUseCase(this._encryptionRepository);

  Future<EncryptedData> call(String data, String keyId) async {
    if (data.isEmpty) {
      throw ArgumentError('Daten dürfen nicht leer sein');
    }

    final isValid = await _encryptionRepository.isKeyValid(keyId);
    if (!isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    return await _encryptionRepository.encryptWithAES(data, keyId);
  }
}

/// Use Case: AES Entschlüsselung
class DecryptWithAESUseCase {
  final EncryptionRepository _encryptionRepository;

  const DecryptWithAESUseCase(this._encryptionRepository);

  Future<String> call(EncryptedData encryptedData, String keyId) async {
    if (encryptedData.isExpired) {
      throw ArgumentError('Verschlüsselte Daten sind abgelaufen');
    }

    final isValid = await _encryptionRepository.isKeyValid(keyId);
    if (!isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    return await _encryptionRepository.decryptWithAES(encryptedData, keyId);
  }
}

/// Use Case: RSA Verschlüsselung
class EncryptWithRSAUseCase {
  final EncryptionRepository _encryptionRepository;

  const EncryptWithRSAUseCase(this._encryptionRepository);

  Future<EncryptedData> call(String data, String publicKeyId) async {
    if (data.isEmpty) {
      throw ArgumentError('Daten dürfen nicht leer sein');
    }

    final isValid = await _encryptionRepository.isKeyValid(publicKeyId);
    if (!isValid) {
      throw ArgumentError('Ungültiger öffentlicher Schlüssel: $publicKeyId');
    }

    return await _encryptionRepository.encryptWithRSA(data, publicKeyId);
  }
}

/// Use Case: RSA Entschlüsselung
class DecryptWithRSAUseCase {
  final EncryptionRepository _encryptionRepository;

  const DecryptWithRSAUseCase(this._encryptionRepository);

  Future<String> call(EncryptedData encryptedData, String privateKeyId) async {
    if (encryptedData.isExpired) {
      throw ArgumentError('Verschlüsselte Daten sind abgelaufen');
    }

    final isValid = await _encryptionRepository.isKeyValid(privateKeyId);
    if (!isValid) {
      throw ArgumentError('Ungültiger privater Schlüssel: $privateKeyId');
    }

    return await _encryptionRepository.decryptWithRSA(encryptedData, privateKeyId);
  }
}

/// Use Case: Digitale Signatur erstellen
class CreateDigitalSignatureUseCase {
  final EncryptionRepository _encryptionRepository;

  const CreateDigitalSignatureUseCase(this._encryptionRepository);

  Future<String> call(String data, String privateKeyId) async {
    if (data.isEmpty) {
      throw ArgumentError('Daten dürfen nicht leer sein');
    }

    final isValid = await _encryptionRepository.isKeyValid(privateKeyId);
    if (!isValid) {
      throw ArgumentError('Ungültiger privater Schlüssel: $privateKeyId');
    }

    return await _encryptionRepository.createDigitalSignature(data, privateKeyId);
  }
}

/// Use Case: Digitale Signatur verifizieren
class VerifyDigitalSignatureUseCase {
  final EncryptionRepository _encryptionRepository;

  const VerifyDigitalSignatureUseCase(this._encryptionRepository);

  Future<bool> call(String data, String signature, String publicKeyId) async {
    if (data.isEmpty || signature.isEmpty) {
      return false;
    }

    final isValid = await _encryptionRepository.isKeyValid(publicKeyId);
    if (!isValid) {
      return false;
    }

    return await _encryptionRepository.verifyDigitalSignature(data, signature, publicKeyId);
  }
}

/// Use Case: Datenintegrität verifizieren
class VerifyDataIntegrityUseCase {
  final EncryptionRepository _encryptionRepository;

  const VerifyDataIntegrityUseCase(this._encryptionRepository);

  Future<bool> call(EncryptedData encryptedData) async {
    if (encryptedData.isExpired) {
      return false;
    }

    return await _encryptionRepository.verifyDataIntegrity(encryptedData);
  }
}

/// Use Case: Abgelaufene Schlüssel bereinigen
class CleanupExpiredKeysUseCase {
  final EncryptionRepository _encryptionRepository;

  const CleanupExpiredKeysUseCase(this._encryptionRepository);

  Future<void> call() async {
    await _encryptionRepository.cleanupExpiredKeys();
  }
}

/// Use Case: Schlüssel exportieren
class ExportKeyUseCase {
  final EncryptionRepository _encryptionRepository;

  const ExportKeyUseCase(this._encryptionRepository);

  Future<String> call(String keyId, String password) async {
    if (password.isEmpty) {
      throw ArgumentError('Passwort ist erforderlich');
    }

    final isValid = await _encryptionRepository.isKeyValid(keyId);
    if (!isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    return await _encryptionRepository.exportKey(keyId, password);
  }
}

/// Use Case: Schlüssel importieren
class ImportKeyUseCase {
  final EncryptionRepository _encryptionRepository;

  const ImportKeyUseCase(this._encryptionRepository);

  Future<EncryptionKey> call(String exportedKey, String password) async {
    if (exportedKey.isEmpty || password.isEmpty) {
      throw ArgumentError('Exportierter Schlüssel und Passwort sind erforderlich');
    }

    return await _encryptionRepository.importKey(exportedKey, password);
  }
}

/// Use Case: Verschlüsselungs-Performance testen
class BenchmarkEncryptionUseCase {
  final EncryptionRepository _encryptionRepository;

  const BenchmarkEncryptionUseCase(this._encryptionRepository);

  Future<Map<String, dynamic>> call() async {
    return await _encryptionRepository.benchmarkEncryption();
  }
}

/// Use Case: Verschlüsselungs-Verfügbarkeit prüfen
class IsEncryptionAvailableUseCase {
  final EncryptionRepository _encryptionRepository;

  const IsEncryptionAvailableUseCase(this._encryptionRepository);

  Future<bool> call() async {
    return await _encryptionRepository.isEncryptionAvailable();
  }
} 