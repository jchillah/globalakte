// features/help_network/presentation/widgets/help_statistics_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../domain/usecases/help_network_usecases.dart';

/// Widget für Statistiken im Hilfe-Netzwerk
class HelpStatisticsWidget extends StatefulWidget {
  final HelpNetworkUseCases useCases;

  const HelpStatisticsWidget({
    super.key,
    required this.useCases,
  });

  @override
  State<HelpStatisticsWidget> createState() => _HelpStatisticsWidgetState();
}

class _HelpStatisticsWidgetState extends State<HelpStatisticsWidget> {
  Map<String, dynamic>? _statistics;
  final List<Map<String, dynamic>> _topHelpers = [];
  final List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);

    try {
      final stats = await widget.useCases.generateHelpStatistics();
      setState(() {
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarUtils.showError(
            context, 'Fehler beim Laden der Statistiken: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hilfe-Netzwerk Statistiken',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                onPressed: _loadStatistics,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            // Übersichtskarten
            if (_statistics != null) _buildOverviewCards(),

            const SizedBox(height: 24),

            // Top Helfer
            if (_topHelpers.isNotEmpty) _buildTopHelpersSection(),

            const SizedBox(height: 24),

            // Kategorien
            if (_categories.isNotEmpty) _buildCategoriesSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Gesamt Anfragen',
          _statistics!['total_requests'].toString(),
          Icons.list,
          Colors.blue,
        ),
        _buildStatCard(
          'Offene Anfragen',
          _statistics!['open_requests'].toString(),
          Icons.pending,
          Colors.orange,
        ),
        _buildStatCard(
          'Abgeschlossen',
          _statistics!['completed_requests'].toString(),
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          'Aktive Helfer',
          _statistics!['active_helpers'].toString(),
          Icons.people,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
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
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHelpersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Helfer',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _topHelpers.take(5).length,
          itemBuilder: (context, index) {
            final helper = _topHelpers[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppConfig.primaryColor,
                  child: Text(
                    helper['helperName'][0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(helper['helperName']),
                subtitle:
                    Text('${helper['acceptedOffers']} angenommene Angebote'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (helper['averageRating'] > 0) ...[
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text('${helper['averageRating'].toStringAsFixed(1)}'),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Anfragen nach Kategorien',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final totalRequests = category['totalRequests'] as int;
            final openRequests = category['openRequests'] as int;
            final completedRequests = category['completedRequests'] as int;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category['category'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$totalRequests Anfragen',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: totalRequests > 0
                          ? completedRequests / totalRequests
                          : 0,
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppConfig.primaryColor),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Offen: $openRequests'),
                        Text('Abgeschlossen: $completedRequests'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
