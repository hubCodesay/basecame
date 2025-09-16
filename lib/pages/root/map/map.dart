import 'dart:async';
import 'package:flutter/material.dart';
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
                // const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    // borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
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
                      const SizedBox(height: 12),

                      /// Button Filter
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilterButton(
                              onPressed: onFilterPhoto,
                              icon: Icons.camera_alt_outlined,
                              dropIcon: true,
                            ),
                            FilterButton(
                              onPressed: onFilterPoint,
                              icon: Icons.location_on_outlined,
                              label: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Start from"),
                                  Text("Within 30 km"),
                                ],
                              ),
                              dropIcon: true,
                            ),
                            FilterButton(
                              onPressed: onFilter,
                              icon: Icons.filter_list,
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
              minChildSize: 0.25,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const Text(
                        "203 Locations",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          Spacer(),
                          Icon(Icons.star, size: 18, color: Colors.black),
                          SizedBox(width: 4),
                          Text("4.95 (3)"),
                          SizedBox(width: 16),
                          Icon(Icons.person, size: 18, color: Colors.black),
                          SizedBox(width: 4),
                          Text("48"),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Section title",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "3h 14m",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "↔ 12.4 km",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "↗ 100 m",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
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
