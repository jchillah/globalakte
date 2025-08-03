// features/authentication/presentation/screens/pin_setup_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

/// PIN Setup Screen für die Ersteinrichtung der PIN
class PinSetupScreen extends StatefulWidget {
  final AuthUser user;

  const PinSetupScreen({
    super.key,
    required this.user,
  });

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  final AuthRepository _authRepository = AuthRepositoryImpl();
  late final SetPinUseCase _setPinUseCase;

  bool _isLoading = false;
  bool _showPin = false;
  bool _showConfirmPin = false;

  @override
  void initState() {
    super.initState();
    _setPinUseCase = SetPinUseCase(_authRepository);
  }

  Future<void> _setupPin() async {
    final pin = _pinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    // Validierung
    if (pin.isEmpty || confirmPin.isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Bitte füllen Sie alle Felder aus');
      return;
    }

    if (pin != confirmPin) {
      SnackBarUtils.showErrorSnackBar(context, 'PINs stimmen nicht überein');
      return;
    }

    if (!_authRepository.isValidPin(pin)) {
      SnackBarUtils.showErrorSnackBar(context,
          'PIN muss mindestens ${AppConfig.minPinLength} Ziffern haben und nur Zahlen enthalten');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _setPinUseCase(pin);

      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(context, 'PIN erfolgreich gesetzt!');
        Navigator.of(context).pop(true); // Erfolg zurückgeben
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Setzen der PIN: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('PIN Setup'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConfig.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'PIN einrichten',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppConfig.defaultPadding),
              Text(
                'Richten Sie eine PIN für die sichere Anmeldung ein. '
                'Die PIN wird verschlüsselt gespeichert.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppConfig.largePadding),

              // PIN Input
              GlobalTextField(
                controller: _pinController,
                label: 'PIN',
                hint: 'Mindestens ${AppConfig.minPinLength} Ziffern',
                obscureText: !_showPin,
                keyboardType: TextInputType.number,
                maxLength: 8,
                suffixIcon: IconButton(
                  icon:
                      Icon(_showPin ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _showPin = !_showPin),
                ),
              ),
              const SizedBox(height: AppConfig.defaultPadding),

              // Confirm PIN Input
              GlobalTextField(
                controller: _confirmPinController,
                label: 'PIN bestätigen',
                hint: 'PIN wiederholen',
                obscureText: !_showConfirmPin,
                keyboardType: TextInputType.number,
                maxLength: 8,
                suffixIcon: IconButton(
                  icon: Icon(_showConfirmPin
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      setState(() => _showConfirmPin = !_showConfirmPin),
                ),
              ),
              const SizedBox(height: AppConfig.largePadding),

              // Security Info
              Container(
                padding: const EdgeInsets.all(AppConfig.defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.security, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Sicherheitshinweise',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• PIN wird verschlüsselt gespeichert\n'
                      '• Mindestens ${AppConfig.minPinLength} Ziffern erforderlich\n'
                      '• Nur Zahlen erlaubt\n'
                      '• PIN kann später geändert werden',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.blue.shade700,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConfig.largePadding),

              // Setup Button
              SizedBox(
                width: double.infinity,
                child: GlobalButton(
                  onPressed: _isLoading ? null : _setupPin,
                  text: 'PIN einrichten',
                  isLoading: _isLoading,
                ),
              ),
              const SizedBox(height: AppConfig.defaultPadding),

              // Skip Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.of(context).pop(false),
                  child: const Text('Später einrichten'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }
}
