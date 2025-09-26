import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basecam/app.dart';
import 'package:basecam/routes.dart';
import 'package:basecam/app_path.dart';
import 'package:basecam/services/equipment_repository.dart';
import 'package:basecam/services/posts_repository.dart';

/// Flutter code sample for [BottomNavigationBar].

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Replace the default error widget (large red/grey debug banners) with a
  // compact, unobtrusive placeholder so missing assets or build-time errors
  // don't cover important UI like buttons. We still log the exception in
  // debug mode so developers can see stack traces in the console.
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (kDebugMode) {
      // Keep the exception visible in logs for debugging
      debugPrint('ErrorWidget intercepted build error: ${details.exception}');
    }
    // A small, fixed-size placeholder to avoid overflowing or covering
    // surrounding controls. Using Align keeps it from expanding to fill
    // unconstrained parents.
    return const Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 40,
        height: 24,
        child: Icon(Icons.broken_image, size: 20, color: Colors.grey),
      ),
    );
  };
  runApp(const _AppInitializer());
}

class _AppInitializer extends StatelessWidget {
  const _AppInitializer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      // start Firebase initialization and keep the future here
      future: _initFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // show a minimal loading screen while Firebase initializes
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        if (snapshot.hasError) {
          // show a clear error so user/developer sees init failure instead of
          // continuing with an uninitialized Firebase (which causes the
          // runtime '[core/no-app]' exceptions you reported).
          final error = snapshot.error;
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Initialization error')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Failed to initialize Firebase.\nPlease check your GoogleService-Info.plist and iOS setup.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      error.toString(),
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Initialization succeeded — log Firebase status and show the real app
        try {
          debugPrint('Firebase initialized: ${snapshot.data?.name}');
          debugPrint(
            'Firebase apps: ${Firebase.apps.map((a) => a.name).toList()}',
          );
          // print current auth user (may be null)
          final current = FirebaseAuth.instance.currentUser;
          debugPrint('Current FirebaseAuth user: ${current?.uid ?? 'null'}');
        } catch (e) {
          debugPrint('Error while logging Firebase status: $e');
        }

        // In debug mode, auto-sign-in a test user so developers can work with
        // the database without manual auth steps. This only runs when
        // compiled in debug (kDebugMode) and when there is no current user.
        // We intentionally don't await here to avoid delaying app startup.
        _ensureDevSignedIn();

        // Ensure Equipments collection exists in debug so developers can
        // immediately create/read items without using the console.
        // Fire-and-forget.
        if (kDebugMode) {
          try {
            equipmentRepo.ensureCollectionExists();
          } catch (e) {
            debugPrint('ensureCollectionExists failed: $e');
          }
          try {
            postsRepo.ensureCollectionExists();
          } catch (e) {
            debugPrint('ensurePostsCollectionExists failed: $e');
          }
        }

        return const BasecamApp();
      },
    );
  }
}

/// Try to initialize Firebase using the platform default config first.
/// If that fails (for example the native plist is missing or not matched),
/// fall back to initializing with explicit options taken from the
/// project's `GoogleService-Info.plist` values embedded below.
Future<FirebaseApp> _initFirebase() async {
  // Web requires explicit FirebaseOptions (firebase_core_web asserts that
  // options != null). Use DefaultFirebaseOptions.currentPlatform on web,
  // and default initialization on other platforms.
  if (kIsWeb) {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  return await Firebase.initializeApp();
}

// Development helper: auto sign-in a test user in debug builds so the
// developer can work with the database without manual auth steps.
void _ensureDevSignedIn() {
  if (!kDebugMode) return;

  final auth = FirebaseAuth.instance;
  if (auth.currentUser != null) return; // already signed in

  // Listen for auth state changes so we can navigate only after Firebase
  // reports the user is signed in. This is more reliable than firing a
  // navigation call immediately after sign-in attempts (router may not be
  // mounted yet).
  StreamSubscription<User?>? sub;
  sub = auth.authStateChanges().listen((user) {
    if (user != null) {
      debugPrint('Dev: authStateChanges -> user signed in: ${user.uid}');
      // Give a short delay to allow router and widgets to mount.
      Future.delayed(const Duration(milliseconds: 250), () {
        try {
          router.go(AppPath.root.path);
        } catch (e) {
          debugPrint('Dev: navigation failed: $e');
        }
      });
      sub?.cancel();
    }
  });

  // fire-and-forget: try to sign in, otherwise create the user.
  (() async {
    try {
      await auth.signInWithEmailAndPassword(
        email: 'test@gmail.com',
        password: 'test999',
      );
      debugPrint('Dev: signInWithEmailAndPassword returned');
    } catch (e) {
      if (e is FirebaseAuthException) {
        debugPrint(
          'Dev: sign-in FirebaseAuthException code=${e.code} message=${e.message}',
        );
      } else {
        debugPrint('Dev: sign-in failed: $e');
      }

      // If sign-in failed because the user doesn't exist, try to create it.
      try {
        final cred = await auth.createUserWithEmailAndPassword(
          email: 'test@gmail.com',
          password: 'test999',
        );
        debugPrint('Dev: created test user: ${cred.user?.uid}');
      } catch (e2) {
        if (e2 is FirebaseAuthException) {
          debugPrint(
            'Dev: createUser failed code=${e2.code} message=${e2.message}',
          );
        } else {
          debugPrint('Dev: failed to create test user: $e2');
        }

        // As a last resort in debug, sign in anonymously so the developer can
        // still work with Firestore (collection seeding, etc.). This avoids a
        // hard failure when the email is already used with a different
        // password or when createUser is blocked by rules.
        try {
          final anon = await auth.signInAnonymously();
          debugPrint(
            'Dev: signed in anonymously as fallback: ${anon.user?.uid}',
          );
        } catch (e3) {
          debugPrint('Dev: anonymous fallback failed: $e3');
        }
      }
    }
  })();
}
