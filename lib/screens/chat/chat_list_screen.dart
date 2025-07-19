import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peer Support'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => chatProvider.loadPeers(authProvider.user?.uid ?? ''),
          ),
        ],
      ),
      body: FutureBuilder(
        future: chatProvider.loadPeers(authProvider.user?.uid ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatProvider.lastError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load peers.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    chatProvider.lastError!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    onPressed: () => chatProvider.loadPeers(authProvider.user?.uid ?? ''),
                  ),
                ],
              ),
            );
          }

          if (chatProvider.peers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No peers available yet.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'When you start a chat with someone, they will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: chatProvider.peers.length,
            itemBuilder: (context, index) {
              final peer = chatProvider.peers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    peer.name[0],
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ),
                title: Text(peer.name),
                subtitle: Text('Last active: ${peer.lastActive}'),
                trailing: peer.unreadCount > 0
                    ? CircleAvatar(
                  radius: 12,
                  backgroundColor: theme.colorScheme.error,
                  child: Text(
                    peer.unreadCount.toString(),
                    style: TextStyle(
                      color: theme.colorScheme.onError,
                      fontSize: 12,
                    ),
                  ),
                )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        peerId: peer.id,
                        peerName: peer.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}