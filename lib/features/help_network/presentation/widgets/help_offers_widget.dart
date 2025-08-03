// features/help_network/presentation/widgets/help_offers_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/app_config.dart';
import '../../domain/entities/help_offer.dart';
import '../../domain/usecases/help_network_usecases.dart';

/// Widget für die Anzeige von Hilfe-Angeboten
class HelpOffersWidget extends StatefulWidget {
  final HelpNetworkUseCases useCases;

  const HelpOffersWidget({
    super.key,
    required this.useCases,
  });

  @override
  State<HelpOffersWidget> createState() => _HelpOffersWidgetState();
}

class _HelpOffersWidgetState extends State<HelpOffersWidget> {
  List<HelpOffer> _helpOffers = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadHelpOffers();
  }

  Future<void> _loadHelpOffers() async {
    setState(() => _isLoading = true);
    try {
      // Mock: Lade alle Angebote für Demo-Zwecke
      final offers = await widget.useCases.getHelpOffersByStatus('pending');
      setState(() {
        _helpOffers = offers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden der Angebote: $e')),
        );
      }
    }
  }

  Future<void> _filterOffers(String filter) async {
    setState(() => _isLoading = true);
    try {
      List<HelpOffer> offers;
      if (filter == 'all') {
        offers = await widget.useCases.getHelpOffersByStatus('pending');
      } else {
        offers = await widget.useCases.getHelpOffersByStatus(filter);
      }
      setState(() {
        _helpOffers = offers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showOfferDetails(HelpOffer offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Angebot von ${offer.helperName}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nachricht: ${offer.message}'),
              const SizedBox(height: 8),
              Text('Status: ${offer.status}'),
              Text('Erstellt am: ${offer.createdAt.toString().split('.')[0]}'),
              if (offer.rating != null) Text('Bewertung: ${offer.rating}/5'),
              if (offer.review != null) Text('Bewertung: ${offer.review}'),
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

  Future<void> _createHelpOffer() async {
    final messageController = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hilfe anbieten'),
        content: TextField(
          controller: messageController,
          decoration: const InputDecoration(
            labelText: 'Ihre Nachricht',
            hintText: 'Beschreiben Sie, wie Sie helfen können...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(messageController.text),
            child: const Text('Angebot erstellen'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        await widget.useCases.createHelpOffer(
          helpRequestId: 'demo_request_id',
          helperId: 'demo_helper',
          helperName: 'Demo Helper',
          message: result,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Hilfe-Angebot erfolgreich erstellt!')),
          );
          _loadHelpOffers();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fehler beim Erstellen des Angebots: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hilfe-Angebote',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: _createHelpOffer,
                icon: const Icon(Icons.add),
                label: const Text('Angebot erstellen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filter-Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Alle', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Ausstehend', 'pending'),
                const SizedBox(width: 8),
                _buildFilterChip('Angenommen', 'accepted'),
                const SizedBox(width: 8),
                _buildFilterChip('Abgelehnt', 'rejected'),
                const SizedBox(width: 8),
                _buildFilterChip('Abgeschlossen', 'completed'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Angebote-Liste
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _helpOffers.isEmpty
                    ? const Center(
                        child: Text('Keine Hilfe-Angebote gefunden'),
                      )
                    : ListView.builder(
                        itemCount: _helpOffers.length,
                        itemBuilder: (context, index) {
                          final offer = _helpOffers[index];
                          return _buildOfferCard(offer);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
        _filterOffers(value);
      },
      selectedColor: AppConfig.primaryColor.withValues(alpha: 0.2),
    );
  }

  Widget _buildOfferCard(HelpOffer offer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConfig.primaryColor,
          child: Text(
            offer.helperName[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          offer.helperName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(offer.message, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(offer.status),
                  backgroundColor: _getStatusColor(offer.status).withValues(alpha: 0.1),
                  labelStyle: TextStyle(color: _getStatusColor(offer.status)),
                ),
                const SizedBox(width: 8),
                if (offer.rating != null)
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text('${offer.rating}/5', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDate(offer.createdAt),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        onTap: () => _showOfferDetails(offer),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inMinutes}m';
    }
  }
} 