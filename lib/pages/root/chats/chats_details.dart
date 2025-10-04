import 'package:basecam/ui/widgets/send.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> _messages = [
    {'text': "I hope you’re enjoying your day as much as I do", 'isSent': false},
    {'text': "Everything is amazing", 'isSent': false},
    {'text': "Weather is nice", 'isSent': false},
    {'text': "Everything is amazing", 'isSent': true},
    {'text': "Weather is nice", 'isSent': true},
    {'text': "I hope you’re enjoying your day as much as I do", 'isSent': false},
    {'text': "Everything is amazing", 'isSent': false},
    {'text': "Weather is nice", 'isSent': false},
    {'text': "Everything is amazing", 'isSent': true},
    {'text': "Weather is nice", 'isSent': true},
  ];

  bool _isBookmarked = false;

    void _handleEventsSearchTextChanged(String newText) {
    // TODO: Implement event filtering logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Chat Title'),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              _isBookmarked
                  ? 'assets/icons/bookmark_filled.svg'
                  : 'assets/icons/bookmark.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              setState(() => _isBookmarked = !_isBookmarked);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isSent = message['isSent'] as bool;
                    // останнє повідомлення групи
                    final bool isLastInGroup =
                        index == _messages.length - 1 ||
                            _messages[index + 1]['isSent'] != isSent;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: isSent
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isSent)
                            if (isLastInGroup)
                              const CircleAvatar(
                                radius: 16,
                                backgroundImage: AssetImage('assets/pexels.jpg'),
                              )
                            else
                              const SizedBox(width: 32),

                          if (!isSent) const SizedBox(width: 6),

                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 260,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isSent ? Colors.black : Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: Radius.circular(isSent ? 16 : 0),
                                  bottomRight: Radius.circular(isSent ? 0 : 16),
                                ),
                              ),
                              child: Text(
                                message['text'],
                                style: TextStyle(
                                  color: isSent ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SendWidget(
                      onChanged: _handleEventsSearchTextChanged,
                      hintText: "Message",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
