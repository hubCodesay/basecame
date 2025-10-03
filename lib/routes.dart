import 'package:basecam/pages/root/map/route/route.dart';
import 'package:basecam/pages/root/map/location_day/location_day.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:basecam/pages/login/login.dart';
import 'package:basecam/pages/onboard/onboard.dart';
import 'package:basecam/pages/registration/registration.dart';
// import 'package:basecam/pages/root/profile/edit_profile.dart';
import 'package:basecam/pages/root/profile/profile.dart';
import 'package:basecam/pages/root/profile/settings.dart';
import 'package:basecam/pages/root/profile/support.dart';
import 'package:basecam/pages/root/profile/edit_profile.dart';
import 'package:basecam/pages/root/root.dart';
import 'package:basecam/pages/start/start.dart';

import 'app_path.dart';

/// GoRouter configuration
final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: AppPath.start.path,
  // AppPath.root.path,
  routes: [
    GoRoute(
      path: AppPath.root.path,
      builder: (context, state) => RootPage(child: Container()),
    ),
    GoRoute(
      path: AppPath.start.path,
      builder: (context, state) => const LoadingPage(),
    ),
    // Location routes expect an `id` path parameter (e.g. /map/location/123)
    GoRoute(
      path: '${AppPath.location.path}/:id',
      builder: (context, state) =>
          LocationScreen(postId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '${AppPath.locationDay.path}/:id',
      builder: (context, state) =>
          LocationDay(postId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: AppPath.onboard.path,
      builder: (context, state) => const OnBoardScreen(),
    ),
    GoRoute(
      path: AppPath.login.path,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppPath.registration.path,
      builder: (context, state) => const RegistrationPage(),
    ),

    GoRoute(
      path: AppPath.rootProfile.path,
      builder: (context, state) => const ProfileTab(),
      routes: [
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: 'edit_profile',
          builder: (context, state) => const ProfileEditPage(),
        ),
        GoRoute(
          path: 'support',
          builder: (context, state) => const SupportRequestPage(),
        ),
      ],
    ),
  ],
);
