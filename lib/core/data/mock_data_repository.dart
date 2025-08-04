// core/data/mock_data_repository.dart

import 'dart:math';

/// Zentrales Mock-Data-Repository für alle Mock-Daten im Projekt
/// Verbessert die Wartbarkeit und Lesbarkeit durch zentrale Organisation
class MockDataRepository {
  static final MockDataRepository _instance = MockDataRepository._internal();
  factory MockDataRepository() => _instance;
  MockDataRepository._internal();

  final Random _random = Random();

  // ===== PDF-GENERATOR MOCK-DATEN =====

  /// PDF-Templates für den PDF-Generator
  Map<String, Map<String, dynamic>> get pdfTemplates => {
        'legal_letter': {
          'id': '1',
          'name': 'Anwaltsschreiben',
          'description': 'Professionelles Anwaltsschreiben mit Briefkopf',
          'templateType': 'legal_letter',
          'htmlTemplate': '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>{{title}}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { text-align: center; margin-bottom: 30px; }
        .logo { font-size: 24px; font-weight: bold; color: #1E3A8A; }
        .date { text-align: right; margin-bottom: 20px; }
        .recipient { margin-bottom: 20px; }
        .content { line-height: 1.6; }
        .signature { margin-top: 40px; }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">GlobalAkte Rechtsanwälte</div>
        <div>Musterstraße 123, 12345 Musterstadt</div>
        <div>Tel: 0123-456789 | E-Mail: info@globalakte.de</div>
    </div>
    
    <div class="date">{{currentDate}}</div>
    
    <div class="recipient">
        <strong>{{recipientName}}</strong><br>
        {{recipientAddress}}
    </div>
    
    <div class="content">
        <h2>{{title}}</h2>
        <p>{{content}}</p>
    </div>
    
    <div class="signature">
        <p>Mit freundlichen Grüßen</p>
        <p><strong>{{author}}</strong></p>
    </div>
</body>
</html>
      ''',
          'defaultData': {
            'title': 'Anwaltsschreiben',
            'recipientName': 'Empfänger Name',
            'recipientAddress': 'Empfänger Adresse',
            'content': 'Inhalt des Schreibens',
            'author': 'Rechtsanwalt',
          },
          'requiredFields': [
            'title',
            'recipientName',
            'recipientAddress',
            'content',
            'author'
          ],
          'optionalFields': ['currentDate'],
          'category': 'Recht',
          'version': '1.0',
        },
        'contract': {
          'id': '2',
          'name': 'Vertrag',
          'description': 'Standard-Vertragstemplate',
          'templateType': 'contract',
          'htmlTemplate': '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>{{title}}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { text-align: center; margin-bottom: 30px; }
        .title { font-size: 20px; font-weight: bold; text-align: center; margin-bottom: 30px; }
        .parties { margin-bottom: 20px; }
        .content { line-height: 1.6; }
        .signatures { margin-top: 40px; display: flex; justify-content: space-between; }
    </style>
</head>
<body>
    <div class="header">
        <h1>{{title}}</h1>
    </div>
    
    <div class="parties">
        <p><strong>Vertragspartei A:</strong> {{partyA}}</p>
        <p><strong>Vertragspartei B:</strong> {{partyB}}</p>
    </div>
    
    <div class="content">
        <h3>§ 1 Vertragsgegenstand</h3>
        <p>{{subject}}</p>
        
        <h3>§ 2 Vertragsdauer</h3>
        <p>{{duration}}</p>
        
        <h3>§ 3 Vergütung</h3>
        <p>{{compensation}}</p>
        
        <h3>§ 4 Kündigung</h3>
        <p>{{termination}}</p>
    </div>
    
    <div class="signatures">
        <div>
            <p>_________________</p>
            <p>{{partyA}}</p>
        </div>
        <div>
            <p>_________________</p>
            <p>{{partyB}}</p>
        </div>
    </div>
    
    <div style="margin-top: 20px; text-align: center;">
        <p>Datum: {{currentDate}}</p>
    </div>
</body>
</html>
      ''',
          'defaultData': {
            'title': 'Vertrag',
            'partyA': 'Vertragspartei A',
            'partyB': 'Vertragspartei B',
            'subject': 'Vertragsgegenstand',
            'duration': 'Vertragsdauer',
            'compensation': 'Vergütung',
            'termination': 'Kündigungsbedingungen',
          },
          'requiredFields': [
            'title',
            'partyA',
            'partyB',
            'subject',
            'duration',
            'compensation',
            'termination'
          ],
          'optionalFields': ['currentDate'],
          'category': 'Vertrag',
          'version': '1.0',
        },
        'application': {
          'id': '3',
          'name': 'Antrag',
          'description': 'Standard-Antragstemplate',
          'templateType': 'application',
          'htmlTemplate': '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>{{title}}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { text-align: center; margin-bottom: 30px; }
        .applicant { margin-bottom: 20px; }
        .content { line-height: 1.6; }
        .signature { margin-top: 40px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>{{title}}</h1>
    </div>
    
    <div class="applicant">
        <p><strong>Antragsteller:</strong> {{applicantName}}</p>
        <p><strong>Adresse:</strong> {{applicantAddress}}</p>
        <p><strong>Datum:</strong> {{currentDate}}</p>
    </div>
    
    <div class="content">
        <h3>Antrag</h3>
        <p>{{applicationText}}</p>
        
        <h3>Begründung</h3>
        <p>{{justification}}</p>
        
        <h3>Belege</h3>
        <p>{{documents}}</p>
    </div>
    
    <div class="signature">
        <p>_________________</p>
        <p>{{applicantName}}</p>
    </div>
</body>
</html>
      ''',
          'defaultData': {
            'title': 'Antrag',
            'applicantName': 'Antragsteller Name',
            'applicantAddress': 'Antragsteller Adresse',
            'applicationText': 'Antragstext',
            'justification': 'Begründung',
            'documents': 'Beigefügte Dokumente',
          },
          'requiredFields': [
            'title',
            'applicantName',
            'applicantAddress',
            'applicationText',
            'justification',
            'documents'
          ],
          'optionalFields': ['currentDate'],
          'category': 'Antrag',
          'version': '1.0',
        },
      };

  /// PDF-Dokumente für den PDF-Generator
  List<Map<String, dynamic>> get pdfDocuments => [
        {
          'id': '1',
          'title': 'Anwaltsschreiben - Musterfall',
          'content': 'HTML-Content für Anwaltsschreiben',
          'templateType': 'legal_letter',
          'metadata': {
            'templateId': '1',
            'author': 'Rechtsanwalt Müller',
            'data': {
              'title': 'Anwaltsschreiben - Musterfall',
              'recipientName': 'Max Mustermann',
              'recipientAddress': 'Musterstraße 1, 12345 Musterstadt',
              'content':
                  'Sehr geehrter Herr Mustermann, hiermit bestätigen wir den Erhalt Ihrer Anfrage...',
              'author': 'Rechtsanwalt Müller',
            },
          },
          'createdAt': DateTime.now().subtract(const Duration(days: 5)),
          'author': 'Rechtsanwalt Müller',
          'tags': ['Anwaltsschreiben', 'Musterfall'],
        },
        {
          'id': '2',
          'title': 'Vertrag - Dienstleistung',
          'content': 'HTML-Content für Vertrag',
          'templateType': 'contract',
          'metadata': {
            'templateId': '2',
            'author': 'Rechtsanwalt Schmidt',
            'data': {
              'title': 'Dienstleistungsvertrag',
              'partyA': 'Firma A GmbH',
              'partyB': 'Firma B GmbH',
              'subject': 'Dienstleistungen im Bereich IT',
              'duration': '12 Monate',
              'compensation': '5.000 EUR monatlich',
              'termination': '3 Monate Kündigungsfrist',
            },
          },
          'createdAt': DateTime.now().subtract(const Duration(days: 3)),
          'author': 'Rechtsanwalt Schmidt',
          'tags': ['Vertrag', 'Dienstleistung'],
        },
      ];

  // ===== EVIDENCE COLLECTION MOCK-DATEN =====

  /// Beweismittel für die Beweissammlung
  List<Map<String, dynamic>> get evidenceItems => [
        {
          'title': 'Fotos vom Unfallort',
          'description': 'Fotografische Dokumentation des Verkehrsunfalls',
          'type': 'photo',
          'filePath': '/evidence/photos/accident_001.jpg',
          'collectedBy': 'Polizist Müller',
          'location': 'Hauptstraße 123, Berlin',
          'caseId': 'CASE-2024-001',
          'notes': 'Fotos zeigen Schäden am Fahrzeug',
          'status': 'collected',
          'collectedAt': DateTime.now().subtract(const Duration(days: 5)),
        },
        {
          'title': 'Videoaufnahme Überwachungskamera',
          'description': 'Videoaufnahme vom Tatzeitpunkt',
          'type': 'video',
          'filePath': '/evidence/videos/surveillance_001.mp4',
          'collectedBy': 'Detektiv Schmidt',
          'location': 'Einkaufszentrum, München',
          'caseId': 'CASE-2024-002',
          'notes': 'Zeigt verdächtige Person',
          'status': 'verified',
          'collectedAt': DateTime.now().subtract(const Duration(days: 3)),
        },
        {
          'title': 'Zeugenaussage',
          'description': 'Schriftliche Zeugenaussage von Max Mustermann',
          'type': 'document',
          'filePath': '/evidence/documents/witness_statement_001.pdf',
          'collectedBy': 'Anwalt Weber',
          'location': 'Kanzlei Weber & Partner',
          'caseId': 'CASE-2024-003',
          'notes': 'Wichtige Details zum Tathergang',
          'status': 'pending',
          'collectedAt': DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          'title': 'Audioaufnahme Telefonat',
          'description': 'Aufnahme eines verdächtigen Telefonats',
          'type': 'audio',
          'filePath': '/evidence/audio/phone_call_001.wav',
          'collectedBy': 'Ermittler Klein',
          'location': 'Polizeipräsidium Hamburg',
          'caseId': 'CASE-2024-004',
          'notes': 'Enthält belastende Aussagen',
          'status': 'collected',
          'collectedAt': DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          'title': 'Blutprobe',
          'description': 'Blutprobe vom Tatort',
          'type': 'physical',
          'filePath': '/evidence/physical/blood_sample_001',
          'collectedBy': 'Kriminaltechniker Fischer',
          'location': 'Labor für Forensik',
          'caseId': 'CASE-2024-005',
          'notes': 'DNA-Analyse in Bearbeitung',
          'status': 'processing',
          'collectedAt': DateTime.now().subtract(const Duration(hours: 12)),
        },
      ];

  /// Beweismittel-Ketten für Evidence Collection
  Map<String, List<String>> get evidenceChains => {
        'CHAIN-001': ['evidence_001', 'evidence_002'],
        'CHAIN-002': ['evidence_003', 'evidence_004'],
        'CHAIN-003': ['evidence_005'],
      };

  // ===== LEGAL AI MOCK-DATEN =====

  /// Rechtliche Kontexte für Legal AI
  List<Map<String, dynamic>> get legalContexts => [
        {
          'title': 'Mietrecht - Kündigung',
          'description': 'Rechtliche Aspekte bei Mietkündigungen',
          'category': 'Zivilrecht',
          'keywords': ['Miete', 'Kündigung', 'Vermieter', 'Mieter'],
          'legalFramework': {
            'gesetze': ['BGB § 573', 'BGB § 574'],
            'fristen': '3 Monate Kündigungsfrist',
          },
        },
        {
          'title': 'Arbeitsrecht - Kündigungsschutz',
          'description': 'Schutz vor unrechtmäßigen Kündigungen',
          'category': 'Arbeitsrecht',
          'keywords': ['Arbeitsvertrag', 'Kündigung', 'Kündigungsschutz'],
          'legalFramework': {
            'gesetze': ['KSchG', 'BGB § 626'],
            'fristen': '4 Wochen Kündigungsfrist',
          },
        },
      ];

  // ===== APPOINTMENT MOCK-DATEN =====

  /// Termine für die Terminverwaltung
  List<Map<String, dynamic>> get appointments => [
        {
          'id': '1',
          'title': 'Gerichtstermin - Mietstreit',
          'description': 'Verhandlung vor dem Amtsgericht Berlin-Mitte',
          'startTime': DateTime.now().add(const Duration(days: 2, hours: 10)),
          'endTime': DateTime.now().add(const Duration(days: 2, hours: 12)),
          'location':
              'Amtsgericht Berlin-Mitte, Littenstraße 12-17, 10179 Berlin',
          'type': 'court',
          'status': 'scheduled',
          'reminderTime': DateTime.now().add(const Duration(days: 1, hours: 9)),
          'caseId': 'case_001',
        },
        {
          'id': '2',
          'title': 'Anwaltstermin - Vertragsprüfung',
          'description': 'Besprechung zur Vertragsprüfung',
          'startTime': DateTime.now().add(const Duration(days: 1, hours: 14)),
          'endTime': DateTime.now().add(const Duration(days: 1, hours: 15)),
          'location':
              'Kanzlei Müller & Partner, Friedrichstraße 123, 10117 Berlin',
          'type': 'lawyer',
          'status': 'scheduled',
          'reminderTime': DateTime.now().add(const Duration(hours: 1)),
          'caseId': 'case_002',
        },
      ];

  // ===== HELP NETWORK MOCK-DATEN =====

  /// Hilfe-Anfragen für das Hilfe-Netzwerk
  List<Map<String, dynamic>> get helpRequests => [
        {
          'id': '1',
          'title': 'Rechtliche Beratung bei Mietstreit',
          'description':
              'Ich habe Probleme mit meinem Vermieter und brauche rechtliche Beratung.',
          'category': 'Zivilrecht',
          'requesterId': 'user_001',
          'requesterName': 'Max Mustermann',
          'status': 'open',
          'priority': 'medium',
          'location': 'Berlin',
          'tags': ['Mietrecht', 'Beratung'],
          'urgency': true,
          'deadline': DateTime.now().add(const Duration(days: 7)),
          'maxHelpers': 3,
          'createdAt': DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          'id': '2',
          'title': 'Unterstützung bei Arbeitsvertrag',
          'description':
              'Ich brauche Hilfe bei der Prüfung meines Arbeitsvertrags.',
          'category': 'Arbeitsrecht',
          'requesterId': 'user_002',
          'requesterName': 'Anna Schmidt',
          'status': 'in_progress',
          'priority': 'high',
          'location': 'München',
          'tags': ['Arbeitsrecht', 'Vertrag'],
          'urgency': false,
          'deadline': DateTime.now().add(const Duration(days: 14)),
          'maxHelpers': 2,
          'createdAt': DateTime.now().subtract(const Duration(days: 5)),
        },
      ];

  /// Hilfe-Angebote für das Hilfe-Netzwerk
  List<Map<String, dynamic>> get helpOffers => [
        {
          'id': '1',
          'helpRequestId': '1',
          'helperId': 'helper_001',
          'helperName': 'Rechtsanwalt Weber',
          'message':
              'Ich kann Ihnen bei Ihrem Mietstreit helfen. Lassen Sie uns das besprechen.',
          'status': 'pending',
          'rating': 4.5,
          'review': 'Sehr kompetente Beratung',
          'createdAt': DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          'id': '2',
          'helpRequestId': '2',
          'helperId': 'helper_002',
          'helperName': 'Anwältin Müller',
          'message':
              'Ich spezialisiere mich auf Arbeitsrecht und kann Ihnen gerne helfen.',
          'status': 'accepted',
          'rating': 4.8,
          'review': 'Hervorragende Unterstützung',
          'createdAt': DateTime.now().subtract(const Duration(days: 3)),
        },
      ];

  // ===== UTILITY-METHODEN =====

  /// Generiert eine zufällige Verzögerung für Mock-API-Calls
  Duration get randomDelay =>
      Duration(milliseconds: 200 + _random.nextInt(800));

  /// Generiert eine zufällige ID
  String get randomId => DateTime.now().millisecondsSinceEpoch.toString();

  /// Generiert eine zufällige Bewertung zwischen 1.0 und 5.0
  double get randomRating => 1.0 + _random.nextDouble() * 4.0;
}
