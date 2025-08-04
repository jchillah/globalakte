// features/document_management/presentation/widgets/document_list_screen.dart
import 'package:flutter/material.dart';

import '../../../../shared/utils/snackbar_utils.dart';
import '../../domain/entities/document.dart';

/// Screen für die Übersicht aller Dokumente
class DocumentListScreen extends StatefulWidget {
  final List<Document> documents;
  final Function(Document) onDocumentSelected;
  final Function(Document) onDocumentDeleted;
  final VoidCallback onRefresh;

  const DocumentListScreen({
    super.key,
    required this.documents,
    required this.onDocumentSelected,
    required this.onDocumentDeleted,
    required this.onRefresh,
  });

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  String _searchQuery = '';
  DocumentCategory? _selectedCategory;
  DocumentStatus? _selectedStatus;
  DocumentType? _selectedType;

  List<Document> get _filteredDocuments {
    return widget.documents.where((document) {
      // Suchfilter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!document.title.toLowerCase().contains(query) &&
            !document.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Kategorie-Filter
      if (_selectedCategory != null && document.category != _selectedCategory) {
        return false;
      }

      // Status-Filter
      if (_selectedStatus != null && document.status != _selectedStatus) {
        return false;
      }

      // Typ-Filter
      if (_selectedType != null && document.documentType != _selectedType) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchAndFilters(),
        const SizedBox(height: 16),
        Expanded(
          child: _buildDocumentList(),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Suchfeld
            TextField(
              decoration: const InputDecoration(
                labelText: 'Dokumente durchsuchen',
                hintText: 'Titel oder Beschreibung eingeben...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Filter
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<DocumentCategory>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategorie',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Alle'),
                      ),
                      ...DocumentCategory.values.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<DocumentStatus>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Alle'),
                      ),
                      ...DocumentStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.name),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<DocumentType>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Typ',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Alle'),
                      ),
                      ...DocumentType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.displayName),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentList() {
    if (_filteredDocuments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: _filteredDocuments.length,
      itemBuilder: (context, index) {
        final document = _filteredDocuments[index];
        return _buildDocumentCard(document);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Keine Dokumente gefunden',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Erstellen Sie ein neues Dokument oder ändern Sie die Filter',
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(Document document) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getDocumentColor(document.documentType),
          child: Icon(
            _getDocumentIcon(document.documentType),
            color: Colors.white,
          ),
        ),
        title: Text(
          document.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(document.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(document.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    document.status.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    document.documentType.displayName,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                ),
                if (document.isEncrypted) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.lock,
                    size: 16,
                    color: Colors.green[600],
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleDocumentAction(action, document),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('Anzeigen'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Bearbeiten'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'download',
              child: Row(
                children: [
                  Icon(Icons.download),
                  SizedBox(width: 8),
                  Text('Herunterladen'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share),
                  SizedBox(width: 8),
                  Text('Teilen'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Löschen', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => widget.onDocumentSelected(document),
      ),
    );
  }

  Color _getDocumentColor(DocumentType type) {
    switch (type) {
      case DocumentType.pdf:
        return Colors.red;
      case DocumentType.image:
        return Colors.green;
      case DocumentType.text:
        return Colors.blue;
      case DocumentType.word:
        return Colors.indigo;
      case DocumentType.excel:
        return Colors.green;
      case DocumentType.audio:
        return Colors.orange;
      case DocumentType.video:
        return Colors.purple;
      case DocumentType.archive:
        return Colors.brown;
      case DocumentType.other:
        return Colors.grey;
    }
  }

  IconData _getDocumentIcon(DocumentType type) {
    switch (type) {
      case DocumentType.pdf:
        return Icons.picture_as_pdf;
      case DocumentType.image:
        return Icons.image;
      case DocumentType.text:
        return Icons.text_snippet;
      case DocumentType.word:
        return Icons.description;
      case DocumentType.excel:
        return Icons.table_chart;
      case DocumentType.audio:
        return Icons.audiotrack;
      case DocumentType.video:
        return Icons.video_file;
      case DocumentType.archive:
        return Icons.archive;
      case DocumentType.other:
        return Icons.insert_drive_file;
    }
  }

  Color _getStatusColor(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.draft:
        return Colors.grey;
      case DocumentStatus.pending:
        return Colors.orange;
      case DocumentStatus.approved:
        return Colors.green;
      case DocumentStatus.rejected:
        return Colors.red;
      case DocumentStatus.archived:
        return Colors.blue;
      case DocumentStatus.expired:
        return Colors.red;
    }
  }

  void _handleDocumentAction(String action, Document document) {
    switch (action) {
      case 'view':
        widget.onDocumentSelected(document);
        break;
      case 'edit':
        SnackBarUtils.showInfoSnackBar(
            context, 'Bearbeiten wird implementiert...');
        break;
      case 'download':
        SnackBarUtils.showInfoSnackBar(
            context, 'Download wird implementiert...');
        break;
      case 'share':
        SnackBarUtils.showInfoSnackBar(context, 'Teilen wird implementiert...');
        break;
      case 'delete':
        _showDeleteConfirmation(document);
        break;
    }
  }

  void _showDeleteConfirmation(Document document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dokument löschen'),
        content: Text(
          'Möchten Sie das Dokument "${document.title}" wirklich löschen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDocumentDeleted(document);
              SnackBarUtils.showSuccessSnackBar(
                context,
                'Dokument erfolgreich gelöscht',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }
}
