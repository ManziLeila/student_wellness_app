import 'package:flutter/cupertino.dart';

import '../models/chat_message.dart';
import '../models/chat_peer.dart';
import '../services/database_service.dart';

class ChatProvider with ChangeNotifier {
  final DatabaseService _dbService;
  final List<ChatMessage> _messages = [];
  List<ChatPeer> _peers = [];
  String? lastError;

  ChatProvider(this._dbService);

  List<ChatMessage> get messages => _messages;
  List<ChatPeer> get peers => _peers;

  // Stream of messages for a specific peer
  Stream<List<ChatMessage>> getMessages({required String userId, required String peerId}) {
    return _dbService.getMessagesStream(userId, peerId);
  }

  // Send a message
  Future<void> sendMessage(ChatMessage message) async {
    await _dbService.sendMessage(message);
    notifyListeners();
  }

  // Load available peers for chat
  Future<void> loadPeers(String userId) async {
    lastError = null;
    try {
      _peers = await _dbService.getChatPeers(userId);
    } catch (e) {
      lastError = e.toString();
      _peers = [];
    }
    notifyListeners();
  }

  // Mark messages as read
  Future<void> markAsRead(String userId, String peerId) async {
    await _dbService.markMessagesAsRead(userId, peerId);
    notifyListeners();
  }
}