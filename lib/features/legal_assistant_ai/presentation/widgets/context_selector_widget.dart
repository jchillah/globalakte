// features/legal_assistant_ai/presentation/widgets/context_selector_widget.dart
import 'package:flutter/material.dart';

import '../../domain/entities/legal_context.dart';

/// Widget für die Auswahl rechtlicher Kontexte
class ContextSelectorWidget extends StatelessWidget {
  final List<LegalContext> contexts;
  final String selectedContext;
  final Function(String) onContextChanged;
  final bool isLoading;

  const ContextSelectorWidget({
    super.key,
    required this.contexts,
    required this.selectedContext,
    required this.onContextChanged,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rechtliche Kontexte',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (contexts.isEmpty)
            _buildEmptyState()
          else
            _buildContextList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Keine Kontexte verfügbar',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextList() {
    return Expanded(
      child: ListView.builder(
        itemCount: contexts.length,
        itemBuilder: (context, index) {
          final contextItem = contexts[index];
          final isSelected = selectedContext == contextItem.title;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: isSelected ? Colors.blue[50] : null,
            child: ListTile(
              leading: Icon(
                Icons.folder,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
              title: Text(
                contextItem.title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contextItem.description),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: [
                      Chip(
                        label: Text(
                          contextItem.category,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                      ...contextItem.keywords.take(2).map((keyword) {
                        return Chip(
                          label: Text(
                            keyword,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.grey[100],
                        );
                      }),
                    ],
                  ),
                ],
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.blue)
                  : null,
              onTap: () => onContextChanged(contextItem.title),
            ),
          );
        },
      ),
    );
  }
}
