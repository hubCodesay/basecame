import 'package:flutter/material.dart';
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
  final PageController _scrollController = PageController();
  final texts = [
    "Join a community of creators, rent gear, and share your passion",
    "Explore stunning locations, create unforgettable journeys, and capture it all",
    "Rent, create, and collaborate — all in one place, anytime, anywhere",
    "Begin your journey with Basecam",
  ];
  final images = [
    "assets/onboard/1.png",
    "assets/onboard/2.png",
    "assets/onboard/3.png",
    "assets/onboard/4.png",
  ];
  int step = 0;
  bool _isAnimating = false; // Флаг для запобігання зациклення

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _syncPageViews(
    int index
  ) async {
    if (_isAnimating) return; // Запобігаємо зациклення

    _isAnimating = true;
    setState(() => step = index);

    // Синхронізуємо другий PageView
    await _scrollController.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );

    _isAnimating = false;
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

              // PageView для зображень
              Stack(
                alignment: AlignmentGeometry.topCenter,
                children: [
                  // Індикатор =========================
                  Container(
                    padding: EdgeInsets.only(
                      top: 36 + screenWidth * 0.7,
                      bottom: 24,
                    ),
                    alignment: Alignment.center,
                    child: SmoothPageIndicator(
                      controller:
                          _scrollController, // Прив'язуємо до першого PageView
                      count: texts.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotColor: ThemeColors.cloudGreyColor,
                        activeDotColor: ThemeColors.pureBlackColor,
                      ),
                    ),
                  ),

                  // Те що гортається
                  SizedBox(
                    height: screenWidth * 0.7 + 68 + 120,
                    child: PageView(
                      controller: _scrollController,
                      onPageChanged: (index) => _syncPageViews(index),
                      children: List.generate(texts.length, (index) {
                        // return Placeholder();
                        return Column(
                          children: [
                            // зображення
                            SizedBox(
                              height: screenWidth * 0.7,
                              child: Center(
                                child: SizedBox(
                                  width: screenWidth * 0.7,
                                  height: screenWidth * 0.7,
                                  child: ClipOval(
                                    child: Image.asset(
                                      images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Місце під Індикатор
                            SizedBox(height: 68),
                            // PageView для тексту
                            SizedBox(
                              height: 120,
                              child: Text(
                                texts[index],
                                style: Theme.of(context).textTheme.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),

              Spacer(),

              // Кнопки
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
                    if (step == 3) ...[
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

  void onNextButton() async {
    if (_isAnimating) return;

    _isAnimating = true;
    setState(() => step++);

    await _scrollController.nextPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
    );

    _isAnimating = false;
  }

  void onLoginButton() {
    context.go(AppPath.login.path);
  }

  void onRegisterButton() {
    context.go(AppPath.registration.path);
  }
}
