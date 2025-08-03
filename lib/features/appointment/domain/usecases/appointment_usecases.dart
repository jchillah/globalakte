// features/appointment/domain/usecases/appointment_usecases.dart
import '../entities/appointment.dart';
import '../repositories/appointment_repository.dart';

/// Use Case: Termin erstellen
class CreateAppointmentUseCase {
  final AppointmentRepository _repository;

  CreateAppointmentUseCase(this._repository);

  Future<Appointment> call(Appointment appointment) async {
    // Validierung
    if (appointment.title.trim().isEmpty) {
      throw ArgumentError('Titel ist erforderlich');
    }
    if (appointment.startTime.isAfter(appointment.endTime)) {
      throw ArgumentError('Startzeit muss vor Endzeit liegen');
    }
    if (appointment.startTime.isBefore(DateTime.now())) {
      throw ArgumentError('Startzeit kann nicht in der Vergangenheit liegen');
    }

    return await _repository.createAppointment(appointment);
  }
}

/// Use Case: Termin aktualisieren
class UpdateAppointmentUseCase {
  final AppointmentRepository _repository;

  UpdateAppointmentUseCase(this._repository);

  Future<Appointment> call(Appointment appointment) async {
    // Validierung
    if (appointment.title.trim().isEmpty) {
      throw ArgumentError('Titel ist erforderlich');
    }
    if (appointment.startTime.isAfter(appointment.endTime)) {
      throw ArgumentError('Startzeit muss vor Endzeit liegen');
    }

    return await _repository.updateAppointment(appointment);
  }
}

/// Use Case: Termin löschen
class DeleteAppointmentUseCase {
  final AppointmentRepository _repository;

  DeleteAppointmentUseCase(this._repository);

  Future<void> call(String appointmentId) async {
    await _repository.deleteAppointment(appointmentId);
  }
}

/// Use Case: Termine für Zeitraum abrufen
class GetAppointmentsByDateRangeUseCase {
  final AppointmentRepository _repository;

  GetAppointmentsByDateRangeUseCase(this._repository);

  Future<List<Appointment>> call(DateTime startDate, DateTime endDate) async {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Startdatum muss vor Enddatum liegen');
    }

    return await _repository.getAppointmentsByDateRange(startDate, endDate);
  }
}

/// Use Case: Termine für Tag abrufen
class GetAppointmentsByDateUseCase {
  final AppointmentRepository _repository;

  GetAppointmentsByDateUseCase(this._repository);

  Future<List<Appointment>> call(DateTime date) async {
    return await _repository.getAppointmentsByDate(date);
  }
}

/// Use Case: Anstehende Termine abrufen
class GetUpcomingAppointmentsUseCase {
  final AppointmentRepository _repository;

  GetUpcomingAppointmentsUseCase(this._repository);

  Future<List<Appointment>> call() async {
    return await _repository.getUpcomingAppointments();
  }
}

/// Use Case: Überfällige Termine abrufen
class GetOverdueAppointmentsUseCase {
  final AppointmentRepository _repository;

  GetOverdueAppointmentsUseCase(this._repository);

  Future<List<Appointment>> call() async {
    return await _repository.getOverdueAppointments();
  }
}

/// Use Case: Termin verschieben
class RescheduleAppointmentUseCase {
  final AppointmentRepository _repository;

  RescheduleAppointmentUseCase(this._repository);

  Future<Appointment> call(
    String appointmentId,
    DateTime newStartTime,
    DateTime newEndTime,
  ) async {
    // Validierung
    if (newStartTime.isAfter(newEndTime)) {
      throw ArgumentError('Neue Startzeit muss vor neuer Endzeit liegen');
    }
    if (newStartTime.isBefore(DateTime.now())) {
      throw ArgumentError('Neue Startzeit kann nicht in der Vergangenheit liegen');
    }

    return await _repository.rescheduleAppointment(
      appointmentId,
      newStartTime,
      newEndTime,
    );
  }
}

/// Use Case: Erinnerung setzen
class SetReminderUseCase {
  final AppointmentRepository _repository;

  SetReminderUseCase(this._repository);

  Future<void> call(String appointmentId, DateTime reminderTime) async {
    // Validierung
    if (reminderTime.isBefore(DateTime.now())) {
      throw ArgumentError('Erinnerungszeit kann nicht in der Vergangenheit liegen');
    }

    await _repository.setReminder(appointmentId, reminderTime);
  }
}

/// Use Case: Termin als abgeschlossen markieren
class MarkAsCompletedUseCase {
  final AppointmentRepository _repository;

  MarkAsCompletedUseCase(this._repository);

  Future<void> call(String appointmentId) async {
    await _repository.markAsCompleted(appointmentId);
  }
}

/// Use Case: Termin als abgesagt markieren
class MarkAsCancelledUseCase {
  final AppointmentRepository _repository;

  MarkAsCancelledUseCase(this._repository);

  Future<void> call(String appointmentId) async {
    await _repository.markAsCancelled(appointmentId);
  }
}

/// Use Case: Termine exportieren
class ExportAppointmentsUseCase {
  final AppointmentRepository _repository;

  ExportAppointmentsUseCase(this._repository);

  Future<String> call(List<Appointment> appointments) async {
    if (appointments.isEmpty) {
      throw ArgumentError('Keine Termine zum Exportieren vorhanden');
    }

    return await _repository.exportAppointments(appointments);
  }
}

/// Use Case: Termine importieren
class ImportAppointmentsUseCase {
  final AppointmentRepository _repository;

  ImportAppointmentsUseCase(this._repository);

  Future<List<Appointment>> call(String data) async {
    if (data.trim().isEmpty) {
      throw ArgumentError('Keine Daten zum Importieren vorhanden');
    }

    return await _repository.importAppointments(data);
  }
}

/// Use Case: Termine mit externem Kalender synchronisieren
class SyncWithExternalCalendarUseCase {
  final AppointmentRepository _repository;

  SyncWithExternalCalendarUseCase(this._repository);

  Future<void> call() async {
    await _repository.syncWithExternalCalendar();
  }
} 