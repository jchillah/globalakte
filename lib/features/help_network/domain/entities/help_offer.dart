// features/help_network/domain/entities/help_offer.dart
/// Entity für Hilfe-Angebote im Hilfe-Netzwerk
class HelpOffer {
  final String id;
  final String helpRequestId;
  final String helperId;
  final String helperName;
  final String message;
  final DateTime createdAt;
  final String status; // 'pending', 'accepted', 'rejected', 'completed'
  final double? rating;
  final String? review;
  final Map<String, dynamic>? metadata;

  const HelpOffer({
    required this.id,
    required this.helpRequestId,
    required this.helperId,
    required this.helperName,
    required this.message,
    required this.createdAt,
    required this.status,
    this.rating,
    this.review,
    this.metadata,
  });

  /// Erstellt ein neues Hilfe-Angebot
  factory HelpOffer.create({
    required String helpRequestId,
    required String helperId,
    required String helperName,
    required String message,
  }) {
    return HelpOffer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      helpRequestId: helpRequestId,
      helperId: helperId,
      helperName: helperName,
      message: message,
      createdAt: DateTime.now(),
      status: 'pending',
    );
  }

  /// Kopiert mit Änderungen
  HelpOffer copyWith({
    String? id,
    String? helpRequestId,
    String? helperId,
    String? helperName,
    String? message,
    DateTime? createdAt,
    String? status,
    double? rating,
    String? review,
    Map<String, dynamic>? metadata,
  }) {
    return HelpOffer(
      id: id ?? this.id,
      helpRequestId: helpRequestId ?? this.helpRequestId,
      helperId: helperId ?? this.helperId,
      helperName: helperName ?? this.helperName,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Konvertiert zu Map für Persistierung
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'helpRequestId': helpRequestId,
      'helperId': helperId,
      'helperName': helperName,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'rating': rating,
      'review': review,
      'metadata': metadata,
    };
  }

  /// Erstellt aus Map
  factory HelpOffer.fromMap(Map<String, dynamic> map) {
    return HelpOffer(
      id: map['id'],
      helpRequestId: map['helpRequestId'],
      helperId: map['helperId'],
      helperName: map['helperName'],
      message: map['message'],
      createdAt: DateTime.parse(map['createdAt']),
      status: map['status'],
      rating: map['rating'],
      review: map['review'],
      metadata: map['metadata'],
    );
  }

  /// Prüft ob das Angebot noch ausstehend ist
  bool get isPending => status == 'pending';

  /// Prüft ob das Angebot angenommen wurde
  bool get isAccepted => status == 'accepted';

  /// Prüft ob das Angebot abgelehnt wurde
  bool get isRejected => status == 'rejected';

  /// Prüft ob das Angebot abgeschlossen ist
  bool get isCompleted => status == 'completed';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HelpOffer && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'HelpOffer(id: $id, helperName: $helperName, status: $status)';
  }
} 