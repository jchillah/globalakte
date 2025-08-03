// features/appointment/presentation/screens/appointment_demo_screen.dart
import 'package:flutter/material.dart';

import '../../../../shared/utils/snackbar_utils.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../domain/usecases/appointment_usecases.dart';
import '../widgets/appointment_card.dart';
import '../widgets/appointment_form_widget.dart';
import '../widgets/calendar_widget.dart';

/// Demo-Screen für Terminverwaltung und Kalender-System
class AppointmentDemoScreen extends StatefulWidget {
  const AppointmentDemoScreen({super.key});

  @override
  State<AppointmentDemoScreen> createState() => _AppointmentDemoScreenState();
}

class _AppointmentDemoScreenState extends State<AppointmentDemoScreen>
    with TickerProviderStateMixin {
  final AppointmentRepository _appointmentRepository =
      AppointmentRepositoryImpl();
  late final CreateAppointmentUseCase _createAppointmentUseCase;
  late final UpdateAppointmentUseCase _updateAppointmentUseCase;
  late final DeleteAppointmentUseCase _deleteAppointmentUseCase;
  late final GetAppointmentsByDateUseCase _getAppointmentsByDateUseCase;
  late final GetUpcomingAppointmentsUseCase _getUpcomingAppointmentsUseCase;
  late final MarkAsCompletedUseCase _markAsCompletedUseCase;
  late final MarkAsCancelledUseCase _markAsCancelledUseCase;

  List<Appointment> _appointments = [];
  List<Appointment> _selectedDateAppointments = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _showCalendar = true;
  bool _showForm = false;
  Appointment? _editingAppointment;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _createAppointmentUseCase =
        CreateAppointmentUseCase(_appointmentRepository);
    _updateAppointmentUseCase =
        UpdateAppointmentUseCase(_appointmentRepository);
    _deleteAppointmentUseCase =
        DeleteAppointmentUseCase(_appointmentRepository);
    _getAppointmentsByDateUseCase =
        GetAppointmentsByDateUseCase(_appointmentRepository);
    _getUpcomingAppointmentsUseCase =
        GetUpcomingAppointmentsUseCase(_appointmentRepository);
    _markAsCompletedUseCase = MarkAsCompletedUseCase(_appointmentRepository);
    _markAsCancelledUseCase = MarkAsCancelledUseCase(_appointmentRepository);

    _loadAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);

    try {
      final upcomingAppointments = await _getUpcomingAppointmentsUseCase();
      final selectedDateAppointments =
          await _getAppointmentsByDateUseCase(_selectedDate);

      if (!mounted) return;

      setState(() {
        _appointments = upcomingAppointments;
        _selectedDateAppointments = selectedDateAppointments;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Laden der Termine: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onDateSelected(DateTime date) async {
    setState(() => _isLoading = true);

    try {
      final appointments = await _getAppointmentsByDateUseCase(date);

      if (!mounted) return;

      setState(() {
        _selectedDate = date;
        _selectedDateAppointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Laden der Termine: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createAppointment(Appointment appointment) async {
    setState(() => _isLoading = true);

    try {
      await _createAppointmentUseCase(appointment);
      await _loadAppointments();

      if (!mounted) return;
      SnackBarUtils.showSuccessSnackBar(context, 'Termin erfolgreich erstellt');
      setState(() => _showForm = false);
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Erstellen des Termins: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateAppointment(Appointment appointment) async {
    setState(() => _isLoading = true);

    try {
      await _updateAppointmentUseCase(appointment);
      await _loadAppointments();

      if (!mounted) return;
      SnackBarUtils.showSuccessSnackBar(
          context, 'Termin erfolgreich aktualisiert');
      setState(() {
        _showForm = false;
        _editingAppointment = null;
      });
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Aktualisieren des Termins: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAppointment(String appointmentId) async {
    setState(() => _isLoading = true);

    try {
      await _deleteAppointmentUseCase(appointmentId);
      await _loadAppointments();

      if (!mounted) return;
      SnackBarUtils.showSuccessSnackBar(context, 'Termin erfolgreich gelöscht');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Löschen des Termins: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsCompleted(String appointmentId) async {
    setState(() => _isLoading = true);

    try {
      await _markAsCompletedUseCase(appointmentId);
      await _loadAppointments();

      if (!mounted) return;
      SnackBarUtils.showSuccessSnackBar(
          context, 'Termin als abgeschlossen markiert');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Markieren des Termins: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsCancelled(String appointmentId) async {
    setState(() => _isLoading = true);

    try {
      await _markAsCancelledUseCase(appointmentId);
      await _loadAppointments();

      if (!mounted) return;
      SnackBarUtils.showSuccessSnackBar(
          context, 'Termin als abgesagt markiert');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Markieren des Termins: $e');
      setState(() => _isLoading = false);
    }
  }

  void _editAppointment(Appointment appointment) {
    setState(() {
      _editingAppointment = appointment;
      _showForm = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terminverwaltung & Kalender'),
        actions: [
          IconButton(
            icon: Icon(_showCalendar ? Icons.list : Icons.calendar_month),
            onPressed: () {
              setState(() => _showCalendar = !_showCalendar);
            },
            tooltip: _showCalendar ? 'Listenansicht' : 'Kalenderansicht',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Übersicht'),
            Tab(text: 'Anstehend'),
            Tab(text: 'Vergangen'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildUpcomingTab(),
          _buildPastTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showForm = true;
            _editingAppointment = null;
          });
        },
        tooltip: 'Neuen Termin erstellen',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOverviewTab() {
    if (_showForm) {
      return AppointmentFormWidget(
        appointment: _editingAppointment,
        onSave: _editingAppointment == null
            ? _createAppointment
            : _updateAppointment,
        onCancel: () {
          setState(() {
            _showForm = false;
            _editingAppointment = null;
          });
        },
        isLoading: _isLoading,
      );
    }

    return Column(
      children: [
        if (_showCalendar) ...[
          CalendarWidget(
            selectedDate: _selectedDate,
            appointments: _appointments,
            onDateSelected: _onDateSelected,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildAppointmentList(_selectedDateAppointments),
          ),
        ] else ...[
          Expanded(
            child: _buildAppointmentList(_appointments),
          ),
        ],
      ],
    );
  }

  Widget _buildUpcomingTab() {
    final upcomingAppointments = _appointments
        .where((a) => a.startTime.isAfter(DateTime.now()))
        .toList();

    return _buildAppointmentList(upcomingAppointments);
  }

  Widget _buildPastTab() {
    final pastAppointments = _appointments
        .where((a) => a.startTime.isBefore(DateTime.now()))
        .toList();

    return _buildAppointmentList(pastAppointments);
  }

  Widget _buildAppointmentList(List<Appointment> appointments) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Termine vorhanden',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Erstellen Sie einen neuen Termin mit dem + Button',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppointmentCard(
            appointment: appointment,
            onEdit: () => _editAppointment(appointment),
            onDelete: () => _deleteAppointment(appointment.id),
            onMarkCompleted: () => _markAsCompleted(appointment.id),
            onMarkCancelled: () => _markAsCancelled(appointment.id),
          ),
        );
      },
    );
  }
}
