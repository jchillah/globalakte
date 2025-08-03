import 'package:flutter/material.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../domain/entities/encryption_key.dart';

/// Widget für die Schlüssel-Verwaltung
class KeyManagementWidget extends StatefulWidget {
  final List<EncryptionKey> keys;
  final String selectedKeyId;
  final Function(String) onKeySelected;
  final Function(String) onCreateKey;
  final bool isLoading;

  const KeyManagementWidget({
    super.key,
    required this.keys,
    required this.selectedKeyId,
    required this.onKeySelected,
    required this.onCreateKey,
    required this.isLoading,
  });

  @override
  State<KeyManagementWidget> createState() => _KeyManagementWidgetState();
}

class _KeyManagementWidgetState extends State<KeyManagementWidget> {
  final TextEditingController _keyNameController = TextEditingController();

  @override
  void dispose() {
    _keyNameController.dispose();
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
              isLoading: widget.isLoading,
            ),
            const SizedBox(height: 16),
            if (widget.keys.isNotEmpty) ...[
              Text(
                'Verfügbare Schlüssel:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...(widget.keys.map((key) => ListTile(
                    title: Text(key.name),
                    subtitle: Text(
                        '${key.algorithm} - ${key.isValid ? 'Aktiv' : 'Inaktiv'}'),
                    trailing: DropdownButton<String>(
                      value: widget.selectedKeyId == key.id ? key.id : null,
                      onChanged: (value) {
                        if (value != null) {
                          widget.onKeySelected(value);
                        }
                      },
                      items: widget.keys
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

  void _createKey() {
    if (_keyNameController.text.trim().isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Bitte geben Sie einen Schlüsselnamen ein');
      return;
    }

    widget.onCreateKey(_keyNameController.text.trim());
    _keyNameController.clear();
  }
} 