# 🕒 Focus Clock - Flutter App

A minimal, professional-grade LED table clock replacement app with auto timezone detection, Dhaka timezone option, landscape orientation, and screen always-on mode.

## ✨ Features

### 🏠 Clock Screen
- **Digital Clock Display** - Large neon-style digital clock with seconds
- **Auto Timezone Detection** - Automatically detects and uses device timezone
- **Dhaka Timezone** - Option to switch to Dhaka, Bangladesh (Asia/Dhaka, UTC+6)
- **Date Display** - Shows current date in readable format
- **Timezone Information** - Displays timezone name and offset

### ⏱️ Timer Screen
- **Countdown Timer** - Set custom countdown timers
- **Stopwatch** - Full stopwatch functionality
- **Quick Timer Presets** - 1, 5, 10, 15, 30 minutes, and 1 hour quick buttons
- **Custom Time Setting** - Set hours, minutes, and seconds manually
- **Progress Bar** - Visual countdown progress indicator
- **Play/Pause/Reset Controls** - Full timer control

### 🎨 Design
- **Dark Neon Minimalism** - Clean, professional design with neon glow effects
- **Landscape Mode Only** - Optimized for horizontal viewing
- **Always-On Display** - Screen stays awake while app is active
- **Smooth Animations** - Beautiful transitions and effects
- **Responsive Design** - Adapts to different screen sizes

## 📦 Packages Used

| Package | Purpose |
|---------|---------|
| `provider` | Lightweight state management |
| `wakelock_plus` | Keep screen awake while app is active |
| `flutter_animate` | Smooth animations for digits |
| `intl` | Timezone + date formatting |
| `flutter_screenutil` | Responsive design for different resolutions |
| `google_fonts` | Digital-style typography (Orbitron & Roboto Mono) |
| `shared_preferences` | Save user settings |

## 🏗️ Architecture

**Pattern:** Provider + MVVM (Model–View–ViewModel)

### Folder Structure

```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── constants/
│   │   ├── app_colors.dart           # Color palette
│   │   ├── app_text_styles.dart      # Typography styles
│   │   └── app_themes.dart           # App theme
│   └── utils/
│       ├── time_utils.dart           # Time formatting utilities
│       └── screen_utils.dart         # Screen responsiveness utils
├── data/
│   ├── models/
│   │   └── clock_model.dart          # Clock data model
│   └── services/
│       ├── timezone_service.dart     # Timezone management
│       └── wakelock_service.dart     # Screen wakelock service
├── state/
│   ├── clock_provider.dart           # Clock state management
│   └── timer_provider.dart           # Timer state management
└── presentation/
    ├── screens/
    │   ├── home_screen.dart          # Clock screen
    │   └── timer_screen.dart         # Timer screen
    └── widgets/
        ├── digital_clock.dart        # Digital clock widget
        ├── timer_display.dart        # Timer display widget
        └── app_button.dart           # Reusable button widget
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.9.2)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd focus_clock
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🎨 Color Palette

| Purpose | Color | Code |
|---------|-------|------|
| Background | Deep black | `#0a0a0a` |
| Primary Neon | Electric mint | `#00FFB0` |
| Accent Neon | Cyan glow | `#00BFFF` |
| Secondary Text | Muted gray | `#A0A0A0` |
| Timer Active | Alert red | `#FF4B4B` |

## 📱 Usage

### Clock Screen
1. View the current time with neon glow effect
2. Tap "Switch Timezone" to change between auto-detect and Dhaka timezone
3. Date and timezone information displayed below the clock

### Timer Screen
1. Toggle between Countdown Timer and Stopwatch modes
2. For Countdown:
   - Use quick preset buttons (1, 5, 10, 15, 30 min, 1 hour)
   - Or tap "Set Time" for custom duration
3. Tap "Start" to begin, "Pause" to pause, "Reset" to reset
4. Progress bar shows countdown completion percentage

## 🔧 Configuration

The app automatically:
- Locks to landscape orientation
- Enables screen wakelock when app is active
- Disables wakelock when app is paused/closed
- Saves timezone preference locally

## 📄 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## 👨‍💻 Author

Built with ❤️ using Flutter

---

**Enjoy your Focus Clock! 🕒✨**
