import 'dart:async';
import 'package:basecam/app_path.dart';
import 'package:basecam/pages/root/widgetes/product_card_with_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:basecam/ui/theme.dart';
import 'package:basecam/pages/root/widgetes/filter_button.dart';
import 'package:basecam/pages/root/widgetes/search.dart';
import 'package:basecam/pages/root/map/new_location_page.dart';

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

  final TextEditingController _mapSearchController = TextEditingController();
  final FocusNode _mapSearchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _mapSearchFocusNode.addListener(_onMapSearchFocusChange);
    _mapSearchController.addListener(_onMapSearchTextChange);
  }

  @override
  void dispose() {
    _mapSearchController.dispose();
    _mapSearchFocusNode.dispose();
    super.dispose();
  }

  void _onMapSearchFocusChange() {
    setState(() {});
  }

  void _onMapSearchTextChange() {
    setState(() {});
  }

  void _handleSearchChanged(String searchText) {
    // placeholder for future search
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Map placeholder
            Container(
              color: Colors.grey.shade100,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.map, size: 72, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'Map unavailable — Maps API is not configured',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Enable the Maps API or provide API keys to use the map.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Top controls
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: ThemeColors.background),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SearchBarWidget(
                              onChanged: _handleSearchChanged,
                              hintText: 'Search',
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final res = await Navigator.of(context)
                                  .push<bool>(
                                    MaterialPageRoute(
                                      builder: (_) => const NewLocationPage(),
                                    ),
                                  );
                              if (res == true && mounted)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Location created'),
                                  ),
                                );
                            },
                            icon: const Icon(
                              Icons.add,
                              color: ThemeColors.blackColor,
                            ),
                            label: const Text(
                              'Plan new',
                              style: TextStyle(
                                color: ThemeColors.blackColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                                    'Start from',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: ThemeColors.greyColor,
                                    ),
                                  ),
                                  Text(
                                    'Within 30 km',
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
                              label: const Text('Filter'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom sheet with live locations from Firestore
            DraggableScrollableSheet(
              initialChildSize: 0.25,
              minChildSize: 0.1,
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
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('location')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return ListView(
                          controller: scrollController,
                          children: const [
                            SizedBox(
                              height: 120,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ],
                        );
                      }
                      if (snap.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Error loading locations: ${snap.error}'),
                        );
                      }

                      final docs = snap.data?.docs ?? [];

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: 2 + docs.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Center(
                              child: Container(
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
                            );
                          } else if (index == 1) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 8,
                              ),
                              child: Text(
                                'Nearby Locations',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            );
                          }

                          final doc = docs[index - 2];
                          final data = doc.data();
                          final title = data['title'] as String? ?? 'Untitled';

                          final tagsRaw = data['tagLoc'];
                          final tag = (tagsRaw is List && tagsRaw.isNotEmpty)
                              ? (tagsRaw.first as String)
                              : (tagsRaw is String ? tagsRaw : '');

                          String? imageUrl;
                          final photoField = data['photoLoc'];
                          if (photoField is String && photoField.isNotEmpty) {
                            imageUrl = photoField;
                          } else if (photoField is List &&
                              photoField.isNotEmpty) {
                            imageUrl = (photoField.first as String?);
                          } else {
                            imageUrl = null; // ProductCard shows placeholder
                          }

                          String locationText = '';
                          final locPoint = data['locatPoint'];
                          if (locPoint is GeoPoint) {
                            locationText =
                                'Point: ${locPoint.latitude.toStringAsFixed(4)}, ${locPoint.longitude.toStringAsFixed(4)}';
                          } else if (locPoint is Map) {
                            final lat = locPoint['latitude'] ?? locPoint['lat'];
                            final lng =
                                locPoint['longitude'] ?? locPoint['lng'];
                            if (lat != null && lng != null)
                              locationText =
                                  'Point: ${lat.toString().substring(0, 8)}, ${lng.toString().substring(0, 8)}';
                          }

                          final createdAt = data['createdAt'];
                          String timestamp = '';
                          if (createdAt is Timestamp) {
                            final dt = createdAt.toDate();
                            timestamp =
                                'Posted ${dt.toLocal().toIso8601String().split('T').first}';
                          }

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16,
                              left: 16,
                              right: 16,
                            ),
                            child: ProductCardNav(
                              onTap: () => context.push(
                                AppPath.location.path,
                                extra: {'id': doc.id},
                              ),
                              productName: title,
                              price: null,
                              tag: tag,
                              location: locationText,
                              timestamp: timestamp,
                              imageUrl: imageUrl,
                            ),
                          );
                        },
                      );
                    },
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
