import 'package:flutter/material.dart';

import 'package:basecam/pages/root/shop/shop_camera.dart';
import 'package:basecam/pages/root/widgetes/product_card.dart';
import 'package:basecam/pages/root/widgetes/search.dart';
import 'package:basecam/ui/theme.dart';

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

                    /// Filters
                    Row(
                      children: const [
                        FilterChipWidget(
                            label: "Filters", icon: Icons.filter_list),
                        SizedBox(width: 8),
                        FilterChipWidget(label: "Cameras", dropdown: true),
                        SizedBox(width: 8),
                        FilterChipWidget(label: "Within City", dropdown: true),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// Results count
                    const Text(
                      "Found 493 results",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
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

class FilterChipWidget extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool dropdown;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.icon,
    this.dropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeColors.greyColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 14, color: ThemeColors.blackColor),
          if (icon != null) const SizedBox(width: 4),
          Text(label),
          if (dropdown) ...[
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 24, color: ThemeColors.background),
          ],
        ],
      ),
    );
  }
}

