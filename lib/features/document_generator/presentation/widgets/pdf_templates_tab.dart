// features/document_generator/presentation/widgets/pdf_templates_tab.dart

import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../domain/entities/pdf_template.dart';

/// Widget für den PDF-Templates-Tab
class PdfTemplatesTab extends StatelessWidget {
  final List<PdfTemplate> templates;
  final bool isLoading;

  const PdfTemplatesTab({
    super.key,
    required this.templates,
    required this.isLoading,
  });

  IconData _getTemplateIcon(String templateType) {
    switch (templateType.toLowerCase()) {
      case 'contract':
        return Icons.description;
      case 'letter':
        return Icons.mail;
      case 'application':
        return Icons.assignment;
      case 'report':
        return Icons.assessment;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getTemplateColor(String templateType) {
    switch (templateType.toLowerCase()) {
      case 'contract':
        return Colors.blue;
      case 'letter':
        return Colors.green;
      case 'application':
        return Colors.orange;
      case 'report':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getTemplateTypeName(String templateType) {
    switch (templateType.toLowerCase()) {
      case 'contract':
        return 'Vertrag';
      case 'letter':
        return 'Brief';
      case 'application':
        return 'Antrag';
      case 'report':
        return 'Bericht';
      default:
        return templateType;
    }
  }

  void _showTemplatePreview(BuildContext context, PdfTemplate template) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Template: ${template.name}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: AppConfig.defaultPadding),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Beschreibung', template.description),
                        _buildInfoRow('Typ', _getTemplateTypeName(template.templateType)),
                        _buildInfoRow('Kategorie', template.displayCategory),
                        _buildInfoRow('Status', template.statusText),
                        _buildInfoRow('Version', template.version ?? '1.0'),
                        const SizedBox(height: AppConfig.defaultPadding),
                        const Text(
                          'Erforderliche Felder:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppConfig.smallPadding),
                        Wrap(
                          spacing: 4,
                          children: template.requiredFields.map((field) => Chip(
                            label: Text(field),
                            backgroundColor: Colors.red.withValues(alpha: 0.1),
                          )).toList(),
                        ),
                        if (template.optionalFields.isNotEmpty) ...[
                          const SizedBox(height: AppConfig.defaultPadding),
                          const Text(
                            'Optionale Felder:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppConfig.smallPadding),
                          Wrap(
                            spacing: 4,
                            children: template.optionalFields.map((field) => Chip(
                              label: Text(field),
                              backgroundColor: Colors.blue.withValues(alpha: 0.1),
                            )).toList(),
                          ),
                        ],
                        const SizedBox(height: AppConfig.defaultPadding),
                        const Text(
                          'HTML-Template:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppConfig.smallPadding),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppConfig.defaultPadding),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(AppConfig.defaultRadius),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            template.htmlTemplate,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConfig.smallPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
                child: ListTile(
                  leading: Icon(
                    _getTemplateIcon(template.templateType),
                    color: _getTemplateColor(template.templateType),
                  ),
                  title: Text(template.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Typ: ${_getTemplateTypeName(template.templateType)}'),
                      Text('Kategorie: ${template.displayCategory}'),
                      Text('Status: ${template.statusText}'),
                      if (template.requiredFields.isNotEmpty)
                        Text('Erforderliche Felder: ${template.requiredFields.length}'),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () => _showTemplatePreview(context, template),
                    icon: const Icon(Icons.visibility),
                  ),
                ),
              );
            },
          );
  }
} 