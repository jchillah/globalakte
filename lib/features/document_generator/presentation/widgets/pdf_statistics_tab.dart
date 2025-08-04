// features/document_generator/presentation/widgets/pdf_statistics_tab.dart

import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';

/// Widget für den PDF-Statistik-Tab
class PdfStatisticsTab extends StatefulWidget {
  final Map<String, dynamic> statistics;
  final bool isLoading;

  const PdfStatisticsTab({
    super.key,
    required this.statistics,
    required this.isLoading,
  });

  @override
  State<PdfStatisticsTab> createState() => _PdfStatisticsTabState();
}

class _PdfStatisticsTabState extends State<PdfStatisticsTab> {

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConfig.defaultPadding),
      margin: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConfig.smallPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
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

  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConfig.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📊 PDF-Statistiken',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppConfig.defaultPadding),
                        _buildStatCard('Gesamt Dokumente', '${widget.statistics['totalDocuments'] ?? 0}'),
                        _buildStatCard('Gesamt Templates', '${widget.statistics['totalTemplates'] ?? 0}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConfig.defaultPadding),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConfig.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dokumente nach Typ',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppConfig.defaultPadding),
                        if (widget.statistics['documentsByType'] != null)
                          ...(widget.statistics['documentsByType'] as Map<String, dynamic>).entries.map(
                            (entry) => _buildStatRow(entry.key, entry.value.toString()),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConfig.defaultPadding),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConfig.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Templates nach Kategorie',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppConfig.defaultPadding),
                        if (widget.statistics['templatesByCategory'] != null)
                          ...(widget.statistics['templatesByCategory'] as Map<String, dynamic>).entries.map(
                            (entry) => _buildStatRow(entry.key, entry.value.toString()),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
} 