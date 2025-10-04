import 'package:basecam/ui/widgets/filter_button.dart';
import 'package:basecam/ui/widgets/info_box_photo.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:basecam/ui/theme.dart';

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
  List<bool> isWaypointExpanded = [true, false];

  @override
  void dispose() {
    _locationNameController.dispose();
    _locationTimingController.dispose();
    _locationDescriptionController.dispose();
    _routeNameController.dispose();
    _routeTimingController.dispose();
    _routeDescriptionController.dispose();
    for (var c in waypointAddressControllers) { c.dispose(); }
    for (var c in waypointNameControllers) { c.dispose(); }
    for (var c in waypointDescControllers) { c.dispose(); }
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


  Widget _buildWaypointsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "List of waypoints",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: waypointAddressControllers.length,
          itemBuilder: (context, index) {
            return Container(
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
                      SvgPicture.asset(
                        'assets/icons/indicator.svg',
                        width: 7,
                        height: 12,
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
                  if (isWaypointExpanded[index]) ...[
                    const SizedBox(height: 8),
                    TextField(
                      controller: waypointNameControllers[index],
                      decoration: const InputDecoration(
                        hintText: "Waypoint name",
                        border: OutlineInputBorder(),
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
                          // borderType: BorderType.RRect,
                          radius: Radius.circular(20),
                          dashPattern: [6, 6],
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/plus.svg',
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(height: 26),
                              Text(
                                "Add Photos",
                                style: TextStyle(
                                  color: ThemeColors.greyColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
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
                            colorFilter: const ColorFilter.mode(ThemeColors.redColor50, BlendMode.srcIn),
                          ),
                          label: const Text(
                            "Delete Waypoint",
                            style: TextStyle(color: ThemeColors.redColor50),
                          ),
                        ),
                      ),
                  ]
                  // --- НОВИЙ БЛОК: ПОКАЗУЄТЬСЯ В ЗГОРНУТОМУ СТАНІ ---
                  else ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 40),
                      child: Text(
                        // Показуємо назву, якщо вона є, інакше опис, інакше нічого
                        waypointNameControllers[index].text.isNotEmpty
                            ? waypointNameControllers[index].text
                            : waypointDescControllers[index].text,
                        style: const TextStyle(
                          color: ThemeColors.greyColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ]
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
              colorFilter: const ColorFilter.mode(ThemeColors.greyColor, BlendMode.srcIn),
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


  // Функція, що повертає контент для кожного таба
  Widget _buildSelectedTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _locationNameController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Name of Location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: FilterButton(
                    onPressed: () {},
                    rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                    useSpacer: true,
                    backgroundColor: ThemeColors.background,
                    borderColor: ThemeColors.silverColor,
                    foregroundColor: ThemeColors.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    borderRadius: 12,
                    label: const Text("Spot Type"),
                    dropIcon: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterButton(
                    onPressed: () {},
                    rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                    useSpacer: true,
                    backgroundColor: ThemeColors.background,
                    borderColor: ThemeColors.silverColor,
                    foregroundColor: ThemeColors.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    borderRadius: 12,
                    label: const Text("Activity"),
                    dropIcon: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationTimingController,
              obscureText: true,
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
            const SizedBox(height: 12),
            FilterButton(
              onPressed: () {},
              rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
              useSpacer: true,
              icon: SvgPicture.asset(
                'assets/icons/search.svg',
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
              label: Text("Input address or pick below"),
            ),
            const SizedBox(height: 18),
            Stack(
              children: [
                Image.asset(
                  imageUrl,
                  height: 143,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 143,
                      color: Colors.grey[300],
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.map, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Map unavailable',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Enable Maps API or provide API keys',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                // TODO: ImagePicker
              },
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  // borderType: BorderType.RRect,
                  radius: Radius.circular(20),
                  dashPattern: [6, 6],
                  color: Colors.grey.shade400,
                  strokeWidth: 2,
                ),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/plus.svg',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(height: 26),
                      Text(
                        "Add Photos",
                        style: TextStyle(
                          color: ThemeColors.greyColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
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

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _routeNameController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Name of route",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: FilterButton(
                    onPressed: () {},
                    rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                    useSpacer: true,
                    backgroundColor: ThemeColors.background,
                    borderColor: ThemeColors.silverColor,
                    foregroundColor: ThemeColors.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    borderRadius: 12,
                    label: const Text("Route Type"),
                    dropIcon: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterButton(
                    onPressed: () {},
                    rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                    useSpacer: true,
                    backgroundColor: ThemeColors.background,
                    borderColor: ThemeColors.silverColor,
                    foregroundColor: ThemeColors.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    borderRadius: 12,
                    label: const Text("Difficulty"),
                    dropIcon: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _routeTimingController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Best Timing",
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
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 143,
                      color: Colors.grey[300],
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.map, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Map unavailable',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Enable Maps API or provide API keys',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                // TODO: ImagePicker
              },
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  // borderType: BorderType.RRect,
                  radius: Radius.circular(20),
                  dashPattern: [6, 6],
                  color: Colors.grey.shade400,
                  strokeWidth: 2,
                ),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/plus.svg',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(height: 26),
                      Text(
                        "Add Photos",
                        style: TextStyle(
                          color: ThemeColors.greyColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
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
                InfoBoxPhoto(
                  // asset: 'assets/icons/timer.svg',
                ),
                InfoBoxPhoto(
                  // asset: 'assets/icons/sunrise.svg',
                ),
                InfoBoxPhoto(
                  // asset: 'assets/icons/timer.svg',
                ),
                InfoBoxPhoto(
                  // asset: 'assets/icons/sunrise.svg',
                ),
                InfoBoxPhoto(
                  // asset: 'assets/icons/timer.svg',
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        );
    // Залишаємо заглушку для другої вкладки
    // return ListView.builder(
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   itemCount: 6,
    //   itemBuilder: (context, index) {
    //     return Padding(
    //       padding: EdgeInsets.only(
    //         bottom: index == 5 ? 0 : itemAxisSpacing,
    //       ),
    //       child: const Text("Content for Locations tab"),
    //     );
    //   },
    // );

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
                        onPressed: () {
                          context.pop();
                        },
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
