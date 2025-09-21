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

    // Values copied from ios/Runner/GoogleService-Info.plist in this repo.
    const fallbackOptions = FirebaseOptions(
      apiKey: 'AIzaSyAh4BpjIU0sEoe48lre6Zucp_rGCHCodzg',
      appId: '1:1046868503978:ios:37a53e83868732941a8fd3',
      messagingSenderId: '1046868503978',
      projectId: 'basecambd',
      storageBucket: 'basecambd.firebasestorage.app',
    );

    // Name omitted to create the default app instance.
    return await Firebase.initializeApp(options: fallbackOptions);
  }
}
