// features/notifications/presentation/screens/notification_demo_screen.dart
import 'package:flutter/material.dart';

import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/usecases/notification_usecases.dart';
import '../widgets/notification_list_widget.dart';
import '../widgets/notification_settings_widget.dart';
import '../widgets/notification_statistics_widget.dart';
import '../widgets/push_test_widget.dart';

/// Demo-Screen für Benachrichtigungen & Push-System
class NotificationDemoScreen extends StatefulWidget {
  const NotificationDemoScreen({super.key});

  @override
  State<NotificationDemoScreen> createState() => _NotificationDemoScreenState();
}

class _NotificationDemoScreenState extends State<NotificationDemoScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late NotificationUseCases _useCases;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Initialisiere Use Cases
    final repository = NotificationRepositoryImpl();
    _useCases = NotificationUseCases(repository);
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
        title: const Text('🔔 Benachrichtigungen & Push-System'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.notifications), text: 'Benachrichtigungen'),
            Tab(icon: Icon(Icons.settings), text: 'Einstellungen'),
            Tab(icon: Icon(Icons.send), text: 'Push-Test'),
            Tab(icon: Icon(Icons.analytics), text: 'Statistiken'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NotificationListWidget(useCases: _useCases),
          NotificationSettingsWidget(useCases: _useCases),
          PushTestWidget(useCases: _useCases),
          NotificationStatisticsWidget(useCases: _useCases),
        ],
      ),
    );
  }
}
