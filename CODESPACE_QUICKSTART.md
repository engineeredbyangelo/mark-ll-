# 🚀 Quick Start - Architect Nexus Mark 2 in Codespace

## Automatic Setup (via devcontainer)

When you open this repository in GitHub Codespaces, the environment will automatically:

1. ✅ Install Flutter SDK (stable channel)
2. ✅ Run `flutter pub get` to install dependencies
3. ✅ Run `flutter doctor` to verify setup
4. ✅ Configure VS Code with Flutter/Dart extensions

**Wait ~2-3 minutes for initial setup to complete.**

## Manual Verification

Once the Codespace loads, verify everything:

```bash
# Check Flutter installation
flutter doctor -v

# Verify dependencies
flutter pub get

# Run architecture compliance check
chmod +x check_architecture.sh
./check_architecture.sh

# Check for any analysis issues
flutter analyze
```

## Running the App

### Option 1: Web (Recommended for Codespace)

```bash
# Enable web support
flutter config --enable-web

# Run in web mode (port 3000 auto-forwarded)
flutter run -d web-server --web-port=3000 --web-hostname=0.0.0.0
```

Click the "Open in Browser" notification to view the app!

### Option 2: Android (if emulator configured)

```bash
# List devices
flutter devices

# Run on Android emulator
flutter run -d android
```

### Option 3: Chrome (headless)

```bash
flutter run -d chrome
```

## Development Workflow

### Hot Reload
- Press `r` in the terminal running Flutter
- Or save files in VS Code (auto-reload enabled)

### Hot Restart
- Press `R` in terminal
- Or press `Shift+F5` in VS Code

### Run Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/widget_test.dart
```

### Architecture Compliance
```bash
# Before committing, always check:
./check_architecture.sh
```

## Project Structure

```
lib/
├── core/
│   ├── theme/              # Cyber-Fluent design system
│   │   ├── app_colors.dart      # Color tokens
│   │   ├── app_typography.dart  # Typography system
│   │   ├── app_dimens.dart      # Dimension constants
│   │   └── app_theme.dart       # Material theme config
│   └── router/
│       └── app_router.dart      # go_router configuration
│
└── features/               # Feature modules (clean architecture)
    ├── auth/
    │   ├── domain/         # Business logic (pure Dart)
    │   │   ├── entities/
    │   │   └── repositories/
    │   ├── data/           # Data sources (to be implemented)
    │   └── presentation/   # UI components
    │       └── screens/
    ├── home/
    ├── learning/
    └── profile/
```

## Key Commands

```bash
# Format code
flutter format lib/

# Generate code (for freezed/json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Clean build artifacts
flutter clean

# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

## Troubleshooting

### "Flutter not found"
The devcontainer should handle this. If not:
```bash
export PATH="$PATH:/sdks/flutter/bin"
flutter doctor
```

### "Pub get failed"
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### "Port 3000 already in use"
```bash
# Use a different port
flutter run -d web-server --web-port=5000
```

### Architecture violations
```bash
# Run compliance check for details
./check_architecture.sh

# Common fixes:
# - Use AppDimens instead of hardcoded numbers
# - Use AppColors instead of Color(0x...)
# - Keep domain layer pure (no Flutter imports)
```

## Next Steps

1. **Download Fonts**:
   - Get Orbitron from https://fonts.google.com/specimen/Orbitron
   - Place in `assets/fonts/`
   - Commit and push

2. **Configure Firebase**:
   - See `SETUP_GUIDE.md` for details
   - Add `google-services.json` (Android)
   - Add `GoogleService-Info.plist` (iOS)

3. **Implement Data Layer**:
   - Create repository implementations
   - Setup Hive database
   - Add API integration

4. **Add Mascot**:
   - Create Lottie animations
   - Place in `assets/animations/`
   - Implement mascot overlay widget

5. **Content Integration**:
   - Connect to CMS
   - Implement module fetching
   - Setup background sync

## Design System Rules

⚠️ **Critical: Follow these strictly**

1. **Colors**: Use `AppColors.*` tokens only
2. **Typography**: Use `AppTypography.*` styles
3. **Spacing**: Use `AppDimens.*` constants
4. **No Magic Numbers**: All dimensions from `AppDimens`
5. **Layer Separation**: Domain layer = pure Dart (no Flutter)
6. **Widget Size**: Keep files under 200 lines
7. **File Naming**: Use `snake_case.dart`

## Useful Resources

- **Architecture Guide**: See `README.md`
- **Setup Instructions**: See `SETUP_GUIDE.md`
- **Design System**: `lib/core/theme/`
- **ASI Instructions**: `.github/copilot-instructions.md`

---

**Ready to build? Run `flutter run -d web-server --web-port=3000`** 🚀
