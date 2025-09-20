import 'dart:async';
import 'package:basecam/app_path.dart';
import 'package:basecam/pages/root/widgetes/product_card.dart';
import 'package:basecam/pages/root/widgetes/product_card_with_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:basecam/ui/theme.dart';
import 'package:basecam/pages/root/widgetes/filter_button.dart';
import 'package:basecam/pages/root/widgetes/search.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  final TextEditingController _mapSearchController = TextEditingController();
  final FocusNode _mapSearchFocusNode = FocusNode();
  TextAlign _currentMapSearchTextAlign = TextAlign.center;

  @override
  void initState() {
    super.initState();
    _mapSearchFocusNode.addListener(_onMapSearchFocusChange);
    _mapSearchController.addListener(_onMapSearchTextChange);
  }

  @override
  void dispose() {
    _mapSearchController.dispose();
    _mapSearchFocusNode.removeListener(_onMapSearchFocusChange);
    _mapSearchController.removeListener(_onMapSearchTextChange);
    _mapSearchFocusNode.dispose();
    super.dispose();
  }

  void _onMapSearchFocusChange() {
    setState(() {
      if (_mapSearchFocusNode.hasFocus ||
          _mapSearchController.text.isNotEmpty) {
        _currentMapSearchTextAlign = TextAlign.start;
      } else {
        _currentMapSearchTextAlign = TextAlign.center;
      }
    });
  }

  void _onMapSearchTextChange() {
    setState(() {
      if (_mapSearchController.text.isNotEmpty) {
        _currentMapSearchTextAlign = TextAlign.start;
      } else if (!_mapSearchFocusNode.hasFocus) {
        _currentMapSearchTextAlign = TextAlign.center;
      }
    });
  }

  void _handleSearchChanged(String searchText) {
    print("Search text: $searchText");
    // TODO: Implement search logic
  }

  void _handlePlanNewPressed() {
    print("Plan new pressed!");
    // TODO: Implement navigation or action for planning new
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// Карта
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),

            /// Верхня панель (без Positioned)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ThemeColors.background,
                    // borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SearchBarWidget(
                              onChanged: _handleSearchChanged,
                              hintText: "Search",
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _handlePlanNewPressed,
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
                      const SizedBox(height: 20),

                      /// Button Filter
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilterButton(
                              onPressed: onFilterPhoto,
                              icon: SvgPicture.asset(
                                'assets/icons/camera.svg',
                                width: 24,
                                height: 24,
                              ),
                              // icon: Icons.camera_alt_outlined,
                              dropIcon: true,
                              backgroundColor: ThemeColors.background,
                              borderColor: ThemeColors.silverColor,
                              foregroundColor: ThemeColors.greyColor,
                              iconColor: ThemeColors.blackColor,
                              borderRadius: 12,
                            ),
                            const SizedBox(width: 4),
                            FilterButton(
                              onPressed: onFilterPoint,
                              icon: SvgPicture.asset(
                                'assets/icons/location.svg',
                                width: 24,
                                height: 24,
                              ),
                              backgroundColor: ThemeColors.background,
                              borderColor: ThemeColors.silverColor,
                              foregroundColor: ThemeColors.greyColor,
                              iconColor: ThemeColors.blackColor,
                              fontWeight: FontWeight.w400,
                              borderRadius: 12,
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Start from",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: ThemeColors.greyColor,
                                    ),
                                  ),
                                  Text(
                                    "Within 30 km",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ThemeColors.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                              dropIcon: true,
                            ),
                            const SizedBox(width: 4),
                            FilterButton(
                              onPressed: onFilter,
                              icon: SvgPicture.asset(
                                'assets/icons/filter.svg',
                                width: 24,
                                height: 24,
                              ),
                              backgroundColor: ThemeColors.background,
                              borderColor: ThemeColors.silverColor,
                              foregroundColor: ThemeColors.greyColor,
                              iconColor: ThemeColors.blackColor,
                              fontWeight: FontWeight.w400,
                              borderRadius: 12,
                              dropIcon: false,
                              label: Text("Filter"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// Нижня панель
            DraggableScrollableSheet(
              initialChildSize: 0.25,
              minChildSize:
                  0.1,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.15,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 8,
                        ),
                        child: Text(
                          "Nearby Locations",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 16,
                              ),
                              child: ProductCardNav(
                                onTap: () => context.push(AppPath.location.path),
                                productName: "Awesome Place ${index + 1}",
                                price: "${(index + 1) * 10} USD",
                                tag: "Adventure",
                                location: "Nearby, ${index * 2 + 1} km",
                                timestamp: "Posted ${index + 1}h ago",
                                imageUrl:
                                    "https://picsum.photos/seed/${index + 100}/400/200",
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void onFilterPhoto() {}

void onFilterPoint() {}

void onFilter() {}
