// features/encryption/presentation/screens/encryption_demo_screen.dart
import 'package:flutter/material.dart';

import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../data/repositories/encryption_repository_impl.dart';
import '../../domain/entities/encrypted_data.dart';
import '../../domain/entities/encryption_key.dart';
import '../../domain/repositories/encryption_repository.dart';
import '../../domain/usecases/encryption_usecases.dart';

/// Demo-Screen für Verschlüsselungs-Features
class EncryptionDemoScreen extends StatefulWidget {
  const EncryptionDemoScreen({super.key});

  @override
  State<EncryptionDemoScreen> createState() => _EncryptionDemoScreenState();
}

class _EncryptionDemoScreenState extends State<EncryptionDemoScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _keyNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  Future<void> _createKey() async {
    if (_keyNameController.text.trim().isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Bitte geben Sie einen Schlüsselnamen ein');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final key =
          await _createKeyUseCase(_keyNameController.text.trim(), 'symmetric');
      await _loadKeys();

      if (!mounted) return;
      SnackBarUtils.showSuccessSnackBar(
          context, 'Schlüssel "${key.name}" erfolgreich erstellt');

      _keyNameController.clear();
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

  Future<void> _encryptData() async {
    if (_textController.text.trim().isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Bitte geben Sie Text zum Verschlüsseln ein');
      return;
    }

    if (_selectedKeyId.isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Bitte wählen Sie einen Schlüssel aus');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final encryptedData = await _encryptDataUseCase(
          _textController.text.trim(), _selectedKeyId);
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
    if (_lastEncryptedData == null) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Keine verschlüsselten Daten vorhanden');
      return;
    }

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

  Future<void> _hashPassword() async {
    if (_passwordController.text.trim().isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Bitte geben Sie ein Passwort ein');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final hash = await _hashPasswordUseCase(_passwordController.text.trim());
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

  Future<void> _verifyPassword() async {
    if (_passwordController.text.trim().isEmpty || _lastHash.isEmpty) {
      SnackBarUtils.showErrorSnackBar(context,
          'Bitte geben Sie ein Passwort ein und erstellen Sie zuerst einen Hash');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final isValid = await _verifyPasswordUseCase(
          _passwordController.text.trim(), _lastHash);

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
                  _buildKeyManagementSection(),
                  const SizedBox(height: 24),
                  _buildEncryptionSection(),
                  const SizedBox(height: 24),
                  _buildPasswordSection(),
                  const SizedBox(height: 24),
                  _buildBenchmarkSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildKeyManagementSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schlüssel-Verwaltung',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            GlobalTextField(
              controller: _keyNameController,
              label: 'Schlüsselname',
              hint: 'z.B. MeinSchlüssel',
            ),
            const SizedBox(height: 16),
            GlobalButton(
              onPressed: _createKey,
              text: 'Schlüssel erstellen',
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            if (_keys.isNotEmpty) ...[
              Text(
                'Verfügbare Schlüssel:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...(_keys.map((key) => ListTile(
                    title: Text(key.name),
                    subtitle: Text(
                        '${key.algorithm} - ${key.isValid ? 'Aktiv' : 'Inaktiv'}'),
                    trailing: DropdownButton<String>(
                      value: _selectedKeyId == key.id ? key.id : null,
                      onChanged: (value) {
                        setState(() => _selectedKeyId = value!);
                      },
                      items: _keys
                          .map((k) => DropdownMenuItem(
                                value: k.id,
                                child: Text(k.name),
                              ))
                          .toList(),
                    ),
                  ))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEncryptionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verschlüsselung',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            GlobalTextField(
              controller: _textController,
              label: 'Text zum Verschlüsseln',
              hint: 'Geben Sie hier Ihren Text ein...',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GlobalButton(
                    onPressed: _encryptData,
                    text: 'Verschlüsseln',
                    isLoading: _isLoading,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GlobalButton(
                    onPressed: _decryptData,
                    text: 'Entschlüsseln',
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
            if (_lastEncryptedData != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Letzte verschlüsselte Daten:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('ID: ${_lastEncryptedData!.id}'),
                    Text('Algorithmus: ${_lastEncryptedData!.algorithm}'),
                    Text(
                        'Erstellt: ${_lastEncryptedData!.createdAt.toString()}'),
                    if (_lastEncryptedData!.hasChecksum)
                      Text(
                          'Checksum: ${_lastEncryptedData!.checksum!.substring(0, 16)}...'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Passwort-Hashing',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            GlobalTextField(
              controller: _passwordController,
              label: 'Passwort',
              hint: 'Geben Sie ein Passwort ein...',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GlobalButton(
                    onPressed: _hashPassword,
                    text: 'Hash erstellen',
                    isLoading: _isLoading,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GlobalButton(
                    onPressed: _verifyPassword,
                    text: 'Verifizieren',
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
            if (_lastHash.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Letzter Hash:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(_lastHash,
                        style: const TextStyle(fontFamily: 'monospace')),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBenchmarkSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance-Benchmark',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            GlobalButton(
              onPressed: _runBenchmark,
              text: 'Benchmark ausführen',
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            Text(
              'Testet die Verschlüsselungs-Performance mit verschiedenen Algorithmen.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _keyNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
