// features/appointment/data/repositories/appointment_repository_impl.dart
import 'dart:convert';
import 'dart:math';

import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';

/// Repository-Implementation für Terminverwaltung
class AppointmentRepositoryImpl implements AppointmentRepository {
  // Mock-Daten für Demo-Zwecke
  final List<Appointment> _appointments = [];
  final Random _random = Random();

  AppointmentRepositoryImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Demo-Termine erstellen
    _appointments.addAll([
      Appointment(
        id: '1',
        title: 'Gerichtstermin - Mietstreit',
        description: 'Verhandlung vor dem Amtsgericht Berlin-Mitte',
        startTime: today.add(const Duration(days: 2, hours: 10)),
        endTime: today.add(const Duration(days: 2, hours: 12)),
        location: 'Amtsgericht Berlin-Mitte, Littenstraße 12-17, 10179 Berlin',
        type: AppointmentType.court,
        status: AppointmentStatus.scheduled,
        reminderTime: today.add(const Duration(days: 1, hours: 9)),
        caseId: 'case_001',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Appointment(
        id: '2',
        title: 'Anwaltstermin - Vertragsprüfung',
        description: 'Besprechung des Arbeitsvertrags mit Rechtsanwalt Müller',
        startTime: today.add(const Duration(days: 1, hours: 14)),
        endTime: today.add(const Duration(days: 1, hours: 15)),
        location: 'Kanzlei Müller & Partner, Friedrichstraße 123, 10117 Berlin',
        type: AppointmentType.lawyer,
        status: AppointmentStatus.confirmed,
        reminderTime: today.add(const Duration(hours: 23)),
        caseId: 'case_002',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      Appointment(
        id: '3',
        title: 'Frist: Einspruch einlegen',
        description: 'Letzter Tag für Einspruch gegen Bußgeldbescheid',
        startTime: today.add(const Duration(days: 5)),
        endTime: today.add(const Duration(days: 5, hours: 1)),
        location: 'Online über Justizportal',
        type: AppointmentType.deadline,
        status: AppointmentStatus.scheduled,
        reminderTime: today.add(const Duration(days: 4, hours: 9)),
        caseId: 'case_003',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Appointment(
        id: '4',
        title: 'Polizeitermin - Zeugenaussage',
        description: 'Aussage als Zeuge im Verkehrsunfall',
        startTime: today.add(const Duration(days: 3, hours: 16)),
        endTime: today.add(const Duration(days: 3, hours: 17)),
        location: 'Polizeidirektion 1, Alexanderplatz 1, 10178 Berlin',
        type: AppointmentType.police,
        status: AppointmentStatus.scheduled,
        reminderTime: today.add(const Duration(days: 2, hours: 9)),
        caseId: 'case_004',
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Appointment(
        id: '5',
        title: 'Ärztlicher Termin - Gutachten',
        description: 'Medizinisches Gutachten für Versicherung',
        startTime: today.add(const Duration(days: 4, hours: 11)),
        endTime: today.add(const Duration(days: 4, hours: 12)),
        location: 'Praxis Dr. Schmidt, Kurfürstendamm 123, 10719 Berlin',
        type: AppointmentType.medical,
        status: AppointmentStatus.confirmed,
        reminderTime: today.add(const Duration(days: 3, hours: 9)),
        caseId: 'case_005',
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
    ]);
  }

  @override
  Future<Appointment> createAppointment(Appointment appointment) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));

    final newAppointment = appointment.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _appointments.add(newAppointment);
    print('Termin erstellt: ${newAppointment.title}');
    return newAppointment;
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));

    final index = _appointments.indexWhere((a) => a.id == appointment.id);
    if (index == -1) {
      throw Exception('Termin nicht gefunden');
    }

    final updatedAppointment = appointment.copyWith(
      updatedAt: DateTime.now(),
    );

    _appointments[index] = updatedAppointment;
    print('Termin aktualisiert: ${updatedAppointment.title}');
    return updatedAppointment;
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(200)));

    _appointments.removeWhere((a) => a.id == appointmentId);
    print('Termin gelöscht: $appointmentId');
  }

  @override
  Future<Appointment?> getAppointmentById(String appointmentId) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 100 + _random.nextInt(150)));

    try {
      return _appointments.firstWhere((a) => a.id == appointmentId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Appointment>> getAppointmentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));

    return _appointments.where((appointment) {
      final appointmentDate = DateTime(
        appointment.startTime.year,
        appointment.startTime.month,
        appointment.startTime.day,
      );
      return appointmentDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          appointmentDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByDate(DateTime date) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(200)));

    return _appointments.where((appointment) {
      final appointmentDate = DateTime(
        appointment.startTime.year,
        appointment.startTime.month,
        appointment.startTime.day,
      );
      final targetDate = DateTime(date.year, date.month, date.day);
      return appointmentDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByCaseId(String caseId) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(200)));

    return _appointments.where((a) => a.caseId == caseId).toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByType(String type) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(200)));

    return _appointments.where((a) => a.type.name == type).toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByStatus(String status) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(200)));

    return _appointments.where((a) => a.status.name == status).toList();
  }

  @override
  Future<List<Appointment>> getUpcomingAppointments() async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));

    final now = DateTime.now();
    return _appointments
        .where((a) => a.startTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  @override
  Future<List<Appointment>> getOverdueAppointments() async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(200)));

    final now = DateTime.now();
    return _appointments
        .where((a) => a.startTime.isBefore(now) && a.status == AppointmentStatus.scheduled)
        .toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsWithReminders() async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(200)));

    return _appointments.where((a) => a.reminderTime != null).toList();
  }

  @override
  Future<void> syncWithExternalCalendar() async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(2000)));

    print('Termine mit externem Kalender synchronisiert');
  }

  @override
  Future<String> exportAppointments(List<Appointment> appointments) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));

    final exportData = {
      'exportDate': DateTime.now().toIso8601String(),
      'appointments': appointments.map((a) => a.toJson()).toList(),
    };

    print('Termine exportiert: ${appointments.length} Termine');
    return jsonEncode(exportData);
  }

  @override
  Future<List<Appointment>> importAppointments(String data) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1500)));

    try {
      final jsonData = jsonDecode(data) as Map<String, dynamic>;
      final appointmentsJson = jsonData['appointments'] as List;
      
      final importedAppointments = appointmentsJson
          .map((json) => Appointment.fromJson(json as Map<String, dynamic>))
          .toList();

      _appointments.addAll(importedAppointments);
      print('Termine importiert: ${importedAppointments.length} Termine');
      return importedAppointments;
    } catch (e) {
      throw Exception('Fehler beim Importieren der Termine: $e');
    }
  }

  @override
  Future<void> setReminder(String appointmentId, DateTime reminderTime) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));

    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index == -1) {
      throw Exception('Termin nicht gefunden');
    }

    final appointment = _appointments[index];
    final updatedAppointment = appointment.copyWith(
      reminderTime: reminderTime,
      updatedAt: DateTime.now(),
    );

    _appointments[index] = updatedAppointment;
    print('Erinnerung gesetzt für Termin: ${appointment.title}');
  }

  @override
  Future<void> removeReminder(String appointmentId) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(200)));

    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index == -1) {
      throw Exception('Termin nicht gefunden');
    }

    final appointment = _appointments[index];
    final updatedAppointment = appointment.copyWith(
      reminderTime: null,
      updatedAt: DateTime.now(),
    );

    _appointments[index] = updatedAppointment;
    print('Erinnerung entfernt für Termin: ${appointment.title}');
  }

  @override
  Future<void> markAsCompleted(String appointmentId) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));

    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index == -1) {
      throw Exception('Termin nicht gefunden');
    }

    final appointment = _appointments[index];
    final updatedAppointment = appointment.copyWith(
      status: AppointmentStatus.completed,
      updatedAt: DateTime.now(),
    );

    _appointments[index] = updatedAppointment;
    print('Termin als abgeschlossen markiert: ${appointment.title}');
  }

  @override
  Future<void> markAsCancelled(String appointmentId) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));

    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index == -1) {
      throw Exception('Termin nicht gefunden');
    }

    final appointment = _appointments[index];
    final updatedAppointment = appointment.copyWith(
      status: AppointmentStatus.cancelled,
      updatedAt: DateTime.now(),
    );

    _appointments[index] = updatedAppointment;
    print('Termin als abgesagt markiert: ${appointment.title}');
  }

  @override
  Future<Appointment> rescheduleAppointment(
    String appointmentId,
    DateTime newStartTime,
    DateTime newEndTime,
  ) async {
    // Simuliere Netzwerk-Verzögerung
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(500)));

    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index == -1) {
      throw Exception('Termin nicht gefunden');
    }

    final appointment = _appointments[index];
    final updatedAppointment = appointment.copyWith(
      startTime: newStartTime,
      endTime: newEndTime,
      updatedAt: DateTime.now(),
    );

    _appointments[index] = updatedAppointment;
    print('Termin verschoben: ${appointment.title}');
    return updatedAppointment;
  }
} 