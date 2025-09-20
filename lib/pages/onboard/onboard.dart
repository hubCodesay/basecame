import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:basecam/app_path.dart';
import 'package:basecam/ui/theme.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key, this.from});

  /// Звідки прийшли на екран
  final String? from;

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final PageController _stepController = PageController();
  final texts = [
    "Join a community of creators, rent gear, and share your passion",
    "Explore stunning locations, create unforgettable journeys, and capture it all",
    "Rent, create, and collaborate — all in one place, anytime, anywhere",
    "Begin your journey with Basecam",
  ];
  int step = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              SizedBox(
                height: screenWidth * 0.7,
                child: Center(
                  child: SizedBox(
                    width: (screenWidth * 0.7),
                    height: (screenWidth * 0.7),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/pexels.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsetsGeometry.only(top: 36, bottom: 24),
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                  controller: _stepController,
                  count: 4,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotColor: ThemeColors.cloudGreyColor,
                    activeDotColor: ThemeColors.pureBlackColor,
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: Text(
                  texts[step],
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (step < 3)
                      FilledButton(
                        onPressed: onNextButton,
                        child: Text("Next"),
                      ),
                    if (step == 3)
                      ...[
                        FilledButton(
                          onPressed: onLoginButton,
                          child: Text("Login"),
                        ),
                        SizedBox(height: 12),
                        FilledButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColors.silverColor,
                            foregroundColor: ThemeColors.blackColor,
                          ),
                          onPressed: onRegisterButton,
                          child: Text("Register"),
                        ),
                      ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onNextButton() {
    setState(() {
      step++;
    });
  }

  void onLoginButton() {
    context.go(AppPath.login.path);
  }

  void onRegisterButton() {
    context.go(AppPath.registration.path);
  }
}
