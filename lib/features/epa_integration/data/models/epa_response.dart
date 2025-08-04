// features/epa_integration/data/models/epa_response.dart

/// Generische Antwort-Klasse für ePA API Calls
class EpaResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? errorCode;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  const EpaResponse({
    required this.success,
    this.data,
    this.message,
    this.errorCode,
    this.metadata,
    required this.timestamp,
  });

  /// Erfolgreiche Antwort erstellen
  factory EpaResponse.success(T data,
      {String? message, Map<String, dynamic>? metadata}) {
    return EpaResponse(
      success: true,
      data: data,
      message: message,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Fehler-Antwort erstellen
  factory EpaResponse.error(String message,
      {String? errorCode, Map<String, dynamic>? metadata}) {
    return EpaResponse(
      success: false,
      message: message,
      errorCode: errorCode,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Antwort aus JSON erstellen
  factory EpaResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return EpaResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromJson(json['data']) : null,
      message: json['message'],
      errorCode: json['errorCode'],
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  /// Antwort zu JSON konvertieren
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJson) {
    return {
      'success': success,
      'data': data != null ? toJson(data as T) : null,
      'message': message,
      'errorCode': errorCode,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'EpaResponse(success: $success, message: $message, timestamp: $timestamp)';
  }
}

/// ePA API Fehler-Codes
enum EpaErrorCode {
  authenticationFailed('AUTH_FAILED', 'Authentifizierung fehlgeschlagen'),
  unauthorized('UNAUTHORIZED', 'Nicht autorisiert'),
  forbidden('FORBIDDEN', 'Zugriff verweigert'),
  notFound('NOT_FOUND', 'Ressource nicht gefunden'),
  validationError('VALIDATION_ERROR', 'Validierungsfehler'),
  serverError('SERVER_ERROR', 'Server-Fehler'),
  networkError('NETWORK_ERROR', 'Netzwerk-Fehler'),
  timeout('TIMEOUT', 'Zeitüberschreitung'),
  syncConflict('SYNC_CONFLICT', 'Synchronisations-Konflikt'),
  offlineMode('OFFLINE_MODE', 'Offline-Modus aktiv'),
  rateLimitExceeded('RATE_LIMIT', 'Rate Limit überschritten');

  const EpaErrorCode(this.code, this.description);
  final String code;
  final String description;
}

/// ePA API Status
enum EpaApiStatus {
  online('ONLINE', 'API ist verfügbar'),
  offline('OFFLINE', 'API ist nicht verfügbar'),
  maintenance('MAINTENANCE', 'Wartungsmodus'),
  degraded('DEGRADED', 'Eingeschränkte Funktionalität');

  const EpaApiStatus(this.status, this.description);
  final String status;
  final String description;
}
