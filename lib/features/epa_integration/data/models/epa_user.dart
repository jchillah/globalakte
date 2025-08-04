// features/epa_integration/data/models/epa_user.dart

/// ePA-Benutzer Entity
class EpaUser {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? organization;
  final String? role;
  final List<String> permissions;
  final DateTime lastLogin;
  final DateTime createdAt;
  final bool isActive;
  final Map<String, dynamic> metadata;

  const EpaUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.organization,
    this.role,
    required this.permissions,
    required this.lastLogin,
    required this.createdAt,
    required this.isActive,
    this.metadata = const {},
  });

  /// Vollständiger Name des Benutzers
  String get fullName => '$firstName $lastName';

  /// Benutzer hat bestimmte Berechtigung
  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  /// Benutzer ist Administrator
  bool get isAdmin => hasPermission('admin');

  /// Benutzer kann Fälle erstellen
  bool get canCreateCases => hasPermission('create_cases');

  /// Benutzer kann Fälle bearbeiten
  bool get canEditCases => hasPermission('edit_cases');

  /// Benutzer kann Dokumente hochladen
  bool get canUploadDocuments => hasPermission('upload_documents');

  /// Benutzer kann Dokumente herunterladen
  bool get canDownloadDocuments => hasPermission('download_documents');

  /// Kopie mit geänderten Werten erstellen
  EpaUser copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? organization,
    String? role,
    List<String>? permissions,
    DateTime? lastLogin,
    DateTime? createdAt,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return EpaUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      organization: organization ?? this.organization,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }

  /// JSON-Serialisierung
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'organization': organization,
      'role': role,
      'permissions': permissions,
      'lastLogin': lastLogin.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  /// JSON-Deserialisierung
  factory EpaUser.fromJson(Map<String, dynamic> json) {
    return EpaUser(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      organization: json['organization'] as String?,
      role: json['role'] as String?,
      permissions: List<String>.from(json['permissions'] ?? []),
      lastLogin: DateTime.parse(json['lastLogin'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] ?? true,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EpaUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'EpaUser(id: $id, username: $username, fullName: $fullName)';
  }
}

/// ePA-Benutzer-Rollen
enum EpaUserRole {
  admin('Administrator', 'Vollzugriff auf alle Funktionen'),
  lawyer('Rechtsanwalt', 'Zugriff auf Fallakten und Dokumente'),
  assistant('Assistent', 'Eingeschränkter Zugriff auf Fälle'),
  client('Mandant', 'Nur Zugriff auf eigene Fälle'),
  observer('Beobachter', 'Nur Lesezugriff auf zugewiesene Fälle');

  const EpaUserRole(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// ePA-Benutzer-Berechtigungen
enum EpaPermission {
  // Fall-Management
  createCases('create_cases', 'Fälle erstellen'),
  editCases('edit_cases', 'Fälle bearbeiten'),
  deleteCases('delete_cases', 'Fälle löschen'),
  viewCases('view_cases', 'Fälle anzeigen'),

  // Dokument-Management
  uploadDocuments('upload_documents', 'Dokumente hochladen'),
  downloadDocuments('download_documents', 'Dokumente herunterladen'),
  deleteDocuments('delete_documents', 'Dokumente löschen'),
  viewDocuments('view_documents', 'Dokumente anzeigen'),

  // Benutzer-Management
  manageUsers('manage_users', 'Benutzer verwalten'),
  viewUsers('view_users', 'Benutzer anzeigen'),

  // System-Administration
  admin('admin', 'Vollzugriff'),
  systemSettings('system_settings', 'Systemeinstellungen'),
  auditLog('audit_log', 'Audit-Log anzeigen');

  const EpaPermission(this.code, this.description);
  final String code;
  final String description;
} 