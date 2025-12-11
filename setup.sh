#!/bin/bash

# Architect Nexus Mark 2 - Quick Start Script
# This script helps you get started with the project

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║    Architect Nexus Mark 2 - Quick Start Setup             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if Flutter is installed
echo "🔍 Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed!"
    echo ""
    echo "Please install Flutter first:"
    echo "  📖 Visit: https://docs.flutter.dev/get-started/install"
    echo ""
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"
echo ""

# Run flutter doctor
echo "🏥 Running Flutter doctor..."
flutter doctor
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
flutter pub get
echo ""

# Check for fonts
echo "🔤 Checking for required fonts..."
if [ ! -f "assets/fonts/Orbitron-Regular.ttf" ] || [ ! -f "assets/fonts/Orbitron-Bold.ttf" ]; then
    echo "⚠️  Orbitron fonts not found!"
    echo ""
    echo "Please download Orbitron fonts:"
    echo "  1. Visit: https://fonts.google.com/specimen/Orbitron"
    echo "  2. Download the font family"
    echo "  3. Copy Orbitron-Regular.ttf and Orbitron-Bold.ttf to assets/fonts/"
    echo ""
else
    echo "✅ Fonts found"
    echo ""
fi

# Check for Firebase configuration
echo "🔥 Checking Firebase configuration..."
FIREBASE_OK=true

if [ ! -f "android/app/google-services.json" ]; then
    echo "⚠️  android/app/google-services.json not found"
    FIREBASE_OK=false
fi

if [ ! -f "ios/Runner/GoogleService-Info.plist" ] && [ -d "ios" ]; then
    echo "⚠️  ios/Runner/GoogleService-Info.plist not found"
    FIREBASE_OK=false
fi

if [ "$FIREBASE_OK" = false ]; then
    echo ""
    echo "Firebase configuration incomplete. Please:"
    echo "  1. Create a Firebase project at https://console.firebase.google.com"
    echo "  2. Add your app and download config files"
    echo "  3. Place google-services.json in android/app/"
    echo "  4. Place GoogleService-Info.plist in ios/Runner/ (for iOS)"
    echo ""
    echo "📖 See SETUP_GUIDE.md for detailed instructions"
    echo ""
else
    echo "✅ Firebase configuration found"
    echo ""
fi

# List available devices
echo "📱 Available devices:"
flutter devices
echo ""

# Summary
echo "╔════════════════════════════════════════════════════════════╗"
echo "║    Setup Status Summary                                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Download Orbitron fonts (if not already done)"
echo "  2. Configure Firebase (if not already done)"
echo "  3. Run the app: flutter run"
echo ""
echo "📖 For detailed setup instructions, see: SETUP_GUIDE.md"
echo "📚 For project overview, see: README.md"
echo ""
echo "🚀 Ready to start? Run: flutter run"
echo ""
