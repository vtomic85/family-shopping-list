# Family Shopping List - Setup Guide

This guide will help you set up the Family Shopping List Flutter application with Firebase.

## Prerequisites

- Flutter SDK (3.2.0 or later)
- Firebase account
- Android Studio (for Android development)

## Step 1: Firebase Project Setup

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new project (or use an existing one)
3. Enable the following services:
   - **Authentication**: Enable Google Sign-In provider
   - **Cloud Firestore**: Create a database in production mode

## Step 2: Configure FlutterFire

1. Install the FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Log in to Firebase:
   ```bash
   firebase login
   ```

3. Configure Firebase for your Flutter app (Android only):
   ```bash
   flutterfire configure --platforms=android
   ```
   
   This will:
   - Create an Android app in your Firebase project
   - Download `google-services.json`
   - Generate `lib/firebase_options.dart` with your configuration

## Step 3: Android Configuration

1. Place `google-services.json` in `android/app/`

2. Update `android/app/build.gradle` if needed:
   - Change `applicationId` to match your Firebase app
   - Update `namespace` accordingly

3. Configure SHA-1 fingerprint in Firebase Console:
   ```bash
   cd android
   ./gradlew signingReport
   ```
   Add the SHA-1 to your Firebase Android app settings (required for Google Sign-In)

## Step 4: Deploy Firestore Security Rules

Deploy the security rules to Firebase:

```bash
firebase deploy --only firestore:rules
```

Or manually copy the contents of `firestore.rules` to the Firebase Console:
1. Go to Firestore Database → Rules
2. Paste the rules and publish

## Step 5: Run the App

1. Get dependencies:
   ```bash
   flutter pub get
   ```

2. Run on your Android device/emulator:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── firebase_options.dart        # Firebase configuration (generated)
├── app.dart                     # MaterialApp with routing
├── models/                      # Data models
├── services/                    # Firebase services
├── providers/                   # State management
├── screens/                     # UI screens
├── widgets/                     # Reusable widgets
└── theme/                       # App theming
```

## Features

- **Google Sign-In**: Secure authentication with Google accounts
- **Family Groups**: Create and manage family shopping groups
- **Real-time Sync**: All changes sync instantly across devices
- **Item Management**: Add, edit, delete shopping items
- **Status Tracking**: Mark items as Pending, Bought, or Not Available
- **Member Management**: Add/remove family members by email

## Troubleshooting

### Google Sign-In not working
- Verify SHA-1 fingerprint is added to Firebase Console
- Ensure `google-services.json` is in `android/app/`
- Check that Google Sign-In is enabled in Firebase Authentication

### Firestore permission denied
- Deploy the security rules using `firebase deploy --only firestore:rules`
- Ensure the user is properly authenticated

### Build errors
- Run `flutter clean` then `flutter pub get`
- Ensure minSdkVersion is 23 or higher in `android/app/build.gradle`

## Notes

- The app uses Firestore for real-time data synchronization
- Each user can either own a family group or be a member of one
- All members of a family group share the same shopping list
- Only group owners can add/remove members
