# 🕒 Focus Clock

**Minimal, configurable desk clock & focus timer — optimized for landscape and always‑on displays.**

[![Flutter](https://img.shields.io/badge/Flutter-3.24.5-02569B?logo=flutter)](https://flutter.dev) 
[![Dart](https://img.shields.io/badge/Dart-3.5.4-0175C2?logo=dart)](https://dart.dev) 
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)


### 📥 Download APK

**Focus Clock v1.0.0 —** download: `./Focus Clock.apk` (52 MB)

---

## Quick links

- APK: `./Focus Clock.apk`
- Screenshots: `docs/screenshots/` (organized by category)
- Contributing: `CONTRIBUTING.md`

---

## Overview (short)

Focus Clock is a compact Android application designed to serve as a readable desk clock, with integrated timer, stopwatch, alarms and reminders. It focuses on reliability, low visual clutter, and landscape-first presentation.

Design goals:
- readable at a distance (large digits)
- minimal interactions (tap/double-tap/swipe)
- configurable color & brightness
- accurate timers & alarms (supports exact alarms)

---

## Screenshot gallery

All images are stored in `docs/screenshots/`. The gallery below is intentionally visual-first and minimal.

### Onboarding

<table>
  <tr>
    <td><img src="docs/screenshots/onboarding/onboarding_1.jpg" width="360"/></td>
    <td><img src="docs/screenshots/onboarding/onboarding_2.jpg" width="360"/></td>
  </tr>
  <tr>
    <td><img src="docs/screenshots/onboarding/onboarding_3.jpg" width="360"/></td>
    <td><img src="docs/screenshots/onboarding/onboarding_4.jpg" width="360"/></td>
  </tr>
</table>

### Home & Settings

<table>
  <tr>
    <td><img src="docs/screenshots/home/home_1.jpg" width="420"/></td>
    <td><img src="docs/screenshots/settings/settings_dialog.jpg" width="420"/></td>
  </tr>
</table>

### Watch faces (examples)

<table>
  <tr>
    <td><img src="docs/screenshots/clock/clock_face_1.jpg" width="360"/></td>
    <td><img src="docs/screenshots/clock/clock_face_2.jpg" width="360"/></td>
  </tr>
</table>

### Timer & Stopwatch

<table>
  <tr>
    <td><img src="docs/screenshots/timer/timer_settings.jpg" width="360"/></td>
    <td><img src="docs/screenshots/timer/timer_running.jpg" width="360"/></td>
  </tr>
</table>

### Alarms & Reminders

<table>
  <tr>
    <td><img src="docs/screenshots/alarm/alarm_list.jpg" width="360"/></td>
    <td><img src="docs/screenshots/reminder/reminder_list.jpg" width="360"/></td>
  </tr>
</table>

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
