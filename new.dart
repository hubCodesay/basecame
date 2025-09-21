import 'package:flutter/material.dart';
import 'package:basecam/pages/root/chats/chats_details.dart'; // Переконайтеся, що цей імпорт потрібен
import 'package:flutter_svg/svg.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  final List<Map<String, dynamic>> _chatDataList = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 0;
  final int _itemsPerPage = 15;

  // Кількість закріплених чатів
  final int _numberOfBookmarkedItems = 2; // Рівно 2 закріплених

  @override
  void initState() {
    super.initState();
    _loadMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    List<Map<String, dynamic>> newItems = List.generate(_itemsPerPage, (i) {
      final overallIndex = _currentPage * _itemsPerPage + i;
      final isGroup = overallIndex % 5 == 0;

      // Закріплені лише перші '_numberOfBookmarkedItems' елементи
      final bool isBookmarkedForThisItem =
          overallIndex < _numberOfBookmarkedItems;

      return {
        'id': overallIndex,
        'title': isGroup ? "Group Chat $overallIndex" : "Chat $overallIndex",
        'subtitle': "Subtitle for chat $overallIndex...",
        'isGroup': isGroup,
        'isBookmarked': isBookmarkedForThisItem,
      };
    });

    setState(() {
      _chatDataList.addAll(newItems);
      _isLoading = false;
      _currentPage++;
    });
  }

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
      body: Column(
        children: [
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              itemCount: _chatDataList.length + (_isLoading ? 1 : 0),
              separatorBuilder: (context, index) {
                if (index >= _chatDataList.length - 1 && _isLoading) {
                  return const SizedBox.shrink();
                }
                if (_chatDataList.isEmpty ||
                    index >= _chatDataList.length - 1) {
                  return const Divider(
                      height: 1, thickness: 0.5, color: Colors.grey);
                }

                final currentChat = _chatDataList[index];
                final nextChat = _chatDataList[index + 1];
                final bool currentChatIsBookmarked =
                currentChat['isBookmarked'] as bool;
                final bool nextChatIsBookmarked =
                nextChat['isBookmarked'] as bool;

                if (currentChatIsBookmarked &&
                    !nextChatIsBookmarked &&
                    index == _numberOfBookmarkedItems - 1) {
                  return const Divider(
                    height: 1,
                    thickness: 2.0,
                    color: Colors.red,
                    indent: 16,
                    endIndent: 16,
                  );
                }
                return const Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Colors.grey,
                );
              },
              itemBuilder: (context, index) {
                if (index == _chatDataList.length && _isLoading) {
                  return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ));
                }
                if (index >= _chatDataList.length) {
                  return const SizedBox.shrink();
                }

                final chatData = _chatDataList[index];
                return ChatTile(
                  title: chatData['title'] as String,
                  subtitle: chatData['subtitle'] as String,
                  isGroup: chatData['isGroup'] as bool,
                  initialIsBookmarked: chatData['isBookmarked'] as bool,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChatPage()),
                    );
                    print("Tapped on chat: ${chatData['title']}");
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

// ChatTile тепер StatefulWidget
class ChatTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isGroup;
  final VoidCallback? onTap;
  final bool initialIsBookmarked;

  const ChatTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.isGroup = false,
    this.onTap,
    this.initialIsBookmarked = false,
  });

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.initialIsBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    Widget? trailingWidget;

    if (_isBookmarked) {
      // Якщо чат закріплений, показуємо НЕІНТЕРАКТИВНУ іконку закладки
      trailingWidget = Padding(
        padding: const EdgeInsets.only(right: 8.0), // Відступ для іконки
        child: SvgPicture.asset(
          'assets/icons/bookmark_filled.svg',
          // Використовуйте іконку для ЗАПОВНЕНОЇ закладки
          // Або ваш 'assets/icons/bookmark.svg', якщо він виглядає як заповнений
          width: 24,
          height: 24,
          // colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn), // Якщо потрібно змінити колір
        ),
      );
    }
    // Якщо _isBookmarked == false, trailingWidget залишається null (нічого не буде в trailing)

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade200,
      ),
      title: Row(
        children: [
          if (widget.isGroup) ...[
            const Icon(Icons.group, size: 16, color: Colors.black),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              widget.title,
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
        widget.subtitle,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailingWidget,
      // Встановлюємо визначений trailingWidget
      onTap: widget.onTap,
    );
  }
}
