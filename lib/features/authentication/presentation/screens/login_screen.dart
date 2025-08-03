// features/authentication/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

/// Login Screen für GlobalAkte
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pinController = TextEditingController();

  final AuthRepository _authRepository = AuthRepositoryImpl();
  late final SignInWithEmailAndPasswordUseCase _signInWithEmailUseCase;
  late final SignInWithPinUseCase _signInWithPinUseCase;

  bool _isLoading = false;
  bool _isPinMode = false;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _signInWithEmailUseCase =
        SignInWithEmailAndPasswordUseCase(_authRepository);
    _signInWithPinUseCase = SignInWithPinUseCase(_authRepository);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Anmelden'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConfig.largePadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: AppConfig.largePadding * 2),
                _buildAuthModeToggle(),
                const SizedBox(height: AppConfig.largePadding),
                _buildAuthForm(),
                const SizedBox(height: AppConfig.largePadding),
                _buildActionButtons(),
                const SizedBox(height: AppConfig.largePadding),
                _buildAdditionalOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppConfig.primaryColor,
            borderRadius: BorderRadius.circular(AppConfig.largeRadius),
          ),
          child: const Icon(
            Icons.gavel,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppConfig.defaultPadding),

        // Titel
        Text(
          'Willkommen zurück',
          style: AppConfig.headlineStyle.copyWith(fontSize: 28),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConfig.smallPadding),

        // Untertitel
        Text(
          _isPinMode
              ? 'Geben Sie Ihre PIN ein'
              : 'Melden Sie sich mit Ihren Zugangsdaten an',
          style: AppConfig.bodyStyle.copyWith(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAuthModeToggle() {
    return Container(
      padding: const EdgeInsets.all(AppConfig.smallPadding),
      decoration: BoxDecoration(
        color: AppConfig.surfaceColor,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              title: 'Email',
              icon: Icons.email,
              isSelected: !_isPinMode,
              onTap: () => setState(() => _isPinMode = false),
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              title: 'PIN',
              icon: Icons.lock,
              isSelected: _isPinMode,
              onTap: () => setState(() => _isPinMode = true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppConfig.defaultPadding,
          horizontal: AppConfig.smallPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppConfig.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : AppConfig.primaryColor,
            ),
            const SizedBox(width: AppConfig.smallPadding),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppConfig.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthForm() {
    if (_isPinMode) {
      return _buildPinForm();
    } else {
      return _buildEmailPasswordForm();
    }
  }

  Widget _buildEmailPasswordForm() {
    return Column(
      children: [
        // Email Field
        GlobalTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'ihre.email@beispiel.de',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email ist erforderlich';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
              return 'Ungültige Email-Adresse';
            }
            return null;
          },
          prefixIcon: const Icon(Icons.email),
        ),

        const SizedBox(height: AppConfig.defaultPadding),

        // Password Field
        GlobalTextField(
          controller: _passwordController,
          label: 'Passwort',
          hint: 'Ihr Passwort',
          obscureText: !_showPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Passwort ist erforderlich';
            }
            if (value.length < 8) {
              return 'Passwort muss mindestens 8 Zeichen haben';
            }
            return null;
          },
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPinForm() {
    return Column(
      children: [
        // PIN Field
        GlobalTextField(
          controller: _pinController,
          label: 'PIN',
          hint: 'Ihre 6-stellige PIN',
          keyboardType: TextInputType.number,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'PIN ist erforderlich';
            }
            if (value.length < 6) {
              return 'PIN muss mindestens 6 Ziffern haben';
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'PIN darf nur Ziffern enthalten';
            }
            return null;
          },
          prefixIcon: const Icon(Icons.pin),
        ),

        const SizedBox(height: AppConfig.smallPadding),

        // PIN Info
        Container(
          padding: const EdgeInsets.all(AppConfig.defaultPadding),
          decoration: BoxDecoration(
            color: AppConfig.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
            border: Border.all(
              color: AppConfig.primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppConfig.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppConfig.smallPadding),
              Expanded(
                child: Text(
                  'PIN ist sicherer als Passwort und schneller einzugeben',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConfig.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Login Button
        GlobalButton(
          text: _isLoading ? 'Anmelden...' : 'Anmelden',
          onPressed: _isLoading ? null : _handleLogin,
          isLoading: _isLoading,
          icon: Icons.login,
        ),

        const SizedBox(height: AppConfig.defaultPadding),

        // Register Link
        GlobalTextButton(
          text: 'Noch kein Konto? Registrieren',
          onPressed: _handleRegister,
          icon: Icons.person_add,
        ),
      ],
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        // Biometric Login
        if (!_isPinMode) ...[
          GlobalSecondaryButton(
            text: 'Mit Biometrie anmelden',
            onPressed: _handleBiometricLogin,
            icon: Icons.fingerprint,
          ),
          const SizedBox(height: AppConfig.defaultPadding),
        ],

        // Forgot Password
        if (!_isPinMode) ...[
          GlobalTextButton(
            text: 'Passwort vergessen?',
            onPressed: _handleForgotPassword,
            icon: Icons.help_outline,
          ),
          const SizedBox(height: AppConfig.defaultPadding),
        ],

        // Demo Info Button
        GlobalTextButton(
          text: 'Demo Login-Daten anzeigen',
          onPressed: () {
            SnackBarUtils.showInfoSnackBar(
              context,
              'Demo Accounts:\n'
              'demo@globalakte.de / Demo123!\n'
              'test@globalakte.de / Test123!\n'
              'admin@globalakte.de / Admin123!',
            );
          },
          icon: Icons.info_outline,
        ),
        const SizedBox(height: AppConfig.defaultPadding),

        // Back to Welcome
        GlobalTextButton(
          text: 'Zurück zum Start',
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.arrow_back,
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isPinMode) {
        try {
          final user = await _signInWithPinUseCase.call(_pinController.text);
          SnackBarUtils.showSuccessSnackBar(
            context,
            'Erfolgreich mit PIN angemeldet: ${user.name}',
          );
          // Navigation zur Haupt-App
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        } catch (e) {
          SnackBarUtils.showErrorSnackBar(
            context,
            'Falsche PIN: $e',
          );
        }
      } else {
        try {
          final user = await _signInWithEmailUseCase.call(
            _emailController.text,
            _passwordController.text,
          );
          SnackBarUtils.showSuccessSnackBar(
            context,
            'Erfolgreich angemeldet: ${user.name}',
          );
          // Navigation zur Haupt-App
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        } catch (e) {
          SnackBarUtils.showErrorSnackBar(
            context,
            'Anmeldung fehlgeschlagen: $e',
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
        context,
        'Anmeldung fehlgeschlagen: ${e.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleRegister() {
    // TODO: Navigation zur Registrierung
    SnackBarUtils.showInfoSnackBar(
      context,
      'Registrierung wird implementiert...',
    );
  }

  void _handleBiometricLogin() {
    // TODO: Biometrie-Authentifizierung
    SnackBarUtils.showInfoSnackBar(
      context,
      'Biometrie-Authentifizierung wird implementiert...',
    );
  }

  void _handleForgotPassword() {
    // TODO: Passwort-Reset
    SnackBarUtils.showInfoSnackBar(
      context,
      'Passwort-Reset wird implementiert...',
    );
  }
}
