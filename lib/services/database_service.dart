import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_wellness_app/models/user_profile.dart';
import 'package:student_wellness_app/models/mood.dart';
import 'package:student_wellness_app/models/journal_entry.dart';
import 'package:student_wellness_app/models/chat_message.dart';
import 'package:student_wellness_app/models/chat_peer.dart';

abstract class DatabaseService {
  // User Profile Operations
  Future<UserProfile?> getUserProfile(String userId);
  Future<void> saveUserProfile(UserProfile profile);

  // Mood Operations
  Future<List<Mood>> getMoods(String userId);
  Future<void> addMood(String userId, Mood mood);
  Future<void> updateMood(String userId, Mood mood);
  Future<void> deleteMood(String userId, String moodId);

  // Journal Operations
  Future<List<JournalEntry>> getJournalEntries(String userId);
  Future<void> addJournalEntry(String userId, JournalEntry entry);
  Future<void> updateJournalEntry(String userId, JournalEntry entry);
  Future<void> deleteJournalEntry(String userId, String entryId);

  // Chat Operations
  Future<List<ChatMessage>> getMessages(String userId, String peerId);
  Stream<List<ChatMessage>> getMessagesStream(String userId, String peerId);
  Future<void> sendMessage(ChatMessage message);
  Future<List<ChatPeer>> getChatPeers(String userId);
  Future<void> markMessagesAsRead(String userId, String peerId);
}

class FirebaseDatabaseService implements DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Profile Implementation
  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? UserProfile.fromJson(doc.data()!) : null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.userId)
          .set(profile.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  // Mood Operations Implementation
  @override
  Future<List<Mood>> getMoods(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('moods')
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs.map((doc) => Mood.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get moods: $e');
    }
  }

  @override
  Future<void> addMood(String userId, Mood mood) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('moods')
          .doc(mood.id)
          .set(mood.toJson());
    } catch (e) {
      throw Exception('Failed to add mood: $e');
    }
  }

  @override
  Future<void> updateMood(String userId, Mood mood) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('moods')
          .doc(mood.id)
          .update(mood.toJson());
    } catch (e) {
      throw Exception('Failed to update mood: $e');
    }
  }

  @override
  Future<void> deleteMood(String userId, String moodId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('moods')
          .doc(moodId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete mood: $e');
    }
  }

  // Journal Operations Implementation
  @override
  Future<List<JournalEntry>> getJournalEntries(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('journals')
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs.map((doc) => JournalEntry.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get journal entries: $e');
    }
  }

  @override
  Future<void> addJournalEntry(String userId, JournalEntry entry) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journals')
          .doc(entry.id)
          .set(entry.toJson());
    } catch (e) {
      throw Exception('Failed to add journal entry: $e');
    }
  }

  @override
  Future<void> updateJournalEntry(String userId, JournalEntry entry) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journals')
          .doc(entry.id)
          .update(entry.toJson());
    } catch (e) {
      throw Exception('Failed to update journal entry: $e');
    }
  }

  @override
  Future<void> deleteJournalEntry(String userId, String entryId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journals')
          .doc(entryId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete journal entry: $e');
    }
  }

  // Chat Operations Implementation
  @override
  Future<List<ChatMessage>> getMessages(String userId, String peerId) async {
    try {
      final chatId = _generateChatId(userId, peerId);
      final snapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  @override
  Stream<List<ChatMessage>> getMessagesStream(String userId, String peerId) {
    final chatId = _generateChatId(userId, peerId);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatMessage.fromJson(doc.data()))
        .toList());
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    try {
      final chatId = _generateChatId(message.senderId, message.peerId);
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(message.id)
          .set(message.toJson());
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<List<ChatPeer>> getChatPeers(String userId) async {
    try {
      // Get all chats where the user is involved
      final chats = await _firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .get();

      // Extract peer IDs and get their profiles
      final peers = <ChatPeer>[];
      for (final chat in chats.docs) {
        final participants = List<String>.from(chat.data()['participants']);
        final peerId = participants.firstWhere((id) => id != userId);

        final peerProfile = await getUserProfile(peerId);
        if (peerProfile != null) {
          // Get unread count
          final unreadCount = await _getUnreadCount(userId, chat.id);

          peers.add(ChatPeer(
            id: peerId,
            name: peerProfile.displayName,
            avatarUrl: peerProfile.avatarUrl,
            lastActive: DateTime.now(), // Should be fetched from user profile
            unreadCount: unreadCount,
          ));
        }
      }
      return peers;
    } catch (e) {
      throw Exception('Failed to get chat peers: $e');
    }
  }

  @override
  Future<void> markMessagesAsRead(String userId, String peerId) async {
    try {
      final chatId = _generateChatId(userId, peerId);
      final unreadMessages = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('senderId', isEqualTo: peerId)
          .get();

      final batch = _firestore.batch();
      for (final doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  // Helper Methods
  String _generateChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '$uid1-$uid2' : '$uid2-$uid1';
  }

  Future<int> _getUnreadCount(String userId, String chatId) async {
    final snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('senderId', isNotEqualTo: userId)
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}