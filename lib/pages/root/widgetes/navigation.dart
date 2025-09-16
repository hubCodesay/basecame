import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined,   textDirection: TextDirection.rtl,),
          label: 'Map',
        ),
        // BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
        BottomNavigationBarItem(

          icon: SvgPicture.asset(
            'assets/icons/chat.svg',
            width: 24,
            height: 24,
          ),
          label: 'Chats',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.language),
          label: 'Shop',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.grid_view),
          label: 'Events',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      // fixedColor: Colors.red,
      currentIndex: selectedIndex,

      onTap: onTap,
    );
  }
}
