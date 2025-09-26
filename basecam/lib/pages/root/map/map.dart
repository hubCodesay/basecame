import 'package:basecam/app_path.dart';
// ...existing code... (removed unused product card import)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:basecam/models/post.dart';
import 'package:basecam/services/posts_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:basecam/ui/theme.dart';
import 'package:basecam/pages/root/widgetes/filter_button.dart';
import 'package:basecam/pages/root/widgetes/search.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  // Simple search state retained for the top search bar.

  // No persistent controllers at class scope; create controllers locally in
  // the modal to keep lifecycle simple and avoid accidental reuse.

  void _handleSearchChanged(String value) {
    // no-op for now
  }

  Future<void> _handlePlanNewPressed() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final categoryController = TextEditingController();
    final priceController = TextEditingController();
    final depositController = TextEditingController();
    final latController = TextEditingController();
    final lngController = TextEditingController();
    final cityController = TextEditingController();
    final countryCodeController = TextEditingController();
    final brandController = TextEditingController();
    final modelController = TextEditingController();
    final conditionController = TextEditingController();
    final availabilityTimezoneController = TextEditingController();
    final mapPointIdController = TextEditingController();
    final photoUrlController = TextEditingController();
    final depositRequired = ValueNotifier<bool>(false);

    var isSaving = false;

    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            minChildSize: 0.25,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Material(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setModalState) {
                      return ListView(
                        controller: scrollController,
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 8),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                          ),
                          TextField(
                            controller: descController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                          ),
                          TextField(
                            controller: categoryController,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: priceController,
                                  decoration: const InputDecoration(
                                    labelText: 'Price / day (amount)',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('EUR'),
                            ],
                          ),
                          Row(
                            children: [
                              ValueListenableBuilder<bool>(
                                valueListenable: depositRequired,
                                builder: (context, value, child) => Checkbox(
                                  value: value,
                                  onChanged: (v) =>
                                      depositRequired.value = v ?? false,
                                ),
                              ),
                              const Text('Deposit required'),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: depositController,
                                  decoration: const InputDecoration(
                                    labelText: 'Deposit amount',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: latController,
                                  decoration: const InputDecoration(
                                    labelText: 'Latitude',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: lngController,
                                  decoration: const InputDecoration(
                                    labelText: 'Longitude',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextField(
                            controller: cityController,
                            decoration: const InputDecoration(
                              labelText: 'City',
                            ),
                          ),
                          TextField(
                            controller: countryCodeController,
                            decoration: const InputDecoration(
                              labelText: 'Country Code (UA)',
                            ),
                          ),
                          TextField(
                            controller: brandController,
                            decoration: const InputDecoration(
                              labelText: 'Brand',
                            ),
                          ),
                          TextField(
                            controller: modelController,
                            decoration: const InputDecoration(
                              labelText: 'Model',
                            ),
                          ),
                          TextField(
                            controller: conditionController,
                            decoration: const InputDecoration(
                              labelText: 'Condition',
                            ),
                          ),
                          TextField(
                            controller: availabilityTimezoneController,
                            decoration: const InputDecoration(
                              labelText: 'Availability timezone',
                            ),
                          ),
                          TextField(
                            controller: mapPointIdController,
                            decoration: const InputDecoration(
                              labelText: 'mapPointId (optional',
                            ),
                          ),
                          TextField(
                            controller: photoUrlController,
                            decoration: const InputDecoration(
                              labelText: 'Photo URL (optional',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: isSaving
                                    ? null
                                    : () async {
                                        final name = nameController.text.trim();
                                        final desc = descController.text.trim();
                                        if (name.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Name is required'),
                                            ),
                                          );
                                          return;
                                        }
                                        setModalState(() => isSaving = true);
                                        try {
                                          final lat = double.tryParse(
                                            latController.text.trim(),
                                          );
                                          final lng = double.tryParse(
                                            lngController.text.trim(),
                                          );
                                          if (lat == null || lng == null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Latitude and Longitude are required',
                                                ),
                                              ),
                                            );
                                            setModalState(
                                              () => isSaving = false,
                                            );
                                            return;
                                          }
                                          final post = Post(
                                            title: name,
                                            description: desc,
                                            category:
                                                categoryController.text
                                                    .trim()
                                                    .isNotEmpty
                                                ? categoryController.text.trim()
                                                : 'camera',
                                            pricePerDayAmount: double.tryParse(
                                              priceController.text.trim(),
                                            ),
                                            depositRequired:
                                                depositRequired.value,
                                            depositAmount:
                                                double.tryParse(
                                                  depositController.text.trim(),
                                                ) ??
                                                0,
                                            locationGeo: GeoPoint(lat, lng),
                                            locationGeohash: '',
                                            locationCity: cityController.text
                                                .trim(),
                                            locationCountryCode:
                                                countryCodeController.text
                                                    .trim(),
                                            brand:
                                                brandController.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : brandController.text.trim(),
                                            model:
                                                modelController.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : modelController.text.trim(),
                                            condition:
                                                conditionController.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : conditionController.text
                                                      .trim(),
                                            availabilityTimezone:
                                                availabilityTimezoneController
                                                    .text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : availabilityTimezoneController
                                                      .text
                                                      .trim(),
                                            mapPointId:
                                                mapPointIdController.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : mapPointIdController.text
                                                      .trim(),
                                            photos:
                                                photoUrlController.text
                                                    .trim()
                                                    .isEmpty
                                                ? []
                                                : [
                                                    {
                                                      'url': photoUrlController
                                                          .text
                                                          .trim(),
                                                      'storagePath': '',
                                                    },
                                                  ],
                                          );
                                          final docId = await postsRepo
                                              .addPost(post)
                                              .timeout(
                                                const Duration(seconds: 10),
                                              );
                                          if (context.mounted)
                                            Navigator.of(context).pop();
                                          ScaffoldMessenger.of(
                                            this.context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Post created and saved to DB (id: $docId)',
                                              ),
                                            ),
                                          );
                                        } on TimeoutException {
                                          debugPrint('Adding post timed out');
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Save timed out. Check your network and try again.',
                                              ),
                                            ),
                                          );
                                          setModalState(() => isSaving = false);
                                        } catch (e, st) {
                                          debugPrint(
                                            'Failed to add post: $e\n$st',
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Failed to save: $e',
                                              ),
                                            ),
                                          );
                                          setModalState(() => isSaving = false);
                                        }
                                      },
                                child: isSaving
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Save'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      );
    } finally {
      nameController.dispose();
      descController.dispose();
      categoryController.dispose();
      priceController.dispose();
      depositController.dispose();
      latController.dispose();
      lngController.dispose();
      cityController.dispose();
      countryCodeController.dispose();
      brandController.dispose();
      modelController.dispose();
      conditionController.dispose();
      availabilityTimezoneController.dispose();
      mapPointIdController.dispose();
      photoUrlController.dispose();
      depositRequired.dispose();
    }
  }

  // Replaced top-level free functions with instance methods so they are
  // available after inlining the map placeholder.
  void _onFilterPhoto() {
    // Placeholder behaviour for filter buttons — no-op for now.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filter by photo (not implemented)')),
    );
  }

  // _handleSearchChanged already declared above; keep single implementation.

  void _onFilterPoint() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filter by point (not implemented)')),
    );
  }

  void _onFilter() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Filter (not implemented)')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Placeholder instead of an actual GoogleMap. This prevents
            // runtime errors when Google Maps fails to initialize or when
            // the plugin isn't configured for the current platform.
            Container(
              color: Colors.grey.shade100,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.map_outlined, size: 72, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Map is unavailable in this build',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
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
                              onPressed: _onFilterPhoto,
                              icon: SvgPicture.asset(
                                'assets/icons/camera.svg',
                                width: 24,
                                height: 24,
                                placeholderBuilder: (context) => const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
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
                              onPressed: _onFilterPoint,
                              icon: SvgPicture.asset(
                                'assets/icons/location.svg',
                                width: 24,
                                height: 24,
                                placeholderBuilder: (context) => const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
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
                              onPressed: _onFilter,
                              icon: SvgPicture.asset(
                                'assets/icons/filter.svg',
                                width: 24,
                                height: 24,
                                placeholderBuilder: (context) => const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Icon(
                                    Icons.filter_list,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
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
                        color: Colors.black.withOpacity(0.15),
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
                        margin: const EdgeInsets.symmetric(vertical: 10),
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
                        child: StreamBuilder<List<Post>>(
                          stream: postsRepo.streamPosts(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final posts = snapshot.data!;
                            if (posts.isEmpty) {
                              return const Center(
                                child: Text(
                                  'Пусто — ще немає постів. Створіть їх через "Plan new".',
                                ),
                              );
                            }
                            return ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final p = posts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Card(
                                    elevation: 2,
                                    child: ListTile(
                                      onTap: () =>
                                          context.push(AppPath.location.path),
                                      title: Text(p.title),
                                      subtitle: Text(p.description),
                                      trailing: p.ownerId != null
                                          ? const Icon(Icons.person)
                                          : null,
                                    ),
                                  ),
                                );
                              },
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

// Removed stray top-level helper functions (instance methods are used above).
