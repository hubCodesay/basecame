import 'package:basecam/pages/root/widgetes/arrow_back_button.dart';
import 'package:basecam/pages/root/widgetes/info_box.dart';
import 'package:basecam/pages/root/widgetes/info_box_horiz.dart';
import 'package:basecam/pages/root/widgetes/save_nav_bottom_bar.dart';
import 'package:basecam/pages/root/widgetes/tag_widget.dart';
import 'package:basecam/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LocationDay extends StatefulWidget {
  const LocationDay({super.key});

  @override
  State<LocationDay> createState() => _LocationDayState();
}

class _LocationDayState extends State<LocationDay> {
  final String imageUrl = "assets/images/map.png";
  final String title = "Location name";
  final String category = "Intermediate";
  final String distance = "13.1 km from Somename District";

  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: ThemeColors.background,
        elevation: 0,
        leading: ArrowButtonBack(onPressed: () => context.pop()),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset(
              _isBookmarked
                  ? 'assets/icons/bookmark.svg' // Іконка для стану "в закладках"
                  : 'assets/icons/bookmark.svg', // Іконка для стану "не в закладках"
              width: 24,
              height: 24,
            ),
            tooltip: _isBookmarked ? "Remove bookmark" : "Add bookmark",
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isBookmarked
                        ? "Location bookmarked"
                        : "Location bookmark removed",
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: SaveNavBottomBar(onSave: () {}, onNavigate: () {}),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Верхня частина з картою та кнопками поверх неї ---
            Stack(
              children: [
                Image.asset(
                  imageUrl,
                  height: 143,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 143,
                      color: Colors.grey[300],
                      child: Center(),
                    );
                  },
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  // --- Назва локації ---
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          maxLines: 2,
                          title,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          backgroundColor: ThemeColors.primaryColor,
                        ),
                        icon: SvgPicture.asset(
                          'assets/icons/camera.svg',
                          width: sizeIcon,
                          height: sizeIcon,
                          colorFilter: ColorFilter.mode(
                            ThemeColors.primaryTextColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // --- Категорія та дистанція ---
                  Row(
                    children: [
                      TagWidget(text: category),
                      const SizedBox(width: 12),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Transform.rotate(
                        angle: 30 * 3.1415927 / 180,
                        child: Icon(
                          Icons.navigation_outlined,
                          size: 16,
                          color: ThemeColors.greyColor,
                        ),
                      ),
                      const SizedBox(width: horizontalOffsetSpace),
                      Expanded(
                        // Дозволяє тексту дистанції переноситися, якщо він довгий
                        child: Text(
                          distance,
                          style: textTheme.bodySmall?.copyWith(
                            color: ThemeColors.greyColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InfoBoxHoriz(
                          asset: 'assets/icons/timer.svg',
                          text: "Spot Type",
                          subText: "Outdoor",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InfoBoxHoriz(
                          asset: 'assets/icons/vector.svg',
                          text: "Spot Type",
                          subText: "Outdoor",

                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InfoBoxHoriz(
                          asset: 'assets/icons/timer.svg',
                          text: "Spot Type",
                          subText: "Outdoor",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InfoBoxHoriz(
                          asset: 'assets/icons/vector.svg',
                          text: "Spot Type",
                          subText: "Outdoor",

                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
