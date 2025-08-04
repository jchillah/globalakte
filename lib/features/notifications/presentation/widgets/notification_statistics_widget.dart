// features/notifications/presentation/widgets/notification_statistics_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../domain/usecases/notification_usecases.dart';

/// Widget für Benachrichtigungsstatistiken
class NotificationStatisticsWidget extends StatefulWidget {
  final NotificationUseCases useCases;

  const NotificationStatisticsWidget({
    super.key,
    required this.useCases,
  });

  @override
  State<NotificationStatisticsWidget> createState() =>
      _NotificationStatisticsWidgetState();
}

class _NotificationStatisticsWidgetState
    extends State<NotificationStatisticsWidget> {
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await widget.useCases.getNotificationStats();
      setState(() {
        _stats = stats;
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadStatistics,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConfig.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildOverviewCards(),
                  const SizedBox(height: 24),
                  _buildTypeBreakdown(),
                  const SizedBox(height: 24),
                  _buildCategoryBreakdown(),
                  const SizedBox(height: 24),
                  _buildExportSection(),
                ],
              ),
            ),
          );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: AppConfig.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Benachrichtigungsstatistiken',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Übersicht über Ihre Benachrichtigungen und deren Verteilung',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    final total = _stats['total'] ?? 0;
    final unread = _stats['unread'] ?? 0;
    final read = _stats['read'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Übersicht',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Gesamt',
                total.toString(),
                Icons.notifications,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Ungelesen',
                unread.toString(),
                Icons.mark_email_unread,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Gelesen',
                read.toString(),
                Icons.mark_email_read,
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBreakdown() {
    final byType = _stats['by_type'] as Map<String, dynamic>? ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verteilung nach Typ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (byType.isEmpty)
              const Center(
                child: Text(
                  'Keine Daten verfügbar',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              Column(
                children: byType.entries.map((entry) {
                  final type = entry.key;
                  final count = entry.value as int;
                  final total = _stats['total'] ?? 1;
                  final percentage = (count / total * 100).toStringAsFixed(1);

                  return _buildStatRow(
                    _getTypeLabel(type),
                    count.toString(),
                    '$percentage%',
                    _getTypeColor(type),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    final byCategory = _stats['by_category'] as Map<String, dynamic>? ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verteilung nach Kategorie',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (byCategory.isEmpty)
              const Center(
                child: Text(
                  'Keine Daten verfügbar',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              Column(
                children: byCategory.entries.map((entry) {
                  final category = entry.key;
                  final count = entry.value as int;
                  final total = _stats['total'] ?? 1;
                  final percentage = (count / total * 100).toStringAsFixed(1);

                  return _buildStatRow(
                    _getCategoryLabel(category),
                    count.toString(),
                    '$percentage%',
                    _getCategoryColor(category),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
      String label, String value, String percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(
            percentage,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export & Berichte',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _exportStatistics,
                    icon: const Icon(Icons.download),
                    label: const Text('Statistiken exportieren'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showDetailedReport,
                    icon: const Icon(Icons.assessment),
                    label: const Text('Detaillierter Bericht'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'info':
        return 'Information';
      case 'success':
        return 'Erfolg';
      case 'warning':
        return 'Warnung';
      case 'error':
        return 'Fehler';
      default:
        return type;
    }
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

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'system':
        return 'System';
      case 'case':
        return 'Fallakte';
      case 'document':
        return 'Dokument';
      case 'appointment':
        return 'Termin';
      default:
        return category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'system':
        return Colors.grey;
      case 'case':
        return Colors.purple;
      case 'document':
        return Colors.teal;
      case 'appointment':
        return Colors.indigo;
      default:
        return Colors.blue;
    }
  }

  Future<void> _exportStatistics() async {
    try {
      await widget.useCases.exportNotifications();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Statistiken exportiert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Die Statistiken wurden erfolgreich exportiert.'),
                const SizedBox(height: 8),
                Text(
                  'Format: JSON',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Export: $e')),
        );
      }
    }
  }

  void _showDetailedReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detaillierter Bericht'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gesamtanzahl: ${_stats['total'] ?? 0}'),
              Text('Ungelesen: ${_stats['unread'] ?? 0}'),
              Text('Gelesen: ${_stats['read'] ?? 0}'),
              const SizedBox(height: 16),
              const Text('Verteilung nach Typ:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...(_stats['by_type'] as Map<String, dynamic>? ?? {}).entries.map(
                    (entry) =>
                        Text('• ${_getTypeLabel(entry.key)}: ${entry.value}'),
                  ),
              const SizedBox(height: 16),
              const Text('Verteilung nach Kategorie:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...(_stats['by_category'] as Map<String, dynamic>? ?? {})
                  .entries
                  .map(
                    (entry) => Text(
                        '• ${_getCategoryLabel(entry.key)}: ${entry.value}'),
                  ),
              const SizedBox(height: 16),
              Text(
                  'Letzte Aktualisierung: ${_stats['last_updated'] ?? 'Unbekannt'}'),
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
}
