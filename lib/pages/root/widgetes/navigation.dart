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
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/map.svg',
            colorFilter: const ColorFilter.mode(
              ThemeColors.blackColor,
              BlendMode.srcIn,
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
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/chat.svg',
            colorFilter: const ColorFilter.mode(
              ThemeColors.blackColor,
              BlendMode.srcIn,
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
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/shop.svg',
            colorFilter: const ColorFilter.mode(
              ThemeColors.blackColor,
              BlendMode.srcIn,
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
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/events.svg',
            colorFilter: const ColorFilter.mode(
              ThemeColors.blackColor,
              BlendMode.srcIn,
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
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/profile.svg',
            colorFilter: const ColorFilter.mode(
              ThemeColors.blackColor,
              BlendMode.srcIn,
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
