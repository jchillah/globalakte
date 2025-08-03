// features/communication/presentation/screens/communication_demo_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/utils/snackbar_utils.dart';
import '../../../encryption/data/repositories/encryption_repository_impl.dart';
import '../../data/repositories/communication_repository_impl.dart';
import '../../domain/entities/chat_room.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/communication_repository.dart';
import '../../domain/usecases/communication_usecases.dart';

/// Demo-Screen für das Kommunikationssystem
class CommunicationDemoScreen extends StatefulWidget {
  const CommunicationDemoScreen({super.key});

  @override
  State<CommunicationDemoScreen> createState() =>
      _CommunicationDemoScreenState();
}

class _CommunicationDemoScreenState extends State<CommunicationDemoScreen> {
  late CommunicationRepository _communicationRepository;
  late SendMessageUseCase _sendMessageUseCase;
  late GetMessagesByChatRoomUseCase _getMessagesByChatRoomUseCase;
  late CreateChatRoomUseCase _createChatRoomUseCase;
  late GetChatRoomsByUserUseCase _getChatRoomsByUserUseCase;
  late SearchMessagesUseCase _searchMessagesUseCase;
  late GetCommunicationStatisticsUseCase _getCommunicationStatisticsUseCase;
  late EncryptMessageUseCase _encryptMessageUseCase;
  late DecryptMessageUseCase _decryptMessageUseCase;
  late SendPushNotificationUseCase _sendPushNotificationUseCase;
  late CreateMessageBackupUseCase _createMessageBackupUseCase;
  late SyncMessagesWithCloudUseCase _syncMessagesWithCloudUseCase;

  List<Message> _messages = [];
  List<ChatRoom> _chatRooms = [];
  Map<String, dynamic> _statistics = {};
  bool _isLoading = false;
  String _searchQuery = '';
  final String _currentUserId = 'demo_user';

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  /// Initialisiert das Repository und die Use Cases
  Future<void> _initializeRepository() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encryptionRepository = EncryptionRepositoryImpl();

      _communicationRepository =
          CommunicationRepositoryImpl(prefs, encryptionRepository);

      _sendMessageUseCase = SendMessageUseCase(_communicationRepository);
      _getMessagesByChatRoomUseCase =
          GetMessagesByChatRoomUseCase(_communicationRepository);
      _createChatRoomUseCase = CreateChatRoomUseCase(_communicationRepository);
      _getChatRoomsByUserUseCase =
          GetChatRoomsByUserUseCase(_communicationRepository);
      _searchMessagesUseCase = SearchMessagesUseCase(_communicationRepository);
      _getCommunicationStatisticsUseCase =
          GetCommunicationStatisticsUseCase(_communicationRepository);
      _encryptMessageUseCase = EncryptMessageUseCase(_communicationRepository);
      _decryptMessageUseCase = DecryptMessageUseCase(_communicationRepository);
      _sendPushNotificationUseCase =
          SendPushNotificationUseCase(_communicationRepository);
      _createMessageBackupUseCase =
          CreateMessageBackupUseCase(_communicationRepository);
      _syncMessagesWithCloudUseCase =
          SyncMessagesWithCloudUseCase(_communicationRepository);

      // Nach der Initialisierung Daten laden
      await _loadData();
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler bei der Initialisierung: $e');
      }
    }
  }

  /// Lädt alle Daten
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final chatRooms = await _getChatRoomsByUserUseCase(_currentUserId);
      final statistics =
          await _getCommunicationStatisticsUseCase(_currentUserId);

      setState(() {
        _chatRooms = chatRooms;
        _statistics = statistics;
        _isLoading = false;
      });

      // Lade Nachrichten für den ersten Chat-Raum
      if (chatRooms.isNotEmpty) {
        await _loadMessagesForChatRoom(chatRooms.first.id);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Laden der Daten: $e');
      }
    }
  }

  /// Lädt Nachrichten für einen Chat-Raum
  Future<void> _loadMessagesForChatRoom(String chatRoomId) async {
    try {
      final messages = await _getMessagesByChatRoomUseCase(chatRoomId);
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Laden der Nachrichten: $e');
      }
    }
  }

  /// Sendet eine Demo-Nachricht
  Future<void> _sendDemoMessage() async {
    try {
      if (_chatRooms.isEmpty) {
        // Erstelle einen Demo-Chat-Raum
        final demoChatRoom = ChatRoom(
          id: '',
          name: 'Demo Chat',
          description: 'Ein Demo-Chat für Tests',
          participantIds: [_currentUserId, 'other_user'],
          createdBy: _currentUserId,
          createdAt: DateTime.now(),
          isEncrypted: false,
          type: ChatRoomType.private,
          status: ChatRoomStatus.active,
        );

        final createdChatRoom = await _createChatRoomUseCase(demoChatRoom);
        setState(() {
          _chatRooms.add(createdChatRoom);
        });
      }

      final chatRoomId = _chatRooms.first.id;
      final demoMessage = Message(
        id: '',
        senderId: _currentUserId,
        receiverId: 'other_user',
        content: 'Demo-Nachricht ${_messages.length + 1}',
        timestamp: DateTime.now(),
        type: MessageType.text,
        status: MessageStatus.sent,
        isEncrypted: false,
        metadata: {'chatRoomId': chatRoomId},
      );

      final sentMessage = await _sendMessageUseCase(demoMessage);

      setState(() {
        _messages.add(sentMessage);
      });

      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(
            context, 'Nachricht gesendet: ${sentMessage.content}');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Senden der Nachricht: $e');
      }
    }
  }

  /// Verschlüsselt eine Nachricht
  Future<void> _encryptMessage(String messageId) async {
    try {
      await _encryptMessageUseCase(messageId, 'demo_key_1');
      await _loadMessagesForChatRoom(_chatRooms.first.id);
      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(context, 'Nachricht verschlüsselt');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Verschlüsseln: $e');
      }
    }
  }

  /// Entschlüsselt eine Nachricht
  Future<void> _decryptMessage(String messageId) async {
    try {
      await _decryptMessageUseCase(messageId);
      await _loadMessagesForChatRoom(_chatRooms.first.id);
      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(context, 'Nachricht entschlüsselt');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Entschlüsseln: $e');
      }
    }
  }

  /// Sendet eine Push-Benachrichtigung
  Future<void> _sendPushNotification() async {
    try {
      final success = await _sendPushNotificationUseCase(
        _currentUserId,
        'Neue Nachricht',
        'Sie haben eine neue Nachricht erhalten',
      );

      if (mounted) {
        if (success) {
          SnackBarUtils.showSuccessSnackBar(
              context, 'Push-Benachrichtigung gesendet');
        } else {
          SnackBarUtils.showErrorSnackBar(
              context, 'Fehler beim Senden der Push-Benachrichtigung');
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Senden der Push-Benachrichtigung: $e');
      }
    }
  }

  /// Erstellt ein Backup
  Future<void> _createBackup() async {
    try {
      final backupPath = await _createMessageBackupUseCase(_currentUserId);
      if (mounted) {
        SnackBarUtils.showSuccessSnackBar(
            context, 'Backup erstellt: $backupPath');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler beim Erstellen des Backups: $e');
      }
    }
  }

  /// Synchronisiert mit der Cloud
  Future<void> _syncWithCloud() async {
    try {
      final success = await _syncMessagesWithCloudUseCase(_currentUserId);
      if (mounted) {
        if (success) {
          SnackBarUtils.showSuccessSnackBar(
              context, 'Cloud-Synchronisation erfolgreich');
        } else {
          SnackBarUtils.showErrorSnackBar(
              context, 'Cloud-Synchronisation fehlgeschlagen');
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(
            context, 'Fehler bei der Cloud-Synchronisation: $e');
      }
    }
  }

  /// Sucht Nachrichten
  Future<void> _searchMessages(String query) async {
    try {
      final results = await _searchMessagesUseCase(query, _currentUserId);
      setState(() {
        _messages = results;
        _searchQuery = query;
      });
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showErrorSnackBar(context, 'Fehler bei der Suche: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kommunikation Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Aktualisieren',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStatisticsCard(),
                _buildSearchBar(),
                Expanded(
                  child: _messages.isEmpty
                      ? _buildEmptyState()
                      : _buildMessagesList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendDemoMessage,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.send),
      ),
    );
  }

  /// Erstellt die Statistik-Karte
  Widget _buildStatisticsCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kommunikations-Statistiken',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatItem(
                  'Gesamt',
                  _statistics['totalMessages']?.toString() ?? '0',
                  Icons.message,
                ),
                _buildStatItem(
                  'Gesendet',
                  _statistics['sentMessages']?.toString() ?? '0',
                  Icons.send,
                ),
                _buildStatItem(
                  'Empfangen',
                  _statistics['receivedMessages']?.toString() ?? '0',
                  Icons.inbox,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatItem(
                  'Verschlüsselt',
                  _statistics['encryptedMessages']?.toString() ?? '0',
                  Icons.lock,
                ),
                _buildStatItem(
                  'Ungelesen',
                  _statistics['unreadMessages']?.toString() ?? '0',
                  Icons.mark_email_unread,
                ),
                _buildStatItem(
                  'Chat-Räume',
                  _chatRooms.length.toString(),
                  Icons.chat,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _sendPushNotification,
                    icon: const Icon(Icons.notifications),
                    label: const Text('Push'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _createBackup,
                    icon: const Icon(Icons.backup),
                    label: const Text('Backup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _syncWithCloud,
                    icon: const Icon(Icons.cloud_sync),
                    label: const Text('Sync'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Erstellt ein Statistik-Element
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Erstellt die Suchleiste
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Nachrichten suchen...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                    _loadMessagesForChatRoom(_chatRooms.first.id);
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            _loadMessagesForChatRoom(_chatRooms.first.id);
          } else {
            _searchMessages(value);
          }
        },
      ),
    );
  }

  /// Erstellt den leeren Zustand
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Keine Nachrichten gefunden',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Senden Sie Ihre erste Nachricht mit dem + Button',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Erstellt die Nachrichtenliste
  Widget _buildMessagesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageCard(message);
      },
    );
  }

  /// Erstellt eine Nachrichten-Karte
  Widget _buildMessageCard(Message message) {
    final isOwnMessage = message.senderId == _currentUserId;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOwnMessage ? Colors.blue : Colors.grey,
          child: Icon(
            _getMessageTypeIcon(message.type),
            color: Colors.white,
          ),
        ),
        title: Text(
          message.content,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Von: ${message.senderId} an: ${message.receiverId}'),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatusChip(message.status),
                const SizedBox(width: 8),
                if (message.isEncrypted)
                  const Chip(
                    label: Text('Verschlüsselt'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white, fontSize: 10),
                  ),
              ],
            ),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'encrypt':
                _encryptMessage(message.id);
                break;
              case 'decrypt':
                _decryptMessage(message.id);
                break;
            }
          },
          itemBuilder: (context) => [
            if (!message.isEncrypted)
              const PopupMenuItem(
                value: 'encrypt',
                child: Row(
                  children: [
                    Icon(Icons.lock),
                    SizedBox(width: 8),
                    Text('Verschlüsseln'),
                  ],
                ),
              ),
            if (message.isEncrypted)
              const PopupMenuItem(
                value: 'decrypt',
                child: Row(
                  children: [
                    Icon(Icons.lock_open),
                    SizedBox(width: 8),
                    Text('Entschlüsseln'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Erstellt einen Status-Chip
  Widget _buildStatusChip(MessageStatus status) {
    Color backgroundColor;
    String label;

    switch (status) {
      case MessageStatus.sent:
        backgroundColor = Colors.grey;
        label = 'Gesendet';
        break;
      case MessageStatus.delivered:
        backgroundColor = Colors.blue;
        label = 'Zugestellt';
        break;
      case MessageStatus.read:
        backgroundColor = Colors.green;
        label = 'Gelesen';
        break;
      case MessageStatus.failed:
        backgroundColor = Colors.red;
        label = 'Fehlgeschlagen';
        break;
      case MessageStatus.pending:
        backgroundColor = Colors.orange;
        label = 'Ausstehend';
        break;
      case MessageStatus.encrypted:
        backgroundColor = Colors.purple;
        label = 'Verschlüsselt';
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      backgroundColor: backgroundColor,
    );
  }

  /// Holt das Icon für einen Nachrichtentyp
  IconData _getMessageTypeIcon(MessageType type) {
    switch (type) {
      case MessageType.text:
        return Icons.message;
      case MessageType.image:
        return Icons.image;
      case MessageType.document:
        return Icons.description;
      case MessageType.voice:
        return Icons.mic;
      case MessageType.video:
        return Icons.videocam;
      case MessageType.system:
        return Icons.info;
      case MessageType.notification:
        return Icons.notifications;
    }
  }
}
