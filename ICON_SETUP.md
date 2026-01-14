# App Icon and Splash Screen Setup

This guide explains how to set up custom app icons and splash screens for the Family Shopping List app.

## App Icon

### Design Specifications

The app icon should be a shopping cart or shopping bag themed design with the app's color scheme:
- **Primary Color**: `#D4896A` (Terracotta)
- **Secondary Color**: `#7A9E7E` (Sage Green)
- **Background**: White or light cream

### Recommended Design

Create a 1024x1024px icon with:
- A shopping cart or bag icon in the center
- Use the terracotta color for the main icon
- Optional: Add a small checkmark or family silhouette to represent collaboration
- Keep it simple and recognizable at small sizes

### Using flutter_launcher_icons

1. **Install the package** (already added to `pubspec.yaml`):
   ```yaml
   dev_dependencies:
     flutter_launcher_icons: ^0.13.1
   ```

2. **Create your icon**:
   - Design a 1024x1024px PNG icon
   - Save it as `assets/icon/app_icon.png`

3. **Configure in `pubspec.yaml`**:
   ```yaml
   flutter_launcher_icons:
     android: true
     ios: false  # iOS not needed
     image_path: "assets/icon/app_icon.png"
     adaptive_icon_background: "#FAF7F5"
     adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
   ```

4. **Generate icons**:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

### Manual Icon Setup (Alternative)

If you prefer to create icons manually:

1. Use an online tool like [AppIcon.co](https://appicon.co/) or [MakeAppIcon](https://makeappicon.com/)
2. Upload your 1024x1024px icon
3. Download the generated Android resources
4. Replace the files in `android/app/src/main/res/mipmap-*` directories

## Splash Screen

### Design Specifications

The splash screen should match the app's branding:
- **Background Color**: `#FAF7F5` (Light cream)
- **Logo**: Shopping cart/bag icon in terracotta color
- **Optional**: App name "Family Shopping List" below the icon

### Using flutter_native_splash

1. **Install the package**:
   ```yaml
   dev_dependencies:
     flutter_native_splash: ^2.3.5
   ```

2. **Create your splash image**:
   - Design a 1152x1152px PNG with transparent background
   - Save it as `assets/icon/splash_icon.png`
   - The icon should be centered and take up about 30% of the space

3. **Configure in `pubspec.yaml`**:
   ```yaml
   flutter_native_splash:
     color: "#FAF7F5"
     image: assets/icon/splash_icon.png
     android: true
     ios: false  # iOS not needed
     android_12:
       color: "#FAF7F5"
       image: assets/icon/splash_icon.png
   ```

4. **Generate splash screens**:
   ```bash
   flutter pub get
   flutter pub run flutter_native_splash:create
   ```

## Quick Setup with Existing Icons

If you already have the current launcher icons and want to keep them:

1. The app currently uses the default Flutter launcher icons
2. The icons are located in `android/app/src/main/res/`
3. You can customize them by replacing the PNG files in each `mipmap-*` folder

## Color Reference

For consistency across all branding materials:

```dart
// Light Theme
Primary: #D4896A (Terracotta)
Secondary: #7A9E7E (Sage Green)
Background: #FAF7F5 (Light Cream)
Surface: #FFFFFF (White)

// Dark Theme
Primary: #E09B7D (Light Terracotta)
Secondary: #8FB193 (Light Sage)
Background: #1A1A1A (Dark Gray)
Surface: #2A2A2A (Medium Gray)
```

## Testing

After setting up icons and splash screens:

1. **Clean and rebuild**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Test on device**:
   - Check the app icon in the launcher
   - Verify the splash screen appears on app startup
   - Test in both light and dark modes

3. **Verify adaptive icon** (Android 8.0+):
   - Long-press the app icon
   - Check that it looks good in different shapes (circle, square, rounded square)

## Resources

- [Flutter Launcher Icons Package](https://pub.dev/packages/flutter_launcher_icons)
- [Flutter Native Splash Package](https://pub.dev/packages/flutter_native_splash)
- [Material Design Icon Guidelines](https://m3.material.io/styles/icons/overview)
- [Android Adaptive Icons](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive)

## Notes

- The current setup uses vector drawable icons for Android
- Icons are defined in `android/app/src/main/res/drawable/` and `android/app/src/main/res/mipmap-anydpi-v26/`
- The app uses a custom launcher icon with the app's color scheme
- For production, consider creating high-quality icons using professional design tools like Figma, Sketch, or Adobe Illustrator
