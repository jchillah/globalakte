// features/encryption/data/repositories/encryption_repository_impl.dart
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/encrypted_data.dart';
import '../../domain/entities/encryption_key.dart';
import '../../domain/repositories/encryption_repository.dart';

/// Implementierung des EncryptionRepository mit lokaler Speicherung
class EncryptionRepositoryImpl implements EncryptionRepository {
  static const String _keysKey = 'encryption_keys';
  static const String _defaultAlgorithm = 'AES-256-GCM';

  @override
  Future<EncryptedData> encrypt(String data, String keyId) async {
    final key = await getKey(keyId);
    if (key == null || !key.isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    // Simulierte Verschlüsselung (in der echten App würde hier echte Verschlüsselung stehen)
    await Future.delayed(const Duration(milliseconds: 100));

    final encryptedContent = _simulateEncryption(data, key);
    final checksum = _generateChecksum(data);

    return EncryptedData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      encryptedContent: encryptedContent,
      algorithm: key.algorithm,
      keyId: keyId,
      createdAt: DateTime.now(),
      checksum: checksum,
    );
  }

  @override
  Future<String> decrypt(EncryptedData encryptedData, String keyId) async {
    if (encryptedData.isExpired) {
      throw ArgumentError('Verschlüsselte Daten sind abgelaufen');
    }

    final key = await getKey(keyId);
    if (key == null || !key.isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    // Simulierte Entschlüsselung
    await Future.delayed(const Duration(milliseconds: 100));

    final decryptedData =
        _simulateDecryption(encryptedData.encryptedContent, key);

    // Integritätsprüfung
    if (encryptedData.hasChecksum) {
      final expectedChecksum = _generateChecksum(decryptedData);
      if (encryptedData.checksum != expectedChecksum) {
        throw ArgumentError('Datenintegrität verletzt');
      }
    }

    return decryptedData;
  }

  @override
  Future<EncryptionKey> createKey(String name, String keyType) async {
    if (!isValidKeyType(keyType)) {
      throw ArgumentError('Ungültiger Schlüsseltyp: $keyType');
    }

    final keyMaterial = await generateSecureKey(32);
    final key = EncryptionKey(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      keyType: keyType,
      algorithm: _getDefaultAlgorithm(keyType),
      keyMaterial: keyMaterial,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 365)), // 1 Jahr
    );

    await _saveKey(key);
    return key;
  }

  @override
  Future<EncryptionKey?> getKey(String keyId) async {
    final keys = await getAllKeys();
    return keys.where((key) => key.id == keyId).firstOrNull;
  }

  @override
  Future<List<EncryptionKey>> getAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final keysJson = prefs.getStringList(_keysKey) ?? [];

    return keysJson
        .map((keyJson) => EncryptionKey.fromJson(jsonDecode(keyJson)))
        .where((key) => key.isValid)
        .toList();
  }

  @override
  Future<EncryptionKey> updateKey(EncryptionKey key) async {
    await _saveKey(key);
    return key;
  }

  @override
  Future<void> deleteKey(String keyId) async {
    final keys = await getAllKeys();
    final updatedKeys = keys.where((key) => key.id != keyId).toList();
    await _saveAllKeys(updatedKeys);
  }

  @override
  Future<EncryptionKey> rotateKey(String keyId) async {
    final oldKey = await getKey(keyId);
    if (oldKey == null) {
      throw ArgumentError('Schlüssel nicht gefunden: $keyId');
    }

    // Neuen Schlüssel erstellen
    final newKey = await createKey('${oldKey.name}_rotated', oldKey.keyType);

    // Alten Schlüssel als rotiert markieren
    final updatedOldKey = oldKey.copyWith(
      isActive: false,
      isRotated: true,
      rotatedFromKeyId: newKey.id,
    );

    await updateKey(updatedOldKey);
    return newKey;
  }

  @override
  Future<bool> isKeyValid(String keyId) async {
    final key = await getKey(keyId);
    return key != null && key.isValid;
  }

  @override
  Future<String> generateSecureKey(int length) async {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Encode(bytes);
  }

  @override
  Future<String> hashPassword(String password) async {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<bool> verifyPassword(String password, String hash) async {
    final passwordHash = await hashPassword(password);
    return passwordHash == hash;
  }

  @override
  Future<EncryptedData> encryptFile(String filePath, String keyId) async {
    // Simulierte Dateiverschlüsselung
    await Future.delayed(const Duration(seconds: 1));

    final key = await getKey(keyId);
    if (key == null || !key.isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    final encryptedContent = _simulateEncryption('file_content', key);

    return EncryptedData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      encryptedContent: encryptedContent,
      algorithm: key.algorithm,
      keyId: keyId,
      createdAt: DateTime.now(),
      metadata: {'filePath': filePath},
    );
  }

  @override
  Future<String> decryptFile(EncryptedData encryptedData, String keyId) async {
    return await decrypt(encryptedData, keyId);
  }

  @override
  Future<EncryptedData> encryptWithAES(String data, String keyId) async {
    final key = await getKey(keyId);
    if (key == null || !key.isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    // Simulierte AES-Verschlüsselung
    final encryptedContent = _simulateAESEncryption(data, key);

    return EncryptedData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      encryptedContent: encryptedContent,
      algorithm: 'AES-256-GCM',
      keyId: keyId,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<String> decryptWithAES(
      EncryptedData encryptedData, String keyId) async {
    final key = await getKey(keyId);
    if (key == null || !key.isValid) {
      throw ArgumentError('Ungültiger Schlüssel: $keyId');
    }

    return _simulateAESDecryption(encryptedData.encryptedContent, key);
  }

  @override
  Future<EncryptedData> encryptWithRSA(String data, String publicKeyId) async {
    final key = await getKey(publicKeyId);
    if (key == null || !key.isValid || !key.isPublicKey) {
      throw ArgumentError('Ungültiger öffentlicher Schlüssel: $publicKeyId');
    }

    // Simulierte RSA-Verschlüsselung
    final encryptedContent = _simulateRSAEncryption(data, key);

    return EncryptedData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      encryptedContent: encryptedContent,
      algorithm: 'RSA-2048',
      keyId: publicKeyId,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<String> decryptWithRSA(
      EncryptedData encryptedData, String privateKeyId) async {
    final key = await getKey(privateKeyId);
    if (key == null || !key.isValid || !key.isPrivateKey) {
      throw ArgumentError('Ungültiger privater Schlüssel: $privateKeyId');
    }

    return _simulateRSADecryption(encryptedData.encryptedContent, key);
  }

  @override
  Future<String> createDigitalSignature(
      String data, String privateKeyId) async {
    final key = await getKey(privateKeyId);
    if (key == null || !key.isValid || !key.isPrivateKey) {
      throw ArgumentError('Ungültiger privater Schlüssel: $privateKeyId');
    }

    // Simulierte digitale Signatur
    final signature = _simulateDigitalSignature(data, key);
    return signature;
  }

  @override
  Future<bool> verifyDigitalSignature(
      String data, String signature, String publicKeyId) async {
    final key = await getKey(publicKeyId);
    if (key == null || !key.isValid || !key.isPublicKey) {
      return false;
    }

    // Simulierte Signatur-Verifikation
    return _simulateVerifyDigitalSignature(data, signature, key);
  }

  @override
  Future<bool> verifyDataIntegrity(EncryptedData encryptedData) async {
    if (encryptedData.isExpired) {
      return false;
    }

    if (!encryptedData.hasChecksum) {
      return true; // Keine Checksum vorhanden
    }

    // Simulierte Integritätsprüfung
    return _simulateVerifyIntegrity(encryptedData);
  }

  @override
  Future<void> cleanupExpiredKeys() async {
    final keys = await getAllKeys();
    final validKeys = keys.where((key) => !key.isExpired).toList();
    await _saveAllKeys(validKeys);
  }

  @override
  Future<String> exportKey(String keyId, String password) async {
    final key = await getKey(keyId);
    if (key == null) {
      throw ArgumentError('Schlüssel nicht gefunden: $keyId');
    }

    // Simulierte Schlüssel-Export
    final exportData = {
      'key': key.toJson(),
      'exportedAt': DateTime.now().toIso8601String(),
      'passwordHash': await hashPassword(password),
    };

    return base64Encode(utf8.encode(jsonEncode(exportData)));
  }

  @override
  Future<EncryptionKey> importKey(String exportedKey, String password) async {
    try {
      final decodedData = utf8.decode(base64Decode(exportedKey));
      final exportData = jsonDecode(decodedData) as Map<String, dynamic>;

      final passwordHash = exportData['passwordHash'] as String;
      final expectedHash = await hashPassword(password);

      if (passwordHash != expectedHash) {
        throw ArgumentError('Falsches Passwort');
      }

      final keyData = exportData['key'] as Map<String, dynamic>;
      final key = EncryptionKey.fromJson(keyData);

      await _saveKey(key);
      return key;
    } catch (e) {
      throw ArgumentError('Ungültiger exportierter Schlüssel');
    }
  }

  @override
  Future<Map<String, dynamic>> benchmarkEncryption() async {
    final testData = 'Testdaten für Performance-Benchmark';
    final key = await createKey('benchmark_key', 'symmetric');

    final stopwatch = Stopwatch();

    // Verschlüsselungs-Performance
    stopwatch.start();
    await encrypt(testData, key.id);
    stopwatch.stop();
    final encryptTime = stopwatch.elapsedMicroseconds;

    // Entschlüsselungs-Performance
    stopwatch.reset();
    stopwatch.start();
    final encryptedData = await encrypt(testData, key.id);
    await decrypt(encryptedData, key.id);
    stopwatch.stop();
    final decryptTime = stopwatch.elapsedMicroseconds;

    return {
      'encryptTimeMicroseconds': encryptTime,
      'decryptTimeMicroseconds': decryptTime,
      'dataSizeBytes': testData.length,
      'algorithm': key.algorithm,
    };
  }

  @override
  bool isValidAlgorithm(String algorithm) {
    const validAlgorithms = [
      'AES-256-GCM',
      'AES-256-CBC',
      'RSA-2048',
      'RSA-4096',
      'ChaCha20-Poly1305',
    ];
    return validAlgorithms.contains(algorithm);
  }

  @override
  bool isValidKeyType(String keyType) {
    const validKeyTypes = [
      'symmetric',
      'asymmetric',
      'public',
      'private',
    ];
    return validKeyTypes.contains(keyType);
  }

  @override
  Future<bool> isEncryptionAvailable() async {
    // Simulierte Verfügbarkeitsprüfung
    return true;
  }

  // Private Hilfsmethoden

  String _simulateEncryption(String data, EncryptionKey key) {
    final bytes = utf8.encode(data);
    final keyBytes = base64Decode(key.keyMaterial);
    final encrypted = _xorEncrypt(bytes, keyBytes);
    return base64Encode(encrypted);
  }

  String _simulateDecryption(String encryptedData, EncryptionKey key) {
    final encryptedBytes = base64Decode(encryptedData);
    final keyBytes = base64Decode(key.keyMaterial);
    final decrypted = _xorEncrypt(encryptedBytes, keyBytes);
    return utf8.decode(decrypted);
  }

  List<int> _xorEncrypt(List<int> data, List<int> key) {
    final result = <int>[];
    for (int i = 0; i < data.length; i++) {
      result.add(data[i] ^ key[i % key.length]);
    }
    return result;
  }

  String _simulateAESEncryption(String data, EncryptionKey key) {
    // Simulierte AES-Verschlüsselung
    final encrypted = _simulateEncryption(data, key);
    return 'AES:$encrypted';
  }

  String _simulateAESDecryption(String encryptedData, EncryptionKey key) {
    // Simulierte AES-Entschlüsselung
    final data = encryptedData.replaceFirst('AES:', '');
    return _simulateDecryption(data, key);
  }

  String _simulateRSAEncryption(String data, EncryptionKey key) {
    // Simulierte RSA-Verschlüsselung
    final encrypted = _simulateEncryption(data, key);
    return 'RSA:$encrypted';
  }

  String _simulateRSADecryption(String encryptedData, EncryptionKey key) {
    // Simulierte RSA-Entschlüsselung
    final data = encryptedData.replaceFirst('RSA:', '');
    return _simulateDecryption(data, key);
  }

  String _simulateDigitalSignature(String data, EncryptionKey key) {
    final bytes = utf8.encode(data);
    final keyBytes = base64Decode(key.keyMaterial);
    final signature = _xorEncrypt(bytes, keyBytes);
    return base64Encode(signature);
  }

  bool _simulateVerifyDigitalSignature(
      String data, String signature, EncryptionKey key) {
    final expectedSignature = _simulateDigitalSignature(data, key);
    return signature == expectedSignature;
  }

  String _generateChecksum(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool _simulateVerifyIntegrity(EncryptedData encryptedData) {
    // Simulierte Integritätsprüfung
    return encryptedData.checksum != null && encryptedData.checksum!.isNotEmpty;
  }

  String _getDefaultAlgorithm(String keyType) {
    switch (keyType) {
      case 'symmetric':
        return 'AES-256-GCM';
      case 'asymmetric':
      case 'public':
      case 'private':
        return 'RSA-2048';
      default:
        return _defaultAlgorithm;
    }
  }

  Future<void> _saveKey(EncryptionKey key) async {
    final keys = await getAllKeys();
    final existingIndex = keys.indexWhere((k) => k.id == key.id);

    if (existingIndex >= 0) {
      keys[existingIndex] = key;
    } else {
      keys.add(key);
    }

    await _saveAllKeys(keys);
  }

  Future<void> _saveAllKeys(List<EncryptionKey> keys) async {
    final prefs = await SharedPreferences.getInstance();
    final keysJson = keys.map((key) => jsonEncode(key.toJson())).toList();
    await prefs.setStringList(_keysKey, keysJson);
  }
}
