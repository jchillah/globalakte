// features/case_timeline/data/repositories/case_file_repository_impl.dart
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/case_file.dart';
import '../../domain/entities/timeline_event.dart';
import '../../domain/repositories/case_file_repository.dart';

/// Implementierung des CaseFileRepository mit lokaler Speicherung
class CaseFileRepositoryImpl implements CaseFileRepository {
  static const String _caseFilesKey = 'case_files';
  static const String _timelineEventsKey = 'timeline_events';
  static const String _epaIntegrationKey = 'epa_integration';
  static const String _backupsKey = 'backups';

  @override
  Future<CaseFile> createCaseFile(CaseFile caseFile) async {
    final caseFiles = await getAllCaseFiles();

    // Prüfe ob Fallnummer bereits existiert
    if (await isCaseNumberExists(caseFile.caseNumber)) {
      throw ArgumentError(
          'Fallnummer bereits vergeben: ${caseFile.caseNumber}');
    }

    caseFiles.add(caseFile);
    await _saveCaseFiles(caseFiles);

    return caseFile;
  }

  @override
  Future<CaseFile?> getCaseFile(String id) async {
    final caseFiles = await getAllCaseFiles();
    try {
      return caseFiles.firstWhere((caseFile) => caseFile.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<CaseFile>> getAllCaseFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final caseFilesJson = prefs.getString(_caseFilesKey);

    if (caseFilesJson == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(caseFilesJson);
      return jsonList.map((json) => CaseFile.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<CaseFile>> getCaseFilesByStatus(String status) async {
    final caseFiles = await getAllCaseFiles();
    return caseFiles.where((caseFile) => caseFile.status == status).toList();
  }

  @override
  Future<List<CaseFile>> getCaseFilesByCategory(String category) async {
    final caseFiles = await getAllCaseFiles();
    return caseFiles
        .where((caseFile) => caseFile.category == category)
        .toList();
  }

  @override
  Future<List<CaseFile>> searchCaseFiles(String query) async {
    final caseFiles = await getAllCaseFiles();
    final lowercaseQuery = query.toLowerCase();

    return caseFiles.where((caseFile) {
      return caseFile.title.toLowerCase().contains(lowercaseQuery) ||
          caseFile.description.toLowerCase().contains(lowercaseQuery) ||
          caseFile.caseNumber.toLowerCase().contains(lowercaseQuery) ||
          (caseFile.assignedTo?.toLowerCase().contains(lowercaseQuery) ??
              false);
    }).toList();
  }

  @override
  Future<CaseFile> updateCaseFile(CaseFile caseFile) async {
    final caseFiles = await getAllCaseFiles();
    final index = caseFiles.indexWhere((cf) => cf.id == caseFile.id);

    if (index == -1) {
      throw ArgumentError('Fallakte nicht gefunden: ${caseFile.id}');
    }

    caseFiles[index] = caseFile.copyWith(updatedAt: DateTime.now());
    await _saveCaseFiles(caseFiles);

    return caseFiles[index];
  }

  @override
  Future<void> deleteCaseFile(String id) async {
    final caseFiles = await getAllCaseFiles();
    caseFiles.removeWhere((caseFile) => caseFile.id == id);
    await _saveCaseFiles(caseFiles);

    // Lösche auch alle zugehörigen Timeline Events
    final events = await getAllTimelineEvents();
    final remainingEvents =
        events.where((event) => event.caseFileId != id).toList();
    await _saveTimelineEvents(remainingEvents);
  }

  @override
  Future<TimelineEvent> createTimelineEvent(TimelineEvent event) async {
    final events = await getAllTimelineEvents();
    events.add(event);
    await _saveTimelineEvents(events);

    return event;
  }

  @override
  Future<List<TimelineEvent>> getTimelineEvents(String caseFileId) async {
    final events = await getAllTimelineEvents();
    return events.where((event) => event.caseFileId == caseFileId).toList();
  }

  @override
  Future<TimelineEvent> updateTimelineEvent(TimelineEvent event) async {
    final events = await getAllTimelineEvents();
    final index = events.indexWhere((e) => e.id == event.id);

    if (index == -1) {
      throw ArgumentError('Timeline Event nicht gefunden: ${event.id}');
    }

    events[index] = event;
    await _saveTimelineEvents(events);

    return events[index];
  }

  @override
  Future<void> deleteTimelineEvent(String id) async {
    final events = await getAllTimelineEvents();
    events.removeWhere((event) => event.id == id);
    await _saveTimelineEvents(events);
  }

  @override
  Future<void> addDocumentToCaseFile(
      String caseFileId, String documentId) async {
    final caseFile = await getCaseFile(caseFileId);
    if (caseFile == null) {
      throw ArgumentError('Fallakte nicht gefunden: $caseFileId');
    }

    final updatedDocumentIds = List<String>.from(caseFile.documentIds);
    if (!updatedDocumentIds.contains(documentId)) {
      updatedDocumentIds.add(documentId);
    }

    final updatedCaseFile = caseFile.copyWith(documentIds: updatedDocumentIds);
    await updateCaseFile(updatedCaseFile);
  }

  @override
  Future<void> removeDocumentFromCaseFile(
      String caseFileId, String documentId) async {
    final caseFile = await getCaseFile(caseFileId);
    if (caseFile == null) {
      throw ArgumentError('Fallakte nicht gefunden: $caseFileId');
    }

    final updatedDocumentIds = List<String>.from(caseFile.documentIds);
    updatedDocumentIds.remove(documentId);

    final updatedCaseFile = caseFile.copyWith(documentIds: updatedDocumentIds);
    await updateCaseFile(updatedCaseFile);
  }

  @override
  Future<bool> checkEpaIntegration(String caseFileId) async {
    final prefs = await SharedPreferences.getInstance();
    final epaData = prefs.getString(_epaIntegrationKey);

    if (epaData == null) return false;

    try {
      final Map<String, dynamic> epaMap = jsonDecode(epaData);
      return epaMap[caseFileId] == true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> enableEpaIntegration(String caseFileId) async {
    final prefs = await SharedPreferences.getInstance();
    final epaData = prefs.getString(_epaIntegrationKey);

    Map<String, dynamic> epaMap = {};
    if (epaData != null) {
      try {
        epaMap = Map<String, dynamic>.from(jsonDecode(epaData));
      } catch (e) {
        epaMap = {};
      }
    }

    epaMap[caseFileId] = true;
    await prefs.setString(_epaIntegrationKey, jsonEncode(epaMap));
  }

  @override
  Future<void> disableEpaIntegration(String caseFileId) async {
    final prefs = await SharedPreferences.getInstance();
    final epaData = prefs.getString(_epaIntegrationKey);

    if (epaData == null) return;

    try {
      final Map<String, dynamic> epaMap =
          Map<String, dynamic>.from(jsonDecode(epaData));
      epaMap.remove(caseFileId);
      await prefs.setString(_epaIntegrationKey, jsonEncode(epaMap));
    } catch (e) {
      // Ignoriere Fehler beim Parsen
    }
  }

  @override
  Future<String?> getEpaStatus(String caseFileId) async {
    final isIntegrated = await checkEpaIntegration(caseFileId);
    if (!isIntegrated) return null;

    // Simuliere ePA-Status
    return 'synchronized';
  }

  @override
  Future<void> syncWithEpa(String caseFileId) async {
    final isIntegrated = await checkEpaIntegration(caseFileId);
    if (!isIntegrated) {
      throw ArgumentError(
          'ePA-Integration nicht aktiviert für Fallakte: $caseFileId');
    }

    // Simuliere Synchronisation
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<Map<String, dynamic>> getCaseFileStatistics() async {
    final caseFiles = await getAllCaseFiles();
    final events = await getAllTimelineEvents();

    final totalCases = caseFiles.length;
    final activeCases = caseFiles.where((cf) => cf.isActive).length;
    final completedCases = caseFiles.where((cf) => cf.isCompleted).length;
    final overdueCases = caseFiles.where((cf) => cf.isOverdue).length;
    final totalEvents = events.length;

    return {
      'totalCases': totalCases,
      'activeCases': activeCases,
      'completedCases': completedCases,
      'overdueCases': overdueCases,
      'totalEvents': totalEvents,
      'averageEventsPerCase': totalCases > 0 ? totalEvents / totalCases : 0,
    };
  }

  @override
  Future<void> createBackup() async {
    final caseFiles = await getAllCaseFiles();
    final events = await getAllTimelineEvents();

    final backup = {
      'timestamp': DateTime.now().toIso8601String(),
      'caseFiles': caseFiles.map((cf) => cf.toJson()).toList(),
      'timelineEvents': events.map((e) => e.toJson()).toList(),
    };

    final backups = await _getBackups();
    backups.add(backup);
    await _saveBackups(backups);
  }

  @override
  Future<void> restoreBackup(String backupId) async {
    final backups = await _getBackups();
    final backup = backups.firstWhere(
      (b) => b['timestamp'] == backupId,
      orElse: () => throw ArgumentError('Backup nicht gefunden: $backupId'),
    );

    final caseFiles = (backup['caseFiles'] as List)
        .map((json) => CaseFile.fromJson(json))
        .toList();

    final events = (backup['timelineEvents'] as List)
        .map((json) => TimelineEvent.fromJson(json))
        .toList();

    await _saveCaseFiles(caseFiles);
    await _saveTimelineEvents(events);
  }

  @override
  bool isValidCaseFile(CaseFile caseFile) {
    return caseFile.title.isNotEmpty &&
        caseFile.description.isNotEmpty &&
        caseFile.caseNumber.isNotEmpty &&
        caseFile.status.isNotEmpty &&
        caseFile.category.isNotEmpty;
  }

  @override
  bool isValidTimelineEvent(TimelineEvent event) {
    return event.title.isNotEmpty &&
        event.description.isNotEmpty &&
        event.caseFileId.isNotEmpty &&
        event.eventType.isNotEmpty;
  }

  @override
  Future<String> generateCaseNumber() async {
    final random = Random();
    final year = DateTime.now().year;
    final randomNumber = random.nextInt(99999).toString().padLeft(5, '0');
    return 'AK-$year-$randomNumber';
  }

  @override
  Future<bool> isCaseNumberExists(String caseNumber) async {
    final caseFiles = await getAllCaseFiles();
    return caseFiles.any((cf) => cf.caseNumber == caseNumber);
  }

  // Private Hilfsmethoden
  Future<void> _saveCaseFiles(List<CaseFile> caseFiles) async {
    final prefs = await SharedPreferences.getInstance();
    final caseFilesJson =
        jsonEncode(caseFiles.map((cf) => cf.toJson()).toList());
    await prefs.setString(_caseFilesKey, caseFilesJson);
  }

  Future<List<TimelineEvent>> getAllTimelineEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString(_timelineEventsKey);

    if (eventsJson == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(eventsJson);
      return jsonList.map((json) => TimelineEvent.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveTimelineEvents(List<TimelineEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = jsonEncode(events.map((e) => e.toJson()).toList());
    await prefs.setString(_timelineEventsKey, eventsJson);
  }

  Future<List<Map<String, dynamic>>> _getBackups() async {
    final prefs = await SharedPreferences.getInstance();
    final backupsJson = prefs.getString(_backupsKey);

    if (backupsJson == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(backupsJson);
      return jsonList.map((json) => Map<String, dynamic>.from(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveBackups(List<Map<String, dynamic>> backups) async {
    final prefs = await SharedPreferences.getInstance();
    final backupsJson = jsonEncode(backups);
    await prefs.setString(_backupsKey, backupsJson);
  }
}
