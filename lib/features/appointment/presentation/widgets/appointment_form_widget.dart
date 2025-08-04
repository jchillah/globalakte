// features/appointment/presentation/widgets/appointment_form_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../domain/entities/appointment.dart';

/// Widget für das Erstellen und Bearbeiten von Terminen
class AppointmentFormWidget extends StatefulWidget {
  final Appointment? appointment;
  final Function(Appointment) onSave;
  final VoidCallback onCancel;
  final bool isLoading;

  const AppointmentFormWidget({
    super.key,
    this.appointment,
    required this.onSave,
    required this.onCancel,
    required this.isLoading,
  });

  @override
  State<AppointmentFormWidget> createState() => _AppointmentFormWidgetState();
}

class _AppointmentFormWidgetState extends State<AppointmentFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime _startTime = DateTime.now().add(const Duration(hours: 1));
  DateTime _endTime = DateTime.now().add(const Duration(hours: 2));
  AppointmentType _selectedType = AppointmentType.general;
  AppointmentStatus _selectedStatus = AppointmentStatus.scheduled;
  DateTime? _reminderTime;
  bool _hasReminder = false;

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      _loadAppointmentData();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _loadAppointmentData() {
    final appointment = widget.appointment!;
    _titleController.text = appointment.title;
    _descriptionController.text = appointment.description;
    _locationController.text = appointment.location;
    _startTime = appointment.startTime;
    _endTime = appointment.endTime;
    _selectedType = appointment.type;
    _selectedStatus = appointment.status;
    _reminderTime = appointment.reminderTime;
    _hasReminder = appointment.reminderTime != null;
  }

  Future<void> _selectDateTime(bool isStartTime) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartTime ? _startTime : _endTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStartTime ? _startTime : _endTime),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          if (isStartTime) {
            _startTime = newDateTime;
            // Automatisch Endzeit anpassen, wenn Startzeit nach Endzeit liegt
            if (_startTime.isAfter(_endTime)) {
              _endTime = _startTime.add(const Duration(hours: 1));
            }
          } else {
            _endTime = newDateTime;
          }
        });
      }
    }
  }

  Future<void> _selectReminderTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderTime ?? _startTime.subtract(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: _startTime,
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reminderTime ?? DateTime.now()),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _reminderTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveAppointment() {
    if (!_formKey.currentState!.validate()) return;

    final appointment = Appointment(
      id: widget.appointment?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: _startTime,
      endTime: _endTime,
      location: _locationController.text.trim(),
      type: _selectedType,
      status: _selectedStatus,
      reminderTime: _hasReminder ? _reminderTime : null,
      caseId: widget.appointment?.caseId,
      createdAt: widget.appointment?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSave(appointment);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.appointment == null ? 'Neuen Termin erstellen' : 'Termin bearbeiten',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Titel
            GlobalTextField(
              controller: _titleController,
              label: 'Titel *',
              hint: 'z.B. Gerichtstermin - Mietstreit',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Titel ist erforderlich';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Beschreibung
            GlobalTextField(
              controller: _descriptionController,
              label: 'Beschreibung',
              hint: 'Details zum Termin...',
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Ort
            GlobalTextField(
              controller: _locationController,
              label: 'Ort',
              hint: 'z.B. Amtsgericht Berlin-Mitte',
            ),
            const SizedBox(height: 16),

            // Startzeit
            _buildDateTimeField(
              label: 'Startzeit *',
              value: DateFormat('dd.MM.yyyy HH:mm').format(_startTime),
              onTap: () => _selectDateTime(true),
            ),
            const SizedBox(height: 16),

            // Endzeit
            _buildDateTimeField(
              label: 'Endzeit *',
              value: DateFormat('dd.MM.yyyy HH:mm').format(_endTime),
              onTap: () => _selectDateTime(false),
            ),
            const SizedBox(height: 16),

            // Typ
            _buildDropdownField<AppointmentType>(
              label: 'Typ',
              value: _selectedType,
              items: AppointmentType.values,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
              itemBuilder: (type) => type.displayName,
            ),
            const SizedBox(height: 16),

            // Status
            _buildDropdownField<AppointmentStatus>(
              label: 'Status',
              value: _selectedStatus,
              items: AppointmentStatus.values,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
              itemBuilder: (status) => status.displayName,
            ),
            const SizedBox(height: 16),

            // Erinnerung
            Row(
              children: [
                Checkbox(
                  value: _hasReminder,
                  onChanged: (value) {
                    setState(() {
                      _hasReminder = value ?? false;
                      if (!_hasReminder) {
                        _reminderTime = null;
                      }
                    });
                  },
                ),
                const Text('Erinnerung setzen'),
              ],
            ),
            if (_hasReminder) ...[
              const SizedBox(height: 16),
              _buildDateTimeField(
                label: 'Erinnerungszeit',
                value: _reminderTime != null
                    ? DateFormat('dd.MM.yyyy HH:mm').format(_reminderTime!)
                    : 'Erinnerungszeit wählen',
                onTap: _selectReminderTime,
              ),
            ],
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: GlobalButton(
                    onPressed: widget.onCancel,
                    text: 'Abbrechen',
                    isLoading: false,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlobalButton(
                    onPressed: _saveAppointment,
                    text: widget.appointment == null ? 'Erstellen' : 'Aktualisieren',
                    isLoading: widget.isLoading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(value),
                const Spacer(),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemBuilder(item)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
} 