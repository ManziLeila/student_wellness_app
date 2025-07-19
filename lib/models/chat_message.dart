// lib/models/chat_message.dart
class ChatMessage {
  final String id;
  final String senderId;
  final String peerId;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.peerId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'],
    senderId: json['senderId'],
    peerId: json['peerId'],
    text: json['text'],
    timestamp: DateTime.parse(json['timestamp']),
    isRead: json['isRead'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'peerId': peerId,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
  };
}