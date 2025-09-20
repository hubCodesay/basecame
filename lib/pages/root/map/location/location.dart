import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:basecam/pages/root/widgetes/image_network.dart';
import 'package:basecam/ui/theme.dart';

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
  final String title = "Location name";
  final String date = "14.05";
  final String description = "Description text about something on this page that can be long or short. It can be pretty long and expand …";
  final String distance = "13.1 km from Somename District";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
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
                            horizontal: 8,
                            vertical: 4,
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
                        Image.asset(
                          'assets/icons/person.png',
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
                            SvgPicture.asset(
                              'assets/icons/timer.svg',
                              width: 24,
                              height: 24,
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
                            SvgPicture.asset(
                              'assets/icons/timer.svg',
                              width: 24,
                              height: 24,
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
                            SvgPicture.asset(
                              'assets/icons/timer.svg',
                              width: 24,
                              height: 24,
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
                          onTap: (){},
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
        ),
      ),
    );
  }
}
