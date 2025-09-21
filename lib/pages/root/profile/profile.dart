import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:basecam/app_path.dart';
import 'package:basecam/pages/root/widgetes/event_card.dart';
import 'package:basecam/pages/root/widgetes/product_card.dart';
import 'package:basecam/pages/root/widgetes/rating.dart';
import 'package:basecam/ui/theme.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int selectedTabIndex = 0;
  final double itemAxisSpacing = 8.0;

  // Функція, що повертає контент для кожного таба
  Widget _buildSelectedTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: itemAxisSpacing,
            crossAxisSpacing: itemAxisSpacing,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            return ProductCard(
              productName: "Long Item name $index",
              price: index.isEven ? "\$${10 + index}/hr" : "\$${50 + index * 2}",
              tag: index.isEven ? "For rent" : "Selling",
              location: "Berlin",
              timestamp: "Yesterday ${18 + index % 6}:24",
              imageUrl: "https://picsum.photos/seed/equip$index/300/400",
            );
          },
        );
      case 1:
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: index == 5 ? 0 : itemAxisSpacing),
              child: EventCard(
                imageUrl: "https://picsum.photos/seed/loc$index/400/200",
                category: "City Tour",
                rating: "4.${8 - index % 3} (${12 + index})",
                participantCount: "${34 + index * 2}",
                title: "Amazing Location $index",
                date: "1${index % 9}.0${5 + index % 4}",
                description:
                "Description about location $index. Can be long or short, detailing the experience.",
                distance: "${5 + index * 0.3} km from you",
                onLearnMorePressed: () {
                  print("Learn more pressed on location $index");
                },
              ),
            );
          },
        );
      case 2:
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: index == 2 ? 0 : itemAxisSpacing),
              child: Rating(
                title: index == 0
                    ? "Excellent Service"
                    : (index == 1 ? "Very Good" : "Satisfactory"),
                description:
                "Really enjoyed renting here. The equipment was in top condition and the staff was helpful.",
                date: "Sep ${5 + index}, 2025",
                tags: index == 0
                    ? ["Friendly", "Fast", "Reliable"]
                    : (index == 1 ? ["Helpful", "Good Value"] : ["Okay"]),
                rating: 5 - index,
              ),
            );
          },
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: ThemeColors.grey4Color,
                    child: const Icon(
                      Icons.person,
                      size: 36,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 36),
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your name",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/favorites.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                // Icon(Icons.star, size: 22, color: ThemeColors.blackColor),
                                const SizedBox(width: 6),
                                const Text(
                                  "4.95",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "22 reviews",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: ThemeColors.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Кнопки Profile і Settings
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: ThemeColors.silverColor,
                        foregroundColor: ThemeColors.blackColor,
                      ),
                      onPressed: () => context.push(AppPath.editProfile.path),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/profile.svg',
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 8),
                          Text('Profile'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: ThemeColors.silverColor,
                        foregroundColor: ThemeColors.blackColor,
                      ),
                      onPressed: () => context.push(AppPath.settings.path),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/settings.svg',
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 8),
                          Text('Settings'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: CupertinoSlidingSegmentedControl<int>(
                  backgroundColor: ThemeColors.silverColor,
                  thumbColor: ThemeColors.pureBlackColor,
                  padding: const EdgeInsets.all(4),
                  groupValue: selectedTabIndex,
                  onValueChanged: (value) => setState(() => selectedTabIndex = value!),
                  children: {
                    0: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          'Equipments',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: selectedTabIndex == 0 ? Colors.white : ThemeColors.greyColor,
                          ),
                        ),
                      ),
                    ),
                    1: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          'Locations',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: selectedTabIndex == 1 ? Colors.white : ThemeColors.greyColor,
                          ),
                        ),
                      ),
                    ),
                    2: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          'Rating',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: selectedTabIndex == 2 ? Colors.white : ThemeColors.greyColor,
                          ),
                        ),
                      ),
                    ),
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Контент, що скролиться, з прозорістю
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: Container(
                    key: ValueKey<int>(selectedTabIndex),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildSelectedTabContent(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}