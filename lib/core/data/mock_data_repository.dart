// core/data/mock_data_repository.dart

import 'dart:math';

/// Zentrales Mock-Data Repository für alle Features
class MockDataRepository {
  static final MockDataRepository _instance = MockDataRepository._internal();
  factory MockDataRepository() => _instance;
  MockDataRepository._internal();

  final Random _random = Random();

  // PDF Templates
  Map<String, Map<String, dynamic>> get pdfTemplates => {
        'legal_letter': {
          'id': 'legal_letter_001',
          'name': 'Anwaltsschreiben',
          'description': 'Standard-Anwaltsschreiben Template',
          'templateType': 'legal_letter',
          'category': 'Recht',
          'version': '1.0',
          'htmlTemplate': '''
<!DOCTYPE html>
<html>
<head>
    <title>Anwaltsschreiben</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { text-align: center; margin-bottom: 30px; }
        .content { line-height: 1.6; }
        .footer { margin-top: 30px; text-align: center; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Anwaltsschreiben</h1>
        <p>Datum: {{currentDate}}</p>
    </div>
    <div class="content">
        <p><strong>An: {{empfaenger}}</strong></p>
        <p><strong>Betreff: {{betreff}}</strong></p>
        <p>{{inhalt}}</p>
        <p>Mit freundlichen Grüßen,<br>
        {{anwaltName}}<br>
        {{anwaltskanzlei}}</p>
    </div>
    <div class="footer">
        <p>{{anwaltskanzlei}}<br>
        {{adresse}}<br>
        Tel: {{telefon}}<br>
        Email: {{email}}</p>
    </div>
</body>
</html>
      ''',
          'defaultData': {
            'empfaenger': 'Max Mustermann',
            'betreff': 'Rechtliche Angelegenheit',
            'inhalt':
                'Sehr geehrte Damen und Herren,\n\nhiermit informieren wir Sie über wichtige rechtliche Aspekte...',
            'anwaltName': 'Dr. Anna Schmidt',
            'anwaltskanzlei': 'Rechtsanwaltskanzlei Schmidt & Partner',
            'adresse': 'Musterstraße 123, 12345 Musterstadt',
            'telefon': '+49 123 456789',
            'email': 'info@schmidt-partner.de',
          },
          'requiredFields': ['empfaenger', 'betreff', 'inhalt', 'anwaltName'],
          'optionalFields': ['anwaltskanzlei', 'adresse', 'telefon', 'email'],
        },
        'contract': {
          'id': 'contract_001',
          'name': 'Vertrag',
          'description': 'Standard-Vertrag Template',
          'templateType': 'contract',
          'category': 'Vertrag',
          'version': '1.0',
          'htmlTemplate': '''
<!DOCTYPE html>
<html>
<head>
    <title>Vertrag</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { text-align: center; margin-bottom: 30px; }
        .content { line-height: 1.6; }
        .signature { margin-top: 30px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>{{vertragstitel}}</h1>
        <p>Datum: {{currentDate}}</p>
    </div>
    <div class="content">
        <p><strong>Vertragsparteien:</strong></p>
        <p>Partei A: {{parteiA}}<br>
        Partei B: {{parteiB}}</p>
        <p><strong>Vertragsgegenstand:</strong><br>
        {{vertragsgegenstand}}</p>
        <p><strong>Vertragsbedingungen:</strong><br>
        {{bedingungen}}</p>
        <p><strong>Laufzeit:</strong> {{laufzeit}}</p>
        <p><strong>Vergütung:</strong> {{verguetung}}</p>
    </div>
    <div class="signature">
        <p>Unterschriften:</p>
        <p>Partei A: _________________<br>
        Partei B: _________________</p>
    </div>
</body>
</html>
      ''',
          'defaultData': {
            'vertragstitel': 'Dienstleistungsvertrag',
            'parteiA': 'Firma A GmbH',
            'parteiB': 'Firma B GmbH',
            'vertragsgegenstand': 'Erbringung von IT-Dienstleistungen',
            'bedingungen': 'Standard-Dienstleistungsbedingungen gelten',
            'laufzeit': '12 Monate',
            'verguetung': '5.000 EUR monatlich',
          },
          'requiredFields': [
            'vertragstitel',
            'parteiA',
            'parteiB',
            'vertragsgegenstand'
          ],
          'optionalFields': ['bedingungen', 'laufzeit', 'verguetung'],
        },
        'application': {
          'id': 'application_001',
          'name': 'Antrag',
          'description': 'Standard-Antrag Template',
          'templateType': 'application',
          'category': 'Antrag',
          'version': '1.0',
          'htmlTemplate': '''
<!DOCTYPE html>
<html>
<head>
    <title>Antrag</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { text-align: center; margin-bottom: 30px; }
        .content { line-height: 1.6; }
        .applicant { margin-top: 20px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>{{antragstitel}}</h1>
        <p>Datum: {{currentDate}}</p>
    </div>
    <div class="content">
        <p><strong>Antragsteller:</strong><br>
        {{antragstellerName}}<br>
        {{antragstellerAdresse}}<br>
        Tel: {{antragstellerTelefon}}<br>
        Email: {{antragstellerEmail}}</p>
        <p><strong>Antragsgrund:</strong><br>
        {{antragsgrund}}</p>
        <p><strong>Gewünschte Maßnahme:</strong><br>
        {{massnahme}}</p>
        <p><strong>Begründung:</strong><br>
        {{begruendung}}</p>
    </div>
    <div class="applicant">
        <p>Unterschrift: _________________<br>
        {{antragstellerName}}</p>
    </div>
</body>
</html>
      ''',
          'defaultData': {
            'antragstitel': 'Antrag auf Genehmigung',
            'antragstellerName': 'Max Mustermann',
            'antragstellerAdresse': 'Musterstraße 123, 12345 Musterstadt',
            'antragstellerTelefon': '+49 123 456789',
            'antragstellerEmail': 'max.mustermann@email.de',
            'antragsgrund': 'Erweiterung der Geschäftstätigkeit',
            'massnahme': 'Genehmigung für neue Räumlichkeiten',
            'begruendung':
                'Die Erweiterung ist notwendig für das Wachstum des Unternehmens...',
          },
          'requiredFields': [
            'antragstitel',
            'antragstellerName',
            'antragsgrund'
          ],
          'optionalFields': [
            'antragstellerAdresse',
            'antragstellerTelefon',
            'antragstellerEmail',
            'massnahme',
            'begruendung'
          ],
        },
      };

  // PDF Documents
  List<Map<String, dynamic>> get pdfDocuments => [
        {
          'id': 'doc_001',
          'title': 'Anwaltsschreiben - Fall Müller',
          'content':
              'Sehr geehrte Damen und Herren, hiermit informieren wir Sie über wichtige rechtliche Aspekte im Fall Müller. Die Angelegenheit erfordert Ihre umgehende Aufmerksamkeit...',
          'templateType': 'legal_letter',
          'metadata': {
            'templateId': 'legal_letter_001',
            'author': 'Dr. Anna Schmidt',
            'data': {
              'empfaenger': 'Max Mustermann',
              'betreff': 'Fall Müller',
              'inhalt':
                  'Sehr geehrte Damen und Herren, hiermit informieren wir Sie über wichtige rechtliche Aspekte im Fall Müller...',
            },
          },
          'createdAt': DateTime.now().subtract(const Duration(days: 2)),
          'author': 'Dr. Anna Schmidt',
          'tags': ['Recht', 'Anwalt', 'Fall Müller'],
        },
        {
          'id': 'doc_002',
          'title': 'Dienstleistungsvertrag - IT-Services',
          'content':
              'Vertrag zwischen Firma A GmbH und Firma B GmbH über die Erbringung von IT-Dienstleistungen. Laufzeit: 12 Monate, Vergütung: 5.000 EUR monatlich...',
          'templateType': 'contract',
          'metadata': {
            'templateId': 'contract_001',
            'author': 'Rechtsabteilung',
            'data': {
              'vertragstitel': 'Dienstleistungsvertrag',
              'parteiA': 'Firma A GmbH',
              'parteiB': 'Firma B GmbH',
              'vertragsgegenstand': 'Erbringung von IT-Dienstleistungen',
            },
          },
          'createdAt': DateTime.now().subtract(const Duration(days: 1)),
          'author': 'Rechtsabteilung',
          'tags': ['Vertrag', 'IT', 'Dienstleistung'],
        },
      ];

  // Help Network Data
  List<Map<String, dynamic>> get helpRequests => [
        {
          'id': 'req_001',
          'title': 'Rechtliche Beratung benötigt',
          'description': 'Ich benötige Hilfe bei einem Arbeitsrecht-Fall',
          'category': 'Recht',
          'requesterId': 'user_001',
          'requesterName': 'Max Mustermann',
          'status': 'open',
          'priority': 'high',
          'location': 'Berlin',
          'tags': ['Arbeitsrecht', 'Beratung'],
          'urgency': 'urgent',
          'deadline': DateTime.now().add(const Duration(days: 3)),
          'maxHelpers': 2,
          'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
        },
        {
          'id': 'req_002',
          'title': 'Dokumente übersetzen',
          'description':
              'Suche jemanden, der englische Verträge ins Deutsche übersetzt',
          'category': 'Übersetzung',
          'requesterId': 'user_002',
          'requesterName': 'Anna Schmidt',
          'status': 'in_progress',
          'priority': 'medium',
          'location': 'Hamburg',
          'tags': ['Übersetzung', 'Vertrag', 'Englisch'],
          'urgency': 'normal',
          'deadline': DateTime.now().add(const Duration(days: 7)),
          'maxHelpers': 1,
          'createdAt': DateTime.now().subtract(const Duration(days: 1)),
        },
      ];

  List<Map<String, dynamic>> get helpOffers => [
        {
          'id': 'offer_001',
          'helpRequestId': 'req_001',
          'helperId': 'helper_001',
          'helperName': 'Dr. Rechtsanwalt',
          'message':
              'Ich kann Ihnen bei dem Arbeitsrecht-Fall helfen. Bin seit 15 Jahren in diesem Bereich tätig.',
          'status': 'pending',
          'rating': 4.8,
          'review': 'Sehr kompetent und hilfsbereit',
          'createdAt': DateTime.now().subtract(const Duration(hours: 1)),
        },
        {
          'id': 'offer_002',
          'helpRequestId': 'req_002',
          'helperId': 'helper_002',
          'helperName': 'Übersetzerin Maria',
          'message':
              'Ich übersetze gerne Ihre Verträge. Habe 10 Jahre Erfahrung mit juristischen Texten.',
          'status': 'accepted',
          'rating': 4.9,
          'review': 'Exzellente Übersetzung, sehr zuverlässig',
          'createdAt': DateTime.now().subtract(const Duration(hours: 3)),
        },
      ];

  List<Map<String, dynamic>> get helpChats => [
        {
          'id': 'chat_001',
          'helpRequestId': 'req_001',
          'senderId': 'user_001',
          'senderName': 'Max Mustermann',
          'message': 'Hallo, vielen Dank für Ihr Angebot!',
          'messageType': 'text',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
          'isRead': true,
        },
        {
          'id': 'chat_002',
          'helpRequestId': 'req_001',
          'senderId': 'helper_001',
          'senderName': 'Dr. Rechtsanwalt',
          'message': 'Gerne! Können Sie mir mehr Details zu Ihrem Fall geben?',
          'messageType': 'text',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 25)),
          'isRead': true,
        },
      ];

  // Evidence Collection Data
  List<Map<String, dynamic>> get evidenceItems => [
        {
          'id': 'evid_001',
          'title': 'Blutprobe - Fall Müller',
          'description': 'Blutprobe vom 15.03.2024, Labor-ID: LAB-2024-001',
          'type': 'biological',
          'status': 'verified',
          'location': 'Labor Berlin',
          'collectedBy': 'Dr. Schmidt',
          'collectedAt': DateTime.now().subtract(const Duration(days: 5)),
          'notes': 'Probe wurde ordnungsgemäß verpackt und versiegelt',
          'tags': ['Blutprobe', 'Fall Müller', 'Labor'],
        },
        {
          'id': 'evid_002',
          'title': 'Fingerabdruck - Tatort',
          'description':
              'Fingerabdruck von der Türklinke, Tatort: Musterstraße 123',
          'type': 'physical',
          'status': 'pending',
          'location': 'Tatort',
          'collectedBy': 'Kriminalbeamter Weber',
          'collectedAt': DateTime.now().subtract(const Duration(days: 3)),
          'notes': 'Abdruck wurde mit Spezialfolie gesichert',
          'tags': ['Fingerabdruck', 'Tatort', 'Spuren'],
        },
      ];

  // Legal AI Data
  List<Map<String, dynamic>> get legalContexts => [
        {
          'id': 'context_001',
          'name': 'Arbeitsrecht',
          'description': 'Rechtliche Beratung im Bereich Arbeitsrecht',
          'keywords': ['Arbeitsvertrag', 'Kündigung', 'Überstunden', 'Urlaub'],
          'isActive': true,
        },
        {
          'id': 'context_002',
          'name': 'Vertragsrecht',
          'description': 'Beratung zu Vertragsangelegenheiten',
          'keywords': ['Vertrag', 'AGB', 'Schadensersatz', 'Leistungsstörung'],
          'isActive': true,
        },
      ];

  List<Map<String, dynamic>> get legalAiMessages => [
        {
          'id': 'msg_001',
          'contextId': 'context_001',
          'sender': 'user',
          'message': 'Kann mein Arbeitgeber mich ohne Grund kündigen?',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'metadata': {
            'sessionId': 'session_001',
            'userType': 'citizen',
          },
        },
        {
          'id': 'msg_002',
          'contextId': 'context_001',
          'sender': 'ai',
          'message':
              'Nein, eine Kündigung ohne Grund ist in Deutschland nicht zulässig. Es gibt verschiedene Arten der Kündigung: ordentliche Kündigung, außerordentliche Kündigung und betriebsbedingte Kündigung. Jede hat spezifische Voraussetzungen...',
          'timestamp':
              DateTime.now().subtract(const Duration(hours: 2, minutes: 1)),
          'metadata': {
            'sessionId': 'session_001',
            'confidence': 0.95,
            'sources': ['Arbeitsgesetzbuch', 'Bundesarbeitsgericht'],
          },
        },
      ];

  // Notification Data
  List<Map<String, dynamic>> get notifications => [
        {
          'id': 'notif_001',
          'title': 'Neue Nachricht',
          'message': 'Sie haben eine neue Nachricht im Hilfe-Netzwerk erhalten',
          'type': 'message',
          'category': 'help_network',
          'isRead': false,
          'createdAt': DateTime.now().subtract(const Duration(minutes: 30)),
          'data': {
            'senderId': 'helper_001',
            'senderName': 'Dr. Rechtsanwalt',
            'helpRequestId': 'req_001',
          },
        },
        {
          'id': 'notif_002',
          'title': 'Dokument erstellt',
          'message': 'Ihr PDF-Dokument wurde erfolgreich generiert',
          'type': 'document',
          'category': 'pdf_generator',
          'isRead': true,
          'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
          'data': {
            'documentId': 'doc_001',
            'documentTitle': 'Anwaltsschreiben - Fall Müller',
          },
        },
      ];

  // EPA Integration Data
  List<Map<String, dynamic>> get epaCases => [
        {
          'id': 'case_001',
          'patientId': 'patient_001',
          'patientName': 'Max Mustermann',
          'caseType': 'Behandlung',
          'status': 'active',
          'createdAt': DateTime.now().subtract(const Duration(days: 10)),
          'updatedAt': DateTime.now().subtract(const Duration(hours: 2)),
          'metadata': {
            'doctor': 'Dr. Schmidt',
            'department': 'Innere Medizin',
            'priority': 'normal',
          },
        },
      ];

  List<Map<String, dynamic>> get epaDocuments => [
        {
          'id': 'epa_doc_001',
          'caseId': 'case_001',
          'title': 'Arztbrief',
          'type': 'medical_report',
          'content': 'Patient zeigt typische Symptome...',
          'createdAt': DateTime.now().subtract(const Duration(days: 5)),
          'author': 'Dr. Schmidt',
          'status': 'active',
        },
      ];

  List<Map<String, dynamic>> get epaUsers => [
        {
          'id': 'epa_user_001',
          'username': 'dr.schmidt',
          'email': 'dr.schmidt@krankenhaus.de',
          'fullName': 'Dr. Hans Schmidt',
          'role': 'doctor',
          'status': 'active',
          'permissions': ['read_cases', 'write_cases', 'read_documents'],
          'department': 'Innere Medizin',
          'phone': '+49 123 456789',
          'createdAt': DateTime.now().subtract(const Duration(days: 30)),
          'lastLogin': DateTime.now().subtract(const Duration(hours: 1)),
          'metadata': {
            'source': 'epa_system',
            'syncStatus': 'synced',
            'lastSync': DateTime.now().toIso8601String(),
          },
        },
        {
          'id': 'epa_user_002',
          'username': 'nurse.mueller',
          'email': 'nurse.mueller@krankenhaus.de',
          'fullName': 'Maria Müller',
          'role': 'nurse',
          'status': 'active',
          'permissions': ['read_cases', 'read_documents'],
          'department': 'Innere Medizin',
          'phone': '+49 123 456790',
          'createdAt': DateTime.now().subtract(const Duration(days: 25)),
          'lastLogin': DateTime.now().subtract(const Duration(hours: 3)),
          'metadata': {
            'source': 'epa_system',
            'syncStatus': 'synced',
            'lastSync': DateTime.now().toIso8601String(),
          },
        },
        {
          'id': 'epa_user_003',
          'username': 'admin.weber',
          'email': 'admin.weber@krankenhaus.de',
          'fullName': 'Peter Weber',
          'role': 'admin',
          'status': 'active',
          'permissions': ['read_cases', 'write_cases', 'read_documents', 'write_documents', 'manage_users'],
          'department': 'IT-Administration',
          'phone': '+49 123 456791',
          'createdAt': DateTime.now().subtract(const Duration(days: 60)),
          'lastLogin': DateTime.now().subtract(const Duration(minutes: 30)),
          'metadata': {
            'source': 'epa_system',
            'syncStatus': 'synced',
            'lastSync': DateTime.now().toIso8601String(),
          },
        },
      ];

  // Utility Methods
  String getRandomId() {
    return 'id_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(1000)}';
  }

  DateTime getRandomDate() {
    return DateTime.now().subtract(Duration(days: _random.nextInt(30)));
  }

  String getRandomName() {
    final names = [
      'Max Mustermann',
      'Anna Schmidt',
      'Peter Weber',
      'Maria Müller'
    ];
    return names[_random.nextInt(names.length)];
  }

  String getRandomEmail() {
    final domains = ['gmail.com', 'outlook.com', 'yahoo.com'];
    final name = getRandomName().toLowerCase().replaceAll(' ', '.');
    final domain = domains[_random.nextInt(domains.length)];
    return '$name@$domain';
  }
}
