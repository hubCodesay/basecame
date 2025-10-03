import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:basecam/pages/root/widgetes/filter_button.dart';
import 'package:basecam/pages/root/widgetes/info_box_photo.dart';
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

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  List<TextEditingController> waypointControllers = [TextEditingController()];

  void _addWaypoint() {
    setState(() {
      waypointControllers.add(TextEditingController());
    });
  }

  void _removeWaypoint(int index) {
    setState(() {
      waypointControllers.removeAt(index);
    });
  }

  // Функція, що повертає контент для кожного таба
  Widget _buildSelectedTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
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
              controller: _nameController,
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
              controller: _descriptionController,
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

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
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
              controller: _nameController,
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
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Список вейпоінтів",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),

                ...waypointControllers.asMap().entries.map((entry) {
                  int index = entry.key;
                  TextEditingController controller = entry.value;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16,
                    ), // відстань між вейпоінтами
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ), // відступи всередині контейнера
                    decoration: BoxDecoration(
                      color: ThemeColors
                          .silverColor, // світлий фон, як на картинці
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // drag-handle (ліворуч)
                        Icon(
                          Icons.drag_indicator_sharp,
                          color: ThemeColors.blackColor,
                        ),
                        // const SizedBox(height: 16),

                        // саме поле вводу
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: "Input Waypoint address",
                              border: InputBorder.none, // без рамки
                              // contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            ),
                          ),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: ThemeColors.greyColor,
                          ),
                          onPressed: () {},
                        ),

                      ],
                    ),
                  );
                }),

                TextButton.icon(
                  onPressed: _addWaypoint,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Waypoint"),
                ),
                const SizedBox(height: 18),
              ],
            ),

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
                        child: const Text("Save changes"),
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
