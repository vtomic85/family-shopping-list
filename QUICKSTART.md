# Quick Start Guide

Get the Family Shopping List app running in minutes!

## Prerequisites

- Flutter SDK 3.2.0+
- Android Studio or VS Code
- Android device or emulator
- Firebase account (free tier is fine)

## 5-Minute Setup

### 1. Clone and Install Dependencies

```bash
git clone https://github.com/vtomic85/family-shopping-list.git
cd family-shopping-list
flutter pub get
```

### 2. Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project (or use existing)
3. Enable **Authentication** → Google Sign-In
4. Enable **Firestore Database** → Start in production mode

### 3. Configure Firebase for Android

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login

# Configure for Android
flutterfire configure --platforms=android
```

This will:
- Create/update `lib/firebase_options.dart`
- Create/update `android/app/google-services.json`

### 4. Set Up Environment Variables

```bash
# Copy the example file
cp .env.example .env

# Edit .env with your Firebase values
# (You can find these in Firebase Console → Project Settings)
```

Your `.env` should look like:
```env
FIREBASE_API_KEY=AIza...
FIREBASE_APP_ID=1:123...
FIREBASE_MESSAGING_SENDER_ID=123...
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project.appspot.com
```

### 5. Deploy Firestore Security Rules

```bash
firebase deploy --only firestore:rules
```

Or manually copy from `firestore.rules` to Firebase Console → Firestore → Rules.

### 6. Configure SHA-1 for Google Sign-In

```bash
cd android
./gradlew signingReport
cd ..
```

Copy the SHA-1 fingerprint and add it to:
Firebase Console → Project Settings → Your Android App → Add fingerprint

### 7. Run the App

```bash
flutter run
```

## Troubleshooting

### Google Sign-In Not Working

- ✅ Check SHA-1 is added to Firebase Console
- ✅ Verify `google-services.json` is in `android/app/`
- ✅ Ensure Google Sign-In is enabled in Firebase Authentication

### Firestore Permission Denied

- ✅ Deploy security rules: `firebase deploy --only firestore:rules`
- ✅ Check you're signed in with Google

### Build Errors

```bash
flutter clean
flutter pub get
flutter run
```

## Development Workflow

### Running the App

```bash
# Debug mode (hot reload enabled)
flutter run

# Release mode (optimized)
flutter run --release

# Specific device
flutter run -d <device-id>
```

### Viewing Logs

```bash
# Flutter logs
flutter logs

# Android logs
adb logcat
```

### Code Quality

```bash
# Run linter
flutter analyze

# Format code
flutter format .
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # MaterialApp setup
├── models/                   # Data models
│   ├── family_group.dart
│   └── shopping_item.dart
├── services/                 # Business logic
│   ├── auth_service.dart
│   └── firestore_service.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── family_group_provider.dart
│   └── shopping_list_provider.dart
├── screens/                  # UI screens
│   ├── auth/
│   ├── home/
│   └── settings/
├── widgets/                  # Reusable widgets
│   ├── add_item_dialog.dart
│   ├── edit_item_dialog.dart
│   ├── shopping_item_tile.dart
│   └── loading_skeleton.dart
└── theme/                    # App theming
    └── app_theme.dart
```

## Common Tasks

### Add a New Feature

1. Create models in `lib/models/`
2. Add service methods in `lib/services/`
3. Create provider in `lib/providers/`
4. Build UI in `lib/screens/` or `lib/widgets/`
5. Update Firestore rules if needed

### Update Firestore Rules

1. Edit `firestore.rules`
2. Deploy: `firebase deploy --only firestore:rules`
3. Test in Firebase Console → Firestore → Rules Playground

### Change App Icon

1. Create 1024x1024px icon → `assets/icon/app_icon.png`
2. Uncomment icon config in `pubspec.yaml`
3. Run: `flutter pub run flutter_launcher_icons`

### Change Splash Screen

1. Create splash icon → `assets/icon/splash_icon.png`
2. Uncomment splash config in `pubspec.yaml`
3. Run: `flutter pub run flutter_native_splash:create`

## Useful Commands

```bash
# Check Flutter setup
flutter doctor

# List devices
flutter devices

# Clean build artifacts
flutter clean

# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Build APK
flutter build apk

# Build App Bundle (for Play Store)
flutter build appbundle
```

## Next Steps

- Read [SETUP.md](SETUP.md) for detailed setup instructions
- Check [README.md](README.md) for project overview
- See [ICON_SETUP.md](ICON_SETUP.md) for branding customization
- Review [CHANGELOG.md](CHANGELOG.md) for recent changes

## Getting Help

- Check existing issues on GitHub
- Review Firebase Console for errors
- Run `flutter doctor` to check setup
- Check `flutter logs` for runtime errors

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design 3](https://m3.material.io/)

---

Happy coding! 🚀
