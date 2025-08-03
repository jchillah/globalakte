import 'package:flutter/material.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../domain/entities/encrypted_data.dart';

/// Widget für die Verschlüsselungs-Sektion
class EncryptionSectionWidget extends StatefulWidget {
  final String selectedKeyId;
  final EncryptedData? lastEncryptedData;
  final Function(String) onEncrypt;
  final Function() onDecrypt;
  final bool isLoading;

  const EncryptionSectionWidget({
    super.key,
    required this.selectedKeyId,
    required this.lastEncryptedData,
    required this.onEncrypt,
    required this.onDecrypt,
    required this.isLoading,
  });

  @override
  State<EncryptionSectionWidget> createState() => _EncryptionSectionWidgetState();
}

class _EncryptionSectionWidgetState extends State<EncryptionSectionWidget> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
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
                    isLoading: widget.isLoading,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GlobalButton(
                    onPressed: _decryptData,
                    text: 'Entschlüsseln',
                    isLoading: widget.isLoading,
                  ),
                ),
              ],
            ),
            if (widget.lastEncryptedData != null) ...[
              const SizedBox(height: 16),
              _buildEncryptedDataDisplay(),
            ],
          ],
        ),
      ),
    );
  }

  void _encryptData() {
    if (_textController.text.trim().isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Bitte geben Sie Text zum Verschlüsseln ein');
      return;
    }

    if (widget.selectedKeyId.isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Bitte wählen Sie einen Schlüssel aus');
      return;
    }

    widget.onEncrypt(_textController.text.trim());
  }

  void _decryptData() {
    if (widget.lastEncryptedData == null) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Keine verschlüsselten Daten vorhanden');
      return;
    }

    widget.onDecrypt();
  }

  Widget _buildEncryptedDataDisplay() {
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
            'Letzte verschlüsselte Daten:',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text('ID: ${widget.lastEncryptedData!.id}'),
          Text('Algorithmus: ${widget.lastEncryptedData!.algorithm}'),
          Text('Erstellt: ${widget.lastEncryptedData!.createdAt.toString()}'),
          if (widget.lastEncryptedData!.hasChecksum)
            Text(
                'Checksum: ${widget.lastEncryptedData!.checksum!.substring(0, 16)}...'),
        ],
      ),
    );
  }
} 