// features/evidence_collection/data/repositories/evidence_repository_impl.dart
import 'dart:convert';
import 'dart:math';

import '../../domain/entities/evidence_item.dart';
import '../../domain/repositories/evidence_repository.dart';

/// Implementation des Evidence Repository mit Mock-Daten
class EvidenceRepositoryImpl implements EvidenceRepository {
  final List<EvidenceItem> _evidenceItems = [];
  final Map<String, List<String>> _evidenceChains = {};
  // Random wird für zukünftige Erweiterungen benötigt
  // ignore: unused_field
  final Random _random = Random();

  EvidenceRepositoryImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock Beweismittel mit verschiedenen Verifizierungsstatus
    final now = DateTime.now();

    _evidenceItems.addAll([
      EvidenceItem(
        id: 'evidence_001',
        title: 'Fotos vom Unfallort',
        description: 'Fotografische Dokumentation des Verkehrsunfalls',
        type: 'photo',
        filePath: '/evidence/photos/accident_001.jpg',
        collectedAt: now,
        collectedBy: 'Polizist Müller',
        location: 'Hauptstraße 123, Berlin',
        metadata: {},
        status: 'verified',
        caseId: 'CASE-2024-001',
        notes: 'Verifiziert von Demo User am $now',
      ),
      EvidenceItem(
        id: 'evidence_002',
        title: 'Videoaufnahme Überwachungskamera',
        description: 'Videoaufnahme vom Tatzeitpunkt',
        type: 'video',
        filePath: '/evidence/videos/surveillance_001.mp4',
        collectedAt: now,
        collectedBy: 'Detektiv Schmidt',
        location: 'Einkaufszentrum, München',
        metadata: {},
        status: 'verified',
        caseId: 'CASE-2024-002',
        notes: 'Verifiziert von Demo User am $now',
      ),
      EvidenceItem(
        id: 'evidence_003',
        title: 'Zeugenaussage',
        description: 'Schriftliche Zeugenaussage von Max Mustermann',
        type: 'document',
        filePath: '/evidence/documents/witness_statement_001.pdf',
        collectedAt: now,
        collectedBy: 'Anwalt Weber',
        location: 'Kanzlei Weber & Partner',
        metadata: {},
        status: 'verified',
        caseId: 'CASE-2024-003',
        notes: 'Wichtige Details zum Tathergang',
      ),
      EvidenceItem(
        id: 'evidence_004',
        title: 'Audioaufnahme Telefonat',
        description: 'Aufnahme eines verdächtigen Telefonats',
        type: 'audio',
        filePath: '/evidence/audio/phone_call_001.wav',
        collectedAt: now,
        collectedBy: 'Ermittler Klein',
        location: 'Polizeipräsidium Hamburg',
        metadata: {},
        status: 'verified',
        caseId: 'CASE-2024-004',
        notes: 'Verifiziert von Demo User am $now',
      ),
      EvidenceItem(
        id: 'evidence_005',
        title: 'Blutprobe',
        description: 'Blutprobe vom Tatort',
        type: 'physical',
        filePath: '/evidence/physical/blood_sample_001',
        collectedAt: now,
        collectedBy: 'Kriminaltechniker Fischer',
        location: 'Labor für Forensik',
        metadata: {},
        status: 'verified',
        caseId: 'CASE-2024-005',
        notes: 'DNA-Analyse in Bearbeitung\nVerifiziert von Demo User am $now',
      ),
    ]);

    // Mock Beweismittel-Ketten
    _evidenceChains['CHAIN-001'] = [
      'evidence_001',
      'evidence_002',
    ];
    _evidenceChains['CHAIN-002'] = [
      'evidence_003',
      'evidence_004',
    ];
  }

  @override
  Future<List<EvidenceItem>> getAllEvidence() async {
    await Future.delayed(Duration(milliseconds: 300));
    return List.from(_evidenceItems);
  }

  @override
  Future<EvidenceItem?> getEvidenceById(String id) async {
    await Future.delayed(Duration(milliseconds: 200));
    try {
      return _evidenceItems.firstWhere((evidence) => evidence.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<EvidenceItem>> getEvidenceByCaseId(String caseId) async {
    await Future.delayed(Duration(milliseconds: 400));
    return _evidenceItems
        .where((evidence) => evidence.caseId == caseId)
        .toList();
  }

  @override
  Future<List<EvidenceItem>> getEvidenceByStatus(String status) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _evidenceItems
        .where((evidence) => evidence.status == status)
        .toList();
  }

  @override
  Future<List<EvidenceItem>> getEvidenceByType(String type) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _evidenceItems.where((evidence) => evidence.type == type).toList();
  }

  @override
  Future<void> saveEvidence(EvidenceItem evidence) async {
    await Future.delayed(Duration(milliseconds: 200));
    _evidenceItems.add(evidence);
  }

  @override
  Future<void> updateEvidence(EvidenceItem evidence) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _evidenceItems.indexWhere((e) => e.id == evidence.id);
    if (index != -1) {
      _evidenceItems[index] = evidence;
    }
  }

  @override
  Future<void> deleteEvidence(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _evidenceItems.removeWhere((evidence) => evidence.id == id);
  }

  @override
  Future<List<EvidenceItem>> searchEvidence(String query) async {
    await Future.delayed(Duration(milliseconds: 500));
    final lowercaseQuery = query.toLowerCase();
    return _evidenceItems.where((evidence) {
      return evidence.title.toLowerCase().contains(lowercaseQuery) ||
          evidence.description.toLowerCase().contains(lowercaseQuery) ||
          evidence.location.toLowerCase().contains(lowercaseQuery) ||
          evidence.collectedBy.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<Map<String, dynamic>> getEvidenceStatistics() async {
    await Future.delayed(Duration(milliseconds: 400));

    final totalCount = _evidenceItems.length;
    final typeStats = <String, int>{};
    final statusStats = <String, int>{};

    for (final evidence in _evidenceItems) {
      typeStats[evidence.type] = (typeStats[evidence.type] ?? 0) + 1;
      statusStats[evidence.status] = (statusStats[evidence.status] ?? 0) + 1;
    }

    return {
      'total_count': totalCount,
      'type_statistics': typeStats,
      'status_statistics': statusStats,
      'recent_additions': _evidenceItems
          .where((e) => e.collectedAt.isAfter(
                DateTime.now().subtract(Duration(days: 7)),
              ))
          .length,
    };
  }

  @override
  Future<String> exportEvidence({String format = 'json'}) async {
    await Future.delayed(Duration(milliseconds: 600));

    if (format == 'json') {
      return jsonEncode({
        'evidence_items': _evidenceItems.map((e) => e.toMap()).toList(),
        'evidence_chains': _evidenceChains,
        'exported_at': DateTime.now().toIso8601String(),
      });
    } else {
      return _evidenceItems
          .map((e) => '${e.title} | ${e.type} | ${e.status} | ${e.collectedAt}')
          .join('\n');
    }
  }

  @override
  Future<void> importEvidence(String data, {String format = 'json'}) async {
    await Future.delayed(Duration(milliseconds: 400));

    if (format == 'json') {
      final jsonData = jsonDecode(data);
      final evidenceItems = (jsonData['evidence_items'] as List)
          .map((e) => EvidenceItem.fromMap(e))
          .toList();
      _evidenceItems.addAll(evidenceItems);
    } else {
      // Einfache Text-Import
      final lines = data.split('\n');
      for (final line in lines) {
        if (line.contains(' | ')) {
          final parts = line.split(' | ');
          if (parts.length >= 4) {
            _evidenceItems.add(EvidenceItem.create(
              title: parts[0],
              description: 'Importiertes Beweismittel',
              type: parts[1],
              filePath: '/imported/${DateTime.now().millisecondsSinceEpoch}',
              collectedBy: 'System Import',
              location: 'Unbekannt',
            ));
          }
        }
      }
    }
  }

  @override
  Future<bool> validateEvidence(EvidenceItem evidence) async {
    await Future.delayed(Duration(milliseconds: 300));

    // Mock-Validierung
    return evidence.title.isNotEmpty &&
        evidence.description.isNotEmpty &&
        evidence.filePath.isNotEmpty &&
        evidence.collectedBy.isNotEmpty &&
        evidence.location.isNotEmpty;
  }

  @override
  Future<void> verifyEvidence(String id, String verifiedBy) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _evidenceItems.indexWhere((e) => e.id == id);
    if (index != -1) {
      final currentEvidence = _evidenceItems[index];
      final verificationNote = currentEvidence.notes != null &&
              currentEvidence.notes!.isNotEmpty
          ? '${currentEvidence.notes}\nVerifiziert von $verifiedBy am ${DateTime.now()}'
          : 'Verifiziert von $verifiedBy am ${DateTime.now()}';

      _evidenceItems[index] = currentEvidence.copyWith(
        status: 'verified',
        notes: verificationNote,
      );
    }
  }

  @override
  Future<void> rejectEvidence(String id, String reason) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _evidenceItems.indexWhere((e) => e.id == id);
    if (index != -1) {
      _evidenceItems[index] = _evidenceItems[index].copyWith(
        status: 'rejected',
        notes: 'Abgelehnt: $reason',
      );
    }
  }

  @override
  Future<void> archiveEvidence(String id) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _evidenceItems.indexWhere((e) => e.id == id);
    if (index != -1) {
      _evidenceItems[index] = _evidenceItems[index].copyWith(
        status: 'archived',
        notes: 'Archiviert am ${DateTime.now()}',
      );
    }
  }

  /// Alle Beweismittel verifizieren (für Demo-Zwecke)
  Future<void> verifyAllEvidence(String verifiedBy) async {
    await Future.delayed(Duration(milliseconds: 500));
    for (int i = 0; i < _evidenceItems.length; i++) {
      final currentEvidence = _evidenceItems[i];
      if (currentEvidence.status != 'verified') {
        final verificationNote = currentEvidence.notes != null &&
                currentEvidence.notes!.isNotEmpty
            ? '${currentEvidence.notes}\nVerifiziert von $verifiedBy am ${DateTime.now()}'
            : 'Verifiziert von $verifiedBy am ${DateTime.now()}';

        _evidenceItems[i] = currentEvidence.copyWith(
          status: 'verified',
          notes: verificationNote,
        );
      }
    }
  }

  @override
  Future<void> createEvidenceChain(
      List<String> evidenceIds, String chainName) async {
    await Future.delayed(Duration(milliseconds: 300));
    final chainId = 'CHAIN-${DateTime.now().millisecondsSinceEpoch}';
    _evidenceChains[chainId] = evidenceIds;
  }

  @override
  Future<List<EvidenceItem>> getEvidenceChain(String chainId) async {
    await Future.delayed(Duration(milliseconds: 300));
    final evidenceIds = _evidenceChains[chainId] ?? [];
    return _evidenceItems
        .where((evidence) => evidenceIds.contains(evidence.id))
        .toList();
  }

  @override
  Future<void> deleteEvidenceChain(String chainId) async {
    await Future.delayed(Duration(milliseconds: 200));
    _evidenceChains.remove(chainId);
  }
}
