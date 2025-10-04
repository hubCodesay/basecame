import 'package:basecam/ui/widgets/image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                    SvgPicture.asset(
                      'assets/icons/profile.svg',
                      width: 24,
                      height: 24,
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
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "14.05",
                            style: TextStyle(color: ThemeColors.background, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),

                /// Лінія №1
                const Divider(height: 1, color: ThemeColors.greyColor),
                const SizedBox(height: 8),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/timer.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(ThemeColors.greyColor, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "3h 14m",
                          style: TextStyle(color: ThemeColors.greyColor),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/edit.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(ThemeColors.greyColor, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "12.4 km",
                          style: TextStyle(color: ThemeColors.greyColor),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/up.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(ThemeColors.greyColor, BlendMode.srcIn),
                        ),
                        SizedBox(width: 4),
                        Text("100 m", style: TextStyle(color: ThemeColors.greyColor)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: vertSpaceDefault),

                /// 🔹 Лінія №2
                const Divider(height: 1, color: ThemeColors.greyColor),
                const SizedBox(height: vertSpaceDefault),

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
                        SvgPicture.asset(
                          'assets/icons/cursor.svg',
                          width: 16,
                          height: 16,
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
