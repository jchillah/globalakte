// features/authentication/presentation/screens/register_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

/// Registrierungs-Screen für GlobalAkte
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepositoryImpl();
  late final SignUpWithEmailAndPasswordUseCase _signUpUseCase;

  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String _selectedRole = 'citizen';

  @override
  void initState() {
    super.initState();
    _signUpUseCase = SignUpWithEmailAndPasswordUseCase(_authRepository);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Registrierung'),
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
                _buildRegistrationForm(),
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
            Icons.person_add,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppConfig.defaultPadding),
        const Text(
          'Konto erstellen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConfig.smallPadding),
        const Text(
          'Erstellen Sie Ihr GlobalAkte-Konto für sichere Fallakten-Verwaltung',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      children: [
        // Name Field
        GlobalTextField(
          controller: _nameController,
          label: 'Vollständiger Name',
          hint: 'Max Mustermann',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name ist erforderlich';
            }
            if (value.length < 2) {
              return 'Name muss mindestens 2 Zeichen haben';
            }
            return null;
          },
          prefixIcon: const Icon(Icons.person),
        ),

        const SizedBox(height: AppConfig.defaultPadding),

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

        // Role Selection
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppConfig.defaultPadding),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedRole,
            decoration: const InputDecoration(
              labelText: 'Rolle',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.work),
            ),
            items: const [
              DropdownMenuItem(
                value: 'citizen',
                child: Text('Bürger'),
              ),
              DropdownMenuItem(
                value: 'lawyer',
                child: Text('Anwalt'),
              ),
              DropdownMenuItem(
                value: 'admin',
                child: Text('Administrator'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
        ),

        const SizedBox(height: AppConfig.defaultPadding),

        // Password Field
        GlobalTextField(
          controller: _passwordController,
          label: 'Passwort',
          hint: 'Mindestens 8 Zeichen',
          obscureText: !_showPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Passwort ist erforderlich';
            }
            if (value.length < 8) {
              return 'Passwort muss mindestens 8 Zeichen haben';
            }
            if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])').hasMatch(value)) {
              return 'Passwort muss Großbuchstabe, Zahl und Sonderzeichen enthalten';
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

        const SizedBox(height: AppConfig.defaultPadding),

        // Confirm Password Field
        GlobalTextField(
          controller: _confirmPasswordController,
          label: 'Passwort bestätigen',
          hint: 'Passwort wiederholen',
          obscureText: !_showConfirmPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Passwort-Bestätigung ist erforderlich';
            }
            if (value != _passwordController.text) {
              return 'Passwörter stimmen nicht überein';
            }
            return null;
          },
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _showConfirmPassword = !_showConfirmPassword;
              });
            },
          ),
        ),

        const SizedBox(height: AppConfig.defaultPadding),

        // Terms and Conditions
        Row(
          children: [
            Checkbox(
              value: true,
              onChanged: (value) {
                // TODO: Implement terms acceptance
              },
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  children: [
                    const TextSpan(text: 'Ich akzeptiere die '),
                    TextSpan(
                      text: 'Nutzungsbedingungen',
                      style: TextStyle(
                        color: AppConfig.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' und '),
                    TextSpan(
                      text: 'Datenschutzerklärung',
                      style: TextStyle(
                        color: AppConfig.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GlobalButton(
          text: _isLoading ? 'Registrierung läuft...' : 'Konto erstellen',
          onPressed: _isLoading ? null : _handleRegister,
          icon: _isLoading ? null : Icons.person_add,
        ),
        const SizedBox(height: AppConfig.defaultPadding),
      ],
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        // Back to Login
        GlobalButton(
          text: 'Zurück zum Login',
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.arrow_back,
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _signUpUseCase.call(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _selectedRole,
      );

      if (!mounted) return;

      SnackBarUtils.showSuccessSnackBar(
        context,
        'Registrierung erfolgreich: ${user.name}',
      );

      // Navigation zur PIN-Setup
      Navigator.of(context).pushReplacementNamed('/pin-setup');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
        context,
        'Registrierung fehlgeschlagen: ${e.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 