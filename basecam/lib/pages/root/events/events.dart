// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:basecam/pages/root/widgetes/event_card.dart';
import 'package:basecam/pages/root/widgetes/filter_button.dart';
import 'package:basecam/pages/root/widgetes/search.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  late int selectedIndex;
  late List<String> days;
  late List<int> dates;
  late List<DateTime> weekDates;

  final TextEditingController _eventsSearchController = TextEditingController();
  final FocusNode _eventsSearchFocusNode = FocusNode();
  TextAlign _currentEventsSearchTextAlign = TextAlign.center;

  @override
  void initState() {
    super.initState();
    _generateWeekData();

    final today = DateTime.now();
    selectedIndex = weekDates.indexWhere(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
    if (selectedIndex == -1) {
      selectedIndex = (weekDates.length / 2).floor();
    }

    _eventsSearchFocusNode.addListener(_onEventsSearchFocusChange);
    _eventsSearchController.addListener(_onEventsSearchTextChange);
  }

  @override
  void dispose() {
    _eventsSearchController.dispose();
    _eventsSearchFocusNode.removeListener(_onEventsSearchFocusChange);
    _eventsSearchController.removeListener(_onEventsSearchTextChange);
    _eventsSearchFocusNode.dispose();
    super.dispose();
  }

  void _onEventsSearchFocusChange() {
    setState(() {
      if (_eventsSearchFocusNode.hasFocus ||
          _eventsSearchController.text.isNotEmpty) {
        _currentEventsSearchTextAlign = TextAlign.start;
      } else {
        _currentEventsSearchTextAlign = TextAlign.center;
      }
    });
  }

  void _onEventsSearchTextChange() {
    setState(() {
      if (_eventsSearchController.text.isNotEmpty) {
        _currentEventsSearchTextAlign = TextAlign.start;
      } else if (!_eventsSearchFocusNode.hasFocus) {
        _currentEventsSearchTextAlign = TextAlign.center;
      }
    });
  }

  void _generateWeekData() {
    days = [];
    dates = [];
    weekDates = [];
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    for (int i = 0; i < 7; i++) {
      final dayDate = startOfWeek.add(Duration(days: i));
      weekDates.add(dayDate);
      days.add(DateFormat.E().format(dayDate));
      dates.add(dayDate.day);
    }
  }

  void _handleEventsSearchTextChanged(String newText) {
    print("Search text in EventsTab changed to: $newText");
    // TODO: Implement event filtering logic
  }

  void _handleFilterPressed() {
    print("Filter icon tapped in EventsTab!");
    // TODO: Implement filter action (e.g., show a dialog)
  }

  @override
  Widget build(BuildContext context) {
    if (weekDates.isEmpty) {
      _generateWeekData();
      final today = DateTime.now();
      selectedIndex = weekDates.indexWhere(
        (date) =>
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day,
      );
      if (selectedIndex == -1) selectedIndex = (weekDates.length / 2).floor();
      if (weekDates.isEmpty) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(days.length, (index) {
                  final isSelected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      width: 44,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.grey.shade200
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            days[index],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dates[index].toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            /// Search Bar + Filter Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: SearchBarWidget(
                      onChanged: _handleEventsSearchTextChanged,
                      hintText: "Search",
                    ),
                  ),
                  SizedBox(width: 8),

                  /// Button Filter
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilterButton(
                          onPressed: _handleFilterPressed,
                          icon: SvgPicture.asset(
                            'assets/icons/filter.svg',
                            width: 24,
                            height: 24,
                          ),
                          dropIcon: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Upcoming events",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            /// Список івентів
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return EventCard(
                    imageUrl: "https://picsum.photos/400/200?random=$index",
                    category: "Intermediate",
                    rating: "4.95 (3)",
                    participantCount: "48",
                    title: "Section title",
                    date: "14.05",
                    description:
                        "Description text about something on this page that can be long or short. It can be pretty long and expand to two lines.",
                    distance: "13.1 km from You",
                    onLearnMorePressed: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
