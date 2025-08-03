// features/encryption/domain/repositories/encryption_repository.dart
import '../entities/encrypted_data.dart';
import '../entities/encryption_key.dart';

/// EncryptionRepository Interface - Definiert die Verschlüsselungs-Operationen
abstract class EncryptionRepository {
  /// Verschlüsselt Daten mit einem bestimmten Schlüssel
  Future<EncryptedData> encrypt(String data, String keyId);

  /// Entschlüsselt Daten mit einem bestimmten Schlüssel
  Future<String> decrypt(EncryptedData encryptedData, String keyId);

  /// Erstellt einen neuen Verschlüsselungsschlüssel
  Future<EncryptionKey> createKey(String name, String keyType);

  /// Holt einen Verschlüsselungsschlüssel anhand der ID
  Future<EncryptionKey?> getKey(String keyId);

  /// Holt alle verfügbaren Schlüssel
  Future<List<EncryptionKey>> getAllKeys();

  /// Aktualisiert einen Verschlüsselungsschlüssel
  Future<EncryptionKey> updateKey(EncryptionKey key);

  /// Löscht einen Verschlüsselungsschlüssel
  Future<void> deleteKey(String keyId);

  /// Rotiert einen Schlüssel (erstellt neuen, markiert alten als inaktiv)
  Future<EncryptionKey> rotateKey(String keyId);

  /// Prüft, ob ein Schlüssel gültig ist
  Future<bool> isKeyValid(String keyId);

  /// Generiert einen sicheren Zufallsschlüssel
  Future<String> generateSecureKey(int length);

  /// Hasht ein Passwort sicher
  Future<String> hashPassword(String password);

  /// Verifiziert ein Passwort gegen einen Hash
  Future<bool> verifyPassword(String password, String hash);

  /// Verschlüsselt eine Datei
  Future<EncryptedData> encryptFile(String filePath, String keyId);

  /// Entschlüsselt eine Datei
  Future<String> decryptFile(EncryptedData encryptedData, String keyId);

  /// Verschlüsselt einen Text mit AES
  Future<EncryptedData> encryptWithAES(String data, String keyId);

  /// Entschlüsselt einen Text mit AES
  Future<String> decryptWithAES(EncryptedData encryptedData, String keyId);

  /// Verschlüsselt einen Text mit RSA
  Future<EncryptedData> encryptWithRSA(String data, String publicKeyId);

  /// Entschlüsselt einen Text mit RSA
  Future<String> decryptWithRSA(
      EncryptedData encryptedData, String privateKeyId);

  /// Erstellt ein digitales Signatur
  Future<String> createDigitalSignature(String data, String privateKeyId);

  /// Verifiziert eine digitale Signatur
  Future<bool> verifyDigitalSignature(
      String data, String signature, String publicKeyId);

  /// Prüft die Integrität verschlüsselter Daten
  Future<bool> verifyDataIntegrity(EncryptedData encryptedData);

  /// Bereinigt abgelaufene Schlüssel
  Future<void> cleanupExpiredKeys();

  /// Exportiert einen Schlüssel (für Backup)
  Future<String> exportKey(String keyId, String password);

  /// Importiert einen Schlüssel (aus Backup)
  Future<EncryptionKey> importKey(String exportedKey, String password);

  /// Prüft die Verschlüsselungs-Performance
  Future<Map<String, dynamic>> benchmarkEncryption();

  /// Validiert Verschlüsselungs-Algorithmen
  bool isValidAlgorithm(String algorithm);

  /// Validiert Schlüssel-Typen
  bool isValidKeyType(String keyType);

  /// Prüft, ob Verschlüsselung verfügbar ist
  Future<bool> isEncryptionAvailable();
}
