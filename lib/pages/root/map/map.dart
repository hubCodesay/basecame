import 'dart:async';
import 'package:basecam/app_path.dart';
import 'package:basecam/ui/widgets/filter_button.dart';
import 'package:basecam/ui/widgets/product_card_with_nav.dart';
import 'package:basecam/ui/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:basecam/ui/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  // ignore: unused_field
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // Static markers (example)
  final Set<Marker> _staticMarkers = <Marker>{
    Marker(
      markerId: const MarkerId('berlin'),
      position: const LatLng(52.5200, 13.4050),
      infoWindow: const InfoWindow(title: 'Berlin'),
    ),
  };

  // Dynamic markers populated from Firestore
  final Map<String, Marker> _dynamicMarkers = {};

  // Subscriptions to Firestore streams
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _locationSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _routeLocSub;

  // ignore: unused_field
  static const CameraPosition _kGooglePlex = CameraPosition(
    // Center on Berlin, Germany
    target: LatLng(52.5200, 13.4050),
    zoom: 12.0,
  );

  // ignore: unused_field
  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  final TextEditingController _mapSearchController = TextEditingController();
  final FocusNode _mapSearchFocusNode = FocusNode();
  // ignore: unused_field
  TextAlign _currentMapSearchTextAlign = TextAlign.center;

  @override
  void initState() {
    super.initState();
    _mapSearchFocusNode.addListener(_onMapSearchFocusChange);
    _mapSearchController.addListener(_onMapSearchTextChange);
    _subscribeFirestoreMarkers();
  }

  @override
  void dispose() {
    _mapSearchController.dispose();
    _mapSearchFocusNode.removeListener(_onMapSearchFocusChange);
    _mapSearchController.removeListener(_onMapSearchTextChange);
    _mapSearchFocusNode.dispose();
    _locationSub?.cancel();
    _routeLocSub?.cancel();
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

  // Plan new action moved to ShopTab; no handler needed here.

  // ----------------- Helpers: Firestore -> Markers -----------------
  void _subscribeFirestoreMarkers() {
    // Listen to 'location' collection
    _locationSub = FirebaseFirestore.instance
        .collection('location')
        .snapshots()
        .listen(
          (snapshot) {
            _updateMarkersFromSnapshot(snapshot, source: 'location');
          },
          onError: (e) {
            // Ignore offline errors; UI remains responsive
          },
        );

    // Listen to 'routeLoc' collection
    _routeLocSub = FirebaseFirestore.instance
        .collection('routeLoc')
        .snapshots()
        .listen(
          (snapshot) {
            _updateMarkersFromSnapshot(snapshot, source: 'routeLoc');
          },
          onError: (e) {
            // Ignore offline errors
          },
        );
  }

  void _updateMarkersFromSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot, {
    required String source,
  }) {
    // Build a new set for this source and then merge into _dynamicMarkers
    final Map<String, Marker> updatedForSource = {};
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final latLng = _extractLatLng(data);
      if (latLng == null) continue; // no coordinates — skip

      final title = (data['title'] ?? '') as String?;
      final markerId = MarkerId('$source:${doc.id}');
      updatedForSource['$source:${doc.id}'] = Marker(
        markerId: markerId,
        position: latLng,
        infoWindow: InfoWindow(title: title?.isNotEmpty == true ? title : null),
      );
    }

    setState(() {
      // Remove old markers for this source
      _dynamicMarkers.removeWhere((key, _) => key.startsWith('$source:'));
      // Add updated
      _dynamicMarkers.addAll(updatedForSource);
    });
  }

  LatLng? _extractLatLng(Map<String, dynamic> data) {
    // 1) GeoPoint under common keys
    final dynamic geo = data['geo'] ?? data['geopoint'] ?? data['position'];
    if (geo is GeoPoint) {
      return LatLng(geo.latitude, geo.longitude);
    }

    // 2) Nested map with lat/lng
    final dynamic loc = data['location'] ?? data['loc'] ?? data['coords'];
    if (loc is Map) {
      final lat = _toDouble(loc['lat'] ?? loc['latitude']);
      final lng = _toDouble(loc['lng'] ?? loc['longitude']);
      if (lat != null && lng != null) return LatLng(lat, lng);
    }

    // 3) Flat lat/lng fields
    final lat = _toDouble(data['lat'] ?? data['latitude']);
    final lng = _toDouble(data['lng'] ?? data['longitude']);
    if (lat != null && lng != null) return LatLng(lat, lng);

    // 4) Coordinates array [lng, lat] or [lat, lng]
    final coords = data['coordinates'];
    if (coords is List && coords.length >= 2) {
      // Try [lat, lng]
      final lat1 = _toDouble(coords[0]);
      final lng1 = _toDouble(coords[1]);
      if (lat1 != null && lng1 != null) return LatLng(lat1, lng1);
    }

    return null;
  }

  double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) {
      return double.tryParse(v);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers = {..._staticMarkers, ..._dynamicMarkers.values};
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// Google Map
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              markers: markers,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) _controller.complete(controller);
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
                          // Plan new button (visible but intentionally does nothing)
                          TextButton.icon(
                            onPressed: () => context.push(
                              AppPath.newLocation.path,
                            ), // intentionally no-op
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
                    builder: (context, locationSnapshot) {
                      final locationDocs = locationSnapshot.data?.docs ?? [];
                      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('routeLoc')
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                        builder: (context, routeSnapshot) {
                          final routeDocs = routeSnapshot.data?.docs ?? [];

                          // combine both lists and keep source info
                          final combined = <Map<String, Object>>[];
                          combined.addAll(
                            locationDocs.map(
                              (d) => {'doc': d, 'source': 'location'},
                            ),
                          );
                          combined.addAll(
                            routeDocs.map(
                              (d) => {'doc': d, 'source': 'routeLoc'},
                            ),
                          );

                          // map to pairs with createdAt DateTime for sorting and keep source
                          final items = combined.map((entry) {
                            final doc =
                                entry['doc']
                                    as QueryDocumentSnapshot<
                                      Map<String, dynamic>
                                    >;
                            final data = doc.data();
                            final createdRaw = data['createdAt'];
                            DateTime created;
                            if (createdRaw is Timestamp) {
                              created = createdRaw.toDate();
                            } else if (createdRaw is int) {
                              created = DateTime.fromMillisecondsSinceEpoch(
                                createdRaw,
                              );
                            } else {
                              created = DateTime.fromMillisecondsSinceEpoch(0);
                            }
                            return {
                              'doc': doc,
                              'created': created,
                              'source': entry['source'],
                            };
                          }).toList();

                          // sort newest first
                          items.sort(
                            (a, b) => (b['created'] as DateTime).compareTo(
                              a['created'] as DateTime,
                            ),
                          );

                          return ListView.builder(
                            controller: scrollController,
                            itemCount: 2 + items.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // шеврон
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
                                // заголовок
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    bottom: 8,
                                  ),
                                  child: Text(
                                    "Nearby Locations",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                );
                              } else {
                                final doc =
                                    items[index - 2]['doc']
                                        as QueryDocumentSnapshot<
                                          Map<String, dynamic>
                                        >;
                                final data = doc.data();
                                // Use the Firestore document id to navigate to details
                                final id = doc.id;
                                final title = data['title'] ?? '';
                                final created =
                                    items[index - 2]['created'] as DateTime;
                                final timestampText =
                                    created.millisecondsSinceEpoch > 0
                                    ? created.toString()
                                    : '';

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 16,
                                    left: 16,
                                    right: 16,
                                  ),
                                  child: ProductCardNav(
                                    onTap: () {
                                      final source =
                                          items[index - 2]['source']
                                              as String? ??
                                          'location';
                                      final target = (source == 'routeLoc')
                                          ? '${AppPath.location.path}/$id' // routeLoc -> open location.dart
                                          : '${AppPath.locationDay.path}/$id'; // location -> open location_day.dart
                                      context.push(target);
                                    },
                                    productName: title,
                                    price: '',
                                    tag:
                                        (data['tagLoc'] is List &&
                                            data['tagLoc'].isNotEmpty)
                                        ? (data['tagLoc'][0] ?? '')
                                        : '',
                                    location: '',
                                    timestamp: timestampText,
                                    imageUrl: data['photoLoc'] ?? '',
                                  ),
                                );
                              }
                            },
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
