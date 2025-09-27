// Auto-filled (minimal) Firebase options using the values you provided.
// This file is a lightweight substitute for the FlutterFire-generated
// `firebase_options.dart`. For a complete per-platform configuration
// (recommended), run `flutterfire configure` which will generate a more
// detailed file.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Web-specific options (useful for `flutter run -d chrome`).
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyDXxRTQiteU84k4ZMKI9_EePI2ZYIIw5BI',
        authDomain: 'basecambd-3b3be.firebaseapp.com',
        projectId: 'basecambd-3b3be',
        storageBucket: 'basecambd-3b3be.appspot.com',
        messagingSenderId: '340144437283',
        appId:
            '1:340144437283:web:REPLACE', // replace with your web appId if available
        measurementId: 'G-REPLACE', // optional
      );
    }

    // iOS / macOS options. We have the iOS App ID you provided, so include
    // it here. If you have a different API key for iOS, replace the apiKey
    // value.
    if (Platform.isIOS || Platform.isMacOS) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyDXxRTQiteU84k4ZMKI9_EePI2ZYIIw5BI',
        appId: '1:340144437283:ios:17c08603b970ae1cec1996',
        messagingSenderId: '340144437283',
        projectId: 'basecambd-3b3be',
        storageBucket: 'basecambd-3b3be.appspot.com',
      );
    }

    // Android / fallback options. Replace androidAppId if you have it.
    return const FirebaseOptions(
      apiKey: 'AIzaSyDXxRTQiteU84k4ZMKI9_EePI2ZYIIw5BI',
      appId: '1:340144437283:android:REPLACE',
      messagingSenderId: '340144437283',
      projectId: 'basecambd-3b3be',
      storageBucket: 'basecambd-3b3be.appspot.com',
    );
  }
}
