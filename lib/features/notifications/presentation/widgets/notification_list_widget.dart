// features/notifications/presentation/widgets/notification_list_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/app_config.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/usecases/notification_usecases.dart';

/// Widget für die Anzeige der Benachrichtigungsliste
class NotificationListWidget extends StatefulWidget {
  final NotificationUseCases useCases;

  const NotificationListWidget({
    super.key,
    required this.useCases,
  });

  @override
  State<NotificationListWidget> createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;
  String _filterType = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notifications = await widget.useCases.getAllNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden: $e')),
        );
      }
    }
  }

  Future<void> _markAsRead(String id) async {
    try {
      await widget.useCases.markNotificationAsRead(id);
      await _loadNotifications();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Markieren: $e')),
        );
      }
    }
  }

  Future<void> _deleteNotification(String id) async {
    try {
      await widget.useCases.deleteNotification(id);
      await _loadNotifications();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Benachrichtigung gelöscht')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Löschen: $e')),
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await widget.useCases.markAllNotificationsAsRead();
      await _loadNotifications();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alle als gelesen markiert')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    }
  }

  Future<void> _clearAllNotifications() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alle Benachrichtigungen löschen'),
        content: const Text(
            'Sind Sie sicher, dass Sie alle Benachrichtigungen löschen möchten?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await widget.useCases.clearAllNotifications();
        await _loadNotifications();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alle Benachrichtigungen gelöscht')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fehler beim Löschen: $e')),
          );
        }
      }
    }
  }

  List<NotificationItem> _getFilteredNotifications() {
    var filtered = _notifications;

    // Filter nach Typ
    if (_filterType != 'all') {
      filtered = filtered.where((n) => n.type == _filterType).toList();
    }

    // Filter nach Suchanfrage
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((n) {
        return n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            n.message.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Sortiere nach Datum (neueste zuerst)
    filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return filtered;
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'success':
        return Colors.green;
      case 'info':
      default:
        return Colors.blue;
    }
  }

  Icon _getTypeIcon(String type) {
    switch (type) {
      case 'error':
        return const Icon(Icons.error, color: Colors.red);
      case 'warning':
        return const Icon(Icons.warning, color: Colors.orange);
      case 'success':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'info':
      default:
        return const Icon(Icons.info, color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _getFilteredNotifications();

    return Padding(
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      child: Column(
        children: [
          // Filter und Suche
          _buildFilterSection(),
          const SizedBox(height: 16),

          // Aktions-Buttons
          _buildActionButtons(),
          const SizedBox(height: 16),

          // Benachrichtigungsliste
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredNotifications.isEmpty
                    ? _buildEmptyState()
                    : _buildNotificationList(filteredNotifications),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      children: [
        // Suchfeld
        TextField(
          decoration: const InputDecoration(
            hintText: 'Benachrichtigungen durchsuchen...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        const SizedBox(height: 12),

        // Filter-Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: const Text('Alle'),
                selected: _filterType == 'all',
                onSelected: (selected) {
                  setState(() {
                    _filterType = 'all';
                  });
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Info'),
                selected: _filterType == 'info',
                onSelected: (selected) {
                  setState(() {
                    _filterType = 'info';
                  });
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Warnung'),
                selected: _filterType == 'warning',
                onSelected: (selected) {
                  setState(() {
                    _filterType = 'warning';
                  });
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Fehler'),
                selected: _filterType == 'error',
                onSelected: (selected) {
                  setState(() {
                    _filterType = 'error';
                  });
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Erfolg'),
                selected: _filterType == 'success',
                onSelected: (selected) {
                  setState(() {
                    _filterType = 'success';
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _markAllAsRead,
            icon: const Icon(Icons.mark_email_read),
            label: const Text('Alle als gelesen'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConfig.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _clearAllNotifications,
            icon: const Icon(Icons.delete_sweep),
            label: const Text('Alle löschen'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Keine Benachrichtigungen',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hier werden Ihre Benachrichtigungen angezeigt',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              _getTypeColor(notification.type).withValues(alpha: 0.1),
          child: _getTypeIcon(notification.type),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 12,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(notification.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (notification.category != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      notification.category!,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'read':
                _markAsRead(notification.id);
                break;
              case 'delete':
                _deleteNotification(notification.id);
                break;
            }
          },
          itemBuilder: (context) => [
            if (!notification.isRead)
              const PopupMenuItem(
                value: 'read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read),
                    SizedBox(width: 8),
                    Text('Als gelesen markieren'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Löschen', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          if (!notification.isRead) {
            _markAsRead(notification.id);
          }
        },
      ),
    );
  }
}
