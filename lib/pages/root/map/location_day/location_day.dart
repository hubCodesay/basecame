import 'package:basecam/pages/root/widgetes/arrow_back_button.dart';
import 'package:basecam/pages/root/widgetes/info_box.dart';
import 'package:basecam/pages/root/widgetes/info_box_horiz.dart';
import 'package:basecam/pages/root/widgetes/info_box_photo.dart';
import 'package:basecam/pages/root/widgetes/product_card.dart';
import 'package:basecam/pages/root/widgetes/rating_list.dart';
import 'package:basecam/pages/root/widgetes/ratings.dart';
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
  final String rating = "4.95 (3)";
  final String participantCount = "48";
  final String description =
      "Description text about something on this page that can be long or short. It can be pretty long and expand …";
  final votes = [4, 4, 2, 2, 5, 5, 5, 3, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          asset: 'assets/icons/spot.svg',
                          text: "Spot Type",
                          subText: "Outdoor",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InfoBoxHoriz(
                          asset: 'assets/icons/difficulty.svg',
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
                          asset: 'assets/icons/sunrise.svg',
                          text: "Spot Type",
                          subText: "Outdoor",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: ThemeColors.greyColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 20,
                        color: ThemeColors.primaryColor,
                      ),
                      const SizedBox(
                        width: horizontalOffsetSpace,
                      ), // Використовуйте width
                      Text(rating),
                      const SizedBox(width: 16), // Використовуйте width
                      SvgPicture.asset(
                        'assets/icons/profile.svg',
                        width: sizeIcon,
                        height: sizeIcon,
                      ),
                      const SizedBox(
                        width: 4,
                      ), // Використовуйте width (можливо, менший відступ тут)
                      Text("$participantCount", style: textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.65,
                    children: const [
                      InfoBoxPhoto(
                        // asset: 'assets/icons/timer.svg',
                      ),
                      InfoBoxPhoto(
                        // asset: 'assets/icons/sunrise.svg',
                      ),
                      InfoBoxPhoto(
                        // asset: 'assets/icons/timer.svg',
                      ),
                      InfoBoxPhoto(
                        // asset: 'assets/icons/sunrise.svg',
                      ),
                      InfoBoxPhoto(
                        // asset: 'assets/icons/timer.svg',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  Ratings(
                    votes: votes,
                  ),

                  const SizedBox(height: 20),
                  RatingList(
                    rating: 5,
                    title: 'Workshop title',
                    description:
                        'Thanks for great service and interesting program. it was so nice to meet all those great proffecionals.',
                    date: '4343',
                    tags: ["gg", "dgfg"],
                  ),

                  const SizedBox(height: 20),
                  RatingList(
                    rating: 4,
                    title: 'Workshop title 2',
                    description:
                        'Thanks for great service and interesting program. it was so nice to meet all those great proffecionals.',
                    date: '4343',
                    tags: ["Tag1", "Tag2"],
                  ),

                  // ReviewItem(
                  //   // Використовуйте назву вашого віджета для одного відгуку
                  //   review: Review(
                  //     // Створюємо об'єкт моделі Review
                  //     rating: 4,
                  //     userName: 'John Doe',
                  //     userAvatarUrl: null, // Або шлях до аватара
                  //     title: 'My Test Review',
                  //     text:
                  //         'This is the content of my test review. It was a good experience.',
                  //     date: DateTime.now(), // Або конкретна дата
                  //     tags: ['Test', 'Example'],
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Text(
                    'Popular photo spots in this region',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 230,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal, // 👈 горизонтальний скрол
                      itemCount: 4,
                      separatorBuilder: (context, index) => SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return Container(
                          width: 155,
                          child: ProductCard(
                            imageUrl: "https://picsum.photos/seed/${index + 50}/200/200",
                            productName: 'location title',
                            location: 'Berlin',
                            timestamp: 'Yesterday 18:24',
                          ),
                        );
                      },
                    ),
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
