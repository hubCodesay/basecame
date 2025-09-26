import 'package:basecam/ui/theme.dart';
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
          icon: SvgPicture.asset(
            'assets/icons/map.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              ThemeColors.greyColor,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => const SizedBox(
              width: 24,
              height: 24,
              child: Icon(Icons.map, size: 20, color: ThemeColors.greyColor),
            ),
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/map.svg',
            colorFilter: const ColorFilter.mode(
              ThemeColors.blackColor,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => const SizedBox(
              width: 24,
              height: 24,
              child: Icon(Icons.map, size: 20, color: ThemeColors.blackColor),
            ),
          ),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/chat.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              ThemeColors.greyColor,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.chat_bubble_outline,
                size: 20,
                color: ThemeColors.greyColor,
              ),
            ),
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/chat.svg',
            colorFilter: const ColorFilter.mode(
              ThemeColors.blackColor,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.chat_bubble,
                size: 20,
                color: ThemeColors.blackColor,
              ),
            ),
          ),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/shop.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              ThemeColors.greyColor,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 20,
                color: ThemeColors.greyColor,
              ),
            ),
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/shop.svg',
            colorFilter: const ColorFilter.mode(
              ThemeColors.blackColor,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.shopping_bag,
                size: 20,
                color: ThemeColors.blackColor,
              ),
            ),
          ),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/events.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              ThemeColors.greyColor,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.event_outlined,
                size: 20,
                color: ThemeColors.greyColor,
              ),
            ),
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/events.svg',
            colorFilter: const ColorFilter.mode(
              ThemeColors.blackColor,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => const SizedBox(
              width: 24,
              height: 24,
              child: Icon(Icons.event, size: 20, color: ThemeColors.blackColor),
            ),
          ),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/profile.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              ThemeColors.greyColor,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.person_outline,
                size: 20,
                color: ThemeColors.greyColor,
              ),
            ),
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/profile.svg',
            colorFilter: const ColorFilter.mode(
              ThemeColors.blackColor,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.person,
                size: 20,
                color: ThemeColors.blackColor,
              ),
            ),
          ),
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
