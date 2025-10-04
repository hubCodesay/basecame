import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:basecam/app.dart';

/// Flutter code sample for [BottomNavigationBar].

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

        // Initialization succeeded — show the real app
        return const BasecamApp();
      },
    );
  }
}

/// Try to initialize Firebase using the platform default config first.
/// If that fails (for example the native plist is missing or not matched),
/// fall back to initializing with explicit [FirebaseOptions] taken from the
/// project's `GoogleService-Info.plist` values embedded below.
Future<FirebaseApp> _initFirebase() async {
  try {
    return await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Default Firebase.initializeApp() failed: $e');
    debugPrint('Attempting fallback Firebase.initializeApp(options: ...)');

    // Values taken from ios/GoogleService-Info.plist (App ID and sender ID).
    // Replace the placeholders below with your real Firebase project values
    // (apiKey, projectId, storageBucket) or run `flutterfire configure` to
    // generate a fully populated `firebase_options.dart`.
    // Filled with the project values you provided. For a full, canonical
    // setup please run `flutterfire configure` which will generate
    // `lib/firebase_options.dart` with per-platform values.
    const fallbackOptions = FirebaseOptions(
      apiKey: 'AIzaSyChysdZYY0yQwwdCzVi0eDCNwpnzv9ntNU',
      appId: '1:907186469751:ios:52b4ac3a5b5e64102e7f72',
      messagingSenderId: '907186469751',
      projectId: 'basecame-d4d15',
      storageBucket: 'basecame-d4d15.firebasestorage.app',
    );

    // Name omitted to create the default app instance.
    return await Firebase.initializeApp(options: fallbackOptions);
  }
}
