// features/document_generator/presentation/screens/pdf_generator_demo_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../data/repositories/pdf_generator_repository_impl.dart';
import '../../domain/usecases/pdf_generator_usecases.dart';
import '../../domain/entities/pdf_document.dart';
import '../../domain/entities/pdf_template.dart';

/// Demo-Screen für PDF-Generator
class PdfGeneratorDemoScreen extends StatefulWidget {
  const PdfGeneratorDemoScreen({super.key});

  @override
  State<PdfGeneratorDemoScreen> createState() => _PdfGeneratorDemoScreenState();
}

class _PdfGeneratorDemoScreenState extends State<PdfGeneratorDemoScreen>
    with TickerProviderStateMixin {
  late PdfGeneratorUseCases _useCases;
  late TabController _tabController;

  List<PdfDocument> _documents = [];
  List<PdfTemplate> _templates = [];
  Map<String, dynamic> _statistics = {};
  
  bool _isLoading = false;
  String _selectedTemplateId = '';
  final Map<String, TextEditingController> _formControllers = {};
  final Map<String, dynamic> _formData = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _useCases = PdfGeneratorUseCases(PdfGeneratorRepositoryImpl());
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final futures = await Future.wait([
        _useCases.getAllPdfDocuments(),
        _useCases.getActivePdfTemplates(),
        _useCases.generatePdfStatistics(),
      ]);

      setState(() {
        _documents = futures[0] as List<PdfDocument>;
        _templates = futures[1] as List<PdfTemplate>;
        _statistics = futures[2] as Map<String, dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarUtils.showError(context, 'Fehler beim Laden der Daten: $e');
      }
    }
  }

  void _initializeFormControllers(PdfTemplate template) {
    _formControllers.clear();
    _formData.clear();
    
    for (final field in template.allFields) {
      _formControllers[field] = TextEditingController(
        text: template.defaultData[field]?.toString() ?? '',
      );
      _formData[field] = template.defaultData[field]?.toString() ?? '';
    }
  }

  Future<void> _generatePdf() async {
    if (_selectedTemplateId.isEmpty) {
      SnackBarUtils.showError(context, 'Bitte ein Template auswählen');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Form-Daten sammeln
      for (final entry in _formControllers.entries) {
        _formData[entry.key] = entry.value.text;
      }

      // PDF generieren
      final pdfBytes = await _useCases.generatePdfFromTemplate(
        _selectedTemplateId,
        _formData,
      );

      // Dokument erstellen
      final document = await _useCases.createPdfDocumentWithTemplate(
        _selectedTemplateId,
        _formData['title'] ?? 'Neues Dokument',
        _formData,
        'Demo-Benutzer',
        ['generiert'],
      );

      setState(() {
        _documents.add(document);
        _isLoading = false;
      });

      if (mounted) {
        SnackBarUtils.showSuccess(context, 'PDF erfolgreich generiert!');
        _showPdfPreview(pdfBytes);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarUtils.showError(context, 'Fehler beim Generieren: $e');
      }
    }
  }

  void _showPdfPreview(Uint8List pdfBytes) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(AppConfig.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PDF-Vorschau',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppConfig.defaultPadding),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConfig.defaultPadding),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PDF wurde erfolgreich generiert!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: AppConfig.defaultPadding),
                      Text('Größe: ${pdfBytes.length} Bytes'),
                      const SizedBox(height: AppConfig.defaultPadding),
                      const Text(
                        'PDF-Vorschau:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppConfig.smallPadding),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppConfig.defaultPadding),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const SingleChildScrollView(
                            child: Text(
                              'Dies ist eine Vorschau des generierten PDF-Dokuments.\n\n'
                              'In einer echten Implementierung würde hier das PDF angezeigt werden.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConfig.defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GlobalButton(
                      onPressed: () => _sharePdf(pdfBytes),
                      text: 'Teilen',
                    ),
                  ),
                  const SizedBox(width: AppConfig.defaultPadding),
                  Expanded(
                    child: GlobalButton(
                      onPressed: () => _printPdf(pdfBytes),
                      text: 'Drucken',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sharePdf(Uint8List pdfBytes) async {
    try {
      // Simuliere Teilen
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        SnackBarUtils.showSuccess(context, 'PDF geteilt!');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Fehler beim Teilen: $e');
      }
    }
  }

  Future<void> _printPdf(Uint8List pdfBytes) async {
    try {
      // Simuliere Drucken
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        SnackBarUtils.showSuccess(context, 'PDF wird gedruckt!');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Fehler beim Drucken: $e');
      }
    }
  }

  Future<void> _uploadToEpa(PdfDocument document) async {
    setState(() => _isLoading = true);

    try {
      final success = await _useCases.uploadPdfToEpa(document.id, 'demo-case-id');
      
      setState(() => _isLoading = false);
      
      if (mounted) {
        if (success) {
          SnackBarUtils.showSuccess(context, 'PDF erfolgreich in ePA hochgeladen!');
        } else {
          SnackBarUtils.showError(context, 'Fehler beim Hochladen in ePA');
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarUtils.showError(context, 'Fehler beim Hochladen: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF-Generator Demo'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Generieren', icon: Icon(Icons.create)),
            Tab(text: 'Dokumente', icon: Icon(Icons.description)),
            Tab(text: 'Templates', icon: Icon(Icons.dashboard)),
            Tab(text: 'Statistiken', icon: Icon(Icons.analytics)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGenerateTab(),
          _buildDocumentsTab(),
          _buildTemplatesTab(),
          _buildStatisticsTab(),
        ],
      ),
    );
  }

  Widget _buildGenerateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConfig.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📄 PDF-Dokument generieren',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppConfig.defaultPadding),
                  Text(
                    'Wählen Sie ein Template und füllen Sie die Felder aus, um ein PDF-Dokument zu generieren.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConfig.defaultPadding),
          
          // Template-Auswahl
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConfig.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Template auswählen',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppConfig.defaultPadding),
                  DropdownButtonFormField<String>(
                    value: _selectedTemplateId.isEmpty ? null : _selectedTemplateId,
                    decoration: const InputDecoration(
                      labelText: 'Template',
                      border: OutlineInputBorder(),
                    ),
                    items: _templates.map((template) => DropdownMenuItem(
                      value: template.id,
                      child: Text('${template.name} (${template.displayCategory})'),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTemplateId = value ?? '';
                        if (value != null) {
                          final template = _templates.firstWhere((t) => t.id == value);
                          _initializeFormControllers(template);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConfig.defaultPadding),

          // Formular
          if (_selectedTemplateId.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConfig.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dokument-Daten',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppConfig.defaultPadding),
                    ..._formControllers.entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
                      child: TextField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          labelText: entry.key,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _formData[entry.key] = value;
                        },
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConfig.defaultPadding),
            
            GlobalButton(
              onPressed: _isLoading ? null : _generatePdf,
              text: 'PDF generieren',
              isLoading: _isLoading,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            itemCount: _documents.length,
            itemBuilder: (context, index) {
              final document = _documents[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
                child: ListTile(
                  leading: Icon(
                    _getDocumentIcon(document.templateType),
                    color: _getDocumentColor(document.templateType),
                  ),
                  title: Text(document.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Typ: ${_getDocumentTypeName(document.templateType)}'),
                      Text('Autor: ${document.author ?? 'Unbekannt'}'),
                      Text('Erstellt: ${document.formattedCreatedAt}'),
                      if (document.tags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children: document.tags.map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Colors.blue.withValues(alpha: 0.1),
                          )).toList(),
                        ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      switch (value) {
                        case 'view':
                          _showDocumentDetails(document);
                          break;
                        case 'share':
                          await _sharePdf(Uint8List(100));
                          break;
                        case 'print':
                          await _printPdf(Uint8List(100));
                          break;
                        case 'epa':
                          await _uploadToEpa(document);
                          break;
                        case 'delete':
                          await _deleteDocument(document);
                          break;
                      }
                    },
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
                        value: 'print',
                        child: Row(
                          children: [
                            Icon(Icons.print),
                            SizedBox(width: 8),
                            Text('Drucken'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'epa',
                        child: Row(
                          children: [
                            Icon(Icons.cloud_upload),
                            SizedBox(width: 8),
                            Text('ePA hochladen'),
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
                ),
              );
            },
          );
  }

  Widget _buildTemplatesTab() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            itemCount: _templates.length,
            itemBuilder: (context, index) {
              final template = _templates[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
                child: ListTile(
                  leading: Icon(
                    _getTemplateIcon(template.templateType),
                    color: _getTemplateColor(template.templateType),
                  ),
                  title: Text(template.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(template.description),
                      Text('Kategorie: ${template.displayCategory}'),
                      Text('Typ: ${_getTemplateTypeName(template.templateType)}'),
                      Text('Status: ${template.statusText}'),
                      Text('Version: ${template.version ?? '1.0'}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'preview':
                          _showTemplatePreview(template);
                          break;
                        case 'edit':
                          _editTemplate(template);
                          break;
                        case 'delete':
                          _deleteTemplate(template);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'preview',
                        child: Row(
                          children: [
                            Icon(Icons.preview),
                            SizedBox(width: 8),
                            Text('Vorschau'),
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
                ),
              );
            },
          );
  }

  Widget _buildStatisticsTab() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConfig.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📊 PDF-Statistiken',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppConfig.defaultPadding),
                        _buildStatCard('Gesamt Dokumente', '${_statistics['totalDocuments'] ?? 0}'),
                        _buildStatCard('Gesamt Templates', '${_statistics['totalTemplates'] ?? 0}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConfig.defaultPadding),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConfig.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dokumente nach Typ',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppConfig.defaultPadding),
                        if (_statistics['documentsByType'] != null)
                          ...(_statistics['documentsByType'] as Map<String, dynamic>).entries.map(
                            (entry) => _buildStatRow(entry.key, entry.value.toString()),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConfig.defaultPadding),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConfig.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Templates nach Kategorie',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppConfig.defaultPadding),
                        if (_statistics['templatesByCategory'] != null)
                          ...(_statistics['templatesByCategory'] as Map<String, dynamic>).entries.map(
                            (entry) => _buildStatRow(entry.key, entry.value.toString()),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      margin: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.blue.shade700,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConfig.smallPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showDocumentDetails(PdfDocument document) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        document.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: AppConfig.defaultPadding),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Typ: ${_getDocumentTypeName(document.templateType)}'),
                        Text('Autor: ${document.author ?? 'Unbekannt'}'),
                        Text('Erstellt: ${document.formattedCreatedAt}'),
                        if (document.updatedAt != null)
                          Text('Aktualisiert: ${document.formattedUpdatedAt}'),
                        if (document.tags.isNotEmpty)
                          Text('Tags: ${document.tags.join(', ')}'),
                        const SizedBox(height: AppConfig.defaultPadding),
                        const Text('PDF-Vorschau:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppConfig.smallPadding),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppConfig.defaultPadding),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // PDF-Header simulieren
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(AppConfig.defaultPadding),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      document.title,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade700,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Erstellt am ${document.formattedCreatedAt}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              // PDF-Inhalt simulieren
                              Padding(
                                padding: const EdgeInsets.all(AppConfig.defaultPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dokument-Inhalt',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: AppConfig.smallPadding),
                                    Text(
                                      'Dies ist eine Vorschau des generierten PDF-Dokuments. '
                                      'In einer echten Implementierung würde hier das gerenderte PDF angezeigt werden.',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: AppConfig.defaultPadding),
                                    Container(
                                      padding: const EdgeInsets.all(AppConfig.defaultPadding),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
                                        border: Border.all(color: Colors.grey.shade200),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dokument-Metadaten:',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text('Template: ${document.templateType}'),
                                          Text('Autor: ${document.author ?? 'Unbekannt'}'),
                                          if (document.tags.isNotEmpty)
                                            Text('Tags: ${document.tags.join(', ')}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConfig.defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GlobalButton(
                        onPressed: () => _sharePdf(Uint8List(100)),
                        text: 'Teilen',
                      ),
                    ),
                    const SizedBox(width: AppConfig.defaultPadding),
                    Expanded(
                      child: GlobalButton(
                        onPressed: () => _printPdf(Uint8List(100)),
                        text: 'Drucken',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTemplatePreview(PdfTemplate template) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Template: ${template.name}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: AppConfig.defaultPadding),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Beschreibung', template.description),
                        _buildInfoRow('Typ', _getTemplateTypeName(template.templateType)),
                        _buildInfoRow('Kategorie', template.displayCategory),
                        _buildInfoRow('Status', template.statusText),
                        _buildInfoRow('Version', template.version ?? '1.0'),
                        const SizedBox(height: AppConfig.defaultPadding),
                        const Text(
                          'Erforderliche Felder:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppConfig.smallPadding),
                        Wrap(
                          spacing: 4,
                          children: template.requiredFields.map((field) => Chip(
                            label: Text(field),
                            backgroundColor: Colors.red.withValues(alpha: 0.1),
                          )).toList(),
                        ),
                        if (template.optionalFields.isNotEmpty) ...[
                          const SizedBox(height: AppConfig.defaultPadding),
                          const Text(
                            'Optionale Felder:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppConfig.smallPadding),
                          Wrap(
                            spacing: 4,
                            children: template.optionalFields.map((field) => Chip(
                              label: Text(field),
                              backgroundColor: Colors.blue.withValues(alpha: 0.1),
                            )).toList(),
                          ),
                        ],
                        const SizedBox(height: AppConfig.defaultPadding),
                        const Text(
                          'HTML-Template:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppConfig.smallPadding),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppConfig.defaultPadding),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            template.htmlTemplate,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConfig.smallPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _editTemplate(PdfTemplate template) {
    SnackBarUtils.showInfo(context, 'Template-Bearbeitung wird implementiert');
  }

  Future<void> _deleteTemplate(PdfTemplate template) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Template löschen'),
        content: Text('Möchten Sie das Template "${template.name}" wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Löschen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await _useCases.deletePdfTemplate(template.id);
        setState(() {
          _templates.removeWhere((t) => t.id == template.id);
          _isLoading = false;
        });
        if (mounted) {
          SnackBarUtils.showSuccess(context, 'Template gelöscht');
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          SnackBarUtils.showError(context, 'Fehler beim Löschen: $e');
        }
      }
    }
  }

  Future<void> _deleteDocument(PdfDocument document) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dokument löschen'),
        content: Text('Möchten Sie das Dokument "${document.title}" wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Löschen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await _useCases.deletePdfDocument(document.id);
        setState(() {
          _documents.removeWhere((d) => d.id == document.id);
          _isLoading = false;
        });
        if (mounted) {
          SnackBarUtils.showSuccess(context, 'Dokument gelöscht');
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          SnackBarUtils.showError(context, 'Fehler beim Löschen: $e');
        }
      }
    }
  }

  IconData _getDocumentIcon(String templateType) {
    switch (templateType) {
      case 'legal_letter':
        return Icons.mail;
      case 'contract':
        return Icons.description;
      case 'application':
        return Icons.assignment;
      case 'report':
        return Icons.assessment;
      case 'certificate':
        return Icons.verified;
      default:
        return Icons.description;
    }
  }

  Color _getDocumentColor(String templateType) {
    switch (templateType) {
      case 'legal_letter':
        return Colors.blue;
      case 'contract':
        return Colors.green;
      case 'application':
        return Colors.orange;
      case 'report':
        return Colors.purple;
      case 'certificate':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDocumentTypeName(String templateType) {
    switch (templateType) {
      case 'legal_letter':
        return 'Anwaltsschreiben';
      case 'contract':
        return 'Vertrag';
      case 'application':
        return 'Antrag';
      case 'report':
        return 'Bericht';
      case 'certificate':
        return 'Urkunde';
      default:
        return templateType;
    }
  }

  IconData _getTemplateIcon(String templateType) {
    switch (templateType) {
      case 'legal_letter':
        return Icons.mail_outline;
      case 'contract':
        return Icons.description_outlined;
      case 'application':
        return Icons.assignment_outlined;
      case 'report':
        return Icons.assessment_outlined;
      case 'certificate':
        return Icons.verified_outlined;
      default:
        return Icons.dashboard;
    }
  }

  Color _getTemplateColor(String templateType) {
    switch (templateType) {
      case 'legal_letter':
        return Colors.blue;
      case 'contract':
        return Colors.green;
      case 'application':
        return Colors.orange;
      case 'report':
        return Colors.purple;
      case 'certificate':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getTemplateTypeName(String templateType) {
    switch (templateType) {
      case 'legal_letter':
        return 'Anwaltsschreiben';
      case 'contract':
        return 'Vertrag';
      case 'application':
        return 'Antrag';
      case 'report':
        return 'Bericht';
      case 'certificate':
        return 'Urkunde';
      default:
        return templateType;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final controller in _formControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
} 