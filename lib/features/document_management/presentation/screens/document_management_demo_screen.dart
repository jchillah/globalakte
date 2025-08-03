// features/document_management/presentation/screens/document_management_demo_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/utils/snackbar_utils.dart';
import '../../../encryption/data/repositories/encryption_repository_impl.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../../domain/entities/document.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/usecases/document_usecases.dart';

/// Demo-Screen für die Dokumentenverwaltung
class DocumentManagementDemoScreen extends StatefulWidget {
  const DocumentManagementDemoScreen({super.key});

  @override
  State<DocumentManagementDemoScreen> createState() =>
      _DocumentManagementDemoScreenState();
}

class _DocumentManagementDemoScreenState
    extends State<DocumentManagementDemoScreen> {
  late DocumentRepository _documentRepository;
  late CreateDocumentUseCase _createDocumentUseCase;
  late GetAllDocumentsUseCase _getAllDocumentsUseCase;
  late SearchDocumentsUseCase _searchDocumentsUseCase;
  late GetDocumentStatisticsUseCase _getDocumentStatisticsUseCase;
  late EncryptDocumentUseCase _encryptDocumentUseCase;
  late DecryptDocumentUseCase _decryptDocumentUseCase;
  late ExportDocumentUseCase _exportDocumentUseCase;
  late CreateBackupUseCase _createBackupUseCase;
  late SyncWithCloudUseCase _syncWithCloudUseCase;

  List<Document> _documents = [];
  Map<String, dynamic> _statistics = {};
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeRepository();
    _loadDocuments();
  }

  /// Initialisiert das Repository und die Use Cases
  Future<void> _initializeRepository() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptionRepository = EncryptionRepositoryImpl();

    _documentRepository = DocumentRepositoryImpl(prefs, encryptionRepository);

    _createDocumentUseCase = CreateDocumentUseCase(_documentRepository);
    _getAllDocumentsUseCase = GetAllDocumentsUseCase(_documentRepository);
    _searchDocumentsUseCase = SearchDocumentsUseCase(_documentRepository);
    _getDocumentStatisticsUseCase =
        GetDocumentStatisticsUseCase(_documentRepository);
    _encryptDocumentUseCase = EncryptDocumentUseCase(_documentRepository);
    _decryptDocumentUseCase = DecryptDocumentUseCase(_documentRepository);
    _exportDocumentUseCase = ExportDocumentUseCase(_documentRepository);
    _createBackupUseCase = CreateBackupUseCase(_documentRepository);
    _syncWithCloudUseCase = SyncWithCloudUseCase(_documentRepository);
  }

  /// Lädt alle Dokumente
  Future<void> _loadDocuments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final documents = await _getAllDocumentsUseCase();
      final statistics = await _getDocumentStatisticsUseCase();

      setState(() {
        _documents = documents;
        _statistics = statistics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Laden der Dokumente: $e');
      }
    }
  }

  /// Erstellt ein Demo-Dokument
  Future<void> _createDemoDocument() async {
    try {
      final demoDocument = Document(
        id: '',
        title: 'Demo-Dokument ${_documents.length + 1}',
        description: 'Ein Demo-Dokument für Testzwecke',
        filePath: '/demo/path/document_${_documents.length + 1}.pdf',
        fileType: 'pdf',
        fileSize: 1024 * 1024, // 1MB
        createdAt: DateTime.now(),
        createdBy: 'demo_user',
        category: DocumentCategory.legal,
        status: DocumentStatus.draft,
        isEncrypted: false,
      );

      final createdDocument = await _createDocumentUseCase(demoDocument);

      setState(() {
        _documents.add(createdDocument);
      });

      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(
            context, 'Demo-Dokument erstellt: ${createdDocument.title}');
      }
      await _loadDocuments(); // Aktualisiere Statistiken
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Erstellen des Demo-Dokuments: $e');
      }
    }
  }

  /// Verschlüsselt ein Dokument
  Future<void> _encryptDocument(String documentId) async {
    try {
      await _encryptDocumentUseCase(documentId, 'demo_key_1');
      await _loadDocuments();
      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(context, 'Dokument verschlüsselt');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Verschlüsseln: $e');
      }
    }
  }

  /// Entschlüsselt ein Dokument
  Future<void> _decryptDocument(String documentId) async {
    try {
      await _decryptDocumentUseCase(documentId);
      await _loadDocuments();
      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(context, 'Dokument entschlüsselt');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Entschlüsseln: $e');
      }
    }
  }

  /// Exportiert ein Dokument
  Future<void> _exportDocument(String documentId) async {
    try {
      final exportPath = await _exportDocumentUseCase(documentId, 'pdf');
      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(
            context, 'Dokument exportiert: $exportPath');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(context, 'Fehler beim Exportieren: $e');
      }
    }
  }

  /// Erstellt ein Backup
  Future<void> _createBackup() async {
    try {
      final backupPath = await _createBackupUseCase();
      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(
            context, 'Backup erstellt: $backupPath');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Erstellen des Backups: $e');
      }
    }
  }

  /// Synchronisiert mit der Cloud
  Future<void> _syncWithCloud() async {
    try {
      final success = await _syncWithCloudUseCase();
      if (mounted) {
        if (success) {
          SnackBarUtils.showSuccessSnackBar(
              context, 'Cloud-Synchronisation erfolgreich');
        } else {
          SnackBarUtils.showErrorSnackBar(
              context, 'Cloud-Synchronisation fehlgeschlagen');
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler bei der Cloud-Synchronisation: $e');
      }
    }
  }

  /// Sucht Dokumente
  Future<void> _searchDocuments(String query) async {
    try {
      final results = await _searchDocumentsUseCase(query);
      setState(() {
        _documents = results;
        _searchQuery = query;
      });
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(context, 'Fehler bei der Suche: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dokumentenverwaltung Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDocuments,
            tooltip: 'Aktualisieren',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStatisticsCard(),
                _buildSearchBar(),
                Expanded(
                  child: _documents.isEmpty
                      ? _buildEmptyState()
                      : _buildDocumentsList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createDemoDocument,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Erstellt die Statistik-Karte
  Widget _buildStatisticsCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dokumenten-Statistiken',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatItem(
                  'Gesamt',
                  _statistics['totalDocuments']?.toString() ?? '0',
                  Icons.description,
                ),
                _buildStatItem(
                  'Verschlüsselt',
                  _statistics['encryptedDocuments']?.toString() ?? '0',
                  Icons.lock,
                ),
                _buildStatItem(
                  'Größe',
                  '${(_statistics['totalSize'] ?? 0) ~/ 1024} KB',
                  Icons.storage,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _createBackup,
                    icon: const Icon(Icons.backup),
                    label: const Text('Backup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _syncWithCloud,
                    icon: const Icon(Icons.cloud_sync),
                    label: const Text('Cloud Sync'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Erstellt ein Statistik-Element
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Erstellt die Suchleiste
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Dokumente suchen...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                    _loadDocuments();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            _loadDocuments();
          } else {
            _searchDocuments(value);
          }
        },
      ),
    );
  }

  /// Erstellt den leeren Zustand
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
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Erstellen Sie Ihr erstes Dokument mit dem + Button',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Erstellt die Dokumentenliste
  Widget _buildDocumentsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _documents.length,
      itemBuilder: (context, index) {
        final document = _documents[index];
        return _buildDocumentCard(document);
      },
    );
  }

  /// Erstellt eine Dokumenten-Karte
  Widget _buildDocumentCard(Document document) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(document.category),
          child: Icon(
            _getCategoryIcon(document.category),
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
                _buildStatusChip(document.status),
                const SizedBox(width: 8),
                if (document.isEncrypted)
                  const Chip(
                    label: Text('Verschlüsselt'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white, fontSize: 10),
                  ),
              ],
            ),
            Text(
              '${document.fileSize ~/ 1024} KB • ${document.fileType.toUpperCase()}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'encrypt':
                _encryptDocument(document.id);
                break;
              case 'decrypt':
                _decryptDocument(document.id);
                break;
              case 'export':
                _exportDocument(document.id);
                break;
            }
          },
          itemBuilder: (context) => [
            if (!document.isEncrypted)
              const PopupMenuItem(
                value: 'encrypt',
                child: Row(
                  children: [
                    Icon(Icons.lock),
                    SizedBox(width: 8),
                    Text('Verschlüsseln'),
                  ],
                ),
              ),
            if (document.isEncrypted)
              const PopupMenuItem(
                value: 'decrypt',
                child: Row(
                  children: [
                    Icon(Icons.lock_open),
                    SizedBox(width: 8),
                    Text('Entschlüsseln'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.download),
                  SizedBox(width: 8),
                  Text('Exportieren'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Erstellt einen Status-Chip
  Widget _buildStatusChip(DocumentStatus status) {
    Color backgroundColor;
    String label;

    switch (status) {
      case DocumentStatus.draft:
        backgroundColor = Colors.grey;
        label = 'Entwurf';
        break;
      case DocumentStatus.pending:
        backgroundColor = Colors.orange;
        label = 'Ausstehend';
        break;
      case DocumentStatus.approved:
        backgroundColor = Colors.green;
        label = 'Genehmigt';
        break;
      case DocumentStatus.rejected:
        backgroundColor = Colors.red;
        label = 'Abgelehnt';
        break;
      case DocumentStatus.archived:
        backgroundColor = Colors.blue;
        label = 'Archiviert';
        break;
      case DocumentStatus.expired:
        backgroundColor = Colors.purple;
        label = 'Abgelaufen';
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      backgroundColor: backgroundColor,
    );
  }

  /// Holt die Farbe für eine Kategorie
  Color _getCategoryColor(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.legal:
        return Colors.red;
      case DocumentCategory.medical:
        return Colors.green;
      case DocumentCategory.financial:
        return Colors.blue;
      case DocumentCategory.personal:
        return Colors.purple;
      case DocumentCategory.official:
        return Colors.orange;
      case DocumentCategory.correspondence:
        return Colors.teal;
      case DocumentCategory.evidence:
        return Colors.indigo;
      case DocumentCategory.contract:
        return Colors.brown;
      case DocumentCategory.certificate:
        return Colors.cyan;
      case DocumentCategory.other:
        return Colors.grey;
    }
  }

  /// Holt das Icon für eine Kategorie
  IconData _getCategoryIcon(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.legal:
        return Icons.gavel;
      case DocumentCategory.medical:
        return Icons.medical_services;
      case DocumentCategory.financial:
        return Icons.account_balance;
      case DocumentCategory.personal:
        return Icons.person;
      case DocumentCategory.official:
        return Icons.admin_panel_settings;
      case DocumentCategory.correspondence:
        return Icons.mail;
      case DocumentCategory.evidence:
        return Icons.fingerprint;
      case DocumentCategory.contract:
        return Icons.description;
      case DocumentCategory.certificate:
        return Icons.verified;
      case DocumentCategory.other:
        return Icons.folder;
    }
  }
}
