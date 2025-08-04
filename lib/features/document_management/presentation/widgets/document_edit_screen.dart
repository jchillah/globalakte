// features/document_management/presentation/widgets/document_edit_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../domain/entities/document.dart';

/// Screen für die Bearbeitung von Dokument-Metadaten
class DocumentEditScreen extends StatefulWidget {
  final Document document;
  final Function(Document) onDocumentUpdated;

  const DocumentEditScreen({
    super.key,
    required this.document,
    required this.onDocumentUpdated,
  });

  @override
  State<DocumentEditScreen> createState() => _DocumentEditScreenState();
}

class _DocumentEditScreenState extends State<DocumentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late DocumentCategory _selectedCategory;
  late DocumentStatus _selectedStatus;
  late DocumentType _selectedType;
  bool _isEncrypted = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    _titleController = TextEditingController(text: widget.document.title);
    _descriptionController =
        TextEditingController(text: widget.document.description);
    _selectedCategory = widget.document.category;
    _selectedStatus = widget.document.status;
    _selectedType = widget.document.documentType;
    _isEncrypted = widget.document.isEncrypted;
  }

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
        title: const Text('Dokument bearbeiten'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveDocument,
            tooltip: 'Speichern',
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
            _buildDocumentInfo(),
            const SizedBox(height: 24),
            _buildCategorySelection(),
            const SizedBox(height: 24),
            _buildStatusSelection(),
            const SizedBox(height: 24),
            _buildTypeSelection(),
            const SizedBox(height: 24),
            _buildEncryptionToggle(),
            const SizedBox(height: 24),
            _buildMetadataSection(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.edit,
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

  Widget _buildStatusSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flag,
                  color: AppConfig.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<DocumentStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status auswählen',
                border: OutlineInputBorder(),
              ),
              items: DocumentStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
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

  Widget _buildMetadataSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: AppConfig.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Metadaten',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMetadataRow('Dateipfad', widget.document.filePath),
            _buildMetadataRow('Dateityp', widget.document.fileType),
            _buildMetadataRow(
                'Dateigröße', _formatFileSize(widget.document.fileSize)),
            _buildMetadataRow(
                'Erstellt', _formatDate(widget.document.createdAt)),
            if (widget.document.updatedAt != null)
              _buildMetadataRow(
                  'Aktualisiert', _formatDate(widget.document.updatedAt!)),
            _buildMetadataRow('Erstellt von', widget.document.createdBy),
            if (widget.document.caseId != null)
              _buildMetadataRow('Fall-ID', widget.document.caseId!),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: _isSaving ? null : _saveDocument,
      icon: _isSaving
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.save),
      label: Text(_isSaving ? 'Wird gespeichert...' : 'Änderungen speichern'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute}';
  }

  void _saveDocument() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Simuliere Speichern
      await Future.delayed(const Duration(seconds: 1));

      final updatedDocument = widget.document.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        status: _selectedStatus,
        documentType: _selectedType,
        isEncrypted: _isEncrypted,
        encryptionKeyId: _isEncrypted
            ? widget.document.encryptionKeyId ??
                'key_${DateTime.now().millisecondsSinceEpoch}'
            : null,
        updatedAt: DateTime.now(),
      );

      widget.onDocumentUpdated(updatedDocument);

      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(
            context, 'Dokument erfolgreich aktualisiert');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(context, 'Fehler beim Speichern: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
