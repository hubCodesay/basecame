import 'package:basecam/pages/root/widgetes/arrow_back_button.dart';
import 'package:basecam/pages/root/widgetes/info_box.dart';
import 'package:basecam/pages/root/widgetes/save_nav_bottom_bar.dart';
import 'package:basecam/pages/root/widgetes/tag_widget.dart';
import 'package:basecam/pages/root/widgetes/waypoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:basecam/ui/theme.dart';
import 'package:go_router/go_router.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final String imageUrl = "assets/images/map.png";
  final String category = "Intermediate";
  final String rating = "4.95 (3)";
  final String participantCount = "48";
  final String title = "Location name Location name";
  final String date = "14.05";
  final String description =
      "Description text about something on this page that can be long or short. It can be pretty long and expand …";
  final String distance = "13.1 km from Somename District";
  bool _isBookmarked = false;
  // Color get appBarIconColor => Theme.of(context).colorScheme.onSurface;

  // --- Стан для Switch ---
  bool light0 = true;
  bool light1 = true;

  final List<Waypoint> _waypoints = [
    Waypoint(
      icon: Icons.flag_outlined,
      title: 'DERWE',
      titleIcon: SizedBox(child: Image.asset("assets/pexels.jpg")),
      subtitle:
          'Description text about something on this page that can be long or short. It can be pretty long and explaining information about the',
    ),
    Waypoint(
      icon: Icons.location_on_outlined,
      title: 'Scenic View',
      subtitle: 'Panoramic view point',
    ),
    Waypoint(
      icon: Icons.sports_score_outlined,
      title: 'Destination',
      subtitle: 'End of the trail',
    ),
    Waypoint(
      icon: Icons.flag_outlined,
      title: 'DERWE',
      titleIcon: SizedBox(child: Image.asset("assets/pexels.jpg")),
      subtitle:
      'Description text about something on this page that can be long or short. It can be pretty long and explaining information about the',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Визначимо текстові стилі тут для легшого доступу та консистентності
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
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
      // --- Нижня панель з кнопками ---
      bottomNavigationBar: SaveNavBottomBar(onSave: () {}, onNavigate: () {}),
      // --- Основний вміст екрану ---
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

            // --- Секція з детальною інформацією ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: vertSpace),
                  // --- Опис ---
                  Text(
                    description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: ThemeColors.greyColor,
                    ),
                  ),
                  const SizedBox(height: vertSpace),

                  // --- Рейтинг і учасники ---
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 20,
                        color: ThemeColors.primaryColor,
                      ),
                      const SizedBox(width: horizontalOffsetSpace),
                      Text(
                        rating,
                        // style: textTheme.bodyMedium?.copyWith(
                        //   fontWeight: FontWeight.w500,
                        // ),
                      ),
                      const SizedBox(width: 16), // Збільшив відступ
                      SvgPicture.asset(
                        'assets/icons/profile.svg',
                        width: sizeIcon,
                        height: sizeIcon,
                      ),
                      const SizedBox(width: 4),
                      Text("$participantCount", style: textTheme.bodyMedium),
                    ],
                  ),

                  /// 🔹 Лінія №2
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: ThemeColors.greyColor),
                  const SizedBox(height: 8),
                  // --- Характеристики ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InfoBox(
                          asset: 'assets/icons/timer.svg',
                          text: "3h 14m",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InfoBox(
                          asset: 'assets/icons/vector.svg',
                          text: "12.4 km",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InfoBox(
                          asset: 'assets/icons/diametr.svg',
                          text: "3h 14m",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InfoBox(
                          asset: 'assets/icons/up.svg',
                          text: "100 m",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- Save offline ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/download.svg',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: horizontalSpace),
                      Expanded(
                        child: Text(
                          "Save offline",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SwitchTheme(
                        data: SwitchThemeData(
                          thumbColor: WidgetStateProperty.all(
                            ThemeColors.background,
                          ),
                          trackColor: WidgetStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            return states.contains(WidgetState.selected)
                                ? ThemeColors
                                      .switchColor // трек у включеному стані
                                : ThemeColors
                                      .switchColor; // трек у вимкненому стані
                          }),
                          trackOutlineColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Switch(
                          value: light1,
                          onChanged: (bool value) {
                            setState(() {
                              light1 = value;
                            });
                          },
                          splashRadius: 0,
                          thumbIcon: WidgetStateProperty.resolveWith<Icon>((
                            states,
                          ) {
                            return const Icon(
                              Icons.circle,
                              size: 12,
                              color: ThemeColors.background,
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // --- Waypoints section ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Waypoints",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Waypoints(waypoints: _waypoints),
                      const SizedBox(height: 8),
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
