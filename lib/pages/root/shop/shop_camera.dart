import 'package:basecam/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RentalItemPage extends StatefulWidget {
  final String? gearId;
  const RentalItemPage({super.key, this.gearId});

  @override
  State<RentalItemPage> createState() => _RentalItemPageState();
}

class _RentalItemPageState extends State<RentalItemPage> {
  String title = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadGear();
  }

  Future<void> _loadGear() async {
    final id = widget.gearId;
    if (id == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('gear')
          .doc(id)
          .get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          title = data?['title'] as String? ?? 'Untitled';
        });
      } else {
        setState(() => title = 'Not found');
      }
    } catch (e) {
      setState(() => title = 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Handle share action
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            color: ThemeColors.greyColor,
            child: const Center(child: Text('Image Placeholder')),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: ThemeColors.greyColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Text('1/4', style: TextStyle(fontSize: 12.0)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          // Title and Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Description text about something on this page that can be long or short. It can be pretty long and exp...',
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  children: [
                    Chip(label: const Text('For rent')),
                    Chip(label: const Text('Camera')),
                    Chip(label: const Text('Tag 1')),
                    Chip(label: const Text('Tag 2')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          // Rating
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12.0,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(
                    Icons.star,
                    size: 16.0,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 8.0),
                const Text('4.95 22 reviews'),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('>')),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          // Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text(
              'Name',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16.0),
          // Calendar
          Container(
            height: 60.0,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCalendarDay('Mon', 8),
                _buildCalendarDay('Tue', 9),
                _buildCalendarDay('Wed', 10),
                _buildCalendarDay('Thu', 11, isSelected: true),
                _buildCalendarDay('Fri', 12),
                _buildCalendarDay('Sat', 13),
                _buildCalendarDay('Sun', 14),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                // primary: Colors.black,
                minimumSize: const Size(double.infinity, 50.0),
              ),
              child: const Text(
                'Book now  \$25/day',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(String day, int date, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[300] : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: const TextStyle(fontSize: 12.0)),
          Text(date.toString(), style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}

// // Usage example
// void main() {
//   runApp(MaterialApp(home: const RentalItemPage()));
// }
