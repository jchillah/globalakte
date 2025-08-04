// features/document_generator/presentation/screens/pdf_generator_demo_screen.dart

import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../data/repositories/pdf_generator_repository_impl.dart';
import '../../domain/entities/pdf_document.dart';
import '../../domain/entities/pdf_template.dart';
import '../../domain/usecases/pdf_generator_usecases.dart';
import '../widgets/pdf_documents_tab.dart';
import '../widgets/pdf_generator_tab.dart';
import '../widgets/pdf_statistics_tab.dart';
import '../widgets/pdf_templates_tab.dart';

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          PdfGeneratorTab(
            useCases: _useCases,
            templates: _templates,
            isLoading: _isLoading,
            onDataChanged: _loadData,
          ),
          PdfDocumentsTab(
            documents: _documents,
            isLoading: _isLoading,
            useCases: _useCases,
            onDataChanged: _loadData,
          ),
          PdfTemplatesTab(
            templates: _templates,
            isLoading: _isLoading,
          ),
          PdfStatisticsTab(
            statistics: _statistics,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
