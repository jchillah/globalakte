// features/accessibility/presentation/widgets/accessibility_report_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Widget für Accessibility-Reports
class AccessibilityReportWidget extends StatelessWidget {
  final String report;
  final VoidCallback onGenerateReport;
  final bool isLoading;

  const AccessibilityReportWidget({
    super.key,
    required this.report,
    required this.onGenerateReport,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assessment,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Accessibility-Report',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (report.isNotEmpty)
                  IconButton(
                    onPressed: () => _showFullReport(context),
                    icon: const Icon(Icons.open_in_new),
                    tooltip: 'Vollständigen Report anzeigen',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (report.isEmpty)
              _buildEmptyState()
            else
              _buildReportPreview(),
            const SizedBox(height: 16),
            _buildGenerateReportButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.assessment_outlined,
            size: 48,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            'Noch kein Report generiert',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Klicken Sie auf "Report generieren" um einen detaillierten '
            'Accessibility-Report zu erstellen.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportPreview() {
    final lines = report.split('\n');
    final previewLines = lines.take(10).toList();
    final hasMoreLines = lines.length > 10;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'Report-Vorschau',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...previewLines.map((line) => _buildReportLine(line)),
          if (hasMoreLines) ...[
            const SizedBox(height: 4),
            Text(
              '... und ${lines.length - 10} weitere Zeilen',
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReportLine(String line) {
    if (line.trim().isEmpty) {
      return const SizedBox(height: 4);
    }

    if (line.startsWith('#')) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Text(
          line.replaceAll('#', '').trim(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    }

    if (line.startsWith('-')) {
      return Padding(
        padding: const EdgeInsets.only(left: 8, top: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontSize: 12)),
            Expanded(
              child: Text(
                line.replaceAll('-', '').trim(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    if (line.contains(':')) {
      final parts = line.split(':');
      if (parts.length >= 2) {
        return Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${parts[0]}: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Expanded(
                child: Text(
                  parts.sublist(1).join(':').trim(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        line,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildGenerateReportButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onGenerateReport,
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.assessment),
        label: Text(isLoading ? 'Report wird generiert...' : 'Report generieren'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  void _showFullReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accessibility-Report'),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            child: SelectableText(
              report,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
          ElevatedButton.icon(
            onPressed: () => _exportReport(context),
            icon: const Icon(Icons.download),
            label: const Text('Exportieren'),
          ),
        ],
      ),
    );
  }

  void _exportReport(BuildContext context) {
    // Hier könnte die Export-Funktionalität implementiert werden
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report-Export wird implementiert...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
} 