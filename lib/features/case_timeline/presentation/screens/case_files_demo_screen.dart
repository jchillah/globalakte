// features/case_timeline/presentation/screens/case_files_demo_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../data/repositories/case_file_repository_impl.dart';
import '../../domain/entities/case_file.dart';
import '../../domain/entities/timeline_event.dart';
import '../../domain/repositories/case_file_repository.dart';
import '../../domain/usecases/case_file_usecases.dart';

/// Demo Screen für die Fallakten-Verwaltung
class CaseFilesDemoScreen extends StatefulWidget {
  const CaseFilesDemoScreen({super.key});

  @override
  State<CaseFilesDemoScreen> createState() => _CaseFilesDemoScreenState();
}

class _CaseFilesDemoScreenState extends State<CaseFilesDemoScreen> {
  final CaseFileRepository _repository = CaseFileRepositoryImpl();
  late final CreateCaseFileUseCase _createCaseFileUseCase;
  late final GetAllCaseFilesUseCase _getAllCaseFilesUseCase;
  late final CreateTimelineEventUseCase _createTimelineEventUseCase;
  late final GetTimelineEventsUseCase _getTimelineEventsUseCase;
  late final EnableEpaIntegrationUseCase _enableEpaIntegrationUseCase;
  late final GetCaseFileStatisticsUseCase _getCaseFileStatisticsUseCase;

  List<CaseFile> _caseFiles = [];
  List<TimelineEvent> _timelineEvents = [];
  Map<String, dynamic> _statistics = {};
  bool _isLoading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();

  String _selectedStatus = 'active';
  String _selectedEventType = 'note';

  @override
  void initState() {
    super.initState();
    _createCaseFileUseCase = CreateCaseFileUseCase(_repository);
    _getAllCaseFilesUseCase = GetAllCaseFilesUseCase(_repository);
    _createTimelineEventUseCase = CreateTimelineEventUseCase(_repository);
    _getTimelineEventsUseCase = GetTimelineEventsUseCase(_repository);
    _enableEpaIntegrationUseCase = EnableEpaIntegrationUseCase(_repository);
    _getCaseFileStatisticsUseCase = GetCaseFileStatisticsUseCase(_repository);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final caseFiles = await _getAllCaseFilesUseCase();
      final statistics = await _getCaseFileStatisticsUseCase();

      setState(() {
        _caseFiles = caseFiles;
        _statistics = statistics;
      });

      if (caseFiles.isNotEmpty) {
        await _loadTimelineEvents(caseFiles.first.id);
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Laden der Daten: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadTimelineEvents(String caseFileId) async {
    try {
      final events = await _getTimelineEventsUseCase(caseFileId);
      setState(() => _timelineEvents = events);
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Laden der Timeline Events: $e');
      }
    }
  }

  Future<void> _createDemoCaseFile() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final category = _categoryController.text.trim();

    if (title.isEmpty || description.isEmpty || category.isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Bitte füllen Sie alle Felder aus');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final caseFile = CaseFile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        caseNumber: await _repository.generateCaseNumber(),
        status: _selectedStatus,
        category: category,
        createdAt: DateTime.now(),
        priority: 'medium',
        assignedTo: 'Demo User',
      );

      await _createCaseFileUseCase(caseFile);
      await _loadData();

      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(
            context, 'Fallakte erfolgreich erstellt!');
        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Erstellen der Fallakte: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _createDemoTimelineEvent() async {
    if (_caseFiles.isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Erstellen Sie zuerst eine Fallakte');
      return;
    }

    final title = _eventTitleController.text.trim();
    final description = _eventDescriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Bitte füllen Sie alle Felder aus');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final event = TimelineEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        caseFileId: _caseFiles.first.id,
        title: title,
        description: description,
        eventType: _selectedEventType,
        timestamp: DateTime.now(),
        createdBy: 'Demo User',
        isImportant: _selectedEventType == 'important',
      );

      await _createTimelineEventUseCase(event);
      await _loadTimelineEvents(_caseFiles.first.id);

      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(
            context, 'Timeline Event erfolgreich erstellt!');
        _clearEventForm();
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Erstellen des Events: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _enableEpaIntegration() async {
    if (_caseFiles.isEmpty) {
      SnackBarUtils.showErrorSnackBar(
          context, 'Erstellen Sie zuerst eine Fallakte');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _enableEpaIntegrationUseCase(_caseFiles.first.id);
      await _loadData();

      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(
            context, 'ePA-Integration aktiviert!');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler bei der ePA-Integration: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _categoryController.clear();
    _selectedStatus = 'active';
  }

  void _clearEventForm() {
    _eventTitleController.clear();
    _eventDescriptionController.clear();
    _selectedEventType = 'note';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Fallakten Demo'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConfig.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatisticsSection(),
                  const SizedBox(height: AppConfig.largePadding),
                  _buildCreateCaseFileSection(),
                  const SizedBox(height: AppConfig.largePadding),
                  _buildCreateTimelineEventSection(),
                  const SizedBox(height: AppConfig.largePadding),
                  _buildEpaIntegrationSection(),
                  const SizedBox(height: AppConfig.largePadding),
                  _buildCaseFilesList(),
                  const SizedBox(height: AppConfig.largePadding),
                  _buildTimelineEventsList(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatisticsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 Statistiken',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Gesamt',
                    _statistics['totalCases']?.toString() ?? '0',
                    Icons.folder,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: AppConfig.defaultPadding),
                Expanded(
                  child: _buildStatCard(
                    'Aktiv',
                    _statistics['activeCases']?.toString() ?? '0',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: AppConfig.defaultPadding),
                Expanded(
                  child: _buildStatCard(
                    'Events',
                    _statistics['totalEvents']?.toString() ?? '0',
                    Icons.timeline,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateCaseFileSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📁 Fallakte erstellen',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            GlobalTextField(
              controller: _titleController,
              label: 'Titel',
              hint: 'Fallakte Titel eingeben',
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            GlobalTextField(
              controller: _descriptionController,
              label: 'Beschreibung',
              hint: 'Beschreibung der Fallakte',
              maxLines: 3,
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            Row(
              children: [
                Expanded(
                  child: GlobalTextField(
                    controller: _categoryController,
                    label: 'Kategorie',
                    hint: 'z.B. civil, criminal',
                  ),
                ),
                const SizedBox(width: AppConfig.defaultPadding),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: ['active', 'in_progress', 'completed', 'closed']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(_getStatusDisplayName(status)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedStatus = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            SizedBox(
              width: double.infinity,
              child: GlobalButton(
                onPressed: _isLoading ? null : _createDemoCaseFile,
                text: 'Fallakte erstellen',
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateTimelineEventSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 Timeline Event erstellen',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            GlobalTextField(
              controller: _eventTitleController,
              label: 'Event Titel',
              hint: 'Titel des Events',
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            GlobalTextField(
              controller: _eventDescriptionController,
              label: 'Beschreibung',
              hint: 'Beschreibung des Events',
              maxLines: 3,
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            DropdownButtonFormField<String>(
              value: _selectedEventType,
              decoration: const InputDecoration(
                labelText: 'Event Typ',
                border: OutlineInputBorder(),
              ),
              items: ['note', 'document', 'meeting', 'important', 'deadline']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(_getEventTypeDisplayName(type)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedEventType = value);
                }
              },
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            SizedBox(
              width: double.infinity,
              child: GlobalButton(
                onPressed: _isLoading ? null : _createDemoTimelineEvent,
                text: 'Event erstellen',
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpaIntegrationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔗 ePA-Integration',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            Text(
              'Aktivieren Sie die ePA-Integration für die erste Fallakte',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            SizedBox(
              width: double.infinity,
              child: GlobalButton(
                onPressed: _isLoading ? null : _enableEpaIntegration,
                text: 'ePA-Integration aktivieren',
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseFilesList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📁 Fallakten (${_caseFiles.length})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            if (_caseFiles.isEmpty)
              const Text('Keine Fallakten vorhanden')
            else
              ..._caseFiles.map((caseFile) => _buildCaseFileItem(caseFile)),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseFileItem(CaseFile caseFile) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      caseFile.caseNumber,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
          ),
          const SizedBox(height: AppConfig.smallPadding),
          Row(
            children: [
              Text(
                'Kategorie: ${_getCategoryDisplayName(caseFile.category)}',
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
    );
  }

  Widget _buildTimelineEventsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 Timeline Events (${_timelineEvents.length})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            if (_timelineEvents.isEmpty)
              const Text('Keine Timeline Events vorhanden')
            else
              ..._timelineEvents.map((event) => _buildTimelineEventItem(event)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineEventItem(TimelineEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getEventTypeDisplayName(event.eventType),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConfig.smallPadding),
          Text(
            event.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppConfig.smallPadding),
          Text(
            'Erstellt: ${_formatDateTime(event.timestamp)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
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

  String _getEventTypeDisplayName(String eventType) {
    switch (eventType) {
      case 'note':
        return 'Notiz';
      case 'document':
        return 'Dokument';
      case 'meeting':
        return 'Termin';
      case 'important':
        return 'Wichtig';
      case 'deadline':
        return 'Deadline';
      default:
        return eventType;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _eventTitleController.dispose();
    _eventDescriptionController.dispose();
    super.dispose();
  }
}
