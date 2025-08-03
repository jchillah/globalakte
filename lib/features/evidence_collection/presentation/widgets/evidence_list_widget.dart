// features/evidence_collection/presentation/widgets/evidence_list_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../data/repositories/evidence_repository_impl.dart';
import '../../domain/entities/evidence_item.dart';
import '../../domain/usecases/evidence_usecases.dart';

/// Widget für die Beweismittel-Übersicht
class EvidenceListWidget extends StatefulWidget {
  final GetAllEvidenceUseCase getAllEvidenceUseCase;
  final EvidenceRepositoryImpl repository;

  const EvidenceListWidget({
    super.key,
    required this.getAllEvidenceUseCase,
    required this.repository,
  });

  @override
  State<EvidenceListWidget> createState() => _EvidenceListWidgetState();
}

class _EvidenceListWidgetState extends State<EvidenceListWidget> {
  List<EvidenceItem> _evidenceItems = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadEvidence();
  }

  Future<void> _loadEvidence() async {
    setState(() => _isLoading = true);

    try {
      final items = await widget.getAllEvidenceUseCase();
      setState(() {
        _evidenceItems = items;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
        context,
        'Fehler beim Laden der Beweismittel: $e',
      );
      setState(() => _isLoading = false);
    }
  }

  List<EvidenceItem> get _filteredItems {
    if (_selectedFilter == 'all') return _evidenceItems;
    return _evidenceItems
        .where((item) => item.type == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter-Bereich
          _buildFilterSection(),
          const SizedBox(height: 16),

          // Beweismittel-Liste
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredItems.isEmpty
                    ? _buildEmptyState()
                    : _buildEvidenceList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('all', 'Alle'),
                _buildFilterChip('photo', 'Fotos'),
                _buildFilterChip('video', 'Videos'),
                _buildFilterChip('document', 'Dokumente'),
                _buildFilterChip('audio', 'Audio'),
                _buildFilterChip('physical', 'Physisch'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
      },
      selectedColor: AppConfig.primaryColor.withValues(alpha: 0.2),
      checkmarkColor: AppConfig.primaryColor,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Keine Beweismittel gefunden',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fügen Sie neue Beweismittel hinzu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceList() {
    return ListView.builder(
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final evidence = _filteredItems[index];
        return _buildEvidenceCard(evidence);
      },
    );
  }

  Widget _buildEvidenceCard(EvidenceItem evidence) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildEvidenceIcon(evidence.type),
        title: Text(
          evidence.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(evidence.description),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatusChip(evidence.status),
                const SizedBox(width: 8),
                Text(
                  evidence.type,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleEvidenceAction(value, evidence),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('Anzeigen'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Bearbeiten'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'verify',
              child: Row(
                children: [
                  Icon(Icons.verified),
                  SizedBox(width: 8),
                  Text('Verifizieren'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 8),
                  Text('Löschen'),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showEvidenceDetails(evidence),
      ),
    );
  }

  Widget _buildEvidenceIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'photo':
        iconData = Icons.photo_camera;
        iconColor = Colors.blue;
        break;
      case 'video':
        iconData = Icons.videocam;
        iconColor = Colors.red;
        break;
      case 'document':
        iconData = Icons.description;
        iconColor = Colors.green;
        break;
      case 'audio':
        iconData = Icons.audiotrack;
        iconColor = Colors.orange;
        break;
      case 'physical':
        iconData = Icons.science;
        iconColor = Colors.purple;
        break;
      default:
        iconData = Icons.attach_file;
        iconColor = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withValues(alpha: 0.1),
      child: Icon(iconData, color: iconColor),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String label;

    switch (status) {
      case 'pending':
        chipColor = Colors.orange;
        label = 'Ausstehend';
        break;
      case 'verified':
        chipColor = Colors.green;
        label = 'Verifiziert';
        break;
      case 'rejected':
        chipColor = Colors.red;
        label = 'Abgelehnt';
        break;
      case 'archived':
        chipColor = Colors.grey;
        label = 'Archiviert';
        break;
      default:
        chipColor = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: chipColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _handleEvidenceAction(String action, EvidenceItem evidence) {
    switch (action) {
      case 'view':
        _showEvidenceDetails(evidence);
        break;
      case 'edit':
        // TODO: Implement edit functionality
        SnackBarUtils.showInfoSnackBar(
          context,
          'Bearbeitung wird implementiert',
        );
        break;
      case 'verify':
        _verifyEvidence(evidence);
        break;
      case 'delete':
        _deleteEvidence(evidence);
        break;
    }
  }

  void _showEvidenceDetails(EvidenceItem evidence) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(evidence.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Beschreibung: ${evidence.description}'),
              const SizedBox(height: 8),
              Text('Typ: ${evidence.type}'),
              const SizedBox(height: 8),
              Text('Status: ${evidence.status}'),
              const SizedBox(height: 8),
              Text('Gesammelt von: ${evidence.collectedBy}'),
              const SizedBox(height: 8),
              Text('Ort: ${evidence.location}'),
              const SizedBox(height: 8),
              Text('Datum: ${evidence.collectedAt.toString().split(' ')[0]}'),
              if (evidence.notes != null) ...[
                const SizedBox(height: 8),
                Text('Notizen: ${evidence.notes}'),
              ],
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

  Future<void> _verifyEvidence(EvidenceItem evidence) async {
    try {
      await widget.repository.verifyEvidence(evidence.id, 'Demo User');
      SnackBarUtils.showSuccessSnackBar(
        context,
        'Beweismittel verifiziert',
      );
      _loadEvidence(); // Liste neu laden
    } catch (e) {
      SnackBarUtils.showErrorSnackBar(
        context,
        'Fehler beim Verifizieren: $e',
      );
    }
  }

  Future<void> _deleteEvidence(EvidenceItem evidence) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Beweismittel löschen'),
        content: Text(
          'Sind Sie sicher, dass Sie "${evidence.title}" löschen möchten?',
        ),
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
        await widget.repository.deleteEvidence(evidence.id);
        SnackBarUtils.showSuccessSnackBar(
          context,
          'Beweismittel gelöscht',
        );
        _loadEvidence(); // Liste neu laden
      } catch (e) {
        SnackBarUtils.showErrorSnackBar(
          context,
          'Fehler beim Löschen: $e',
        );
      }
    }
  }
} 