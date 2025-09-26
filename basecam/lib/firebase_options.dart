// Provide a DefaultFirebaseOptions helper that returns a FirebaseOptions
// instance. For development we use placeholder values so web builds don't
// crash with the "options != null" assertion. Replace these with real
// values from your Firebase project for production.
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
    // From ios/GoogleService-Info.plist uploaded to the repo
    apiKey: 'AIzaSyAm1MHa-8O-pPXAU2kQwqSMU0ltlXi2ARg',
    appId: '1:340144437283:ios:17c08603b970ae1cec1996',
    messagingSenderId: '340144437283',
    projectId: 'basecambd-3b3be',
    // common default for authDomain is <projectId>.firebaseapp.com
    authDomain: 'basecambd-3b3be.firebaseapp.com',
    storageBucket: 'basecambd-3b3be.firebasestorage.app',
    measurementId: '',
  );
}
