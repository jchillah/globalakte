import 'package:flutter/material.dart';

import '../../../../shared/utils/snackbar_utils.dart';
import '../../data/repositories/legal_ai_repository_impl.dart';
import '../../domain/entities/ai_message.dart';
import '../../domain/entities/legal_context.dart';
import '../../domain/repositories/legal_ai_repository.dart';
import '../../domain/usecases/legal_ai_usecases.dart';
import '../widgets/chat_widget.dart';
import '../widgets/context_selector_widget.dart';
import '../widgets/document_generator_widget.dart';
import '../widgets/legal_analysis_widget.dart';

/// Demo-Screen für Legal AI Features
class LegalAiDemoScreen extends StatefulWidget {
  const LegalAiDemoScreen({super.key});

  @override
  State<LegalAiDemoScreen> createState() => _LegalAiDemoScreenState();
}

class _LegalAiDemoScreenState extends State<LegalAiDemoScreen>
    with TickerProviderStateMixin {
  late final LegalAiRepository _repository;
  late final SendMessageUseCase _sendMessageUseCase;
  late final GetChatHistoryUseCase _getChatHistoryUseCase;
  late final GetLegalContextsUseCase _getLegalContextsUseCase;
  late final GenerateLegalDocumentUseCase _generateDocumentUseCase;
  late final AnalyzeLegalDocumentUseCase _analyzeDocumentUseCase;

  List<AiMessage> _chatHistory = [];
  List<LegalContext> _legalContexts = [];
  String _selectedContext = '';
  bool _isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    _repository = LegalAiRepositoryImpl();
    _sendMessageUseCase = SendMessageUseCase(_repository);
    _getChatHistoryUseCase = GetChatHistoryUseCase(_repository);
    _getLegalContextsUseCase = GetLegalContextsUseCase(_repository);
    _generateDocumentUseCase = GenerateLegalDocumentUseCase(_repository);
    _analyzeDocumentUseCase = AnalyzeLegalDocumentUseCase(_repository);

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    try {
      final futures = await Future.wait([
        _getChatHistoryUseCase(),
        _getLegalContextsUseCase(),
      ]);

      if (!mounted) return;

      setState(() {
        _chatHistory = futures[0] as List<AiMessage>;
        _legalContexts = futures[1] as List<LegalContext>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
        context,
        'Fehler beim Laden der Daten: $e',
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final response = await _sendMessageUseCase(
        message,
        context: _selectedContext.isNotEmpty ? _selectedContext : null,
      );

      if (!mounted) return;

      setState(() {
        _chatHistory.add(AiMessage.user(content: message));
        _chatHistory.add(response);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
        context,
        'Fehler beim Senden der Nachricht: $e',
      );
      setState(() => _isLoading = false);
    }
  }

  void _onContextChanged(String context) {
    setState(() => _selectedContext = context);
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
        title: const Text('Legal AI Assistent'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.chat), text: 'Chat'),
            Tab(icon: Icon(Icons.folder), text: 'Kontexte'),
            Tab(icon: Icon(Icons.description), text: 'Dokumente'),
            Tab(icon: Icon(Icons.analytics), text: 'Analyse'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Chat Tab
          ChatWidget(
            chatHistory: _chatHistory,
            isLoading: _isLoading,
            onSendMessage: _sendMessage,
          ),
          
          // Kontexte Tab
          ContextSelectorWidget(
            contexts: _legalContexts,
            selectedContext: _selectedContext,
            onContextChanged: _onContextChanged,
            isLoading: _isLoading,
          ),
          
          // Dokumente Tab
          DocumentGeneratorWidget(
            generateDocumentUseCase: _generateDocumentUseCase,
            selectedContext: _selectedContext,
            isLoading: _isLoading,
          ),
          
          // Analyse Tab
          LegalAnalysisWidget(
            analyzeDocumentUseCase: _analyzeDocumentUseCase,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
} 