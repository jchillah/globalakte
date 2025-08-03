// features/evidence_collection/presentation/screens/evidence_collection_demo_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../data/repositories/evidence_repository_impl.dart';
import '../../domain/usecases/evidence_usecases.dart';
import '../widgets/evidence_chain_widget.dart';
import '../widgets/evidence_form_widget.dart';
import '../widgets/evidence_list_widget.dart';
import '../widgets/evidence_statistics_widget.dart';

/// Demo-Screen für das Beweismittel-Sammel-Feature
class EvidenceCollectionDemoScreen extends StatefulWidget {
  const EvidenceCollectionDemoScreen({super.key});

  @override
  State<EvidenceCollectionDemoScreen> createState() =>
      _EvidenceCollectionDemoScreenState();
}

class _EvidenceCollectionDemoScreenState
    extends State<EvidenceCollectionDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late EvidenceRepositoryImpl _repository;
  late GetAllEvidenceUseCase _getAllEvidenceUseCase;
  late SaveEvidenceUseCase _saveEvidenceUseCase;
  late GetEvidenceStatisticsUseCase _getStatisticsUseCase;
  late CreateEvidenceChainUseCase _createChainUseCase;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _repository = EvidenceRepositoryImpl();
    _getAllEvidenceUseCase = GetAllEvidenceUseCase(_repository);
    _saveEvidenceUseCase = SaveEvidenceUseCase(_repository);
    _getStatisticsUseCase = GetEvidenceStatisticsUseCase(_repository);
    _createChainUseCase = CreateEvidenceChainUseCase(_repository);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Beweismittel-Sammlung'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'Übersicht'),
            Tab(icon: Icon(Icons.add), text: 'Hinzufügen'),
            Tab(icon: Icon(Icons.analytics), text: 'Statistiken'),
            Tab(icon: Icon(Icons.link), text: 'Ketten'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Beweismittel-Übersicht
          EvidenceListWidget(
            getAllEvidenceUseCase: _getAllEvidenceUseCase,
            repository: _repository,
          ),

          // Tab 2: Neues Beweismittel hinzufügen
          EvidenceFormWidget(
            saveEvidenceUseCase: _saveEvidenceUseCase,
            onEvidenceSaved: _handleEvidenceSaved,
          ),

          // Tab 3: Statistiken
          EvidenceStatisticsWidget(
            getStatisticsUseCase: _getStatisticsUseCase,
          ),

          // Tab 4: Beweismittel-Ketten
          EvidenceChainWidget(
            repository: _repository,
            createChainUseCase: _createChainUseCase,
          ),
        ],
      ),
    );
  }

  void _handleEvidenceSaved() {
    SnackBarUtils.showSuccessSnackBar(
      context,
      'Beweismittel erfolgreich hinzugefügt',
    );
    // Zurück zur Übersicht wechseln
    _tabController.animateTo(0);
  }
}
