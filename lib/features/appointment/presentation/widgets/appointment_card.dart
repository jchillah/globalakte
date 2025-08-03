// features/appointment/presentation/widgets/appointment_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/appointment.dart';

/// Widget für die Anzeige eines Termins in der Liste
class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMarkCompleted;
  final VoidCallback onMarkCancelled;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkCompleted,
    required this.onMarkCancelled,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = appointment.startTime.isBefore(DateTime.now()) &&
        appointment.status == AppointmentStatus.scheduled;
    final isToday = _isToday(appointment.startTime);

    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _getStatusColor(appointment.status),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getTypeIcon(appointment.type),
                              color: _getTypeColor(appointment.type),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                appointment.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isOverdue ? Colors.red : null,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appointment.description,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(appointment.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${DateFormat('dd.MM.yyyy HH:mm').format(appointment.startTime)} - '
                    '${DateFormat('HH:mm').format(appointment.endTime)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  if (isToday) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'HEUTE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                  if (isOverdue) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'ÜBERFÄLLIG',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (appointment.location.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        appointment.location,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (appointment.reminderTime != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.notifications,
                        size: 16, color: Colors.orange[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Erinnerung: ${DateFormat('dd.MM.yyyy HH:mm').format(appointment.reminderTime!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.orange[600],
                          ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (appointment.status == AppointmentStatus.scheduled) ...[
                    TextButton.icon(
                      onPressed: onMarkCompleted,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Abgeschlossen'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green[700],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: onMarkCancelled,
                      icon: const Icon(Icons.cancel, size: 16),
                      label: const Text('Absagen'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red[700],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 18),
                    tooltip: 'Bearbeiten',
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 18),
                    tooltip: 'Löschen',
                    color: Colors.red[600],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(status)),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Colors.blue;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.inProgress:
        return Colors.orange;
      case AppointmentStatus.completed:
        return Colors.grey;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.postponed:
        return Colors.purple;
    }
  }

  IconData _getTypeIcon(AppointmentType type) {
    switch (type) {
      case AppointmentType.general:
        return Icons.event;
      case AppointmentType.court:
        return Icons.gavel;
      case AppointmentType.lawyer:
        return Icons.person;
      case AppointmentType.police:
        return Icons.local_police;
      case AppointmentType.medical:
        return Icons.medical_services;
      case AppointmentType.deadline:
        return Icons.schedule;
      case AppointmentType.reminder:
        return Icons.notifications;
    }
  }

  Color _getTypeColor(AppointmentType type) {
    switch (type) {
      case AppointmentType.general:
        return Colors.blue;
      case AppointmentType.court:
        return Colors.red;
      case AppointmentType.lawyer:
        return Colors.green;
      case AppointmentType.police:
        return Colors.orange;
      case AppointmentType.medical:
        return Colors.purple;
      case AppointmentType.deadline:
        return Colors.red;
      case AppointmentType.reminder:
        return Colors.orange;
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
