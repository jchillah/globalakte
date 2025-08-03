import 'package:flutter/material.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';

/// Widget für die Passwort-Sektion
class PasswordSectionWidget extends StatefulWidget {
  final String lastHash;
  final Function(String) onHashPassword;
  final Function(String) onVerifyPassword;
  final bool isLoading;

  const PasswordSectionWidget({
    super.key,
    required this.lastHash,
    required this.onHashPassword,
    required this.onVerifyPassword,
    required this.isLoading,
  });

  @override
  State<PasswordSectionWidget> createState() => _PasswordSectionWidgetState();
}

class _PasswordSectionWidgetState extends State<PasswordSectionWidget> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    isLoading: widget.isLoading,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GlobalButton(
                    onPressed: _verifyPassword,
                    text: 'Verifizieren',
                    isLoading: widget.isLoading,
                  ),
                ),
              ],
            ),
            if (widget.lastHash.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildHashDisplay(),
            ],
          ],
        ),
      ),
    );
  }

  void _hashPassword() {
    if (_passwordController.text.trim().isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Bitte geben Sie ein Passwort ein');
      return;
    }

    widget.onHashPassword(_passwordController.text.trim());
  }

  void _verifyPassword() {
    if (_passwordController.text.trim().isEmpty || widget.lastHash.isEmpty) {
      SnackBarUtils.showErrorSnackBar(context,
          'Bitte geben Sie ein Passwort ein und erstellen Sie zuerst einen Hash');
      return;
    }

    widget.onVerifyPassword(_passwordController.text.trim());
  }

  Widget _buildHashDisplay() {
    return Container(
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
          Text(widget.lastHash, style: const TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }
} 