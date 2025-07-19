// lib/models/chat_peer.dart
class ChatPeer {
  final String id;
  final String name;
  final String? avatarUrl;
  final DateTime lastActive;
  final int unreadCount;

  ChatPeer({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.lastActive,
    this.unreadCount = 0,
  });

  factory ChatPeer.fromJson(Map<String, dynamic> json) => ChatPeer(
    id: json['id'],
    name: json['name'],
    avatarUrl: json['avatarUrl'],
    lastActive: DateTime.parse(json['lastActive']),
    unreadCount: json['unreadCount'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatarUrl': avatarUrl,
    'lastActive': lastActive.toIso8601String(),
    'unreadCount': unreadCount,
  };

  String get status {
    final now = DateTime.now();
    final difference = now.difference(lastActive);
    if (difference.inMinutes < 5) {
      return 'Online';
    } else if (difference.inMinutes < 60) {
      return 'Last seen ${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return 'Last seen ${difference.inHours} hr ago';
    } else {
      return 'Last seen ${difference.inDays} days ago';
    }
  }
}