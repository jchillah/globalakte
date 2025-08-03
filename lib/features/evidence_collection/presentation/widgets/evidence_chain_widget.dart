// features/evidence_collection/presentation/widgets/evidence_chain_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../data/repositories/evidence_repository_impl.dart';
import '../../domain/entities/evidence_item.dart';
import '../../domain/usecases/evidence_usecases.dart';

/// Widget für Beweismittel-Ketten
class EvidenceChainWidget extends StatefulWidget {
  final EvidenceRepositoryImpl repository;
  final CreateEvidenceChainUseCase createChainUseCase;

  const EvidenceChainWidget({
    super.key,
    required this.repository,
    required this.createChainUseCase,
  });

  @override
  State<EvidenceChainWidget> createState() => _EvidenceChainWidgetState();
}

class _EvidenceChainWidgetState extends State<EvidenceChainWidget> {
  List<EvidenceItem> _allEvidence = [];
  final List<EvidenceItem> _selectedEvidence = [];
  final _chainNameController = TextEditingController();
  bool _isLoading = true;
  bool _isCreatingChain = false;

  @override
  void initState() {
    super.initState();
    _loadEvidence();
  }

  @override
  void dispose() {
    _chainNameController.dispose();
    super.dispose();
  }

  Future<void> _loadEvidence() async {
    setState(() => _isLoading = true);

    try {
      final evidence = await widget.repository.getAllEvidence();
      setState(() {
        _allEvidence = evidence;
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildChainContent(),
    );
  }

  Widget _buildChainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 16),

        // Info-Button
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Beweismittel-Ketten',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            IconButton(
              onPressed: _showInfoDialog,
              icon: Icon(
                Icons.info_outline,
                color: AppConfig.primaryColor,
              ),
              tooltip: 'Informationen zu Beweismittel-Ketten',
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Ketten-Name
        GlobalTextField(
          controller: _chainNameController,
          label: 'Ketten-Name *',
          hint: 'z.B. Unfall-Dokumentation',
        ),

        const SizedBox(height: 24),

        // Ausgewählte Beweismittel
        if (_selectedEvidence.isNotEmpty) ...[
          Text(
            'Ausgewählte Beweismittel (${_selectedEvidence.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildSelectedEvidenceList(),
          const SizedBox(height: 16),
        ],

        // Beweismittel-Auswahl
        Text(
          'Beweismittel auswählen',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _buildEvidenceSelectionList(),
        ),

        const SizedBox(height: 16),

        // Aktionen
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildSelectedEvidenceList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: _selectedEvidence.map((evidence) {
            return ListTile(
              leading: _buildEvidenceIcon(evidence.type),
              title: Text(
                evidence.title,
                style: const TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                evidence.type,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => _removeEvidenceFromSelection(evidence),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEvidenceSelectionList() {
    return ListView.builder(
      itemCount: _allEvidence.length,
      itemBuilder: (context, index) {
        final evidence = _allEvidence[index];
        final isSelected = _selectedEvidence.contains(evidence);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: CheckboxListTile(
            value: isSelected,
            onChanged: (selected) {
              setState(() {
                if (selected == true) {
                  _addEvidenceToSelection(evidence);
                } else {
                  _removeEvidenceFromSelection(evidence);
                }
              });
            },
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
            secondary: _buildEvidenceIcon(evidence.type),
          ),
        );
      },
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
      child: Icon(iconData, color: iconColor, size: 20),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: chipColor,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _selectedEvidence.isEmpty ? null : _clearSelection,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.grey.shade700,
            ),
            child: const Text('Auswahl löschen'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GlobalButton(
            onPressed: _canCreateChain() ? _createChain : null,
            text: 'Kette erstellen',
            isLoading: _isCreatingChain,
          ),
        ),
      ],
    );
  }

  void _addEvidenceToSelection(EvidenceItem evidence) {
    if (!_selectedEvidence.contains(evidence)) {
      setState(() {
        _selectedEvidence.add(evidence);
      });
    }
  }

  void _removeEvidenceFromSelection(EvidenceItem evidence) {
    setState(() {
      _selectedEvidence.remove(evidence);
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedEvidence.clear();
    });
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: AppConfig.primaryColor),
            const SizedBox(width: 8),
            const Text('Beweismittel-Ketten'),
          ],
        ),
        content: const Text(
          'Erstellen Sie logische Verbindungen zwischen Beweismitteln, '
          'um Zusammenhänge zu dokumentieren und die Beweiskette zu stärken.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }

  bool _canCreateChain() {
    return _chainNameController.text.trim().isNotEmpty &&
        _selectedEvidence.length >= 2;
  }

  Future<void> _createChain() async {
    if (!_canCreateChain()) {
      SnackBarUtils.showErrorSnackBar(
        context,
        'Bitte geben Sie einen Namen ein und wählen Sie mindestens 2 Beweismittel aus',
      );
      return;
    }

    setState(() => _isCreatingChain = true);

    try {
      final evidenceIds = _selectedEvidence.map((e) => e.id).toList();
      final chainName = _chainNameController.text.trim();

      await widget.createChainUseCase(evidenceIds, chainName);

      if (!mounted) return;

      SnackBarUtils.showSuccessSnackBar(
        context,
        'Beweismittel-Kette "$chainName" erfolgreich erstellt',
      );

      // Form zurücksetzen
      _chainNameController.clear();
      _selectedEvidence.clear();
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
        context,
        'Fehler beim Erstellen der Kette: $e',
      );
    } finally {
      if (mounted) {
        setState(() => _isCreatingChain = false);
      }
    }
  }
}
