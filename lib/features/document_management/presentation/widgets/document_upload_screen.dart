// features/document_management/presentation/widgets/document_upload_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../domain/entities/document.dart';

/// Screen für das Hochladen von Dokumenten
class DocumentUploadScreen extends StatefulWidget {
  final String? caseId;
  final Function(Document) onDocumentUploaded;

  const DocumentUploadScreen({
    super.key,
    this.caseId,
    required this.onDocumentUploaded,
  });

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DocumentCategory _selectedCategory = DocumentCategory.other;
  DocumentType _selectedType = DocumentType.other;
  bool _isEncrypted = false;
  bool _isUploading = false;
  String? _selectedFilePath;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dokument hochladen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
            tooltip: 'Hilfe anzeigen',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFileSelection(),
            const SizedBox(height: 24),
            _buildDocumentForm(),
            const SizedBox(height: 24),
            _buildCategorySelection(),
            const SizedBox(height: 24),
            _buildTypeSelection(),
            const SizedBox(height: 24),
            _buildEncryptionToggle(),
            const SizedBox(height: 32),
            _buildUploadButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.upload_file,
                  color: AppConfig.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Datei auswählen',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _selectedFilePath != null
                      ? Colors.green
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: _selectFile,
                borderRadius: BorderRadius.circular(8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedFilePath != null
                            ? Icons.check_circle
                            : Icons.add,
                        size: 48,
                        color: _selectedFilePath != null
                            ? Colors.green
                            : Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedFilePath != null
                            ? 'Datei ausgewählt'
                            : 'Datei auswählen',
                        style: TextStyle(
                          color: _selectedFilePath != null
                              ? Colors.green
                              : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_selectedFilePath != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _selectedFilePath!,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Unterstützte Formate: PDF, Bilder, Text, Word, Excel, Audio, Video, Archive',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description,
                  color: AppConfig.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Dokument-Informationen',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titel *',
                hintText: 'Dokument-Titel eingeben',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Titel ist erforderlich';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Beschreibung',
                hintText: 'Dokument-Beschreibung eingeben',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.category,
                  color: AppConfig.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Kategorie',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<DocumentCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategorie auswählen',
                border: OutlineInputBorder(),
              ),
              items: DocumentCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insert_drive_file,
                  color: AppConfig.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Dokumententyp',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<DocumentType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Typ auswählen',
                border: OutlineInputBorder(),
              ),
              items: DocumentType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEncryptionToggle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.security,
                  color: AppConfig.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Sicherheit',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dokument verschlüsseln'),
              subtitle: const Text('Dokument wird mit AES-256 verschlüsselt'),
              value: _isEncrypted,
              onChanged: (value) {
                setState(() {
                  _isEncrypted = value;
                });
              },
              secondary: Icon(
                _isEncrypted ? Icons.lock : Icons.lock_open,
                color: _isEncrypted ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return ElevatedButton.icon(
      onPressed: _isUploading ? null : _uploadDocument,
      icon: _isUploading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.upload),
      label: Text(_isUploading ? 'Wird hochgeladen...' : 'Dokument hochladen'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  void _selectFile() {
    // Simuliere Dateiauswahl
    setState(() {
      _selectedFilePath = '/path/to/selected/document.pdf';
    });
    SnackBarUtils.showInfoSnackBar(
        context, 'Dateiauswahl wird implementiert...');
  }

  void _uploadDocument() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedFilePath == null) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Bitte wählen Sie eine Datei aus');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Simuliere Upload
      await Future.delayed(const Duration(seconds: 2));

      final document = Document(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        filePath: _selectedFilePath!,
        fileType: 'pdf',
        documentType: _selectedType,
        fileSize: 1024 * 1024, // 1MB
        createdAt: DateTime.now(),
        createdBy: 'Current User',
        caseId: widget.caseId,
        category: _selectedCategory,
        status: DocumentStatus.pending,
        isEncrypted: _isEncrypted,
        encryptionKeyId: _isEncrypted
            ? 'key_${DateTime.now().millisecondsSinceEpoch}'
            : null,
        metadata: {
          'uploadMethod': 'manual',
          'originalName': 'document.pdf',
        },
      );

      widget.onDocumentUploaded(document);

      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(
            context, 'Dokument erfolgreich hochgeladen');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(context, 'Fehler beim Hochladen: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hilfe - Dokument hochladen'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'So laden Sie ein Dokument hoch:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('1. Wählen Sie eine Datei aus'),
              Text('2. Füllen Sie die Dokument-Informationen aus'),
              Text('3. Wählen Sie Kategorie und Typ'),
              Text('4. Aktivieren Sie Verschlüsselung (optional)'),
              Text('5. Klicken Sie auf "Hochladen"'),
              SizedBox(height: 12),
              Text(
                'Unterstützte Formate:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• PDF, Bilder, Text, Word, Excel'),
              Text('• Audio, Video, Archive'),
              Text('• Maximale Größe: 50 MB'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }
}
