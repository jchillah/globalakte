// features/epa_integration/presentation/screens/epa_integration_demo_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../data/api/epa_api_client.dart';
import '../../data/api/epa_api_client_impl.dart';
import '../../data/models/epa_case.dart';
import '../../data/models/epa_document.dart';
import '../../data/models/epa_user.dart';

/// Demo-Screen für ePA-Integration
class EpaIntegrationDemoScreen extends StatefulWidget {
  const EpaIntegrationDemoScreen({super.key});

  @override
  State<EpaIntegrationDemoScreen> createState() =>
      _EpaIntegrationDemoScreenState();
}

class _EpaIntegrationDemoScreenState extends State<EpaIntegrationDemoScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _caseTitleController = TextEditingController();
  final _caseDescriptionController = TextEditingController();
  final _documentTitleController = TextEditingController();
  final _documentContentController = TextEditingController();

  late EpaApiClient _apiClient;
  EpaUser? _currentUser;
  List<EpaCase> _cases = [];
  List<EpaDocument> _documents = [];
  bool _isLoading = false;
  String _selectedCaseId = '';
  String _apiStatus = 'Nicht verbunden';

  @override
  void initState() {
    super.initState();
    _initializeApiClient();
    _checkApiStatus();
  }

  void _initializeApiClient() {
    // Für Demo-Zwecke verwenden wir einen Mock-Server
    const baseUrl = 'https://api.epa-demo.globalakte.de';
    _apiClient = EpaApiClientImpl(baseUrl: baseUrl);
  }

  Future<void> _checkApiStatus() async {
    setState(() => _isLoading = true);

    try {
      final response = await _apiClient.checkApiStatus();
      setState(() {
        _apiStatus = response.success ? 'Verfügbar' : 'Nicht verfügbar';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _apiStatus = 'Fehler: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _authenticate() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      SnackBarUtils.showError(
          context, 'Bitte Benutzername und Passwort eingeben');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _apiClient.authenticate(
        _usernameController.text,
        _passwordController.text,
      );

      if (response.success && response.data != null) {
        setState(() {
          _currentUser = response.data;
          _isLoading = false;
        });
        if (mounted) {
          SnackBarUtils.showSuccess(context, 'Erfolgreich angemeldet');
        }
        await _loadCases();
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          SnackBarUtils.showError(
              context, response.message ?? 'Authentifizierung fehlgeschlagen');
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarUtils.showError(
            context, 'Authentifizierung fehlgeschlagen: $e');
      }
    }
  }

  Future<void> _loadCases() async {
    if (_currentUser == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await _apiClient.getCases();

      if (response.success && response.data != null) {
        setState(() {
          _cases = response.data!;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          SnackBarUtils.showError(
              context, response.message ?? 'Fehler beim Laden der Fälle');
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarUtils.showError(context, 'Fehler beim Laden der Fälle: $e');
      }
    }
  }

  Future<void> _createCase() async {
    if (_caseTitleController.text.isEmpty) {
      SnackBarUtils.showError(context, 'Bitte Falltitel eingeben');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newCase = EpaCase(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _caseTitleController.text,
        description: _caseDescriptionController.text,
        caseNumber:
            'CASE-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch}',
        caseType: 'general',
        status: EpaCaseStatus.open,
        assignedUserId: _currentUser?.id ?? 'unknown',
        createdBy: _currentUser?.id ?? 'unknown',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        priority: EpaCasePriority.medium,
        tags: [],
        metadata: {},
        participants: [],
      );

      final response = await _apiClient.createCase(newCase);

      if (response.success) {
        setState(() => _isLoading = false);
        if (mounted) {
          SnackBarUtils.showSuccess(context, 'Fall erfolgreich erstellt');
        }
        _caseTitleController.clear();
        _caseDescriptionController.clear();
        await _loadCases();
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          SnackBarUtils.showError(
              context, response.message ?? 'Fehler beim Erstellen des Falls');
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarUtils.showError(context, 'Fehler beim Erstellen des Falls: $e');
      }
    }
  }

  Future<void> _uploadDocument() async {
    if (_selectedCaseId.isEmpty) {
      SnackBarUtils.showError(context, 'Bitte einen Fall auswählen');
      return;
    }

    if (_documentTitleController.text.isEmpty) {
      SnackBarUtils.showError(context, 'Bitte Dokumenttitel eingeben');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final document = EpaDocument(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _documentTitleController.text,
        description: _documentContentController.text,
        caseId: _selectedCaseId,
        documentType: 'text',
        filePath: '/documents/${_documentTitleController.text}.txt',
        fileName: '${_documentTitleController.text}.txt',
        fileSize: _documentContentController.text.length,
        mimeType: 'text/plain',
        status: EpaDocumentStatus.available,
        uploadedBy: _currentUser?.id ?? 'unknown',
        uploadedAt: DateTime.now(),
        category: EpaDocumentCategory.other,
        tags: [],
        metadata: {},
      );

      final response =
          await _apiClient.uploadDocument(_selectedCaseId, document);

      if (response.success) {
        setState(() => _isLoading = false);
        if (mounted) {
          SnackBarUtils.showSuccess(
              context, 'Dokument erfolgreich hochgeladen');
        }
        _documentTitleController.clear();
        _documentContentController.clear();
        await _loadDocuments();
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          SnackBarUtils.showError(
              context, response.message ?? 'Fehler beim Hochladen');
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarUtils.showError(context, 'Fehler beim Hochladen: $e');
      }
    }
  }

  Future<void> _loadDocuments() async {
    if (_selectedCaseId.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final response = await _apiClient.getCaseDocuments(_selectedCaseId);

      if (response.success && response.data != null) {
        setState(() {
          _documents = response.data!;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          SnackBarUtils.showError(
              context, response.message ?? 'Fehler beim Laden der Dokumente');
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarUtils.showError(context, 'Fehler beim Laden der Dokumente: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ePA-Integration Demo'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildApiStatusCard(),
            const SizedBox(height: AppConfig.defaultPadding),
            _buildAuthenticationSection(),
            const SizedBox(height: AppConfig.defaultPadding),
            if (_currentUser != null) ...[
              _buildCaseManagementSection(),
              const SizedBox(height: AppConfig.defaultPadding),
              _buildDocumentManagementSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildApiStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cloud_sync,
                  color: _apiStatus == 'Verfügbar' ? Colors.green : Colors.red,
                ),
                const SizedBox(width: AppConfig.smallPadding),
                Text(
                  'ePA API Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppConfig.smallPadding),
            Text(
              _apiStatus,
              style: TextStyle(
                color: _apiStatus == 'Verfügbar' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConfig.smallPadding),
            GlobalButton(
              onPressed: _isLoading ? null : _checkApiStatus,
              text: 'Status prüfen',
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔐 Authentifizierung',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Benutzername',
                hintText: 'ePA Benutzername eingeben',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Passwort',
                hintText: 'ePA Passwort eingeben',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            GlobalButton(
              onPressed: _isLoading ? null : _authenticate,
              text: 'Anmelden',
              isLoading: _isLoading,
            ),
            if (_currentUser != null) ...[
              const SizedBox(height: AppConfig.defaultPadding),
              Container(
                padding: const EdgeInsets.all(AppConfig.defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
                  border:
                      Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: AppConfig.smallPadding),
                    Expanded(
                      child: Text(
                        'Angemeldet als: ${_currentUser!.fullName}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCaseManagementSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📁 Fall-Management',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            TextField(
              controller: _caseTitleController,
              decoration: const InputDecoration(
                labelText: 'Falltitel',
                hintText: 'Titel des Falls eingeben',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            TextField(
              controller: _caseDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Beschreibung',
                hintText: 'Beschreibung des Falls eingeben',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            Row(
              children: [
                Expanded(
                  child: GlobalButton(
                    onPressed: _isLoading ? null : _createCase,
                    text: 'Fall erstellen',
                    isLoading: _isLoading,
                  ),
                ),
                const SizedBox(width: AppConfig.defaultPadding),
                Expanded(
                  child: GlobalButton(
                    onPressed: _isLoading ? null : _loadCases,
                    text: 'Fälle laden',
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
            if (_cases.isNotEmpty) ...[
              const SizedBox(height: AppConfig.defaultPadding),
              Text(
                'Verfügbare Fälle (${_cases.length}):',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppConfig.smallPadding),
              ..._cases.map((epaCase) => _buildCaseItem(epaCase)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCaseItem(EpaCase epaCase) {
    final isSelected = _selectedCaseId == epaCase.id;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConfig.smallPadding),
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      decoration: BoxDecoration(
        color: isSelected
            ? AppConfig.primaryColor.withValues(alpha: 0.1)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        border: Border.all(
          color: isSelected ? AppConfig.primaryColor : Colors.grey.shade200,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCaseId = epaCase.id;
          });
          _loadDocuments();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    epaCase.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    epaCase.status.displayName,
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
              epaCase.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConfig.smallPadding),
            Text(
              'Fallnummer: ${epaCase.caseNumber}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentManagementSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📄 Dokument-Management',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            if (_selectedCaseId.isNotEmpty) ...[
              TextField(
                controller: _documentTitleController,
                decoration: const InputDecoration(
                  labelText: 'Dokumenttitel',
                  hintText: 'Titel des Dokuments eingeben',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppConfig.defaultPadding),
              TextField(
                controller: _documentContentController,
                decoration: const InputDecoration(
                  labelText: 'Dokumentinhalt',
                  hintText: 'Inhalt des Dokuments eingeben',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: AppConfig.defaultPadding),
              GlobalButton(
                onPressed: _isLoading ? null : _uploadDocument,
                text: 'Dokument hochladen',
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppConfig.defaultPadding),
              Text(
                'Dokumente (${_documents.length}):',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppConfig.smallPadding),
              ..._documents.map((document) => _buildDocumentItem(document)),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(AppConfig.defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
                  border:
                      Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: AppConfig.smallPadding),
                    Expanded(
                      child: Text(
                        'Bitte wählen Sie einen Fall aus, um Dokumente zu verwalten',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(EpaDocument document) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConfig.smallPadding),
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
              const Icon(Icons.description, color: Colors.blue),
              const SizedBox(width: AppConfig.smallPadding),
              Expanded(
                child: Text(
                  document.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Text(
                document.formattedFileSize,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConfig.smallPadding),
          Text(
            document.description,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppConfig.smallPadding),
          Text(
            'Hochgeladen: ${_formatDateTime(document.uploadedAt)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _caseTitleController.dispose();
    _caseDescriptionController.dispose();
    _documentTitleController.dispose();
    _documentContentController.dispose();
    _apiClient.dispose();
    super.dispose();
  }
}
