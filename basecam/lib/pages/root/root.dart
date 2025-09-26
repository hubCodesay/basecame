import 'package:flutter/material.dart';

import 'package:basecam/pages/root/chats/chats.dart';
import 'package:basecam/pages/root/events/events.dart';
import 'package:basecam/pages/root/map/map.dart';
import 'package:basecam/pages/root/profile/profile.dart';
import 'package:basecam/pages/root/shop/shop.dart';
import 'package:basecam/pages/root/widgetes/navigation.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key, required this.child});
  final Widget child;

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  // static const TextStyle optionStyle = TextStyle(
  //   fontSize: 30,
  //   fontWeight: FontWeight.bold,
  // );
  static const List<Widget> _widgetOptions = <Widget>[
    MapTab(),
    ChatsTab(),
    ShopTab(),
    EventsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
