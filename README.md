<div align="center"># 🕒 Focus Clock - Flutter App



# 🕒 Focus ClockA minimal, professional-grade LED table clock replacement app with auto timezone detection, Dhaka timezone option, landscape orientation, and screen always-on mode.



### *A Minimalist, Feature-Rich Clock App for Android*## ✨ Features



[![Flutter](https://img.shields.io/badge/Flutter-3.24.5-02569B?logo=flutter)](https://flutter.dev)### 🏠 Clock Screen

[![Dart](https://img.shields.io/badge/Dart-3.5.4-0175C2?logo=dart)](https://dart.dev)- **Digital Clock Display** - Large neon-style digital clock with seconds

[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)- **Auto Timezone Detection** - Automatically detects and uses device timezone

[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android)](https://www.android.com)- **Dhaka Timezone** - Option to switch to Dhaka, Bangladesh (Asia/Dhaka, UTC+6)

- **Date Display** - Shows current date in readable format

*Your all-in-one time management companion with stunning watch faces, powerful timers, smart alarms, and customizable aesthetics.*- **Timezone Information** - Displays timezone name and offset



[Download APK](../../releases) • [Report Bug](../../issues) • [Request Feature](../../issues)### ⏱️ Timer Screen

- **Countdown Timer** - Set custom countdown timers

</div>- **Stopwatch** - Full stopwatch functionality

- **Quick Timer Presets** - 1, 5, 10, 15, 30 minutes, and 1 hour quick buttons

---- **Custom Time Setting** - Set hours, minutes, and seconds manually

- **Progress Bar** - Visual countdown progress indicator

## 📸 Screenshots- **Play/Pause/Reset Controls** - Full timer control



<div align="center">### 🎨 Design

- **Dark Neon Minimalism** - Clean, professional design with neon glow effects

### 🎬 Onboarding Experience- **Landscape Mode Only** - Optimized for horizontal viewing

<p float="left">- **Always-On Display** - Screen stays awake while app is active

  <img src="docs/screenshots/onboarding/onboarding1.png" width="200" />- **Smooth Animations** - Beautiful transitions and effects

  <img src="docs/screenshots/onboarding/onboarding2.png" width="200" />- **Responsive Design** - Adapts to different screen sizes

  <img src="docs/screenshots/onboarding/onboarding3.png" width="200" />

  <img src="docs/screenshots/onboarding/onboarding4.png" width="200" />## 📦 Packages Used

</p>

| Package | Purpose |

### 🏠 Home & Navigation|---------|---------|

<p float="left">| `provider` | Lightweight state management |

  <img src="docs/screenshots/home/homePage.png" width="200" />| `wakelock_plus` | Keep screen awake while app is active |

  <img src="docs/screenshots/settings/settings.png" width="200" />| `flutter_animate` | Smooth animations for digits |

</p>| `intl` | Timezone + date formatting |

| `flutter_screenutil` | Responsive design for different resolutions |

### 🕐 Beautiful Watch Faces| `google_fonts` | Digital-style typography (Orbitron & Roboto Mono) |

<p float="left">| `shared_preferences` | Save user settings |

  <img src="docs/screenshots/clock/clock1.png" width="200" />

  <img src="docs/screenshots/clock/clock2.png" width="200" />## 🏗️ Architecture

  <img src="docs/screenshots/clock/clock3.png" width="200" />

  <img src="docs/screenshots/clock/clock4.png" width="200" />**Pattern:** Provider + MVVM (Model–View–ViewModel)

</p>

### Folder Structure

### ⏱️ Timer & Stopwatch

<p float="left">```

  <img src="docs/screenshots/timer/timer1.png" width="200" />lib/

  <img src="docs/screenshots/timer/timer2.png" width="200" />├── main.dart                          # App entry point

  <img src="docs/screenshots/timer/timer3.png" width="200" />├── core/

  <img src="docs/screenshots/stopwatch/stopwatch.png" width="200" />│   ├── constants/

</p>│   │   ├── app_colors.dart           # Color palette

│   │   ├── app_text_styles.dart      # Typography styles

### 🔔 Alarms & Reminders│   │   └── app_themes.dart           # App theme

<p float="left">│   └── utils/

  <img src="docs/screenshots/alarm/alarm.png" width="200" />│       ├── time_utils.dart           # Time formatting utilities

  <img src="docs/screenshots/alarm/alarm2.png" width="200" />│       └── screen_utils.dart         # Screen responsiveness utils

  <img src="docs/screenshots/alarm/alarm3.png" width="200" />├── data/

  <img src="docs/screenshots/alarm/alarm4.png" width="200" />│   ├── models/

</p>│   │   └── clock_model.dart          # Clock data model

│   └── services/

### 📝 Smart Reminders│       ├── timezone_service.dart     # Timezone management

<p float="left">│       └── wakelock_service.dart     # Screen wakelock service

  <img src="docs/screenshots/reminder/remainder1.png" width="200" />├── state/

  <img src="docs/screenshots/reminder/remainder2.png" width="200" />│   ├── clock_provider.dart           # Clock state management

  <img src="docs/screenshots/reminder/remainder3.png" width="200" />│   └── timer_provider.dart           # Timer state management

  <img src="docs/screenshots/reminder/remainder4.png" width="200" />└── presentation/

</p>    ├── screens/

    │   ├── home_screen.dart          # Clock screen

</div>    │   └── timer_screen.dart         # Timer screen

    └── widgets/

---        ├── digital_clock.dart        # Digital clock widget

        ├── timer_display.dart        # Timer display widget

## ✨ Features        └── app_button.dart           # Reusable button widget

```

### ⏰ **Clock**

- 🎨 **5 Stunning Watch Faces**## 🚀 Getting Started

  - Default LED Digital Clock

  - Large Display Clock### Prerequisites

  - Seven-Segment Display- Flutter SDK (>=3.9.2)

  - Rounded Corners Design- Android Studio / VS Code

  - Mechanical Flip Clock- Android/iOS device or emulator

- 🔄 **Swipe** left/right to change clock faces

- 🎯 **Double-tap** to change colors instantly### Installation

- 📱 **Portrait & Landscape** support

- 🌙 **Fullscreen mode** for distraction-free viewing1. Clone the repository:

- ⚡ **Smooth animations** with flip effects```bash

git clone <repository-url>

### ⏱️ **Timer**cd focus_clock

- 🔄 **Dual Countdown Modes**```

  - **Reverse Countdown**: Traditional 60→0 seconds

  - **Forward Countdown**: Modern 0→60 seconds2. Install dependencies:

- ⭕ **Circular Progress** indicator with visual feedback```bash

- ⚡ **Quick Adjust** buttons (-10s, +30s)flutter pub get

- 🎯 **Quick Presets**: 5, 10, 15, 20, 25, 30, 45, 60 minutes```

- 🎛️ **Custom Time Picker** (minutes & seconds)

- 🔊 **Sound & Vibration** alerts3. Run the app:

- 📱 **Portrait**: Circular UI with large buttons```bash

- 💻 **Landscape**: Large digit displayflutter run

- ⏸️ **Pause/Resume** functionality```

- 🔄 **5-min Snooze** option

## 🎨 Color Palette

### ⏲️ **Stopwatch**

- 🎯 **Professional Design** with circular progress| Purpose | Color | Code |

- ✨ **Animated pulse & glow** effects|---------|-------|------|

- ⚡ **Precise millisecond** tracking| Background | Deep black | `#0a0a0a` |

- 📊 **Split times** support| Primary Neon | Electric mint | `#00FFB0` |

- 🎨 **Modern gradient** buttons| Accent Neon | Cyan glow | `#00BFFF` |

- 🔄 **Smooth animations** throughout| Secondary Text | Muted gray | `#A0A0A0` |

| Timer Active | Alert red | `#FF4B4B` |

### 🔔 **Alarms**

- ➕ **Unlimited alarms** with custom labels## 📱 Usage

- 📅 **Repeat days** (Mon-Sun selection)

- 💤 **Snooze** functionality (10 minutes)### Clock Screen

- 📳 **Vibration** support1. View the current time with neon glow effect

- 🎵 **Multiple ringtones** to choose from2. Tap "Switch Timezone" to change between auto-detect and Dhaka timezone

- 🎚️ **iOS-style ON/OFF toggle** switch3. Date and timezone information displayed below the clock

- 🗑️ **Auto-delete** after alarm goes off (optional)

- ⏰ **Beautiful alarm dialog** with gradient background### Timer Screen

1. Toggle between Countdown Timer and Stopwatch modes

### 📝 **Reminders**2. For Countdown:

- 📅 **Date & Time** based reminders   - Use quick preset buttons (1, 5, 10, 15, 30 min, 1 hour)

- ⏳ **Live countdown** timer display   - Or tap "Set Time" for custom duration

- 🔊 **Sound & Vibration** alerts3. Tap "Start" to begin, "Pause" to pause, "Reset" to reset

- 🔔 **Persistent notifications**4. Progress bar shows countdown completion percentage

- 🗑️ **Swipe-to-delete** functionality

- 📝 **Custom descriptions** for each reminder## 🔧 Configuration

- ⚡ **Instant notifications** at set time

The app automatically:

### 🎨 **Customization**- Locks to landscape orientation

- 🌈 **36+ Preset Colors**- Enables screen wakelock when app is active

  - Carefully curated color palette- Disables wakelock when app is paused/closed

  - Vibrant neon colors- Saves timezone preference locally

  - Professional themes

- 🎨 **Custom RGB Color Picker**## 📄 License

  - Interactive color wheel

  - Real-time previewThis project is open source and available under the MIT License.

  - HEX code display (#RRGGBB)

  - RGB sliders (0-255)## 🤝 Contributing

- 🔆 **Brightness Control** (10%-100%)

- 🎯 **Consistent color** across all featuresContributions, issues, and feature requests are welcome!

- 🌙 **Dark theme** optimized

## 👨‍💻 Author

### 📊 **Analytics & More**

- 📈 **Firebase Analytics** integrationBuilt with ❤️ using Flutter

- 📱 **Track app usage** & engagement

- 🎬 **Onboarding tutorial** (first launch only)---

- 💾 **Settings persistence** with SharedPreferences

- ⚡ **Optimized performance** & battery usage**Enjoy your Focus Clock! 🕒✨**


---

## 🎯 Key Highlights

| Feature | Description |
|---------|-------------|
| 🎨 **Beautiful UI** | Minimalist dark theme with neon accents and smooth animations |
| ⚡ **Fast & Lightweight** | Optimized performance with 52 MB APK size |
| 🎯 **User-Friendly** | Intuitive gestures (swipe, double-tap, long-press) |
| 🔔 **Smart Notifications** | Never miss alarms or reminders |
| 🎨 **Fully Customizable** | 36+ colors + custom RGB picker |
| 📱 **Adaptive Layout** | Portrait & landscape support |
| 🌙 **Dark Mode** | Easy on the eyes, perfect for night use |
| 🔄 **Smooth Animations** | Delightful transitions throughout |

---

## 📱 System Requirements

| Requirement | Details |
|------------|---------|
| **Platform** | Android |
| **Minimum Version** | Android 5.0 (API 21) |
| **Recommended** | Android 8.0+ (API 26+) |
| **Permissions** | • Notifications<br>• Exact Alarms<br>• Vibration |
| **Storage** | ~52 MB |
| **Internet** | Optional (for Firebase Analytics) |

---

## 🚀 Installation

### Option 1: Download APK (Recommended)
1. Go to [Releases](../../releases)
2. Download the latest `Focus Clock.apk`
3. Enable "Install from Unknown Sources" in Settings
4. Tap the APK file to install
5. Open Focus Clock and enjoy!

### Option 2: Build from Source

```bash
# 1. Clone the repository
git clone https://github.com/mehedi-hridoy/FocusClock.git
cd FocusClock

# 2. Install dependencies
flutter pub get

# 3. Run on connected device/emulator
flutter run

# 4. Build release APK
flutter build apk --release
```

---

## 🎮 Usage Guide

### ⏰ Clock Screen
1. **Change Watch Face**: Swipe left/right
2. **Change Color**: Double-tap anywhere
3. **Fullscreen**: Tap to hide status bar
4. **Settings**: Long-press to access settings

### ⏱️ Timer
1. **Open Timer**: Tap Timer icon from home
2. **Set Time**: Double-tap to open settings
   - Choose preset (5, 10, 15, etc.)
   - Or set custom time
   - Toggle countdown direction (↓ reverse or ↑ forward)
3. **Start**: Tap play button
4. **Adjust**: Swipe left/right to change time
5. **Quick Adjust**: Use -10s or +30s buttons

### ⏲️ Stopwatch
1. **Open Stopwatch**: Tap Stopwatch icon from home
2. **Start**: Tap play button
3. **Pause**: Tap pause button
4. **Reset**: Tap reset button
5. **Change Color**: Swipe up/down

### 🔔 Alarms
1. **Add Alarm**: Tap + button
2. **Set Time**: Use time picker
3. **Repeat Days**: Select Mon-Sun
4. **Label**: Add custom name
5. **Options**: 
   - Toggle vibration
   - Select ringtone
   - Enable auto-delete
6. **Save**: Tap checkmark
7. **Toggle**: Use ON/OFF switch

### 📝 Reminders
1. **Add Reminder**: Tap + button
2. **Set Date & Time**
3. **Description**: Add note
4. **Save**: Reminder appears in list
5. **Delete**: Swipe left on reminder
6. **View Countdown**: Live timer shows remaining time

### 🎨 Customization
1. **Quick Color Change**: Double-tap on any screen
2. **Browse Colors**: Swipe up/down
3. **Custom Color**: 
   - Open settings (long-press)
   - Tap "Custom Color"
   - Use color wheel or RGB sliders
   - See live preview
   - Save with HEX code display
4. **Brightness**: Adjust slider in settings

---

## 🏗️ Architecture

**Pattern:** Clean Architecture + Provider (State Management)

```
lib/
├── main.dart                                 # App entry point
├── core/
│   ├── constants/
│   │   ├── color_palette.dart               # 36+ preset colors
│   │   └── app_constants.dart               # App-wide constants
│   ├── services/
│   │   ├── alarm_service.dart               # Alarm & sound management
│   │   ├── notification_service.dart        # Local notifications
│   │   └── firebase_service.dart            # Firebase Analytics
│   └── utils/
│       └── time_utils.dart                  # Time formatting utilities
├── state/
│   ├── settings_provider.dart               # Color, brightness, settings
│   ├── timer_provider.dart                  # Timer state & logic
│   ├── alarm_provider.dart                  # Alarm state & persistence
│   └── reminder_provider.dart               # Reminder state & persistence
├── data/
│   └── models/
│       ├── alarm_model.dart                 # Alarm data structure
│       └── reminder_model.dart              # Reminder data structure
└── presentation/
    ├── screens/
    │   ├── home_screen.dart                 # Main navigation
    │   ├── onboarding_screen.dart           # First-time tutorial
    │   ├── fullscreen_clock_screen.dart     # Clock display
    │   ├── fullscreen_timer_screen.dart     # Timer UI
    │   ├── fullscreen_stopwatch_screen.dart # Stopwatch UI
    │   ├── alarm_screen.dart                # Alarm list
    │   ├── add_alarm_screen.dart            # Create/edit alarm
    │   └── reminder_screen.dart             # Reminder list
    └── widgets/
        ├── customizable_watch_face_*.dart   # 5 clock face widgets
        ├── alarm_ringing_dialog.dart        # Alarm alert UI
        ├── custom_color_picker.dart         # RGB color picker
        └── drawer_menu.dart                 # Navigation drawer
```

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.24.5 |
| **Language** | Dart 3.5.4 |
| **State Management** | Provider |
| **Local Storage** | SharedPreferences |
| **Notifications** | flutter_local_notifications |
| **Analytics** | Firebase Analytics |
| **Fonts** | Google Fonts (Orbitron, Comfortaa) |
| **Permissions** | permission_handler |
| **Audio** | flutter_ringtone_player |
| **Vibration** | vibration |

### 📦 Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2                      # State management
  google_fonts: ^6.2.1                  # Typography
  shared_preferences: ^2.3.5            # Persistence
  flutter_local_notifications: ^17.2.3  # Notifications
  firebase_core: ^3.15.2                # Firebase
  firebase_analytics: ^11.6.0           # Analytics
  intl: ^0.19.0                         # Date/Time formatting
  permission_handler: ^11.3.1           # Permissions
  flutter_ringtone_player: ^4.0.0+4     # Audio alerts
  vibration: ^2.1.0                     # Haptic feedback
  device_info_plus: ^11.5.0             # Device info
```

---

## 🎨 Design Philosophy

### Principles
- **Minimalism**: Clean, distraction-free interface
- **Dark Theme**: Easy on eyes, battery-efficient
- **Neon Accents**: Modern, vibrant, customizable
- **Smooth Animations**: Delightful user experience
- **Intuitive Gestures**: Natural, discoverable interactions

### Color System
- 36 carefully curated preset colors
- Custom RGB picker for unlimited possibilities
- Consistent color application across all features
- High contrast for readability
- Optimized for AMOLED displays

---

## 🔐 Permissions

| Permission | Purpose | Required |
|-----------|---------|----------|
| **Notifications** | Show alarm & reminder alerts | Yes |
| **Exact Alarms** | Trigger alarms at precise times | Yes |
| **Vibration** | Haptic feedback for alerts | Optional |

*Focus Clock respects your privacy. No data is collected except anonymous usage analytics via Firebase.*

---

## 🐛 Known Issues

Currently, there are no known critical issues. If you encounter any problems:
1. Check [existing issues](../../issues)
2. Create a [new issue](../../issues/new) with:
   - Device model & Android version
   - Steps to reproduce
   - Screenshots (if applicable)

---

## 🗺️ Roadmap

- [ ] **iOS Support** (iPhone & iPad)
- [ ] **Widgets** (Home screen clock widget)
- [ ] **World Clock** (Multiple timezones)
- [ ] **Pomodoro Timer** (Work/break cycles)
- [ ] **Themes** (Light mode, AMOLED black)
- [ ] **Backup & Sync** (Cloud storage)
- [ ] **More Watch Faces** (Analog, binary, etc.)
- [ ] **Alarm Challenges** (Math problems, shake to dismiss)
- [ ] **Sleep Timer** (Auto-stop music)
- [ ] **Statistics** (Usage tracking & insights)

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Development Guidelines
- Follow Flutter/Dart style guide
- Write meaningful commit messages
- Add comments for complex logic
- Test on multiple devices
- Update documentation

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Mehedi Hasan Hridoy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 👨‍💻 Author

**Mehedi Hasan Hridoy**

- GitHub: [@mehedi-hridoy](https://github.com/mehedi-hridoy)

---

## 🙏 Acknowledgments

- **Flutter Team** - Amazing framework
- **Firebase** - Analytics platform
- **Google Fonts** - Beautiful typography
- **Material Design** - Design guidelines
- **Community** - Inspiration & support

---

## ⭐ Star History

If you like this project, please give it a ⭐ on GitHub!

---

## 📞 Support

Need help? Have questions?

- 🐛 [Report a Bug](../../issues/new?labels=bug)
- 💡 [Request a Feature](../../issues/new?labels=enhancement)
- 💬 [Discussions](../../discussions)

---

<div align="center">

### Made with ❤️ using Flutter

**[Download Now](../../releases)** • **[View Source](../../)** • **[Report Issue](../../issues)**

---

*© 2025 Mehedi Hasan Hridoy. All rights reserved.*

</div>
