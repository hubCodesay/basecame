import 'package:basecam/pages/root/widgetes/filter_button.dart';
import 'package:flutter/material.dart';

import 'package:basecam/pages/root/shop/shop_camera.dart';
import 'package:basecam/pages/root/widgetes/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:basecam/models/gear.dart';
import 'package:basecam/pages/root/widgetes/search.dart';
import 'package:basecam/ui/theme.dart';
import 'package:flutter_svg/svg.dart';

class ShopTab extends StatelessWidget {
  const ShopTab({super.key});

  void _handleShopSearchChanged(String searchText) {
    print("Shop search text: $searchText");
    // TODO: Implement search logic for shop items
  }

  void _handleShopPostNewPressed() {
    print("Post new pressed in ShopTab!");
    // TODO: Implement action for posting a new item (e.g., navigate to a new screen)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Search & Post new
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SearchBarWidget(
                              onChanged: _handleShopSearchChanged,
                              hintText: "Search",
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _handleShopPostNewPressed,
                            icon: const Icon(
                              Icons.add,
                              color: ThemeColors.blackColor,
                            ),
                            label: const Text(
                              "Plan new",
                              style: TextStyle(
                                color: ThemeColors.blackColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Button Filter
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilterButton(
                              onPressed: onFilter,
                              icon: SvgPicture.asset(
                                'assets/icons/filter.svg',
                                width: 24,
                                height: 24,
                              ),
                              dropIcon: false,
                              backgroundColor: ThemeColors.background,
                              borderColor: ThemeColors.silverColor,
                              foregroundColor: ThemeColors.greyColor,
                              iconColor: ThemeColors.blackColor,
                              borderRadius: 12,
                              label: Text("Filters"),
                            ),
                            const SizedBox(width: 4),
                            FilterButton(
                              onPressed: onAllCetegories,
                              backgroundColor: ThemeColors.background,
                              borderColor: ThemeColors.silverColor,
                              foregroundColor: ThemeColors.greyColor,
                              iconColor: ThemeColors.blackColor,
                              fontWeight: FontWeight.w400,
                              borderRadius: 12,
                              dropIcon: true,
                              label: Text("All cetegories"),
                            ),
                            const SizedBox(width: 4),
                            FilterButton(
                              onPressed: onWithinCountry,
                              backgroundColor: ThemeColors.background,
                              borderColor: ThemeColors.silverColor,
                              foregroundColor: ThemeColors.greyColor,
                              iconColor: ThemeColors.blackColor,
                              fontWeight: FontWeight.w400,
                              borderRadius: 12,
                              dropIcon: true,
                              label: Text("Within Country"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Results count (dynamic)
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
            .collection('gear')
            .where('status', isEqualTo: 'active')
            .snapshots(),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return const Text(
                            'Found 0 results',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          );
                        }
                        final docs = snap.data!.docs;
                        // Count only documents that look valid (ownerId and title present)
                        final validCount = docs.where((d) {
                          final data = d.data();
                          final owner = data['ownerId'] as String?;
                          final title = data['title'] as String?;
                          return (owner?.isNotEmpty ?? false) &&
                              (title?.isNotEmpty ?? false);
                        }).length;
                        return Text(
                          'Found $validCount results',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              /// Grid with items (live from Firestore `gear` collection)
              SliverToBoxAdapter(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
            .collection('gear')
            .where('status', isEqualTo: 'active')
            .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Error loading items: ${snapshot.error}'),
                      );
                    }

                    final docs = snapshot.data?.docs ?? [];
                    final items = docs
                        .map((d) {
                          try {
                            return Gear.fromDoc(d);
                          } catch (e, st) {
                            debugPrint(
                              'Skipping malformed gear doc ${d.id}: $e\n$st',
                            );
                            return null;
                          }
                        })
                        .whereType<Gear>()
                        .toList();
                    // client side sort by createdAt desc
                    items.sort((a, b) {
                      final ta =
                          a.createdAt?.toDate() ??
                          DateTime.fromMillisecondsSinceEpoch(0);
                      final tb =
                          b.createdAt?.toDate() ??
                          DateTime.fromMillisecondsSinceEpoch(0);
                      return tb.compareTo(ta);
                    });

                    if (items.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text('No items available'),
                      );
                    }

                    // Build a GridView inside a constrained height
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.6,
                          ),
                      itemBuilder: (context, index) {
                        final gear = items[index];
                        final price = '\$${gear.priceAmount}/day';
                        final imageUrl = gear.photos.isNotEmpty
                            ? (gear.photos.first['url'] as String?) ?? ''
                            : '';
                        final time = gear.createdAt != null
                            ? gear.createdAt!.toDate().toLocal().toString()
                            : '';
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RentalItemPage(gearId: gear.id),
                              ),
                            );
                          },
                          child: ProductCard(
                            productName: gear.title,
                            price: price,
                            tag: 'For rent',
                            location: gear.locationCity,
                            timestamp: time,
                            imageUrl: imageUrl,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void onFilter() {}

void onAllCetegories() {}

void onWithinCountry() {}
