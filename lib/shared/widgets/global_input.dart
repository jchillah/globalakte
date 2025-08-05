// shared/widgets/global_input.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_config.dart';

/// Wiederverwendbare Input-Widgets für GlobalAkte
class GlobalTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;

  const GlobalTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: AppConfig.smallPadding),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          validator: validator,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          onTap: onTap,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: enabled
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            contentPadding: const EdgeInsets.all(AppConfig.defaultPadding),
          ),
        ),
      ],
    );
  }
}

/// PIN Input Widget für Authentifizierung
class PinInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const PinInputField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalTextField(
      label: 'PIN',
      hint: '6-stellige PIN eingeben',
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: true,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      prefixIcon: const Icon(Icons.lock_outline),
    );
  }
}

/// Email Input Widget
class EmailInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const EmailInputField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalTextField(
      label: 'E-Mail',
      hint: 'ihre.email@beispiel.de',
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      enabled: enabled,
      validator: validator ?? _emailValidator,
      onChanged: onChanged,
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-Mail ist erforderlich';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Bitte geben Sie eine gültige E-Mail-Adresse ein';
    }
    return null;
  }
}

/// Password Input Widget
class PasswordInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool showPasswordToggle;

  const PasswordInputField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.showPasswordToggle = true,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return GlobalTextField(
      label: 'Passwort',
      hint: 'Passwort eingeben',
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      enabled: widget.enabled,
      validator: widget.validator,
      onChanged: widget.onChanged,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: widget.showPasswordToggle
          ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          : null,
    );
  }
}
