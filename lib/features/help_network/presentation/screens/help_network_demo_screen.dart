// features/help_network/presentation/screens/help_network_demo_screen.dart
import 'package:flutter/material.dart';

import '../../data/repositories/help_network_repository_impl.dart';
import '../../domain/usecases/help_network_usecases.dart';
import '../widgets/help_chat_widget.dart';
import '../widgets/help_offers_widget.dart';
import '../widgets/help_request_form_widget.dart';
import '../widgets/help_request_list_widget.dart';
import '../widgets/help_statistics_widget.dart';

/// Demo-Screen für das Hilfe-Netzwerk Feature
class HelpNetworkDemoScreen extends StatefulWidget {
  const HelpNetworkDemoScreen({super.key});

  @override
  State<HelpNetworkDemoScreen> createState() => _HelpNetworkDemoScreenState();
}

class _HelpNetworkDemoScreenState extends State<HelpNetworkDemoScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late HelpNetworkUseCases _useCases;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initializeUseCases();
  }

  Future<void> _initializeUseCases() async {
    final repository = HelpNetworkRepositoryImpl();
    _useCases = HelpNetworkUseCases(repository);
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hilfe-Netzwerk'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'Anfragen'),
            Tab(icon: Icon(Icons.add), text: 'Erstellen'),
            Tab(icon: Icon(Icons.handshake), text: 'Angebote'),
            Tab(icon: Icon(Icons.chat), text: 'Chat'),
            Tab(icon: Icon(Icons.analytics), text: 'Statistiken'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                HelpRequestListWidget(useCases: _useCases),
                HelpRequestFormWidget(useCases: _useCases),
                HelpOffersWidget(useCases: _useCases),
                HelpChatWidget(useCases: _useCases),
                HelpStatisticsWidget(useCases: _useCases),
              ],
            ),
    );
  }
}
