// features/appointment/domain/entities/appointment.dart

/// Termin-Entity für das Terminverwaltungs-System
class Appointment {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final AppointmentType type;
  final AppointmentStatus status;
  final String? reminderId;
  final DateTime? reminderTime;
  final String? caseId; // Verknüpfung mit Fallakte
  final DateTime createdAt;
  final DateTime updatedAt;

  const Appointment({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.type,
    required this.status,
    this.reminderId,
    this.reminderTime,
    this.caseId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Erstellt eine Kopie mit aktualisierten Eigenschaften
  Appointment copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    AppointmentType? type,
    AppointmentStatus? status,
    String? reminderId,
    DateTime? reminderTime,
    String? caseId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      type: type ?? this.type,
      status: status ?? this.status,
      reminderId: reminderId ?? this.reminderId,
      reminderTime: reminderTime ?? this.reminderTime,
      caseId: caseId ?? this.caseId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Konvertiert zu Map für JSON-Serialisierung
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'type': type.name,
      'status': status.name,
      'reminderId': reminderId,
      'reminderTime': reminderTime?.toIso8601String(),
      'caseId': caseId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Erstellt aus Map (JSON-Deserialisierung)
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      location: json['location'] as String,
      type: AppointmentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AppointmentType.general,
      ),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AppointmentStatus.scheduled,
      ),
      reminderId: json['reminderId'] as String?,
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'] as String)
          : null,
      caseId: json['caseId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Appointment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Appointment(id: $id, title: $title, startTime: $startTime, type: $type, status: $status)';
  }
}

/// Termin-Typen für Kategorisierung
enum AppointmentType {
  general('Allgemein'),
  court('Gerichtstermin'),
  lawyer('Anwaltstermin'),
  police('Polizeitermin'),
  medical('Ärztlicher Termin'),
  deadline('Frist'),
  reminder('Erinnerung');

  const AppointmentType(this.displayName);
  final String displayName;
}

/// Termin-Status für Workflow-Management
enum AppointmentStatus {
  scheduled('Geplant'),
  confirmed('Bestätigt'),
  inProgress('Läuft'),
  completed('Abgeschlossen'),
  cancelled('Abgesagt'),
  postponed('Verschoben');

  const AppointmentStatus(this.displayName);
  final String displayName;
}
