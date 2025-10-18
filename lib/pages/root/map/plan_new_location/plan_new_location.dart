import 'package:basecam/ui/widgets/info_box_photo.dart';
import 'package:basecam/ui/widgets/single_photo_picker.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:basecam/ui/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Image picker, storage and platform checks used by the inline upload helper
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PlanNewLocation extends StatefulWidget {
  const PlanNewLocation({super.key});

  @override
  _PlanNewLocationState createState() => _PlanNewLocationState();
}

class _PlanNewLocationState extends State<PlanNewLocation> {
  int selectedTabIndex = 0;
  final double itemAxisSpacing = 8.0;
  final _formKey = GlobalKey<FormState>();
  final String imageUrl = "assets/images/map.png";

  // Контролери для вкладки "Location"
  final _locationNameController = TextEditingController();
  final _locationTimingController = TextEditingController();
  final _locationDescriptionController = TextEditingController();

  // Контролери для вкладки "Route"
  final _routeNameController = TextEditingController();
  final _routeTimingController = TextEditingController();
  final _routeDescriptionController = TextEditingController();
  final _routeTagController = TextEditingController();

  // Стан для вейпоінтів
  List<TextEditingController> waypointAddressControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  List<TextEditingController> waypointNameControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  List<TextEditingController> waypointDescControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  List<bool> isWaypointExpanded = [false, false];

  @override
  void dispose() {
    _locationNameController.dispose();
    _locationTimingController.dispose();
    _locationDescriptionController.dispose();
    _routeNameController.dispose();
    _routeTimingController.dispose();
    _routeDescriptionController.dispose();
    _routeTagController.dispose();
    for (var c in waypointAddressControllers) {
      c.dispose();
    }
    for (var c in waypointNameControllers) {
      c.dispose();
    }
    for (var c in waypointDescControllers) {
      c.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> waypointControllers = [TextEditingController()];

  void _addWaypoint() {
    setState(() {
      waypointAddressControllers.add(TextEditingController());
      waypointNameControllers.add(TextEditingController());
      waypointDescControllers.add(TextEditingController());
      isWaypointExpanded.add(false);
    });
  }

  void _removeWaypoint(int index) {
    if (waypointAddressControllers.length > 2) {
      setState(() {
        waypointAddressControllers[index].dispose();
        waypointNameControllers[index].dispose();
        waypointDescControllers[index].dispose();

        waypointAddressControllers.removeAt(index);
        waypointNameControllers.removeAt(index);
        waypointDescControllers.removeAt(index);
        isWaypointExpanded.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A minimum of 2 waypoints is required."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Reorder handler keeps address/name/description/expand state in sync
  void _reorderWaypoint(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final a = waypointAddressControllers.removeAt(oldIndex);
      final n = waypointNameControllers.removeAt(oldIndex);
      final d = waypointDescControllers.removeAt(oldIndex);
      final e = isWaypointExpanded.removeAt(oldIndex);
      waypointAddressControllers.insert(newIndex, a);
      waypointNameControllers.insert(newIndex, n);
      waypointDescControllers.insert(newIndex, d);
      isWaypointExpanded.insert(newIndex, e);
    });
  }

  Widget _buildWaypointsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "List of waypoints",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: waypointAddressControllers.length,
          buildDefaultDragHandles: false,
          onReorder: (oldIndex, newIndex) =>
              _reorderWaypoint(oldIndex, newIndex),
          itemBuilder: (context, index) {
            return Container(
              key: ValueKey('wp_$index'),
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThemeColors.silverColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ReorderableDragStartListener(
                        index: index,
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/indicator.svg',
                              width: 7,
                              height: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: waypointAddressControllers[index],
                          decoration: const InputDecoration(
                            hintText: "Input Waypoint address",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isWaypointExpanded[index]
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: ThemeColors.greyColor,
                        ),
                        onPressed: () {
                          setState(() {
                            isWaypointExpanded[index] =
                                !isWaypointExpanded[index];
                          });
                        },
                      ),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        SizeTransition(sizeFactor: animation, child: child),
                    child: isWaypointExpanded[index]
                        ? Column(
                            key: ValueKey('expanded_$index'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              TextField(
                                controller: waypointNameControllers[index],
                                decoration: const InputDecoration(
                                  hintText: "Waypoint name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: waypointDescControllers[index],
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  hintText: "Description",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  // TODO: ImagePicker
                                },
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    radius: Radius.circular(20),
                                    dashPattern: const [6, 6],
                                    color: ThemeColors.greyColor,
                                    strokeWidth: 2,
                                  ),
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        SizedBox(height: 8),
                                        // Placeholder for photo add UI
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (waypointAddressControllers.length > 2)
                                Center(
                                  child: TextButton.icon(
                                    onPressed: () => _removeWaypoint(index),
                                    icon: SvgPicture.asset(
                                      'assets/icons/delete.svg',
                                      width: 20,
                                      height: 20,
                                      colorFilter: const ColorFilter.mode(
                                        ThemeColors.redColor50,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    label: const Text(
                                      "Delete Waypoint",
                                      style: TextStyle(
                                        color: ThemeColors.redColor50,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          },
        ),
        Center(
          child: TextButton.icon(
            onPressed: _addWaypoint,
            icon: SvgPicture.asset(
              'assets/icons/plus.svg',
              width: 10,
              height: 10,
              colorFilter: const ColorFilter.mode(
                ThemeColors.greyColor,
                BlendMode.srcIn,
              ),
            ),
            label: const Text("Add Waypoint"),
            style: TextButton.styleFrom(
              foregroundColor: ThemeColors.greyColor,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Build content for currently selected tab
  Widget _buildSelectedTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _locationNameController,
              decoration: const InputDecoration(
                hintText: "Name of Location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationTimingController,
              decoration: const InputDecoration(
                hintText: "Best Timing",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationDescriptionController,
              decoration: const InputDecoration(
                hintText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 18),
            Stack(
              children: [
                Image.asset(
                  imageUrl,
                  height: 143,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SinglePhotoPicker(
              onChanged: (file) {
                // зберегти у роути setState(() => _imageFile = file);
              },
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.65,
              children: const [
                InfoBoxPhoto(),
                InfoBoxPhoto(),
                InfoBoxPhoto(),
                InfoBoxPhoto(),
              ],
            ),
            const SizedBox(height: 10),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _routeNameController,
              obscureText: false,
              decoration: const InputDecoration(
                hintText: "Name of route",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _routeTagController,
              decoration: const InputDecoration(
                hintText: "Tag",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _routeDescriptionController,
              decoration: const InputDecoration(
                hintText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            _buildWaypointsList(),
            Stack(
              children: [
                Image.asset(
                  imageUrl,
                  height: 143,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SinglePhotoPicker(
              onChanged: (file) {
                // зберегти у роути setState(() => _imageFile = file);
              },
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.65,
              children: const [
                InfoBoxPhoto(),
                InfoBoxPhoto(),
                InfoBoxPhoto(),
                InfoBoxPhoto(),
                InfoBoxPhoto(),
              ],
            ),
            const SizedBox(height: 10),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTabStyle = Theme.of(
      context,
    ).textTheme.titleMedium!.copyWith(color: ThemeColors.greyColor);
    final textSelTabStyle = Theme.of(
      context,
    ).textTheme.titleMedium!.copyWith(color: ThemeColors.primaryTextColor);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "New experience",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 24),
                CustomSlidingSegmentedControl<int>(
                  isStretch: true,
                  initialValue: selectedTabIndex,
                  children: {
                    0: Text(
                      'Location',
                      style: selectedTabIndex == 0
                          ? textSelTabStyle
                          : textTabStyle,
                    ),
                    1: Text(
                      'Route',
                      style: selectedTabIndex == 1
                          ? textSelTabStyle
                          : textTabStyle,
                    ),
                  },
                  decoration: BoxDecoration(
                    color: ThemeColors.silverColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: ThemeColors.pureBlackColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                        offset: Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                  onValueChanged: (value) {
                    setState(() => selectedTabIndex = value);
                  },
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: Container(
                      alignment: Alignment.topCenter,
                      key: ValueKey<int>(selectedTabIndex),
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildSelectedTabContent(),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: ThemeColors.silverColor,
                          foregroundColor: ThemeColors.blackColor,
                        ),
                        onPressed: () => context.pop(),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _onCreatePressed,
                        child: const Text("Create"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --------------- Firestore save logic ---------------
extension _PlanNewLocationSave on _PlanNewLocationState {
  Future<void> _onCreatePressed() async {
    // Handle Location save (tab 0)
    if (selectedTabIndex == 0) {
      final name = _locationNameController.text.trim();
      final timing = _locationTimingController.text.trim();
      final description = _locationDescriptionController.text.trim();

      if (name.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Enter location name')));
        return;
      }

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saving location...')));

      try {
        // Ensure auth
        if (FirebaseAuth.instance.currentUser == null) {
          await FirebaseAuth.instance.signInAnonymously();
        }
        final uid = FirebaseAuth.instance.currentUser!.uid;

        // Create new location doc with generated id
        final locRef = FirebaseFirestore.instance
            .collection('locationMaps')
            .doc();

        final data = {
          'name': name,
          'timing': timing,
          'description': description,
          'ownerUid': uid,
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Write data (merge=false -> replace current if exists). Using set without merge
        // to ensure the doc reflects the new payload. If you prefer merge, use SetOptions(merge: true).
        await locRef.set(data);

        // Photo for location is optional. The UI provides a map/placeholding
        // area where a user can later add a photo. We do NOT force a picker
        // here to keep creation fast and optional for users.
        // If you want to offer immediate upload, call
        // `_pickAndUploadPhotoToCollection('locationMaps', locRef.id)` on user action.

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Location saved')));
        await Future.delayed(const Duration(milliseconds: 400));
        if (context.mounted) context.pop();
        return;
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
        return;
      }
    }

    // --- Route save (existing logic) ---

    final title = _routeNameController.text.trim();
    final description = _routeDescriptionController.text.trim();
    final tag = _routeTagController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter route name')));
      return;
    }
    if (waypointAddressControllers.length < 2) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Add at least 2 waypoints')));
      return;
    }

    // Visual feedback
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saving route...')));

    try {
      // Ensure the user is authenticated (for ownerUid and Storage path uid)
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }

      final routeRef = await FirebaseFirestore.instance
          .collection('routes')
          .add({
            'title': title,
            'description': description,
            // Store as list for compatibility with map list renderer
            'tagLoc': tag.isNotEmpty ? [tag] : [],
            'ownerUid': FirebaseAuth.instance.currentUser!.uid,
            'createdAt': FieldValue.serverTimestamp(),
          });

      final batch = FirebaseFirestore.instance.batch();
      for (int i = 0; i < waypointAddressControllers.length; i++) {
        final addr = waypointAddressControllers[i].text.trim();
        final name = waypointNameControllers[i].text.trim();
        final desc = waypointDescControllers[i].text.trim();
        final wpRef = routeRef.collection('waypoints').doc();
        batch.set(wpRef, {
          'address': addr,
          'name': name,
          'description': desc,
          'order': i,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();

      // Optional: right after creating the route+waypoints, offer to pick
      // and upload a route cover photo. The function will open the gallery,
      // upload to Storage (routes/{uid}/{routeId}/{ts}.jpg), then write
      // the download URL into route document photos[] field.
      try {
        final url = await _pickAndUploadPhotoToCollection(
          'routes',
          routeRef.id,
        );
        if (url != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo uploaded successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Photo upload failed: $e')));
        }
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Route saved')));
      // Close screen after short delay
      await Future.delayed(const Duration(milliseconds: 400));
      if (context.mounted) context.pop();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    }
  }
}

// Local helper: pick image from gallery and upload to Firebase Storage, then
// save the download URL into Firestore under collection/docId -> photos[]
extension _PlanNewLocationPhoto on _PlanNewLocationState {
  Future<String?> _pickAndUploadPhotoToCollection(
    String collection,
    String docId,
  ) async {
    // Keep this helper self-contained to avoid depending on external services
    // file which may be missing. Uses image_picker and firebase_storage
    try {
      // lazy import-like usage: create ImagePicker here
      final picker = ImagePicker();
      final xfile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (xfile == null) return null;

      // Ensure auth
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      final storagePath = '$collection/$uid/$docId/$ts.jpg';
      final ref = FirebaseStorage.instance.ref().child(storagePath);

      UploadTask uploadTask;
      if (kIsWeb) {
        final bytes = await xfile.readAsBytes();
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        final file = File(xfile.path);
        uploadTask = ref.putFile(
          file,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      }

      final sub = uploadTask.snapshotEvents.listen((s) {
        // Optionally, you can surface progress to UI by setting state here
      });
      final snap = await uploadTask.whenComplete(() {});
      await sub.cancel();

      final url = await snap.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection(collection).doc(docId).set({
        'photos': FieldValue.arrayUnion([url]),
        'updatedAt': FieldValue.serverTimestamp(),
        'ownerUid': FirebaseAuth.instance.currentUser!.uid,
      }, SetOptions(merge: true));

      return url;
    } catch (e) {
      rethrow;
    }
  }
}
