import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../../../models/gear.dart';
import '../../gear/show_new_gear_modal.dart';

import 'package:basecam/app_path.dart';
import 'package:basecam/pages/root/widgetes/event_card.dart';
import 'package:basecam/pages/root/widgetes/product_card.dart';
import 'package:basecam/pages/root/widgetes/rating_list.dart';
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
        // Show only gear created by the signed-in user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Please sign in to see your equipments'),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () => context.push(AppPath.login.path),
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ),
          );
        }

        // Avoid requiring a composite index by not ordering server-side.
        // We fetch the user's docs and sort by `createdAt` on the client.
        final stream = FirebaseFirestore.instance
            .collection('gear')
            .where('ownerId', isEqualTo: user.uid)
            .snapshots();

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              final err = snapshot.error.toString();
              // Try to extract an index creation URL from the error text
              final urlMatch = RegExp(r'https?://[^\s]+').firstMatch(err);
              final indexUrl = urlMatch?.group(0);

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: $err', textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      if (indexUrl != null) ...[
                        SelectableText(indexUrl),
                        const SizedBox(height: 8),
                        FilledButton.tonal(
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: indexUrl),
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Index URL copied to clipboard',
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Copy index creation URL'),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }

            final docs = List.of(snapshot.data?.docs ?? []);
            // Sort by server timestamp `createdAt` descending on client to avoid
            // needing a composite index for the query.
            docs.sort((a, b) {
              final aTs = (a.data()?['createdAt'] as Timestamp?);
              final bTs = (b.data()?['createdAt'] as Timestamp?);
              final aMillis = aTs?.millisecondsSinceEpoch ?? 0;
              final bMillis = bTs?.millisecondsSinceEpoch ?? 0;
              return bMillis.compareTo(aMillis);
            });
            if (docs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "You have no listings yet. You can create one from the Map tab by tapping 'Plan new'.",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.tonal(
                        onPressed: () async {
                          // open the new gear modal
                          await showNewGearModal(context);
                        },
                        child: const Text('Create your first listing'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: itemAxisSpacing,
                crossAxisSpacing: itemAxisSpacing,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                final doc = docs[index];
                final gear = Gear.fromDoc(doc);

                final imageUrl = gear.photos.isNotEmpty
                    ? (gear.photos[0]['url'] as String?)
                    : null;
                final priceText =
                    '${gear.priceAmount} ${gear.priceCurrency}/day';
                final tag = gear.status;
                final location = gear.locationCity.isNotEmpty
                    ? gear.locationCity
                    : '';
                final timestamp = gear.createdAt != null
                    ? '${gear.createdAt!.toDate()}'
                    : '';

                return ProductCard(
                  productName: gear.title,
                  price: priceText,
                  tag: tag,
                  location: location,
                  timestamp: timestamp,
                  imageUrl:
                      imageUrl ??
                      'https://picsum.photos/seed/equip${index}/300/400',
                );
              },
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
              padding: EdgeInsets.only(
                bottom: index == 2 ? 0 : itemAxisSpacing,
              ),
              child: RatingList(
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
                                StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>?
                                >(
                                  stream:
                                      FirebaseAuth.instance.currentUser == null
                                      ? Stream.value(null)
                                      : FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                            )
                                            .snapshots(),
                                  builder: (context, snap) {
                                    if (snap.hasData &&
                                        snap.data != null &&
                                        snap.data!.exists) {
                                      final data = snap.data!.data() ?? {};

                                      // Prefer nested `reviewsSummary` object when available.
                                      Map<String, dynamic>? reviewsSummary;
                                      try {
                                        if (data['reviewsSummary'] is Map) {
                                          reviewsSummary =
                                              Map<String, dynamic>.from(
                                                data['reviewsSummary'] as Map,
                                              );
                                        }
                                      } catch (_) {
                                        reviewsSummary = null;
                                      }

                                      dynamic ratingVal;
                                      dynamic reviewsCount;

                                      if (reviewsSummary != null) {
                                        ratingVal =
                                            reviewsSummary['rating'] ??
                                            reviewsSummary['avg'] ??
                                            reviewsSummary['ratingValue'];
                                        reviewsCount =
                                            reviewsSummary['reviewCount'] ??
                                            reviewsSummary['count'] ??
                                            reviewsSummary['reviews'];
                                      } else {
                                        ratingVal =
                                            data['rating'] ??
                                            data['ratingValue'] ??
                                            data['avgRating'] ??
                                            data['rating_avg'] ??
                                            0;
                                        reviewsCount =
                                            data['reviewsCount'] ??
                                            data['reviews_count'] ??
                                            data['reviews'] ??
                                            0;
                                      }

                                      final ratingText = ratingVal is num
                                          ? (ratingVal.toStringAsFixed(2))
                                          : ratingVal.toString();
                                      final reviewsText = reviewsCount is num
                                          ? reviewsCount.toString()
                                          : reviewsCount.toString();

                                      return Row(
                                        children: [
                                          Text(
                                            ratingText,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '$reviewsText reviews',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: ThemeColors.greyColor,
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    // fallback static values while loading or if no profile
                                    return Row(
                                      children: const [
                                        Text(
                                          "4.95",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "22 reviews",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: ThemeColors.greyColor,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
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
