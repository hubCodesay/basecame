import 'package:basecam/ui/theme.dart';
import 'package:basecam/ui/widgets/arrow_back_button.dart';
import 'package:flutter/material.dart';
import 'package:basecam/pages/root/chats/chats_details.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

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
        leading: ArrowButtonBack(onPressed: () => Navigator.pop(context)),
        // FilterButton(onPressed: () => Navigator.pop(context)),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text(
          "Active chats",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(
            height: 1,
            thickness: 1.0,
            color: ThemeColors.silverColor,
            indent: 16,
            endIndent: 16,
          ),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              itemCount: _chatDataList.length + (_isLoading ? 1 : 0),
              separatorBuilder: (context, index) {
                if (index >= _chatDataList.length - 1) {
                  return const SizedBox.shrink(); // Немає розділювача після останнього елемента або перед індикатором
                }

                final currentChat = _chatDataList[index];
                final nextChat = _chatDataList[index + 1];
                final bool currentChatIsBookmarked = currentChat['isBookmarked'] as bool;
                final bool nextChatIsBookmarked = nextChat['isBookmarked'] as bool;

                // --- 2. ОСОБЛИВА ЛІНІЯ МІЖ ЗАКРІПЛЕНИМИ ТА НЕЗАКРІПЛЕНИМИ ---
                // Ставиться, якщо поточний чат закріплений, а наступний - ні,
                // і поточний чат є останнім із закріплених.
                if (currentChatIsBookmarked &&
                    !nextChatIsBookmarked &&
                    index == _numberOfBookmarkedItems - 1) {
                  return const Divider(
                    height: 1,
                    thickness: 1.0,
                    color: ThemeColors.silverColor,
                    indent: 16,
                    endIndent: 16,
                  );
                }
                return const SizedBox.shrink();
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

class ChatTile extends StatelessWidget {
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
    required this.initialIsBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    Widget? trailingWidget;
    if (initialIsBookmarked) {
      trailingWidget = Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: SvgPicture.asset(
          'assets/icons/bookmark_filled.svg',
          height: 24,
        ),
      );
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade200,
      ),
      title: Row(
        children: [
          if (isGroup) ...[
            SvgPicture.asset(
              'assets/icons/group.svg',
              height: 24,
            ),
            // const Icon(Icons.group, size: 16, color: Colors.black),
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
        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailingWidget,
      onTap: onTap,
    );
  }
}