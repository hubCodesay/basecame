import 'package:basecam/pages/root/widgetes/filter_button.dart';
import 'package:flutter/material.dart';

import 'package:basecam/pages/root/shop/shop_camera.dart';
import 'package:basecam/pages/root/widgetes/product_card.dart';
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

                    /// Results count
                    const Text(
                      "Found 493 results",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              /// Grid with items
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RentalItemPage(),
                          ),
                        );
                      },
                      child: ProductCard(
                        productName: "Camera Model X ${index + 1}",
                        price: "\$${(index + 1) * 10}/day",
                        tag: "For rent",
                        location: "Berlin",
                        timestamp: "Yesterday 18:2${index}",
                      ),
                    );
                  },
                  childCount: 10, // Example count
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.6,
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
