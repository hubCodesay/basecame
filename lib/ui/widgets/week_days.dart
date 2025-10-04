import 'package:flutter/material.dart';

class WeekDaysSelector extends StatefulWidget {
  final List<String> days;
  final List<int> dates;
  final int initialIndex;
  final ValueChanged<int> onDaySelected;

  const WeekDaysSelector({
    super.key,
    required this.days,
    required this.dates,
    this.initialIndex = 0,
    required this.onDaySelected,
  });

  @override
  State<WeekDaysSelector> createState() => _WeekDaysSelectorState();
}

class _WeekDaysSelectorState extends State<WeekDaysSelector> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.days.length, (index) {
        final isSelected = index == selectedIndex;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            widget.onDaySelected(index);
          },
          child: Container(
            width: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey.shade200 : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  widget.days[index],
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.dates[index].toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
