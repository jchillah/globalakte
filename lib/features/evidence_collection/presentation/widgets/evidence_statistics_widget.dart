// features/evidence_collection/presentation/widgets/evidence_statistics_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../domain/usecases/evidence_usecases.dart';

/// Widget für Beweismittel-Statistiken
class EvidenceStatisticsWidget extends StatefulWidget {
  final GetEvidenceStatisticsUseCase getStatisticsUseCase;

  const EvidenceStatisticsWidget({
    super.key,
    required this.getStatisticsUseCase,
  });

  @override
  State<EvidenceStatisticsWidget> createState() =>
      _EvidenceStatisticsWidgetState();
}

class _EvidenceStatisticsWidgetState extends State<EvidenceStatisticsWidget> {
  Map<String, dynamic>? _statistics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);

    try {
      final stats = await widget.getStatisticsUseCase();
      setState(() {
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
        context,
        'Fehler beim Laden der Statistiken: $e',
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _statistics == null
              ? _buildErrorState()
              : _buildStatisticsContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Fehler beim Laden der Statistiken',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadStatistics,
            child: const Text('Erneut versuchen'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsContent() {
    final stats = _statistics!;
    final totalCount = stats['total_count'] as int;
    final typeStats = stats['type_statistics'] as Map<String, dynamic>;
    final statusStats = stats['status_statistics'] as Map<String, dynamic>;
    final recentAdditions = stats['recent_additions'] as int;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Beweismittel-Statistiken',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),

          // Übersichtskarten
          _buildOverviewCards(totalCount, recentAdditions),

          const SizedBox(height: 24),

          // Typ-Statistiken
          _buildTypeStatistics(typeStats),

          const SizedBox(height: 24),

          // Status-Statistiken
          _buildStatusStatistics(statusStats),

          const SizedBox(height: 24),

          // Aktualisieren-Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loadStatistics,
              icon: const Icon(Icons.refresh),
              label: const Text('Statistiken aktualisieren'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(int totalCount, int recentAdditions) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Gesamt',
          totalCount.toString(),
          Icons.folder,
          Colors.blue,
        ),
        _buildStatCard(
          'Neu (7 Tage)',
          recentAdditions.toString(),
          Icons.add_circle,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeStatistics(Map<String, dynamic> typeStats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: AppConfig.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Nach Typ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...typeStats.entries.map((entry) {
              final type = entry.key;
              final count = entry.value as int;
              return _buildStatRow(_getTypeLabel(type), count.toString());
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusStatistics(Map<String, dynamic> statusStats) {
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
                  'Nach Status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...statusStats.entries.map((entry) {
              final status = entry.key;
              final count = entry.value as int;
              return _buildStatRow(_getStatusLabel(status), count.toString());
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'photo':
        return 'Fotos';
      case 'video':
        return 'Videos';
      case 'document':
        return 'Dokumente';
      case 'audio':
        return 'Audio';
      case 'physical':
        return 'Physisch';
      default:
        return type;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Ausstehend';
      case 'verified':
        return 'Verifiziert';
      case 'rejected':
        return 'Abgelehnt';
      case 'archived':
        return 'Archiviert';
      default:
        return status;
    }
  }
} 