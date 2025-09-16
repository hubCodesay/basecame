import 'package:flutter/material.dart';
import 'package:basecam/pages/root/chats/chats_details.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Active chats",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: 6,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final isGroup = index == 2 || index == 5;
          final chatTitle = isGroup ? "Group Chat Title" : "Chat Title";

          return ChatTile(
            title: chatTitle,
            subtitle: isGroup
                ? "Name:  Sounds awesome, let`s keep it simple and..."
                : "Sounds awesome, let`s keep it simple and...",
            isGroup: isGroup,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}

class ChatTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isGroup;
  final VoidCallback? onTap;

  const ChatTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.isGroup = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade200,
      ),
      title: Row(
        children: [
          if (isGroup) ...[
            const Icon(Icons.group, size: 16, color: Colors.black),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 13,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.bookmark_border, color: Colors.black),
      onTap: onTap,
    );
  }
}
