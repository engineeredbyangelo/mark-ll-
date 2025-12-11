#!/bin/bash

echo "🚀 Committing Codespace Configuration & Platform Support"
echo "=========================================================="
echo ""

cd "/home/engineeredbyangelo/Mark ll"

# Stage new files
echo "📦 Staging new files..."
git add .devcontainer/
git add .github/workflows/
git add android/
git add web/
git add test/
git add check_architecture.sh
git add CODESPACE_QUICKSTART.md
git add .gitignore
git add .github/copilot-instructions.md

# Show what will be committed
echo ""
echo "📋 Files to be committed:"
git status --short

echo ""
read -p "Proceed with commit? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Commit
    git commit -m "Add Codespace config, platform support, and CI/CD

- Added devcontainer.json for automatic Flutter setup
- Configured Android build (build.gradle, AndroidManifest)
- Added web support (index.html, manifest.json)
- Created test suite and widget_test.dart
- Added architecture compliance checker script
- Setup GitHub Actions CI/CD workflow
- Created CODESPACE_QUICKSTART.md guide
- Updated .gitignore to exclude Flutter SDK
- Updated copilot instructions with progress"

    # Push to GitHub
    echo ""
    echo "⬆️  Pushing to GitHub..."
    git push origin main

    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Successfully pushed to GitHub!"
        echo ""
        echo "🎯 Next Steps:"
        echo "  1. Open VS Code Command Palette (Ctrl+Shift+P)"
        echo "  2. Run: 'Codespaces: Connect to Codespace'"
        echo "  3. Select: engineeredbyangelo/mark-ll-"
        echo "  4. Wait ~2 minutes for Flutter SDK installation"
        echo "  5. Run: flutter run -d web-server --web-port=3000"
        echo ""
        echo "📖 See CODESPACE_QUICKSTART.md for detailed instructions"
    else
        echo ""
        echo "❌ Push failed. Check your authentication."
    fi
else
    echo ""
    echo "❌ Commit cancelled"
fi
