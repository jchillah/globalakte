// features/encryption/presentation/screens/encryption_demo_screen.dart
import 'package:flutter/material.dart';

import '../../../../shared/utils/snackbar_utils.dart';
import '../../data/repositories/encryption_repository_impl.dart';
import '../../domain/entities/encrypted_data.dart';
import '../../domain/entities/encryption_key.dart';
import '../../domain/repositories/encryption_repository.dart';
import '../../domain/usecases/encryption_usecases.dart';
import '../widgets/benchmark_section_widget.dart';
import '../widgets/encryption_section_widget.dart';
import '../widgets/key_management_widget.dart';
import '../widgets/password_section_widget.dart';

/// Demo-Screen für Verschlüsselungs-Features
class EncryptionDemoScreen extends StatefulWidget {
  const EncryptionDemoScreen({super.key});

  @override
  State<EncryptionDemoScreen> createState() => _EncryptionDemoScreenState();
}

class _EncryptionDemoScreenState extends State<EncryptionDemoScreen> {
  final EncryptionRepository _encryptionRepository = EncryptionRepositoryImpl();
  late final EncryptDataUseCase _encryptDataUseCase;
  late final DecryptDataUseCase _decryptDataUseCase;
  late final CreateEncryptionKeyUseCase _createKeyUseCase;
  late final GetAllEncryptionKeysUseCase _getAllEncryptionKeysUseCase;
  late final HashPasswordUseCase _hashPasswordUseCase;
  late final VerifyPasswordUseCase _verifyPasswordUseCase;
  late final BenchmarkEncryptionUseCase _benchmarkUseCase;

  List<EncryptionKey> _keys = [];
  EncryptedData? _lastEncryptedData;
  String _lastHash = '';
  bool _isLoading = false;
  String _selectedKeyId = '';

  @override
  void initState() {
    super.initState();
    _initializeUseCases();
    _loadKeys();
  }

  void _initializeUseCases() {
    _encryptDataUseCase = EncryptDataUseCase(_encryptionRepository);
    _decryptDataUseCase = DecryptDataUseCase(_encryptionRepository);
    _createKeyUseCase = CreateEncryptionKeyUseCase(_encryptionRepository);
    _getAllEncryptionKeysUseCase =
        GetAllEncryptionKeysUseCase(_encryptionRepository);
    _hashPasswordUseCase = HashPasswordUseCase(_encryptionRepository);
    _verifyPasswordUseCase = VerifyPasswordUseCase(_encryptionRepository);
    _benchmarkUseCase = BenchmarkEncryptionUseCase(_encryptionRepository);
  }

  Future<void> _loadKeys() async {
    try {
      final keys = await _getAllEncryptionKeysUseCase();
      if (!mounted) return;
      setState(() {
        _keys = keys;
        if (keys.isNotEmpty) {
          _selectedKeyId = keys.first.id;
        }
      });
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Laden der Schlüssel: $e');
    }
  }

  Future<void> _createKey(String keyName) async {
    setState(() => _isLoading = true);

    try {
      await _createKeyUseCase(keyName, 'symmetric');
      await _loadKeys();

      if (!mounted) return;
      SnackBarUtils.showSuccessSnackBar(
          context, 'Schlüssel "$keyName" erfolgreich erstellt');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Erstellen des Schlüssels: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _encryptData(String text) async {
    setState(() => _isLoading = true);

    try {
      final encryptedData = await _encryptDataUseCase(text, _selectedKeyId);
      if (!mounted) return;
      setState(() => _lastEncryptedData = encryptedData);

      SnackBarUtils.showSuccessSnackBar(
          context, 'Text erfolgreich verschlüsselt (ID: ${encryptedData.id})');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(context, 'Fehler beim Verschlüsseln: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _decryptData() async {
    setState(() => _isLoading = true);

    try {
      final decryptedText =
          await _decryptDataUseCase(_lastEncryptedData!, _selectedKeyId);

      if (!mounted) return;
      SnackBarUtils.showSuccessSnackBar(
          context, 'Text erfolgreich entschlüsselt: $decryptedText');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(context, 'Fehler beim Entschlüsseln: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _hashPassword(String password) async {
    setState(() => _isLoading = true);

    try {
      final hash = await _hashPasswordUseCase(password);
      if (!mounted) return;
      setState(() => _lastHash = hash);

      SnackBarUtils.showSuccessSnackBar(
          context, 'Passwort erfolgreich gehasht');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(context, 'Fehler beim Hashen: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyPassword(String password) async {
    setState(() => _isLoading = true);

    try {
      final isValid = await _verifyPasswordUseCase(password, _lastHash);

      if (!mounted) return;
      if (isValid) {
        SnackBarUtils.showSuccessSnackBar(context, 'Passwort ist korrekt!');
      } else {
        SnackBarUtils.showErrorSnackBar(context, 'Passwort ist falsch!');
      }
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler bei der Passwort-Verifikation: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _runBenchmark() async {
    setState(() => _isLoading = true);

    try {
      final benchmark = await _benchmarkUseCase();

      if (!mounted) return;
      SnackBarUtils.showInfoSnackBar(context,
          'Benchmark abgeschlossen: ${benchmark['encryptTimeMicroseconds']}μs Verschlüsselung, ${benchmark['decryptTimeMicroseconds']}μs Entschlüsselung');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(context, 'Fehler beim Benchmark: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verschlüsselung Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeyManagementWidget(
                    keys: _keys,
                    selectedKeyId: _selectedKeyId,
                    onKeySelected: (keyId) =>
                        setState(() => _selectedKeyId = keyId),
                    onCreateKey: _createKey,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),
                  EncryptionSectionWidget(
                    selectedKeyId: _selectedKeyId,
                    lastEncryptedData: _lastEncryptedData,
                    onEncrypt: _encryptData,
                    onDecrypt: _decryptData,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),
                  PasswordSectionWidget(
                    lastHash: _lastHash,
                    onHashPassword: _hashPassword,
                    onVerifyPassword: _verifyPassword,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),
                  BenchmarkSectionWidget(
                    onRunBenchmark: _runBenchmark,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
    );
  }
}
