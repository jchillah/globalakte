// features/notifications/domain/entities/push_settings.dart
/// Entity für Push-Benachrichtigungseinstellungen
class PushSettings {
  final String id;
  final bool isEnabled;
  final bool caseNotifications;
  final bool documentNotifications;
  final bool appointmentNotifications;
  final bool systemNotifications;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String? deviceToken;
  final DateTime lastUpdated;

  const PushSettings({
    required this.id,
    required this.isEnabled,
    required this.caseNotifications,
    required this.documentNotifications,
    required this.appointmentNotifications,
    required this.systemNotifications,
    required this.soundEnabled,
    required this.vibrationEnabled,
    this.deviceToken,
    required this.lastUpdated,
  });

  /// Erstellt Standard-Einstellungen
  factory PushSettings.defaultSettings() {
    return PushSettings(
      id: 'default',
      isEnabled: true,
      caseNotifications: true,
      documentNotifications: true,
      appointmentNotifications: true,
      systemNotifications: true,
      soundEnabled: true,
      vibrationEnabled: true,
      lastUpdated: DateTime.now(),
    );
  }

  /// Konvertiert zu Map für Persistierung
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isEnabled': isEnabled,
      'caseNotifications': caseNotifications,
      'documentNotifications': documentNotifications,
      'appointmentNotifications': appointmentNotifications,
      'systemNotifications': systemNotifications,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'deviceToken': deviceToken,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Erstellt aus Map
  factory PushSettings.fromMap(Map<String, dynamic> map) {
    return PushSettings(
      id: map['id'],
      isEnabled: map['isEnabled'],
      caseNotifications: map['caseNotifications'],
      documentNotifications: map['documentNotifications'],
      appointmentNotifications: map['appointmentNotifications'],
      systemNotifications: map['systemNotifications'],
      soundEnabled: map['soundEnabled'],
      vibrationEnabled: map['vibrationEnabled'],
      deviceToken: map['deviceToken'],
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }

  /// Kopiert mit Änderungen
  PushSettings copyWith({
    String? id,
    bool? isEnabled,
    bool? caseNotifications,
    bool? documentNotifications,
    bool? appointmentNotifications,
    bool? systemNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? deviceToken,
    DateTime? lastUpdated,
  }) {
    return PushSettings(
      id: id ?? this.id,
      isEnabled: isEnabled ?? this.isEnabled,
      caseNotifications: caseNotifications ?? this.caseNotifications,
      documentNotifications: documentNotifications ?? this.documentNotifications,
      appointmentNotifications: appointmentNotifications ?? this.appointmentNotifications,
      systemNotifications: systemNotifications ?? this.systemNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      deviceToken: deviceToken ?? this.deviceToken,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PushSettings && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PushSettings(id: $id, isEnabled: $isEnabled, lastUpdated: $lastUpdated)';
  }
} 