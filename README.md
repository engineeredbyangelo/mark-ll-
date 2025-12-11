# Architect Nexus (Mark 2)

<div align="center">

**Flow State Learning • Cyber-Fluent Design • Offline-First Architecture**

An interactive learning platform transforming tech education through gamification, immersive UI, and intelligent caching.

</div>

---

## 🎯 Vision

Architect Nexus Mark 2 is not just a developer news feed—it's a **high-fidelity, interactive learning ecosystem** designed for "Flow State" learning. Users consume tech guides, AI insights, and coding tutorials through a gamified, visually immersive interface that keeps them engaged and progressing.

## ✨ Core Value Proposition

### For Users
- **Frictionless Learning**: Seamless, futuristic environment for consuming complex tech topics
- **Flow State Experience**: < 100ms interactions with optimistic UI updates
- **Personalized Journey**: AI-driven content recommendations based on your learning cache
- **Interactive Modules**: Swipeable slides with syntax-highlighted code and instant feedback

### For the Business
- **Increased Retention**: Gamification through animated mascot and skill constellation
- **Engagement Metrics**: Track completion rates, session time, and cache utilization
- **Scalable Content**: CMS-driven module system for easy content management

## 🎨 Design System: Cyber-Fluent

### Color Palette
```dart
Background Primary:   #121212  // Deep Charcoal
Background Secondary: #0B0C15  // Midnight Blue
Accent Primary:       #00F0FF  // Electric Blue
Accent Secondary:     #BD00FF  // Neon Purple
Text Highlight:       #FFD700  // Cyber Yellow
Glass Overlay:        RGBA(255, 255, 255, 0.05) + Blur(10px)
```

### Typography
- **Headers**: Orbitron (Uppercase, Wide spacing)
- **Body**: Inter (High readability)
- **Code**: JetBrains Mono (Syntax highlighted)

### UI Components
- **Glass Cards**: Translucent overlays with subtle gradients
- **Floating Navigation**: Bottom dock that disappears on scroll for immersion
- **Spark Mascot**: Dynamic geometric companion providing real-time feedback

## 🏗️ Architecture

### Clean Architecture with MVVM

```
lib/
├── core/
│   ├── theme/              # Design system tokens
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_dimens.dart
│   │   └── app_theme.dart
│   └── router/             # Navigation configuration
│       └── app_router.dart
├── features/
│   ├── auth/
│   │   ├── domain/         # Pure business logic
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   ├── data/           # API & local cache
│   │   └── presentation/   # UI & ViewModels
│   ├── home/               # Content discovery stream
│   ├── learning/           # Interactive module viewer
│   └── profile/            # The Cache - Progress & saved content
└── main.dart
```

### Data Strategy: Offline-First

**Single Source of Truth**: Local database (Hive)

**Sync Flow**:
1. **Read**: UI reads from Local DB
2. **Write**: UI writes to Local DB → Background sync to Cloud
3. **Fetch**: Background Service pulls from Cloud → Updates Local DB → UI reacts

## 🚀 Features

### 1. Authentication (The Portal)
- OAuth 2.0: GitHub, Google, Apple Sign-In
- Email/Password authentication
- "Hyperspace Login" animation
- Preference setup with tag selection

### 2. Home Screen (The Stream)
- Hero Cards with 3D-rendered thumbnails
- Daily Byte: <60 second tips in horizontal scroll
- Smart sorting based on user cache history
- Floating glass bottom navigation

### 3. Content Engine (Flow State View)
- Swipeable slide-based modules (6-10 slides)
- Interactive code blocks with syntax highlighting
- Copy/Run functionality
- Neon progress bar at top
- Haptic feedback on completion

### 4. Profile (The Cache)
- **My Stacks**: Folder-based content organization
- **Skill Constellation**: Visual skill tree with lit-up nodes
- **Resume Learning**: Unfinished modules section
- Progress tracking and stats

## 📦 Tech Stack

### Frontend
- **Framework**: Flutter (60fps animations support)
- **State Management**: Riverpod
- **Navigation**: go_router
- **Animations**: flutter_animate

### Backend
- **Local Database**: Hive (offline-first)
- **Authentication**: Firebase Auth
- **Content Delivery**: To be integrated with CMS

### Design
- **Typography**: Google Fonts (Inter), Orbitron
- **Icons**: Material Icons + Custom assets

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode for mobile development
- VS Code with Flutter extension (recommended)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd "Mark ll"
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Download custom fonts**
   - Download Orbitron from [Google Fonts](https://fonts.google.com/specimen/Orbitron)
   - Place font files in `assets/fonts/`
   - Files needed: `Orbitron-Regular.ttf`, `Orbitron-Bold.ttf`

4. **Run the app**
   ```bash
   flutter run
   ```

### Build Runners

Generate code for models and repositories:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📋 Development Standards

### Coding Conventions
- **Variables**: camelCase (`userProfile`, `learningProgress`)
- **Classes**: PascalCase (`ModuleCard`, `AuthService`)
- **Files**: snake_case (`home_screen.dart`, `auth_repository.dart`)

### Architecture Rules
1. **No Magic Numbers**: All dimensions come from `AppDimens`
2. **Strict Typing**: `any` type is forbidden
3. **Widget Modularity**: Max 200 lines per widget file
4. **Layer Separation**: UI never directly accesses database

### Feature Structure
```
/features/[feature_name]/
  ├── data/          # API calls, DTOs
  ├── domain/        # Entities, UseCases (The "Rules")
  └── presentation/  # Widgets, ViewModels (The "Look")
```

## 🎮 The Mascot: Spark

An event-driven geometric UI companion that:
- **Observes**: UserActivityStream
- **Reacts**: 
  - AppLaunch → WaveAnimation
  - ScrollIdle(5s) → PeekAnimation
  - ModuleComplete → CelebrationLoop

Implementation: Global Overlay Widget on top of Z-index stack

## 📊 Success Metrics (KPIs)

| Metric | Target | Description |
|--------|--------|-------------|
| **Completion Rate** | 60% | % of users finishing opened modules |
| **Session Time** | >5 min | Average time spent per session |
| **Cache Utilization** | 40% | % of users saving ≥1 item/week |

## 🎯 User Stories

| Priority | Feature | User Story |
|----------|---------|------------|
| P0 | Auth Rewrite | "As a user, I want to sign up with one tap using GitHub so I can start learning immediately." |
| P0 | Visual Overhaul | "As a user, I want a dark mode interface with neon accents so that reading for long periods is easy on my eyes." |
| P1 | The Cache | "As a user, I want to 'Bookmark' a tutorial so I can find it easily in my Profile later." |
| P1 | Slide View | "As a user, I want to consume guides in bite-sized slides rather than long scrolling text." |
| P2 | Mascot Logic | "As a user, I want the mascot to give me a visual cue (thumbs up/glow) when I finish a chapter." |

## 📝 Definition of Done

Before merging any code for Mark 2, ensure:

- [ ] Dark Mode works perfectly (no white flashes)
- [ ] "Back" navigation feels instant (cached state)
- [ ] Mascot appears correctly on designated screen
- [ ] Code is linted and follows directory structure
- [ ] All UI components adhere to Cyber-Fluent design system
- [ ] App is fully offline-first with seamless caching
- [ ] Flow State UX maintained (<100ms interactions)
- [ ] Mascot interactions are smooth and engaging
- [ ] Thoroughly tested for performance and scalability
- [ ] Codebase is well-documented and maintainable

## 🤝 Contributing

This is a structured project following clean architecture principles. When contributing:

1. Follow the coding standards outlined above
2. Maintain layer separation (Domain/Data/Presentation)
3. Use design system tokens (no hardcoded colors/sizes)
4. Write tests for business logic
5. Ensure offline-first data flow

## 📄 License

[Add your license here]

## 🔗 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Material Design 3](https://m3.material.io)

---

<div align="center">

**Built with ❤️ for Flow State Learning**

</div>
