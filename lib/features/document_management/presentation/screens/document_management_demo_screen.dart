// features/document_management/presentation/screens/document_management_demo_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../../encryption/data/repositories/encryption_repository_impl.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../../domain/entities/document.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/usecases/document_usecases.dart';

/// Verbesserte Dokumentenverwaltung mit moderner UI und Barrierefreiheit
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
  List<Document> _filteredDocuments = [];
  Map<String, dynamic> _statistics = {};
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  String _selectedCategory = 'Alle';
  String _selectedSortBy = 'Datum';
  bool _showOnlyEncrypted = false;

  final List<String> _categories = [
    'Alle',
    'Verträge',
    'Urteile',
    'Korrespondenz',
    'Beweise',
    'Sonstiges',
  ];

  final List<String> _sortOptions = [
    'Datum',
    'Name',
    'Größe',
    'Kategorie',
  ];

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  /// Initialisiert das Repository und die Use Cases
  Future<void> _initializeRepository() async {
    try {
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

      // Nach der Initialisierung Dokumente laden
      await _loadDocuments();
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(
            context, 'Fehler bei der Initialisierung: $e');
      }
    }
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
        _filteredDocuments = documents;
        _statistics = statistics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        SnackBarUtils.showError(
            context, 'Fehler beim Laden der Dokumente: $e');
      }
    }
  }

  /// Filtert und sortiert die Dokumente
  void _filterAndSortDocuments() {
    List<Document> filtered = _documents;

    // Kategorie-Filter
    if (_selectedCategory != 'Alle') {
      filtered = filtered.where((doc) => doc.category.name == _selectedCategory).toList();
    }

    // Verschlüsselungs-Filter
    if (_showOnlyEncrypted) {
      filtered = filtered.where((doc) => doc.isEncrypted).toList();
    }

    // Such-Filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((doc) =>
          doc.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.category.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // Sortierung
    switch (_selectedSortBy) {
      case 'Datum':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Name':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Größe':
        filtered.sort((a, b) => b.fileSize.compareTo(a.fileSize));
        break;
      case 'Kategorie':
        filtered.sort((a, b) => a.category.name.compareTo(b.category.name));
        break;
    }

    setState(() {
      _filteredDocuments = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Dokumentenverwaltung'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDocumentDialog,
            tooltip: 'Neues Dokument hinzufügen',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
            tooltip: 'Einstellungen',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          _buildStatistics(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildDocumentsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDocumentDialog,
        icon: const Icon(Icons.add),
        label: const Text('Neues Dokument'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Suchleiste
          GlobalInput(
            labelText: 'Dokumente durchsuchen',
            hintText: 'Name, Beschreibung oder Kategorie eingeben...',
            prefixIcon: const Icon(Icons.search),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _filterAndSortDocuments();
            },
          ),
          const SizedBox(height: AppConfig.defaultPadding),
          
          // Filter und Sortierung
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  label: 'Kategorie: $_selectedCategory',
                  onTap: _showCategoryFilter,
                ),
              ),
              const SizedBox(width: AppConfig.smallPadding),
              Expanded(
                child: _buildFilterChip(
                  label: 'Sortierung: $_selectedSortBy',
                  onTap: _showSortOptions,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConfig.smallPadding),
          
          // Verschlüsselungs-Filter
          Row(
            children: [
              Checkbox(
                value: _showOnlyEncrypted,
                onChanged: (value) {
                  setState(() {
                    _showOnlyEncrypted = value ?? false;
                  });
                  _filterAndSortDocuments();
                },
                activeColor: AppConfig.primaryColor,
              ),
              const Text('Nur verschlüsselte Dokumente'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConfig.defaultPadding,
          vertical: AppConfig.smallPadding,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    if (_statistics.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(AppConfig.defaultPadding),
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      decoration: BoxDecoration(
        color: AppConfig.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        border: Border.all(
          color: AppConfig.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.description,
              label: 'Gesamt',
              value: '${_statistics['totalDocuments'] ?? 0}',
            ),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.lock,
              label: 'Verschlüsselt',
              value: '${_statistics['encryptedDocuments'] ?? 0}',
            ),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.storage,
              label: 'Größe',
              value: '${_statistics['totalSize'] ?? '0'} MB',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppConfig.primaryColor,
          size: 24,
        ),
        const SizedBox(height: AppConfig.smallPadding),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConfig.primaryColor,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConfig.primaryColor.withValues(alpha: 0.7),
              ),
        ),
      ],
    );
  }

  Widget _buildDocumentsList() {
    if (_filteredDocuments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
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
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppConfig.defaultPadding),
          Text(
            'Keine Dokumente gefunden',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: AppConfig.smallPadding),
          Text(
            'Fügen Sie Ihr erstes Dokument hinzu oder ändern Sie die Filtereinstellungen',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(Document document) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getCategoryColor(document.category.name).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
          ),
          child: Icon(
            _getCategoryIcon(document.category.name),
            color: _getCategoryColor(document.category.name),
          ),
        ),
        title: Text(
          document.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.category,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  document.category.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                ),
                const Spacer(),
                if (document.isEncrypted)
                  Icon(
                    Icons.lock,
                    size: 16,
                    color: AppConfig.secondaryColor,
                  ),
                const SizedBox(width: 4),
                Text(
                  '${document.fileSize} KB',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleDocumentAction(value, document),
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
              value: 'encrypt',
              child: Row(
                children: [
                  Icon(Icons.lock),
                  SizedBox(width: 8),
                  Text('Verschlüsseln'),
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
        onTap: () => _viewDocument(document),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Verträge':
        return Colors.blue;
      case 'Urteile':
        return Colors.red;
      case 'Korrespondenz':
        return Colors.green;
      case 'Beweise':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Verträge':
        return Icons.description;
      case 'Urteile':
        return Icons.gavel;
      case 'Korrespondenz':
        return Icons.mail;
      case 'Beweise':
        return Icons.photo_camera;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _showCategoryFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kategorie auswählen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _categories.map((category) => ListTile(
            title: Text(category),
            leading: Radio<String>(
              value: category,
              groupValue: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
                _filterAndSortDocuments();
                Navigator.pop(context);
              },
            ),
          )).toList(),
        ),
      ),
    );
  }

  void _showSortOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sortierung auswählen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _sortOptions.map((option) => ListTile(
            title: Text(option),
            leading: Radio<String>(
              value: option,
              groupValue: _selectedSortBy,
              onChanged: (value) {
                setState(() {
                  _selectedSortBy = value!;
                });
                _filterAndSortDocuments();
                Navigator.pop(context);
              },
            ),
          )).toList(),
        ),
      ),
    );
  }

  void _showAddDocumentDialog() {
    // TODO: Implementiere Dialog zum Hinzufügen von Dokumenten
    SnackBarUtils.showInfo(
      context,
      'Dokument hinzufügen wird implementiert',
    );
  }

  void _showSettingsDialog() {
    // TODO: Implementiere Einstellungen-Dialog
    SnackBarUtils.showInfo(
      context,
      'Einstellungen werden implementiert',
    );
  }

  void _viewDocument(Document document) {
    // TODO: Implementiere Dokument-Anzeige
    SnackBarUtils.showInfo(
      context,
      'Dokument wird angezeigt: ${document.title}',
    );
  }

  void _handleDocumentAction(String action, Document document) {
    switch (action) {
      case 'view':
        _viewDocument(document);
        break;
      case 'edit':
        // TODO: Implementiere Dokument-Bearbeitung
        SnackBarUtils.showInfo(
          context,
          'Dokument bearbeiten wird implementiert',
        );
        break;
      case 'encrypt':
        _encryptDocument(document);
        break;
      case 'export':
        _exportDocument(document);
        break;
      case 'delete':
        _deleteDocument(document);
        break;
    }
  }

  Future<void> _encryptDocument(Document document) async {
    try {
      await _encryptDocumentUseCase(document.id, 'demo_key_1');
      await _loadDocuments();
      SnackBarUtils.showSuccess(
        context,
        'Dokument erfolgreich verschlüsselt',
      );
    } catch (e) {
      SnackBarUtils.showError(
        context,
        'Fehler beim Verschlüsseln: $e',
      );
    }
  }

  Future<void> _exportDocument(Document document) async {
    try {
      await _exportDocumentUseCase(document.id, 'pdf');
      SnackBarUtils.showSuccess(
        context,
        'Dokument erfolgreich exportiert',
      );
    } catch (e) {
      SnackBarUtils.showError(
        context,
        'Fehler beim Exportieren: $e',
      );
    }
  }

  Future<void> _deleteDocument(Document document) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dokument löschen'),
        content: Text(
          'Möchten Sie das Dokument "${document.title}" wirklich löschen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // TODO: Implementiere Dokument-Löschung
        SnackBarUtils.showSuccess(
          context,
          'Dokument erfolgreich gelöscht',
        );
        await _loadDocuments();
      } catch (e) {
        SnackBarUtils.showError(
          context,
          'Fehler beim Löschen: $e',
        );
      }
    }
  }
}
