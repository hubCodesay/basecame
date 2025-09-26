import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:basecam/app_path.dart';
import 'package:basecam/pages/root/widgetes/event_card.dart';
import 'package:basecam/pages/root/widgetes/product_card.dart';
import 'package:basecam/pages/root/widgetes/rating.dart';
import 'package:basecam/ui/theme.dart';
import 'package:basecam/services/equipment_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:basecam/models/equipment.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        // Show only the equipments created by the currently signed-in user.
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnap) {
            final user = authSnap.data;
            if (user == null) {
              return const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Center(child: Text('Sign in to see your equipments.')),
              );
            }

            return StreamBuilder<List<Equipment>>(
              stream: equipmentRepo.streamEquipmentsForUser(user.uid),
              builder: (context, snapshot) {
                final equipments = snapshot.data ?? [];
                if (equipments.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Center(
                      child: Text(
                        'No equipments yet. Add one from Map -> Plan new.',
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: equipments.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: itemAxisSpacing,
                    crossAxisSpacing: itemAxisSpacing,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
                    final item = equipments[index];
                    return ProductCard(
                      productName: item.name,
                      price: item.price.toString(),
                      tag: 'For rent',
                      location: 'Unknown',
                      timestamp: 'Just now',
                      imageUrl: item.imageUrl,
                    );
                  },
                );
              },
            );
          },
        );

      case 1:
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == 5 ? 0 : itemAxisSpacing,
              ),
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
                  // keep a print for quick debug
                  // ignore: avoid_print
                  print("Learn more pressed on location $index");
                },
              ),
            );
          },
        );

      case 2:
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == 2 ? 0 : itemAxisSpacing,
              ),
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
        return const SizedBox.shrink();
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
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, authSnap) {
                      final user = authSnap.data;
                      if (user == null) {
                        return CircleAvatar(
                          radius: 40,
                          backgroundColor: ThemeColors.grey4Color,
                          child: ClipOval(
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: SvgPicture.asset(
                                'assets/icons/ava_user.svg',
                                fit: BoxFit.cover,
                                // if asset fails, show a simple person icon
                                placeholderBuilder: (context) => const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 28,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return StreamBuilder<
                        DocumentSnapshot<Map<String, dynamic>>
                      >(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .snapshots(),
                        builder: (context, docSnap) {
                          String? avatarUrl;
                          if (docSnap.hasData && docSnap.data!.exists) {
                            final data = docSnap.data!.data();
                            if (data != null) {
                              if (data['profile'] is Map &&
                                  data['profile']['avatarUrl'] != null) {
                                avatarUrl = data['profile']['avatarUrl']
                                    .toString();
                              } else if (data['avatarUrl'] != null) {
                                avatarUrl = data['avatarUrl'].toString();
                              }
                            }
                          }

                          if (avatarUrl == null || avatarUrl.isEmpty) {
                            return CircleAvatar(
                              radius: 40,
                              backgroundColor: ThemeColors.grey4Color,
                              child: ClipOval(
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: SvgPicture.asset(
                                    'assets/icons/ava_user.svg',
                                    fit: BoxFit.cover,
                                    placeholderBuilder: (context) =>
                                        const Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 28,
                                            color: Colors.black54,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            );
                          }

                          final isSvg = avatarUrl.toLowerCase().endsWith(
                            '.svg',
                          );

                          return CircleAvatar(
                            radius: 40,
                            backgroundColor: ThemeColors.grey4Color,
                            child: ClipOval(
                              child: isSvg
                                  ? SvgPicture.network(
                                      avatarUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      placeholderBuilder: (context) =>
                                          Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.white,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                    )
                                  : Image.network(
                                      avatarUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              SvgPicture.asset(
                                                'assets/icons/ava_user.svg',
                                                width: 72,
                                                height: 72,
                                                fit: BoxFit.cover,
                                              ),
                                    ),
                            ),
                          );
                        },
                      );
                    },
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
                            // Show signed-in user's displayName or email; update reactively
                            StreamBuilder<User?>(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                final user = snapshot.data;
                                final title =
                                    user?.displayName ??
                                    user?.email ??
                                    'Your name';
                                return Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                            // Show rating and reviews pulled from Firestore user doc.
                            // Fallback: rating = 5.0, reviews = 0 when not available. !
                            StreamBuilder<User?>(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, authSnap) {
                                final user = authSnap.data;
                                if (user == null) {
                                  // Not signed in — show defaults
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 22,
                                        color: ThemeColors.blackColor,
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        "5.0",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "0 reviews",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: ThemeColors.greyColor,
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                return StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>
                                >(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .snapshots(),
                                  builder: (context, docSnap) {
                                    double rating = 5.0;
                                    int reviews = 0;
                                    if (docSnap.hasData &&
                                        docSnap.data!.exists) {
                                      final data = docSnap.data!.data();
                                      if (data != null) {
                                        // Prefer the new reviewsSummary map if present
                                        if (data['reviewsSummary'] is Map) {
                                          final rs = Map<String, dynamic>.from(
                                            data['reviewsSummary'],
                                          );
                                          if (rs['rating'] != null) {
                                            final r = rs['rating'];
                                            if (r is num)
                                              rating = r.toDouble();
                                            else {
                                              rating =
                                                  double.tryParse(
                                                    r.toString(),
                                                  ) ??
                                                  rating;
                                            }
                                          }
                                          if (rs['reviewCount'] != null) {
                                            final rc = rs['reviewCount'];
                                            if (rc is int)
                                              reviews = rc;
                                            else {
                                              reviews =
                                                  int.tryParse(rc.toString()) ??
                                                  reviews;
                                            }
                                          }
                                        } else {
                                          // Fallback to legacy top-level fields
                                          if (data['rating'] != null) {
                                            final r = data['rating'];
                                            if (r is num)
                                              rating = r.toDouble();
                                            else {
                                              rating =
                                                  double.tryParse(
                                                    r.toString(),
                                                  ) ??
                                                  rating;
                                            }
                                          }
                                          if (data['reviewCount'] != null) {
                                            final rc = data['reviewCount'];
                                            if (rc is int)
                                              reviews = rc;
                                            else {
                                              reviews =
                                                  int.tryParse(rc.toString()) ??
                                                  reviews;
                                            }
                                          } else if (data['reviews'] is List) {
                                            reviews = (data['reviews'] as List)
                                                .length;
                                          }
                                        }
                                      }
                                    }

                                    final ratingStr = (rating % 1 == 0)
                                        ? rating.toStringAsFixed(0)
                                        : rating.toStringAsFixed(2);
                                    final reviewsText =
                                        '$reviews review${reviews == 1 ? '' : 's'}';

                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 22,
                                          color: ThemeColors.blackColor,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          ratingStr,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          reviewsText,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: ThemeColors.greyColor,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
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
                          Image.asset(
                            'assets/icons/profile.png',
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
                          Image.asset(
                            'assets/icons/settings.png',
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Icon(
                                    Icons.settings,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ),
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
                  onValueChanged: (value) =>
                      setState(() => selectedTabIndex = value!),
                  children: {
                    0: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Text(
                          'Equipments',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: selectedTabIndex == 0
                                ? Colors.white
                                : ThemeColors.greyColor,
                          ),
                        ),
                      ),
                    ),
                    1: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Text(
                          'Locations',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: selectedTabIndex == 1
                                ? Colors.white
                                : ThemeColors.greyColor,
                          ),
                        ),
                      ),
                    ),
                    2: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Text(
                          'Rating',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: selectedTabIndex == 2
                                ? Colors.white
                                : ThemeColors.greyColor,
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
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
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
