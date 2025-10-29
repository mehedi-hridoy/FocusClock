# Installation Guide - Focus Clock v1.0.0

## Prerequisites
- Android device running Android 5.0 (Lollipop) or higher
- Approximately 60 MB of free storage space

## Installation Steps

### Option 1: Direct APK Installation (Recommended)

1. **Download the APK**
   - Go to the [Releases](https://github.com/YOUR_USERNAME/focus_clock/releases) page
   - Download `app-release.apk` from the v1.0.0 release

2. **Enable Unknown Sources**
   - Go to your device **Settings**
   - Navigate to **Security** (or **Privacy**)
   - Enable **Install from Unknown Sources** or **Allow from this source** (for Android 8.0+)
   - Some devices: **Settings** → **Apps** → **Special access** → **Install unknown apps** → Select your browser/file manager → Allow

3. **Install the APK**
   - Open your **Downloads** folder or notification
   - Tap on `app-release.apk`
   - Tap **Install** when prompted
   - Wait for the installation to complete
   - Tap **Open** to launch Focus Clock

4. **Grant Permissions**
   - When prompted, allow the following permissions:
     - **Notifications** - For reminder alerts
     - **Alarms & reminders** - For setting precise alarms
     - **Display over other apps** (if needed) - For alarm screen

### Option 2: ADB Installation (For Developers)

1. **Prerequisites**
   - Install [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools)
   - Enable **Developer Options** on your device:
     - Go to **Settings** → **About phone**
     - Tap **Build number** 7 times
   - Enable **USB Debugging**:
     - Go to **Settings** → **Developer Options**
     - Enable **USB debugging**

2. **Connect Device**
   ```bash
   # Connect your device via USB
   # Verify connection
   adb devices
   ```

3. **Install APK**
   ```bash
   # Navigate to the downloaded APK location
   cd ~/Downloads
   
   # Install the app
   adb install app-release.apk
   ```

4. **Launch App**
   ```bash
   # Launch Focus Clock
   adb shell am start -n com.example.focus_clock/.MainActivity
   ```

### Option 3: Wireless ADB Installation (Advanced)

1. **Enable Wireless Debugging** (Android 11+)
   - **Settings** → **Developer Options** → **Wireless debugging**
   - Tap **Pair device with pairing code**
   - Note the IP address and port

2. **Pair and Install**
   ```bash
   # Pair device (enter the code shown on your device)
   adb pair <IP_ADDRESS>:<PORT>
   
   # Connect
   adb connect <IP_ADDRESS>:<PORT>
   
   # Install
   adb install app-release.apk
   ```

## Post-Installation Setup

### First Launch
1. **Onboarding Screen**: Swipe through the welcome screens
2. **Main Screen**: You'll see the default clock face
3. **Grant Permissions**: Allow notifications and alarm permissions when prompted

### Configure Your First Alarm
1. Tap the **Alarm** tab at the bottom
2. Tap the **+** button
3. Set your desired time
4. Choose repeat options (optional)
5. Save the alarm

### Configure Your First Timer
1. Tap the **Timer** tab
2. Use the picker to set hours, minutes, seconds
3. Tap **Start** to begin the countdown
4. Tap the timer to enter fullscreen mode

### Customize Watch Face
1. From the main clock screen, tap **⚙️ Settings**
2. Select **Watch Face**
3. Choose from 5 beautiful designs
4. Customize colors using the color picker

## Troubleshooting

### Installation Failed
- **Error: "App not installed"**
  - Solution: Uninstall any previous version first
  - Check if you have enough storage space (60 MB needed)
  
- **Error: "For security reasons, your phone is not allowed to install unknown apps from this source"**
  - Solution: Enable "Install from Unknown Sources" for your browser/file manager
  - Path: Settings → Apps → Special access → Install unknown apps

### App Crashes on Launch
- Clear app data: Settings → Apps → Focus Clock → Storage → Clear Data
- Restart your device
- Reinstall the app
- Report the issue on GitHub with device details

### Alarms Not Working
- Check that **Alarms & reminders** permission is granted
- Ensure the app has **Battery optimization** disabled:
  - Settings → Apps → Focus Clock → Battery → Don't optimize
- Check that Do Not Disturb is not blocking alarms

### Notifications Not Showing
- Grant notification permission: Settings → Apps → Focus Clock → Notifications → Allow
- Check notification categories are enabled
- Ensure battery saver is not blocking notifications

### Timer/Stopwatch Not Audible
- Check device volume levels
- Go to Focus Clock → Settings → enable sounds
- Check if Do Not Disturb mode is active

## Uninstallation

### Via Device Settings
1. Go to **Settings** → **Apps**
2. Find and tap **Focus Clock**
3. Tap **Uninstall**
4. Confirm uninstallation

### Via ADB
```bash
adb uninstall com.example.focus_clock
```

## Support

### Get Help
- 📖 Read the [Release Notes](RELEASE_NOTES_v1.0.0.md)
- 🐛 Report bugs: [GitHub Issues](https://github.com/YOUR_USERNAME/focus_clock/issues)
- 💬 Ask questions: [GitHub Discussions](https://github.com/YOUR_USERNAME/focus_clock/discussions)

### System Information (For Bug Reports)
When reporting issues, please include:
- Device model and manufacturer
- Android version
- Focus Clock version (1.0.0)
- Steps to reproduce the issue
- Screenshots or screen recordings (if applicable)

---

**Thank you for installing Focus Clock! 🎉**

We hope you enjoy using the app. If you find it helpful, please consider starring the repository on GitHub and sharing it with others!
