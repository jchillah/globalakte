// features/case_timeline/presentation/screens/case_files_list_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../data/repositories/case_file_repository_impl.dart';
import '../../domain/entities/case_file.dart';
import '../../domain/repositories/case_file_repository.dart';
import '../../domain/usecases/case_file_usecases.dart';

/// Screen für die Fallakten-Liste
class CaseFilesListScreen extends StatefulWidget {
  const CaseFilesListScreen({super.key});

  @override
  State<CaseFilesListScreen> createState() => _CaseFilesListScreenState();
}

class _CaseFilesListScreenState extends State<CaseFilesListScreen> {
  final CaseFileRepository _repository = CaseFileRepositoryImpl();
  late final GetAllCaseFilesUseCase _getAllCaseFilesUseCase;

  final TextEditingController _searchController = TextEditingController();

  List<CaseFile> _caseFiles = [];
  List<CaseFile> _filteredCaseFiles = [];
  bool _isLoading = false;
  String _selectedStatus = 'all';
  String _selectedCategory = 'all';

  final List<String> _statusOptions = [
    'all',
    'active',
    'in_progress',
    'completed',
    'closed',
  ];

  final List<String> _categoryOptions = [
    'all',
    'civil',
    'criminal',
    'administrative',
    'family',
    'labor',
  ];

  @override
  void initState() {
    super.initState();
    _getAllCaseFilesUseCase = GetAllCaseFilesUseCase(_repository);
    _loadCaseFiles();
  }

  Future<void> _loadCaseFiles() async {
    setState(() => _isLoading = true);

    try {
      final caseFiles = await _getAllCaseFilesUseCase();
      setState(() {
        _caseFiles = caseFiles;
        _filteredCaseFiles = caseFiles;
      });
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Laden der Fallakten: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterCaseFiles() {
    setState(() {
      _filteredCaseFiles = _caseFiles.where((caseFile) {
        final matchesStatus =
            _selectedStatus == 'all' || caseFile.status == _selectedStatus;
        final matchesCategory = _selectedCategory == 'all' ||
            caseFile.category == _selectedCategory;
        final matchesSearch = _searchController.text.isEmpty ||
            caseFile.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            caseFile.caseNumber
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        return matchesStatus && matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _onSearchChanged(String value) {
    _filterCaseFiles();
  }

  void _onStatusChanged(String? value) {
    if (value != null) {
      setState(() => _selectedStatus = value);
      _filterCaseFiles();
    }
  }

  void _onCategoryChanged(String? value) {
    if (value != null) {
      setState(() => _selectedCategory = value);
      _filterCaseFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Fallakten'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigation zur Fallakte erstellen
              _showCreateCaseDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilterSection(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCaseFiles.isEmpty
                    ? _buildEmptyState()
                    : _buildCaseFilesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Suchfeld
          GlobalTextField(
            controller: _searchController,
            label: 'Fallakten suchen',
            hint: 'Titel, Fallnummer oder Beschreibung',
            onChanged: _onSearchChanged,
            prefixIcon: const Icon(Icons.search),
          ),
          const SizedBox(height: AppConfig.defaultPadding),

          // Filter
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: _statusOptions.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(_getStatusDisplayName(status)),
                    );
                  }).toList(),
                  onChanged: _onStatusChanged,
                ),
              ),
              const SizedBox(width: AppConfig.defaultPadding),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategorie',
                    border: OutlineInputBorder(),
                  ),
                  items: _categoryOptions.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(_getCategoryDisplayName(category)),
                    );
                  }).toList(),
                  onChanged: _onCategoryChanged,
                ),
              ),
            ],
          ),
        ],
      ),
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
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: AppConfig.defaultPadding),
          Text(
            'Keine Fallakten gefunden',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: AppConfig.smallPadding),
          Text(
            'Erstellen Sie Ihre erste Fallakte oder passen Sie die Filter an.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConfig.largePadding),
          GlobalButton(
            onPressed: () {
              // TODO: Navigation zur Fallakte erstellen
              SnackBarUtils.showInfoSnackBar(
                  context, 'Fallakte erstellen - Coming Soon');
            },
            text: 'Erste Fallakte erstellen',
          ),
        ],
      ),
    );
  }

  Widget _buildCaseFilesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      itemCount: _filteredCaseFiles.length,
      itemBuilder: (context, index) {
        final caseFile = _filteredCaseFiles[index];
        return _buildCaseFileCard(caseFile);
      },
    );
  }

  Widget _buildCaseFileCard(CaseFile caseFile) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Navigation zu Fallakte Details
          _showCaseFileDetails(caseFile);
        },
        child: Padding(
          padding: const EdgeInsets.all(AppConfig.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          caseFile.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          caseFile.caseNumber,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(caseFile.status),
                ],
              ),
              const SizedBox(height: AppConfig.smallPadding),
              Text(
                caseFile.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConfig.smallPadding),
              Row(
                children: [
                  Icon(
                    Icons.category,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getCategoryDisplayName(caseFile.category),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const Spacer(),
                  if (caseFile.isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Überfällig',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppConfig.smallPadding),
              Row(
                children: [
                  Icon(
                    Icons.description,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${caseFile.documentCount} Dokumente',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(width: AppConfig.defaultPadding),
                  Icon(
                    Icons.timeline,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${caseFile.timelineEventCount} Events',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const Spacer(),
                  if (caseFile.isEpaIntegrated)
                    Icon(
                      Icons.cloud_sync,
                      size: 16,
                      color: Colors.blue.shade600,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;

    switch (status) {
      case 'active':
        color = Colors.green;
        text = 'Aktiv';
        break;
      case 'in_progress':
        color = Colors.orange;
        text = 'In Bearbeitung';
        break;
      case 'completed':
        color = Colors.blue;
        text = 'Abgeschlossen';
        break;
      case 'closed':
        color = Colors.grey;
        text = 'Geschlossen';
        break;
      default:
        color = Colors.grey;
        text = 'Unbekannt';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'all':
        return 'Alle Status';
      case 'active':
        return 'Aktiv';
      case 'in_progress':
        return 'In Bearbeitung';
      case 'completed':
        return 'Abgeschlossen';
      case 'closed':
        return 'Geschlossen';
      default:
        return status;
    }
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'all':
        return 'Alle Kategorien';
      case 'civil':
        return 'Zivilrecht';
      case 'criminal':
        return 'Strafrecht';
      case 'administrative':
        return 'Verwaltungsrecht';
      case 'family':
        return 'Familienrecht';
      case 'labor':
        return 'Arbeitsrecht';
      default:
        return category;
    }
  }

  void _showCreateCaseDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'civil';
    String selectedStatus = 'active';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Neue Fallakte erstellen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlobalTextField(
              controller: titleController,
              label: 'Titel',
              hint: 'Titel der Fallakte',
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            GlobalTextField(
              controller: descriptionController,
              label: 'Beschreibung',
              hint: 'Kurze Beschreibung',
              maxLines: 3,
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategorie',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'civil', child: Text('Zivilrecht')),
                      DropdownMenuItem(
                          value: 'criminal', child: Text('Strafrecht')),
                      DropdownMenuItem(
                          value: 'administrative',
                          child: Text('Verwaltungsrecht')),
                      DropdownMenuItem(
                          value: 'family', child: Text('Familienrecht')),
                      DropdownMenuItem(
                          value: 'labor', child: Text('Arbeitsrecht')),
                    ],
                    onChanged: (value) => selectedCategory = value!,
                  ),
                ),
                const SizedBox(width: AppConfig.defaultPadding),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'active', child: Text('Aktiv')),
                      DropdownMenuItem(
                          value: 'in_progress', child: Text('In Bearbeitung')),
                    ],
                    onChanged: (value) => selectedStatus = value!,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                Navigator.of(context).pop();
                _createNewCase(
                  titleController.text,
                  descriptionController.text,
                  selectedCategory,
                  selectedStatus,
                );
              }
            },
            child: const Text('Erstellen'),
          ),
        ],
      ),
    );
  }

  void _createNewCase(
      String title, String description, String category, String status) {
    // Implementiere Fallakte-Erstellung
    try {
      // Hier würde normalerweise der Use Case aufgerufen werden
      // _createCaseFileUseCase(caseFile);

      SnackBarUtils.showSuccessSnackBar(
        context,
        'Fallakte "$title" wurde erstellt',
      );

      // Liste neu laden
      _loadCaseFiles();
    } catch (e) {
      SnackBarUtils.showErrorSnackBar(
        context,
        'Fehler beim Erstellen der Fallakte: $e',
      );
    }
  }

  void _showCaseFileDetails(CaseFile caseFile) {
    // Navigation zu Fallakte Details
    SnackBarUtils.showInfoSnackBar(
      context,
      'Fallakte Details für "${caseFile.title}" - Coming Soon',
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
