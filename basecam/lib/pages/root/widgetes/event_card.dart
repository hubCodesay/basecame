import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:basecam/pages/root/widgetes/image_network.dart';
import 'package:basecam/ui/theme.dart';

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String rating;
  final String participantCount;
  final String title;
  final String date;
  final String description;
  final String distance;
  final VoidCallback? onLearnMorePressed;

  const EventCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.participantCount,
    required this.title,
    required this.date,
    required this.description,
    required this.distance,
    this.onLearnMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ImageNetwork(
              imageUrl: imageUrl,
              height: 137.35,
              width: double.infinity,
            ),
          ),

          /// --- Контент картки ---
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.greyColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: ThemeColors.background,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.star,
                      size: 18,
                      color: ThemeColors.blackColor,
                    ),
                    const SizedBox(width: 4),
                    Text(rating),
                    const SizedBox(width: 12),
                    // Use a constrained Image.asset with a fallback sized box to
                    // avoid the large "Unable to load asset" debug banner
                    // that can overflow and cover controls.
                    Image.asset(
                      'assets/icons/person.png',
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                    const SizedBox(width: 2),
                    Text(participantCount),
                  ],
                ),
                const SizedBox(height: 10),

                /// Заголовок + час у бейджі
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/icons/calendar.svg',
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                            width: 16,
                            height: 16,
                            placeholderBuilder: (context) => const SizedBox(
                              width: 16,
                              height: 16,
                              child: Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "14.05",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),

                /// Лінія №1
                const Divider(height: 1, color: Colors.black12),
                const SizedBox(height: 8),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/timer.png',
                          width: 16,
                          height: 16,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: Icon(
                                  Icons.schedule,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "3h 14m",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/expand.png",
                          width: 16,
                          height: 16,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: Icon(
                                  Icons.open_in_full,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "12.4 km",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/vector.png",
                          width: 16,
                          height: 16,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: Icon(
                                  Icons.place,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                        SizedBox(width: 4),
                        Text("100 m", style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                /// 🔹 Лінія №2
                const Divider(height: 1, color: Colors.black12),
                const SizedBox(height: 8),

                /// Заголовок TODO: для Profile
                // Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                // children: [
                //   Expanded(
                //     child: Text(
                //       title,
                //       style: const TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 16,
                //       ),
                //       maxLines: 2,
                //       overflow: TextOverflow.ellipsis,
                //     ),
                //   ),
                // const SizedBox(
                //   width: 80,
                // ), // Відступ між заголовком та датою
                // Text(
                //   date,
                //   style: const TextStyle(
                //     color: Colors.black54,
                //     fontSize: 12,
                //   ),
                // ),
                //   ],
                // ),
                // const SizedBox(height: 8),

                /// Опис
                Text(
                  description,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                /// Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/cursor.png",
                          width: 16,
                          height: 16,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    InkWell(
                      onTap: onLearnMorePressed,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Learn more",
                            style: TextStyle(
                              color: ThemeColors.blackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: ThemeColors.blackColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
