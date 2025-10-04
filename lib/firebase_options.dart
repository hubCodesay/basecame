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
        apiKey: 'AIzaSyB-SnKUamlBC7QM67JEaeuiIgXdz-89eyk',
        authDomain: 'basecame-d4d15.firebaseapp.com',
        projectId: 'basecame-d4d15',
        storageBucket: 'basecame-d4d15.firebasestorage.app',
        messagingSenderId: '907186469751',
        appId: '1:907186469751:web:REPLACE',
        measurementId: 'G-REPLACE',
      );
    }

    // iOS / macOS options. We have the iOS App ID you provided, so include
    // it here. If you have a different API key for iOS, replace the apiKey
    // value.
    if (Platform.isIOS || Platform.isMacOS) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyChysdZYY0yQwwdCzVi0eDCNwpnzv9ntNU',
        appId: '1:907186469751:ios:52b4ac3a5b5e64102e7f72',
        messagingSenderId: '907186469751',
        projectId: 'basecame-d4d15',
        storageBucket: 'basecame-d4d15.firebasestorage.app',
      );
    }

    // Android / fallback options. Replace androidAppId if you have it.
    return const FirebaseOptions(
      apiKey: 'AIzaSyChysdZYY0yQwwdCzVi0eDCNwpnzv9ntNU',
      appId: '1:907186469751:android:REPLACE',
      messagingSenderId: '907186469751',
      projectId: 'basecame-d4d15',
      storageBucket: 'basecame-d4d15.firebasestorage.app',
    );
  }
}
