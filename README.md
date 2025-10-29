# 🕒 Focus Clock

**Your all-in-one LED desk clock replacement app — with timer, stopwatch, alarms & reminders. Built for landscape mode and always-on displays.**

[![Flutter](https://img.shields.io/badge/Flutter-3.24.5-02569B?logo=flutter)](https://flutter.dev) 
[![Dart](https://img.shields.io/badge/Dart-3.5.4-0175C2?logo=dart)](https://dart.dev) 
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

### 📥 Download APK

**Focus Clock v1.0.0 —** download: `./Focus Clock.apk` (52 MB)

---

## Overview

Focus Clock is your LED desk clock replacement — a full-featured Android app designed to sit on your desk or nightstand. No need for expensive LED clocks when you have an old phone or tablet.

**Why Focus Clock?**
- Replaces physical LED desk clocks
- Always-on display support
- Large, readable digits in landscape mode
- Multiple watch faces with customizable colors
- Integrated timer, stopwatch, alarms & reminders

---

## 📱 Screenshots

### 🎬 Onboarding Experience

![Onboarding 1](docs/screenshots/onboarding/onboarding1.png)
![Onboarding 2](docs/screenshots/onboarding/onboarding2.png)
![Onboarding 3](docs/screenshots/onboarding/onboarding3.png)
![Onboarding 4](docs/screenshots/onboarding/onboarding4.png)
![Onboarding 5](docs/screenshots/onboarding/onboarding5.png)
![Onboarding 6](docs/screenshots/onboarding/onboarding6.png)

### 🏠 Home Screen

![Home Page](docs/screenshots/home/homePage.png)

### 🕐 Watch Faces

![Clock Face 1](docs/screenshots/clock/clock1.png)
![Clock Face 2](docs/screenshots/clock/clock2.png)
![Clock Face 3](docs/screenshots/clock/clock3.png)
![Clock Face 4](docs/screenshots/clock/clock4.png)

### ⏱️ Timer

![Timer 1](docs/screenshots/timer/timer1.png)
![Timer 2](docs/screenshots/timer/timer2.png)
![Timer 3](docs/screenshots/timer/timer3.png)

### ⏲️ Stopwatch

![Stopwatch](docs/screenshots/stopwatch/stopwatch.png)

### 🔔 Alarms

![Alarm List](docs/screenshots/alarm/alarm.png)
![Alarm 2](docs/screenshots/alarm/alarm2.png)
![Alarm 3](docs/screenshots/alarm/alarm3.png)
![Alarm 4](docs/screenshots/alarm/alarm4.png)
![Alarm 5](docs/screenshots/alarm/alarm5.png)

### 📝 Reminders

![Reminder 1](docs/screenshots/reminder/remainder1.png)
![Reminder 2](docs/screenshots/reminder/remainder2.png)
![Reminder 3](docs/screenshots/reminder/remainder3.png)
![Reminder 4](docs/screenshots/reminder/remainder4.png)
![Reminder 5](docs/screenshots/reminder/remainder5.png)

### ⚙️ Settings

![Settings](docs/screenshots/settings/settings.png)

---

## Key features (short)

- 5 watch faces (LED, segment, rounded, large-digit, flip)
- 36+ preset colors + RGB custom picker
- Timer with reversible countdown direction (60→0 or 0→60)
- Stopwatch with lap support
- Multiple alarms and reminders with repeat and ringtones
- Landscape-first, always-on display

---

## Developer notes (concise / senior-dev style)

### Contract (inputs / outputs / error modes)
- Inputs: UI gestures (tap, double-tap, long-press, swipe), settings, scheduled alarm/reminder payloads.
- Outputs: full-screen rendering, local notifications, alarm audio/vibration, persisted settings.
- Errors: permission denial, OS battery optimizations, missing audio files. App should fail gracefully and log.

### Where to look (quick map)
- Entry: `lib/main.dart`
- Screens: `lib/presentation/screens/` (clock, timer, stopwatch, alarm, reminder)
- Widgets: `lib/presentation/widgets/`
- State: `lib/state/` (`timer_provider.dart`, `settings_provider.dart`, etc.)
- Services: `lib/core/services/` (alarm_service, notification_service)
- Assets/screenshots: `docs/screenshots/`

### Run & build (commands)

Install dependencies and run on a device/emulator:

```bash
flutter pub get
flutter run -d <device-id>
```

Build release APK:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Tests

Run unit and widget tests:

```bash
flutter test
```

Integration tests (if present): use `integration_test` and run via `flutter test` or `flutter drive` as configured.

### Release checklist
- Bump `version` / `buildNumber` in `pubspec.yaml`.
- Run `flutter build apk --release` and verify on target devices.
- Tag and push a release; attach `Focus.Clock.apk` in GitHub releases and include changelog.

Minimal release commands:

```bash
git add .
git commit -m "release: v1.0.0"
git tag -a v1.0.0 -m "Focus Clock v1.0.0"
git push origin main --tags
```

### CI suggestions (lightweight)
- `flutter format --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`
- Optional: `fastlane` for Play Store automation

### Troubleshooting (common)
- App won't install: enable "Install unknown apps" and ensure selected APK matches device ABI.
- Alarms not firing: verify Exact Alarms permission and remove battery optimizations for the app.
- UI performance issues: run DevTools profiler and check main-thread work.

---

## Contributing

Please follow `CONTRIBUTING.md`. Keep PRs focused and include tests for behavior changes.

---

## License

MIT — see `LICENSE` for details.

---

Made with ❤️ using Flutter
