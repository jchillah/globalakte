// features/legal_assistant_ai/data/services/legal_context_service.dart
import '../../domain/entities/legal_context.dart';

/// Service für Legal Context Operationen
class LegalContextService {
  final List<LegalContext> _legalContexts = [];

  LegalContextService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock rechtliche Kontexte
    _legalContexts.addAll([
      LegalContext.create(
        title: 'Mietrecht - Kündigung',
        description: 'Rechtliche Aspekte bei Mietkündigungen',
        category: 'Zivilrecht',
        keywords: ['Miete', 'Kündigung', 'Vermieter', 'Mieter'],
        legalFramework: {
          'gesetze': ['BGB § 573', 'BGB § 574'],
          'fristen': '3 Monate Kündigungsfrist',
          'wichtige_aspekte': [
            'Schriftform erforderlich',
            'Begründung notwendig',
            'Fristen beachten',
          ],
        },
      ),
      LegalContext.create(
        title: 'Arbeitsrecht - Kündigungsschutz',
        description: 'Schutz vor unrechtmäßigen Kündigungen',
        category: 'Arbeitsrecht',
        keywords: ['Arbeitsvertrag', 'Kündigung', 'Kündigungsschutz'],
        legalFramework: {
          'gesetze': ['KSchG', 'BGB § 626'],
          'fristen': '4 Wochen Kündigungsfrist',
          'wichtige_aspekte': [
            'Betriebszugehörigkeit > 6 Monate',
            'Sozialauswahl bei Massenkündigung',
            'Anhörung des Betriebsrats',
          ],
        },
      ),
      LegalContext.create(
        title: 'Familienrecht - Sorgerecht',
        description: 'Rechtliche Aspekte des Sorgerechts',
        category: 'Familienrecht',
        keywords: ['Sorgerecht', 'Kind', 'Eltern', 'Trennung'],
        legalFramework: {
          'gesetze': ['BGB § 1626', 'BGB § 1627'],
          'grundsatz': 'Kindeswohl steht im Vordergrund',
          'wichtige_aspekte': [
            'Gemeinsames Sorgerecht',
            'Alleiniges Sorgerecht',
            'Umgangsrecht',
          ],
        },
      ),
      LegalContext.create(
        title: 'Strafrecht - Diebstahl',
        description: 'Rechtliche Aspekte bei Diebstahldelikten',
        category: 'Strafrecht',
        keywords: ['Diebstahl', 'StGB', 'Strafverfahren'],
        legalFramework: {
          'gesetze': ['StGB § 242', 'StGB § 243'],
          'strafrahmen': 'Freiheitsstrafe bis 5 Jahre',
          'wichtige_aspekte': [
            'Vorsatz erforderlich',
            'Fremdbesitz',
            'Wegnahme',
          ],
        },
      ),
      LegalContext.create(
        title: 'Verkehrsrecht - Bußgeld',
        description: 'Rechtliche Aspekte bei Verkehrsverstößen',
        category: 'Verkehrsrecht',
        keywords: ['Bußgeld', 'Verkehrsverstoß', 'Führerschein'],
        legalFramework: {
          'gesetze': ['StVG', 'StVO'],
          'verfahren': 'Bußgeldverfahren',
          'wichtige_aspekte': [
            'Einspruchsfrist 2 Wochen',
            'Beweisfotos',
            'Zeugenaussagen',
          ],
        },
      ),
    ]);
  }

  // CRUD Operationen
  Future<List<LegalContext>> getAllLegalContexts() async {
    await Future.delayed(Duration(milliseconds: 300));
    return List.from(_legalContexts);
  }

  Future<List<LegalContext>> getLegalContextsByCategory(String category) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _legalContexts
        .where((context) => context.category == category)
        .toList();
  }

  Future<LegalContext?> getLegalContextById(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    try {
      return _legalContexts.firstWhere((context) => context.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveLegalContext(LegalContext context) async {
    await Future.delayed(Duration(milliseconds: 200));
    _legalContexts.add(context);
  }

  Future<void> updateLegalContext(LegalContext context) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _legalContexts.indexWhere((c) => c.id == context.id);
    if (index != -1) {
      _legalContexts[index] = context;
    }
  }

  Future<void> deleteLegalContext(String contextId) async {
    await Future.delayed(Duration(milliseconds: 100));
    _legalContexts.removeWhere((context) => context.id == contextId);
  }

  Future<List<LegalContext>> searchLegalContexts(String query) async {
    await Future.delayed(Duration(milliseconds: 400));
    final lowercaseQuery = query.toLowerCase();
    return _legalContexts.where((context) {
      return context.title.toLowerCase().contains(lowercaseQuery) ||
          context.description.toLowerCase().contains(lowercaseQuery) ||
          context.keywords.any((keyword) => keyword.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Future<List<String>> getCategories() async {
    await Future.delayed(Duration(milliseconds: 200));
    final categories = _legalContexts.map((context) => context.category).toSet();
    return categories.toList();
  }

  Future<List<LegalContext>> getContextsByKeywords(List<String> keywords) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _legalContexts.where((context) {
      return keywords.any((keyword) => 
          context.keywords.any((contextKeyword) => 
              contextKeyword.toLowerCase().contains(keyword.toLowerCase())));
    }).toList();
  }

  Future<Map<String, dynamic>> getContextStatistics() async {
    await Future.delayed(Duration(milliseconds: 200));
    
    final categories = <String, int>{};
    final totalContexts = _legalContexts.length;
    
    for (final context in _legalContexts) {
      categories[context.category] = (categories[context.category] ?? 0) + 1;
    }
    
    return {
      'total_contexts': totalContexts,
      'categories': categories,
      'average_keywords': _legalContexts.fold(0, (sum, context) => sum + context.keywords.length) / totalContexts,
    };
  }

  Future<List<LegalContext>> getPopularContexts({int limit = 5}) async {
    await Future.delayed(Duration(milliseconds: 300));
    // Mock Implementation - in einer echten App würde hier die Popularität gemessen
    return _legalContexts.take(limit).toList();
  }

  Future<void> importLegalContexts(List<LegalContext> contexts) async {
    await Future.delayed(Duration(milliseconds: 500));
    _legalContexts.clear();
    _legalContexts.addAll(contexts);
  }

  Future<List<LegalContext>> exportLegalContexts() async {
    await Future.delayed(Duration(milliseconds: 200));
    return List.from(_legalContexts);
  }
} 