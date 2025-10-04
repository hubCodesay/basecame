import 'package:basecam/ui/widgets/arrow_back_button.dart';
import 'package:basecam/ui/widgets/info_box.dart';
import 'package:basecam/ui/widgets/save_nav_bottom_bar.dart';
import 'package:basecam/ui/widgets/tag_widget.dart';
import 'package:basecam/ui/widgets/waypoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:basecam/ui/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:basecam/services/posts_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationScreen extends StatefulWidget {
  final String? postId;
  const LocationScreen({super.key, this.postId});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // Default image for the route (fallback)
  final String defaultImage = "assets/pexels.jpg";
  final String category = "Intermediate";
  final String rating = "4.95 (3)";
  final String participantCount = "48";
  String title = "Route name";
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
    // Increment view counter once when screen is first shown for a given postId
    if (widget.postId != null && widget.postId!.isNotEmpty) {
      _incrementViewCount();
    }
  }

  Future<void> _incrementViewCount() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('viewUser')
          .doc(widget.postId);
      // Use atomic increment to avoid race conditions
      await docRef.set({
        'views': FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (e) {
      // ignore errors for now — we don't want to block UI on analytics failure
      // Consider logging to monitoring in a real app
    }
  }

  @override
  Widget build(BuildContext context) {
    // Визначимо текстові стилі тут для легшого доступу та консистентності
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // If a postId was provided, try to set the title from postsRepo (sync stub)
    if (widget.postId != null && widget.postId!.isNotEmpty) {
      final found = postsRepo.getPostById(widget.postId!);
      if (found != null) {
        title = found.title;
      }
    }

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
                // If we have a postId, try to load a remote image from /routeLoc/{postId}
                // Fields we try: 'photoUrl', 'photo', 'image'. If none present, fall back to defaultImage.
                (widget.postId != null && widget.postId!.isNotEmpty)
                    ? StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('routeLoc')
                            .doc(widget.postId)
                            .snapshots(),
                        builder: (context, snap) {
                          String? remotePhoto;
                          if (snap.hasData && snap.data?.data() != null) {
                            final data = snap.data!.data()!;
                            remotePhoto =
                                data['photoUrl'] as String? ??
                                data['photo'] as String? ??
                                data['image'] as String?;
                          }

                          if (remotePhoto != null && remotePhoto.isNotEmpty) {
                            return Image.network(
                              remotePhoto,
                              height: 143,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  defaultImage,
                                  height: 143,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              },
                            );
                          }

                          // Fallback while waiting or if no remote image
                          return Image.asset(
                            defaultImage,
                            height: 143,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        defaultImage,
                        height: 143,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                        child:
                            (widget.postId != null && widget.postId!.isNotEmpty)
                            ? StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>
                              >(
                                stream: FirebaseFirestore.instance
                                    .collection('routeLoc')
                                    .doc(widget.postId)
                                    .snapshots(),
                                builder: (context, snap) {
                                  final remoteTitle =
                                      snap.data?.data()?['title'] as String?;
                                  final display = remoteTitle ?? title;
                                  return Text(
                                    display,
                                    maxLines: 2,
                                    style: textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  );
                                },
                              )
                            : Text(
                                title,
                                maxLines: 2,
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
                      // Render tags from Firestore: /routeLoc/{postId}/tagLoc
                      (widget.postId != null && widget.postId!.isNotEmpty)
                          ? StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>
                            >(
                              stream: FirebaseFirestore.instance
                                  .collection('routeLoc')
                                  .doc(widget.postId)
                                  .snapshots(),
                              builder: (context, snap) {
                                if (snap.hasError)
                                  return TagWidget(text: category);
                                if (!snap.hasData || snap.data?.data() == null)
                                  return TagWidget(text: category);

                                final raw = snap.data!.data()?['tagLoc'];
                                // tagLoc can be a String, List<String>, Map<String, dynamic> or null
                                if (raw == null)
                                  return TagWidget(text: category);

                                List<String> tags = [];
                                if (raw is String) {
                                  tags = [raw];
                                } else if (raw is Iterable) {
                                  tags = raw.cast<String>().toList();
                                } else if (raw is Map) {
                                  // if stored as map {tag: true}
                                  tags = raw.entries
                                      .where((e) => e.value == true)
                                      .map((e) => e.key as String)
                                      .toList()
                                      .cast<String>();
                                }

                                if (tags.isEmpty)
                                  return TagWidget(text: category);

                                return Flexible(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: tags
                                        .map((t) => TagWidget(text: t))
                                        .toList(),
                                  ),
                                );
                              },
                            )
                          : TagWidget(text: category),
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
                  (widget.postId != null && widget.postId!.isNotEmpty)
                      ? StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('routeLoc')
                              .doc(widget.postId)
                              .snapshots(),
                          builder: (context, snap) {
                            // On error or no data, fall back to the local `description` value
                            if (snap.hasError) {
                              return Text(
                                description,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: ThemeColors.greyColor,
                                ),
                              );
                            }

                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final remoteDescr =
                                snap.data?.data()?['descrLoc'] as String?;
                            final display = remoteDescr ?? description;

                            return Text(
                              display,
                              style: textTheme.bodyMedium?.copyWith(
                                color: ThemeColors.greyColor,
                              ),
                            );
                          },
                        )
                      : Text(
                          description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: ThemeColors.greyColor,
                          ),
                        ),
                  const SizedBox(height: vertSpace),

                  // --- Рейтинг і учасники ---
                  /*  Row(
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
                      // Show live view count from /viewUser/{postId} if available
                      (widget.postId != null && widget.postId!.isNotEmpty)
                          ? StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>
                            >(
                              stream: FirebaseFirestore.instance
                                  .collection('viewUser')
                                  .doc(widget.postId)
                                  .snapshots(),
                              builder: (context, snap) {
                                if (snap.hasError)
                                  return Text(
                                    participantCount,
                                    style: textTheme.bodyMedium,
                                  );
                                if (!snap.hasData ||
                                    snap.data?.data() == null) {
                                  return Text(
                                    participantCount,
                                    style: textTheme.bodyMedium,
                                  );
                                }
                                final views = snap.data?.data()?['views'];
                                final v = (views is int)
                                    ? views
                                    : (views is num ? views.toInt() : null);
                                return Text(
                                  v != null ? v.toString() : participantCount,
                                  style: textTheme.bodyMedium,
                                );
                              },
                            )
                          : Text(participantCount, style: textTheme.bodyMedium),
                    ],
                  ),
 */
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
                          asset: 'assets/icons/edit.svg',
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
                      const SizedBox(width: 8),
                      // (Add stage button removed)
                      const SizedBox(height: 10),
                      // Load waypoints from Firestore: /routeLoc/{postId}/waypoints ordered by 'order'
                      (widget.postId != null && widget.postId!.isNotEmpty)
                          ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('routeLoc')
                                  .doc(widget.postId)
                                  .collection('waypoints')
                                  .orderBy('order')
                                  .snapshots(),
                              builder: (context, snap) {
                                if (snap.hasError)
                                  return Waypoints(waypoints: _waypoints);
                                if (!snap.hasData)
                                  return Waypoints(waypoints: _waypoints);

                                final docs = snap.data!.docs;
                                if (docs.isEmpty)
                                  return Waypoints(waypoints: _waypoints);

                                final wpList = docs.map((d) {
                                  final data = d.data();
                                  final name =
                                      data['name'] as String? ?? 'Stage';
                                  final descr = data['descr'] as String? ?? '';
                                  final orderVal = data['order'];
                                  final order = (orderVal is int)
                                      ? orderVal
                                      : (orderVal is num
                                            ? orderVal.toInt()
                                            : null);
                                  String distanceText = '';
                                  // If this is the first waypoint (order == 0), show 0 km
                                  if (order != null && order == 0) {
                                    distanceText = '0 km';
                                  } else {
                                    distanceText = '9 km';
                                  }

                                  // For now always show the same default image for each waypoint
                                  Widget? titleIcon = Image.asset(
                                    defaultImage,
                                    fit: BoxFit.cover,
                                  );

                                  return Waypoint(
                                    icon: Icons.location_on_outlined,
                                    title: name,
                                    subtitle: descr,
                                    titleIcon: titleIcon,
                                    distance: distanceText,
                                  );
                                }).toList();

                                return Waypoints(waypoints: wpList);
                              },
                            )
                          : Waypoints(waypoints: _waypoints),
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
