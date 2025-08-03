// features/case_timeline/presentation/widgets/case_file_card.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../domain/entities/case_file.dart';

/// Widget für die Anzeige einer Fallakte-Karte
class CaseFileCard extends StatelessWidget {
  final CaseFile caseFile;
  final VoidCallback? onTap;

  const CaseFileCard({
    super.key,
    required this.caseFile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppConfig.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          caseFile.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          caseFile.caseNumber,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(caseFile.status),
                ],
              ),
              const SizedBox(height: AppConfig.smallPadding),
              Text(
                caseFile.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConfig.smallPadding),
              Row(
                children: [
                  Icon(
                    Icons.category,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getCategoryDisplayName(caseFile.category),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const Spacer(),
                  if (caseFile.isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Überfällig',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppConfig.smallPadding),
              Row(
                children: [
                  Icon(
                    Icons.description,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${caseFile.documentCount} Dokumente',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(width: AppConfig.defaultPadding),
                  Icon(
                    Icons.timeline,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${caseFile.timelineEventCount} Events',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const Spacer(),
                  if (caseFile.isEpaIntegrated)
                    Icon(
                      Icons.cloud_sync,
                      size: 16,
                      color: Colors.blue.shade600,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;

    switch (status) {
      case 'active':
        color = Colors.green;
        text = 'Aktiv';
        break;
      case 'in_progress':
        color = Colors.orange;
        text = 'In Bearbeitung';
        break;
      case 'completed':
        color = Colors.blue;
        text = 'Abgeschlossen';
        break;
      case 'closed':
        color = Colors.grey;
        text = 'Geschlossen';
        break;
      default:
        color = Colors.grey;
        text = 'Unbekannt';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'civil':
        return 'Zivilrecht';
      case 'criminal':
        return 'Strafrecht';
      case 'administrative':
        return 'Verwaltungsrecht';
      case 'family':
        return 'Familienrecht';
      case 'labor':
        return 'Arbeitsrecht';
      default:
        return category;
    }
  }
}
