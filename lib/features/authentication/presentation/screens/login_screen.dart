// features/authentication/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

/// Login Screen für GlobalAkte
/// Verbesserte Version mit Barrierefreiheit und moderner UI
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
  bool _rememberMe = false;

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
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
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
                _buildRememberMeCheckbox(),
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
            boxShadow: [
              BoxShadow(
                color: AppConfig.primaryColor.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.gavel,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppConfig.defaultPadding),
        Text(
          'Willkommen zurück',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConfig.smallPadding),
        Text(
          'Melden Sie sich an, um auf Ihre Akten zuzugreifen',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isPinMode = false),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConfig.smallPadding,
                ),
                decoration: BoxDecoration(
                  color: !_isPinMode
                      ? AppConfig.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConfig.smallRadius),
                ),
                child: Text(
                  'E-Mail',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_isPinMode
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConfig.smallPadding),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isPinMode = true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConfig.smallPadding,
                ),
                decoration: BoxDecoration(
                  color: _isPinMode
                      ? AppConfig.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConfig.smallRadius),
                ),
                child: Text(
                  'PIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isPinMode
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthForm() {
    if (_isPinMode) {
      return _buildPinForm();
    } else {
      return _buildEmailForm();
    }
  }

  Widget _buildEmailForm() {
    return Column(
      children: [
        GlobalInput(
          controller: _emailController,
          labelText: 'E-Mail-Adresse',
          hintText: 'ihre.email@beispiel.de',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bitte geben Sie Ihre E-Mail-Adresse ein';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Bitte geben Sie eine gültige E-Mail-Adresse ein';
            }
            return null;
          },
          onFieldSubmitted: (_) => _handleLogin(),
        ),
        const SizedBox(height: AppConfig.defaultPadding),
        GlobalInput(
          controller: _passwordController,
          labelText: 'Passwort',
          hintText: 'Ihr Passwort',
          obscureText: !_showPassword,
          prefixIcon: const Icon(Icons.lock_outlined),
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bitte geben Sie Ihr Passwort ein';
            }
            if (value.length < 6) {
              return 'Das Passwort muss mindestens 6 Zeichen lang sein';
            }
            return null;
          },
          onFieldSubmitted: (_) => _handleLogin(),
        ),
      ],
    );
  }

  Widget _buildPinForm() {
    return Column(
      children: [
        GlobalInput(
          controller: _pinController,
          labelText: 'PIN',
          hintText: 'Ihre 4-stellige PIN',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          prefixIcon: const Icon(Icons.pin_outlined),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bitte geben Sie Ihre PIN ein';
            }
            if (value.length != 4) {
              return 'Die PIN muss 4-stellig sein';
            }
            return null;
          },
          onFieldSubmitted: (_) => _handleLogin(),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) => setState(() => _rememberMe = value ?? false),
          activeColor: AppConfig.primaryColor,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _rememberMe = !_rememberMe),
            child: Text(
              'Angemeldet bleiben',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GlobalButton(
          text: _isLoading ? 'Anmelden...' : 'Anmelden',
          onPressed: _isLoading ? null : _handleLogin,
          isLoading: _isLoading,
        ),
        const SizedBox(height: AppConfig.defaultPadding),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: Text(
            'Noch kein Konto? Registrieren',
            style: TextStyle(
              color: AppConfig.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: AppConfig.defaultPadding),
        TextButton.icon(
          onPressed: _handleForgotPassword,
          icon: const Icon(Icons.help_outline),
          label: const Text('Passwort vergessen?'),
        ),
        const SizedBox(height: AppConfig.smallPadding),
        TextButton.icon(
          onPressed: _handleBiometricLogin,
          icon: const Icon(Icons.fingerprint),
          label: const Text('Biometrische Anmeldung'),
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isPinMode) {
        await _signInWithPinUseCase.execute(_pinController.text);
      } else {
        await _signInWithEmailUseCase.execute(
          _emailController.text,
          _passwordController.text,
        );
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
        SnackBarUtils.showSuccess(
          context,
          'Erfolgreich angemeldet!',
        );
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(
          context,
          'Anmeldung fehlgeschlagen: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleForgotPassword() {
    // TODO: Implementiere Passwort-Reset-Funktionalität
    SnackBarUtils.showInfo(
      context,
      'Passwort-Reset-Funktion wird implementiert',
    );
  }

  void _handleBiometricLogin() {
    // TODO: Implementiere biometrische Anmeldung
    SnackBarUtils.showInfo(
      context,
      'Biometrische Anmeldung wird implementiert',
    );
  }
}
