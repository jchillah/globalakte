// features/appointment/domain/repositories/appointment_repository.dart
import '../entities/appointment.dart';

/// Repository-Interface für Terminverwaltung
abstract class AppointmentRepository {
  /// Erstellt einen neuen Termin
  Future<Appointment> createAppointment(Appointment appointment);

  /// Aktualisiert einen bestehenden Termin
  Future<Appointment> updateAppointment(Appointment appointment);

  /// Löscht einen Termin
  Future<void> deleteAppointment(String appointmentId);

  /// Holt einen Termin anhand der ID
  Future<Appointment?> getAppointmentById(String appointmentId);

  /// Holt alle Termine für einen Zeitraum
  Future<List<Appointment>> getAppointmentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Holt alle Termine für einen bestimmten Tag
  Future<List<Appointment>> getAppointmentsByDate(DateTime date);

  /// Holt alle Termine für eine Fallakte
  Future<List<Appointment>> getAppointmentsByCaseId(String caseId);

  /// Holt alle Termine nach Typ
  Future<List<Appointment>> getAppointmentsByType(String type);

  /// Holt alle Termine nach Status
  Future<List<Appointment>> getAppointmentsByStatus(String status);

  /// Holt alle anstehenden Termine (heute und in der Zukunft)
  Future<List<Appointment>> getUpcomingAppointments();

  /// Holt alle überfälligen Termine
  Future<List<Appointment>> getOverdueAppointments();

  /// Holt alle Termine mit Erinnerungen
  Future<List<Appointment>> getAppointmentsWithReminders();

  /// Synchronisiert Termine mit externem Kalender
  Future<void> syncWithExternalCalendar();

  /// Exportiert Termine
  Future<String> exportAppointments(List<Appointment> appointments);

  /// Importiert Termine
  Future<List<Appointment>> importAppointments(String data);

  /// Setzt Erinnerung für einen Termin
  Future<void> setReminder(String appointmentId, DateTime reminderTime);

  /// Entfernt Erinnerung für einen Termin
  Future<void> removeReminder(String appointmentId);

  /// Markiert Termin als abgeschlossen
  Future<void> markAsCompleted(String appointmentId);

  /// Markiert Termin als abgesagt
  Future<void> markAsCancelled(String appointmentId);

  /// Verschiebt Termin
  Future<Appointment> rescheduleAppointment(
    String appointmentId,
    DateTime newStartTime,
    DateTime newEndTime,
  );
} 