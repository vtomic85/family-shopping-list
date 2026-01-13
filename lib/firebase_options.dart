// IMPORTANT: This file is a placeholder.
// You must generate the actual firebase_options.dart using the FlutterFire CLI:
//
// 1. Install FlutterFire CLI: dart pub global activate flutterfire_cli
// 2. Run: flutterfire configure --platforms=android
// 3. Select your Firebase project
// 4. The CLI will generate this file with your actual Firebase configuration
//
// For more information, see: https://firebase.google.com/docs/flutter/setup

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = android;

  // TODO: Replace these placeholder values with your actual Firebase configuration
  // Run `flutterfire configure --platforms=android` to generate the correct values
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );
}
