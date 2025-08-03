// features/help_network/presentation/widgets/help_request_list_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../domain/entities/help_request.dart';
import '../../domain/usecases/help_network_usecases.dart';

/// Widget für die Anzeige von Hilfe-Anfragen
class HelpRequestListWidget extends StatefulWidget {
  final HelpNetworkUseCases useCases;

  const HelpRequestListWidget({
    super.key,
    required this.useCases,
  });

  @override
  State<HelpRequestListWidget> createState() => _HelpRequestListWidgetState();
}

class _HelpRequestListWidgetState extends State<HelpRequestListWidget> {
  List<HelpRequest> _helpRequests = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadHelpRequests();
  }

  Future<void> _loadHelpRequests() async {
    setState(() => _isLoading = true);
    try {
      final requests = await widget.useCases.getAllHelpRequests();
      setState(() {
        _helpRequests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden der Anfragen: $e')),
        );
      }
    }
  }

  Future<void> _searchRequests(String query) async {
    setState(() => _isLoading = true);
    try {
      final requests = await widget.useCases.searchHelpRequests(query);
      setState(() {
        _helpRequests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _filterRequests(String filter) async {
    setState(() => _isLoading = true);
    try {
      List<HelpRequest> requests;
      if (filter == 'all') {
        requests = await widget.useCases.getAllHelpRequests();
      } else {
        requests = await widget.useCases.getHelpRequestsByStatus(filter);
      }
      setState(() {
        _helpRequests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showRequestDetails(HelpRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Beschreibung: ${request.description}'),
              const SizedBox(height: 8),
              Text('Kategorie: ${request.category}'),
              Text('Status: ${request.status}'),
              Text('Priorität: ${request.priority}'),
              Text('Erstellt von: ${request.requesterName}'),
              Text('Erstellt am: ${request.createdAt.toString().split('.')[0]}'),
              if (request.location != null) Text('Standort: ${request.location}'),
              if (request.tags.isNotEmpty) Text('Tags: ${request.tags.join(', ')}'),
              if (request.isUrgent) const Text('⚠️ Dringend', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Suchleiste
          TextField(
            decoration: const InputDecoration(
              hintText: 'Hilfe-Anfragen durchsuchen...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
              if (value.isNotEmpty) {
                _searchRequests(value);
              } else {
                _loadHelpRequests();
              }
            },
          ),
          const SizedBox(height: 16),

          // Filter-Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Alle', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Offen', 'open'),
                const SizedBox(width: 8),
                _buildFilterChip('In Bearbeitung', 'in_progress'),
                const SizedBox(width: 8),
                _buildFilterChip('Abgeschlossen', 'completed'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Anfragen-Liste
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _helpRequests.isEmpty
                    ? const Center(
                        child: Text('Keine Hilfe-Anfragen gefunden'),
                      )
                    : ListView.builder(
                        itemCount: _helpRequests.length,
                        itemBuilder: (context, index) {
                          final request = _helpRequests[index];
                          return _buildRequestCard(request);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
        _filterRequests(value);
      },
      selectedColor: AppConfig.primaryColor.withValues(alpha: 0.2),
    );
  }

  Widget _buildRequestCard(HelpRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _getPriorityIcon(request.priority),
        title: Text(
          request.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(request.category),
                  backgroundColor: AppConfig.primaryColor.withValues(alpha: 0.1),
                  labelStyle: TextStyle(color: AppConfig.primaryColor),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(request.status),
                  backgroundColor: _getStatusColor(request.status).withValues(alpha: 0.1),
                  labelStyle: TextStyle(color: _getStatusColor(request.status)),
                ),
              ],
            ),
            if (request.tags.isNotEmpty)
              Text('Tags: ${request.tags.take(2).join(', ')}', style: TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              request.requesterName,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              _formatDate(request.createdAt),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        onTap: () => _showRequestDetails(request),
      ),
    );
  }

  Widget _getPriorityIcon(String priority) {
    IconData icon;
    Color color;
    
    switch (priority) {
      case 'urgent':
        icon = Icons.priority_high;
        color = Colors.red;
        break;
      case 'high':
        icon = Icons.priority_high;
        color = Colors.orange;
        break;
      case 'medium':
        icon = Icons.remove;
        color = Colors.blue;
        break;
      case 'low':
        icon = Icons.keyboard_arrow_down;
        color = Colors.green;
        break;
      default:
        icon = Icons.remove;
        color = Colors.grey;
    }
    
    return Icon(icon, color: color);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inMinutes}m';
    }
  }
} 