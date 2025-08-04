// features/epa_integration/data/api/epa_api_client_impl.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/epa_case.dart';
import '../models/epa_document.dart';
import '../models/epa_user.dart';
import '../models/epa_response.dart';
import 'epa_api_client.dart';

/// Implementation des ePA API Clients
class EpaApiClientImpl implements EpaApiClient {
  final String baseUrl;
  final http.Client _httpClient;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  EpaApiClientImpl({
    required this.baseUrl,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  @override
  Future<EpaResponse<EpaUser>> authenticate(String username, String password) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['accessToken'];
        _refreshToken = data['refreshToken'];
        _tokenExpiry = DateTime.parse(data['expiresAt']);

        final user = EpaUser.fromJson(data['user']);
        return EpaResponse.success(user, message: 'Authentifizierung erfolgreich');
      } else {
        return EpaResponse.error('Authentifizierung fehlgeschlagen: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<List<EpaCase>>> getCases({
    String? userId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      await _ensureValidToken();

      final queryParams = <String, String>{};
      if (userId != null) queryParams['userId'] = userId;
      if (status != null) queryParams['status'] = status;
      if (fromDate != null) queryParams['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();

      final response = await _httpClient.get(
        Uri.parse('$baseUrl/cases').replace(queryParameters: queryParams),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final cases = (data['cases'] as List)
            .map((json) => EpaCase.fromJson(json))
            .toList();
        return EpaResponse.success(cases);
      } else {
        return EpaResponse.error('Fehler beim Abrufen der Fälle: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<EpaCase>> getCase(String caseId) async {
    try {
      await _ensureValidToken();

      final response = await _httpClient.get(
        Uri.parse('$baseUrl/cases/$caseId'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final epaCase = EpaCase.fromJson(data);
        return EpaResponse.success(epaCase);
      } else {
        return EpaResponse.error('Fall nicht gefunden: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<List<EpaDocument>>> getCaseDocuments(String caseId) async {
    try {
      await _ensureValidToken();

      final response = await _httpClient.get(
        Uri.parse('$baseUrl/cases/$caseId/documents'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final documents = (data['documents'] as List)
            .map((json) => EpaDocument.fromJson(json))
            .toList();
        return EpaResponse.success(documents);
      } else {
        return EpaResponse.error('Fehler beim Abrufen der Dokumente: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<EpaDocument>> getDocument(String documentId) async {
    try {
      await _ensureValidToken();

      final response = await _httpClient.get(
        Uri.parse('$baseUrl/documents/$documentId'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final document = EpaDocument.fromJson(data);
        return EpaResponse.success(document);
      } else {
        return EpaResponse.error('Dokument nicht gefunden: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<String>> downloadDocument(String documentId) async {
    try {
      await _ensureValidToken();

      final response = await _httpClient.get(
        Uri.parse('$baseUrl/documents/$documentId/download'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        // Simuliere Download-Pfad
        final downloadPath = '/downloads/document_$documentId.pdf';
        return EpaResponse.success(downloadPath, message: 'Download erfolgreich');
      } else {
        return EpaResponse.error('Download fehlgeschlagen: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<EpaCase>> createCase(EpaCase epaCase) async {
    try {
      await _ensureValidToken();

      final response = await _httpClient.post(
        Uri.parse('$baseUrl/cases'),
        headers: _getAuthHeaders(),
        body: jsonEncode(epaCase.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final createdCase = EpaCase.fromJson(data);
        return EpaResponse.success(createdCase, message: 'Fall erfolgreich erstellt');
      } else {
        return EpaResponse.error('Fehler beim Erstellen des Falls: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<EpaCase>> updateCase(String caseId, EpaCase epaCase) async {
    try {
      await _ensureValidToken();

      final response = await _httpClient.put(
        Uri.parse('$baseUrl/cases/$caseId'),
        headers: _getAuthHeaders(),
        body: jsonEncode(epaCase.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedCase = EpaCase.fromJson(data);
        return EpaResponse.success(updatedCase, message: 'Fall erfolgreich aktualisiert');
      } else {
        return EpaResponse.error('Fehler beim Aktualisieren des Falls: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<EpaDocument>> uploadDocument(String caseId, EpaDocument document) async {
    try {
      await _ensureValidToken();

      // Simuliere Dokument-Upload
      final uploadedDocument = document.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uploadedAt: DateTime.now(),
        status: EpaDocumentStatus.available,
      );

      return EpaResponse.success(uploadedDocument, message: 'Dokument erfolgreich hochgeladen');
    } catch (e) {
      return EpaResponse.error('Fehler beim Hochladen: $e');
    }
  }

  @override
  Future<EpaResponse<bool>> deleteCase(String caseId) async {
    try {
      await _ensureValidToken();

      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/cases/$caseId'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 204) {
        return EpaResponse.success(true, message: 'Fall erfolgreich gelöscht');
      } else {
        return EpaResponse.error('Fehler beim Löschen des Falls: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<bool>> deleteDocument(String documentId) async {
    try {
      await _ensureValidToken();

      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/documents/$documentId'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 204) {
        return EpaResponse.success(true, message: 'Dokument erfolgreich gelöscht');
      } else {
        return EpaResponse.error('Fehler beim Löschen des Dokuments: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<Map<String, dynamic>>> getSyncStatus() async {
    try {
      await _ensureValidToken();

      final response = await _httpClient.get(
        Uri.parse('$baseUrl/sync/status'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EpaResponse.success(data);
      } else {
        return EpaResponse.error('Fehler beim Abrufen des Sync-Status: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<Map<String, dynamic>>> syncOfflineChanges(List<Map<String, dynamic>> changes) async {
    try {
      await _ensureValidToken();

      final response = await _httpClient.post(
        Uri.parse('$baseUrl/sync/offline'),
        headers: _getAuthHeaders(),
        body: jsonEncode({'changes': changes}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EpaResponse.success(data, message: 'Offline-Änderungen synchronisiert');
      } else {
        return EpaResponse.error('Fehler bei der Synchronisation: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<Map<String, dynamic>>> resolveConflicts(List<Map<String, dynamic>> conflicts) async {
    try {
      await _ensureValidToken();

      final response = await _httpClient.post(
        Uri.parse('$baseUrl/sync/resolve'),
        headers: _getAuthHeaders(),
        body: jsonEncode({'conflicts': conflicts}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EpaResponse.success(data, message: 'Konflikte gelöst');
      } else {
        return EpaResponse.error('Fehler beim Lösen der Konflikte: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<Map<String, dynamic>>> checkApiStatus() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EpaResponse.success(data);
      } else {
        return EpaResponse.error('API nicht verfügbar: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<String>> refreshToken(String refreshToken) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['accessToken'];
        _tokenExpiry = DateTime.parse(data['expiresAt']);
        return EpaResponse.success(_accessToken!, message: 'Token erneuert');
      } else {
        return EpaResponse.error('Token-Erneuerung fehlgeschlagen: ${response.statusCode}');
      }
    } catch (e) {
      return EpaResponse.error('Netzwerk-Fehler: $e');
    }
  }

  @override
  Future<EpaResponse<bool>> logout() async {
    try {
      if (_accessToken != null) {
        await _httpClient.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: _getAuthHeaders(),
        );
      }

      _accessToken = null;
      _refreshToken = null;
      _tokenExpiry = null;

      return EpaResponse.success(true, message: 'Erfolgreich abgemeldet');
    } catch (e) {
      return EpaResponse.error('Fehler beim Abmelden: $e');
    }
  }

  /// Stellt sicher, dass ein gültiger Token vorhanden ist
  Future<void> _ensureValidToken() async {
    if (_accessToken == null) {
      throw Exception('Nicht authentifiziert');
    }

    if (_tokenExpiry != null && _tokenExpiry!.isBefore(DateTime.now())) {
      if (_refreshToken != null) {
        final response = await refreshToken(_refreshToken!);
        if (!response.success) {
          throw Exception('Token-Erneuerung fehlgeschlagen');
        }
      } else {
        throw Exception('Token abgelaufen und kein Refresh-Token verfügbar');
      }
    }
  }

  /// Erstellt Auth-Headers
  Map<String, String> _getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };
  }

  @override
  void dispose() {
    _httpClient.close();
  }
} 