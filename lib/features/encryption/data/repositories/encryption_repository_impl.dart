// features/encryption/data/repositories/encryption_repository_impl.dart
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/encrypted_data.dart';
import '../../domain/entities/encryption_key.dart';
import '../../domain/repositories/encryption_repository.dart';

/// Implementierung des EncryptionRepository mit echter Verschlüsselung
class EncryptionRepositoryImpl implements EncryptionRepository {
  static const String _keysKey = 'encryption_keys';
  static const String _defaultAlgorithm = 'AES-256-GCM';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<EncryptedData> encrypt(String data, String keyId) async {
    final key = await getKey(keyId);
    if (key == null) {
      throw ArgumentError('Schlüssel nicht gefunden: $keyId');
    }

    final encryptedContent = _encryptWithAES(data, key);
    final checksum = _generateChecksum(data);
    final signature = await _createDigitalSignature(data, key);

    return EncryptedData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      encryptedContent: encryptedContent,
      algorithm: key.algorithm,
      keyId: key.id,
      createdAt: DateTime.now(),
      signature: signature,
      checksum: checksum,
      metadata: {
        'originalLength': data.length,
        'encryptedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Future<String> decrypt(EncryptedData encryptedData, String keyId) async {
    final key = await getKey(keyId);
    if (key == null) {
      throw ArgumentError('Schlüssel nicht gefunden: $keyId');
    }

    if (key.id != encryptedData.keyId) {
      throw ArgumentError('Schlüssel-ID stimmt nicht überein');
    }

    final decryptedContent =
        _decryptWithAES(encryptedData.encryptedContent, key);

    // Verifiziere Checksum
    final expectedChecksum = _generateChecksum(decryptedContent);
    if (encryptedData.checksum != expectedChecksum) {
      throw ArgumentError(
          'Datenintegrität verletzt - Checksum stimmt nicht überein');
    }

    return decryptedContent;
  }

  @override
  Future<EncryptionKey> createKey(String name, String keyType) async {
    final keyId = DateTime.now().millisecondsSinceEpoch.toString();
    final algorithm = _getDefaultAlgorithm(keyType);

    // Generiere echten AES-Schlüssel
    final keyMaterial = _generateSecureKey(32); // 256-bit für AES-256

    final key = EncryptionKey(
      id: keyId,
      name: name,
      keyType: keyType,
      algorithm: algorithm,
      keyMaterial: keyMaterial,
      createdAt: DateTime.now(),
      isActive: true,
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
    try {
      final keysJson = await _secureStorage.read(key: _keysKey);
      if (keysJson == null) return [];

      final List<dynamic> keysList = jsonDecode(keysJson);
      return keysList.map((json) => EncryptionKey.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
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

    // Erstelle neuen Schlüssel
    final newKey = await createKey('${oldKey.name} (rotated)', oldKey.keyType);

    // Markiere alten Schlüssel als rotiert
    final updatedOldKey = oldKey.copyWith(
      isRotated: true,
      rotatedFromKeyId: newKey.id,
    );
    await _saveKey(updatedOldKey);

    return newKey;
  }

  @override
  Future<bool> isKeyValid(String keyId) async {
    final key = await getKey(keyId);
    return key?.isValid ?? false;
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
    // Vereinfachte Implementierung - in der echten App würde hier die Datei gelesen
    final fileContent = 'Simulierte Datei: $filePath';
    return await encrypt(fileContent, keyId);
  }

  @override
  Future<String> decryptFile(EncryptedData encryptedData, String keyId) async {
    return await decrypt(encryptedData, keyId);
  }

  @override
  Future<EncryptedData> encryptWithAES(String data, String keyId) async {
    return await encrypt(data, keyId);
  }

  @override
  Future<String> decryptWithAES(
      EncryptedData encryptedData, String keyId) async {
    return await decrypt(encryptedData, keyId);
  }

  @override
  Future<EncryptedData> encryptWithRSA(String data, String publicKeyId) async {
    // RSA-Implementierung würde hier stehen
    // Für Demo-Zwecke verwenden wir AES
    return await encrypt(data, publicKeyId);
  }

  @override
  Future<String> decryptWithRSA(
      EncryptedData encryptedData, String privateKeyId) async {
    // RSA-Implementierung würde hier stehen
    // Für Demo-Zwecke verwenden wir AES
    return await decrypt(encryptedData, privateKeyId);
  }

  @override
  Future<String> createDigitalSignature(
      String data, String privateKeyId) async {
    final key = await getKey(privateKeyId);
    if (key == null) {
      throw ArgumentError('Schlüssel nicht gefunden: $privateKeyId');
    }

    // Erstelle digitalen Hash als Signatur
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return base64Encode(digest.bytes);
  }

  @override
  Future<bool> verifyDigitalSignature(
      String data, String signature, String publicKeyId) async {
    final key = await getKey(publicKeyId);
    if (key == null) {
      throw ArgumentError('Schlüssel nicht gefunden: $publicKeyId');
    }

    // Verifiziere Signatur
    final expectedSignature = await createDigitalSignature(data, publicKeyId);
    return signature == expectedSignature;
  }

  @override
  Future<bool> verifyDataIntegrity(EncryptedData encryptedData) async {
    try {
      final key = await getKey(encryptedData.keyId);
      if (key == null) return false;

      final decryptedContent =
          _decryptWithAES(encryptedData.encryptedContent, key);
      final expectedChecksum = _generateChecksum(decryptedContent);

      return encryptedData.checksum == expectedChecksum;
    } catch (e) {
      return false;
    }
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

    // Verschlüssele den Schlüssel mit dem Passwort
    final keyJson = jsonEncode(key.toJson());
    final encryptedKey = _encryptWithPassword(keyJson, password);
    return encryptedKey;
  }

  @override
  Future<EncryptionKey> importKey(String exportedKey, String password) async {
    try {
      final decryptedKeyJson = _decryptWithPassword(exportedKey, password);
      final keyData = jsonDecode(decryptedKeyJson);
      final key = EncryptionKey.fromJson(keyData);

      await _saveKey(key);
      return key;
    } catch (e) {
      throw ArgumentError('Import fehlgeschlagen: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> benchmarkEncryption() async {
    final testData = 'Test-Daten für Benchmark';
    final key = await createKey('benchmark_key', 'symmetric');

    final stopwatch = Stopwatch()..start();

    // Benchmark Verschlüsselung
    stopwatch.reset();
    stopwatch.start();
    final encryptedData = await encrypt(testData, key.id);
    final encryptionTime = stopwatch.elapsedMicroseconds;

    // Benchmark Entschlüsselung
    stopwatch.reset();
    stopwatch.start();
    await decrypt(encryptedData, key.id);
    final decryptionTime = stopwatch.elapsedMicroseconds;

    return {
      'encryptionTimeMicroseconds': encryptionTime,
      'decryptionTimeMicroseconds': decryptionTime,
      'dataSizeBytes': testData.length,
      'algorithm': key.algorithm,
    };
  }

  @override
  bool isValidAlgorithm(String algorithm) {
    return ['AES-256-GCM', 'AES-256-CBC', 'RSA-2048', 'RSA-4096']
        .contains(algorithm);
  }

  @override
  bool isValidKeyType(String keyType) {
    return ['symmetric', 'asymmetric', 'public', 'private'].contains(keyType);
  }

  @override
  Future<bool> isEncryptionAvailable() async {
    try {
      // Teste Verschlüsselung
      final testKey = await createKey('test_key', 'symmetric');
      final testData = 'test';
      final encrypted = await encrypt(testData, testKey.id);
      final decrypted = await decrypt(encrypted, testKey.id);

      return decrypted == testData;
    } catch (e) {
      return false;
    }
  }

  // Private Hilfsmethoden
  String _encryptWithAES(String data, EncryptionKey key) {
    final keyBytes = base64Decode(key.keyMaterial);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(Key(keyBytes), mode: AESMode.gcm));

    final encrypted = encrypter.encrypt(data, iv: iv);
    // Kombiniere IV und verschlüsselte Daten
    final combined = base64Encode(iv.bytes + encrypted.bytes);
    return combined;
  }

  String _decryptWithAES(String encryptedData, EncryptionKey key) {
    final keyBytes = base64Decode(key.keyMaterial);
    final combined = base64Decode(encryptedData);

    // Extrahiere IV (erste 16 Bytes) und verschlüsselte Daten
    final iv = IV(Uint8List.fromList(combined.take(16).toList()));
    final encryptedBytes = Uint8List.fromList(combined.skip(16).toList());

    final encrypter = Encrypter(AES(Key(keyBytes), mode: AESMode.gcm));
    final encrypted = Encrypted(encryptedBytes);

    return encrypter.decrypt(encrypted, iv: iv);
  }

  String _generateSecureKey(int length) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Encode(bytes);
  }

  String _generateChecksum(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String> _createDigitalSignature(String data, EncryptionKey key) async {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return base64Encode(digest.bytes);
  }

  String _encryptWithPassword(String data, String password) {
    final passwordBytes = utf8.encode(password);
    final key = sha256.convert(passwordBytes).bytes;
    final iv = IV.fromSecureRandom(16);
    final encrypter =
        Encrypter(AES(Key(Uint8List.fromList(key)), mode: AESMode.cbc));

    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  String _decryptWithPassword(String encryptedData, String password) {
    final passwordBytes = utf8.encode(password);
    final key = sha256.convert(passwordBytes).bytes;
    final iv = IV.fromSecureRandom(16);
    final encrypter =
        Encrypter(AES(Key(Uint8List.fromList(key)), mode: AESMode.cbc));

    final encrypted = Encrypted.fromBase64(encryptedData);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  String _getDefaultAlgorithm(String keyType) {
    switch (keyType) {
      case 'symmetric':
        return 'AES-256-GCM';
      case 'asymmetric':
        return 'RSA-2048';
      case 'public':
        return 'RSA-2048';
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
    final keysJson = jsonEncode(keys.map((key) => key.toJson()).toList());
    await _secureStorage.write(key: _keysKey, value: keysJson);
  }
}
