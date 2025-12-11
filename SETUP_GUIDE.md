# Architect Nexus Mark 2 - Complete Setup Guide

This guide will walk you through setting up the Architect Nexus Mark 2 project from scratch.

## Prerequisites

### Required Software

1. **Flutter SDK** (version 3.0.0 or higher)
   - Download: https://docs.flutter.dev/get-started/install
   - Verify installation: `flutter doctor`

2. **Dart SDK** (comes with Flutter)
   - Verify: `dart --version`

3. **IDE** (choose one):
   - **VS Code** (Recommended)
     - Install Flutter extension
     - Install Dart extension
   - **Android Studio**
     - Install Flutter plugin
     - Install Dart plugin

4. **Platform-Specific Tools**:
   
   **For Android:**
   - Android Studio
   - Android SDK (API 21+)
   - Android Emulator or physical device
   
   **For iOS (macOS only):**
   - Xcode (latest version)
   - CocoaPods: `sudo gem install cocoapods`
   - iOS Simulator or physical device

## Step-by-Step Setup

### 1. Install Flutter

**macOS/Linux:**
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (add to .bashrc or .zshrc)
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

**Windows:**
- Download Flutter SDK from https://flutter.dev
- Extract to `C:\src\flutter`
- Add `C:\src\flutter\bin` to PATH
- Run `flutter doctor` in PowerShell

### 2. Resolve Flutter Doctor Issues

Run `flutter doctor` and fix any issues:

```bash
flutter doctor
```

Common fixes:
- Android licenses: `flutter doctor --android-licenses`
- Xcode setup: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
- Install CocoaPods: `sudo gem install cocoapods`

### 3. Clone and Setup Project

```bash
# Navigate to project directory
cd "/home/engineeredbyangelo/Mark ll"

# Install dependencies
flutter pub get

# Generate code (for models and repositories)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Download Required Fonts

1. Visit https://fonts.google.com/specimen/Orbitron
2. Download the Orbitron font family
3. Extract and copy these files to `assets/fonts/`:
   - `Orbitron-Regular.ttf`
   - `Orbitron-Bold.ttf`

### 5. Setup Firebase (Required for Authentication)

1. **Create Firebase Project**:
   - Go to https://console.firebase.google.com
   - Create a new project: "Architect Nexus"
   - Enable Google Analytics (optional)

2. **Add Android App**:
   - Register app with package name: `com.architectnexus.architect_nexus`
   - Download `google-services.json`
   - Place in `android/app/`

3. **Add iOS App** (if building for iOS):
   - Register app with bundle ID: `com.architectnexus.architectNexus`
   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/`

4. **Enable Authentication Providers**:
   - Go to Firebase Console → Authentication → Sign-in method
   - Enable: Email/Password, Google, GitHub

5. **Configure OAuth**:
   - **Google Sign-In**: Enable in Firebase Console
   - **GitHub Sign-In**: 
     - Create OAuth app at https://github.com/settings/developers
     - Add callback URL from Firebase Console

### 6. Configure Platform-Specific Settings

#### Android Configuration

Edit `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.architectnexus.architect_nexus"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "2.0.0"
    }
}
```

#### iOS Configuration (macOS only)

```bash
cd ios
pod install
cd ..
```

Edit `ios/Runner/Info.plist` to add:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

### 7. Run the Application

#### Using Command Line:

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in debug mode (default)
flutter run

# Run in release mode
flutter run --release
```

#### Using VS Code:

1. Open project in VS Code
2. Press `F5` or click "Run and Debug"
3. Select device from bottom right
4. App will launch automatically

#### Using Android Studio:

1. Open project in Android Studio
2. Select device from toolbar
3. Click "Run" (green play button)

### 8. Verify Installation

After running, you should see:
- ✅ Cyber-Fluent dark theme with neon accents
- ✅ Login screen with authentication options
- ✅ Smooth animations and transitions
- ✅ No console errors

## Common Issues & Solutions

### Issue: "Flutter not found"
**Solution**: Ensure Flutter bin directory is in your PATH
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### Issue: "SDK version mismatch"
**Solution**: Update Flutter and dependencies
```bash
flutter upgrade
flutter pub upgrade
```

### Issue: "gradle build failed" (Android)
**Solution**: Update Android SDK and Gradle
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean
cd .. && flutter run
```

### Issue: "CocoaPods error" (iOS)
**Solution**: Update CocoaPods
```bash
sudo gem install cocoapods
cd ios
pod repo update
pod install
cd ..
```

### Issue: "Font not found"
**Solution**: Ensure fonts are in `assets/fonts/` and listed in `pubspec.yaml`

### Issue: "Firebase errors"
**Solution**: Verify configuration files are in correct locations:
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

## Development Workflow

### Hot Reload
- Press `r` in terminal while app is running
- Or save files in VS Code (auto-reload enabled)

### Hot Restart
- Press `R` in terminal
- Or press `Shift + F5` in VS Code

### Generate Code
After modifying models:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run Tests
```bash
flutter test
```

### Build APK (Android)
```bash
flutter build apk --release
```

### Build IPA (iOS)
```bash
flutter build ios --release
```

## Project Structure Overview

```
lib/
├── core/
│   ├── theme/              # Design system (colors, typography, dimensions)
│   └── router/             # Navigation configuration
├── features/
│   ├── auth/               # Authentication & login
│   ├── home/               # Main content stream
│   ├── learning/           # Interactive module viewer
│   └── profile/            # User profile & cache
└── main.dart               # App entry point
```

## Next Steps

1. **Customize Content**: 
   - Add learning modules in the CMS (to be integrated)
   - Update mock data in feature files

2. **Add Mascot**:
   - Create Spark animations in Lottie
   - Place in `assets/animations/`
   - Implement mascot overlay widget

3. **Implement Backend**:
   - Set up Hive database for offline storage
   - Create repository implementations
   - Add API integration layer

4. **Testing**:
   - Write unit tests for business logic
   - Add widget tests for UI components
   - Perform integration testing

5. **Deployment**:
   - Configure app signing
   - Submit to App Store / Play Store
   - Set up CI/CD pipeline

## Support & Resources

- **Flutter Docs**: https://docs.flutter.dev
- **Riverpod Docs**: https://riverpod.dev
- **Firebase Setup**: https://firebase.google.com/docs/flutter/setup
- **Project README**: See `README.md` for architecture details

## Checklist

- [ ] Flutter SDK installed and verified
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Fonts downloaded and placed in `assets/fonts/`
- [ ] Firebase project created
- [ ] Firebase configuration files added
- [ ] OAuth providers configured
- [ ] App runs successfully on emulator/device
- [ ] No console errors
- [ ] Dark theme displays correctly
- [ ] Navigation works smoothly

---

**Need Help?** Check the project README or create an issue in the repository.
