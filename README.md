# MyClock - Android Clock App

A feature-rich Android clock application built with Kotlin that includes multiple time-tracking features in a sleek, fullscreen landscape interface.

## 📱 Download APK

**[⬇️ Download MyClock.apk](https://github.com/Aarush47/MyTime/raw/main/MyClock.apk)** (6.6 MB)

Click the link above to download and install the app directly on your Android device.

## Features

### 🕐 Clock
- Real-time flip-style digital clock display
- Syncs with device time automatically
- Shows hours, minutes, and seconds with AM/PM indicator

### ⏱️ Stopwatch
- Analog stopwatch display with 60-tick precision
- Lap time tracking with detailed records
- Clean horizontal layout:
  - Left side: Analog stopwatch with control buttons
  - Right side: Lap records with lap time and total time
- Visual design with orange animated hand
- Start/Stop and Lap functionality

### ⏰ Alarm
- Set multiple alarms with custom labels
- Repeat alarms with day selection (weekdays/specific days)
- Alarm notifications with sound and vibration
- Haptic feedback on interactions
- Delete confirmation dialogs
- Toggle alarms on/off easily

### 📅 Calendar
- Monthly calendar view
- Highlights current day
- Navigate between months

## Technical Details

### Built With
- **Language**: Kotlin
- **Min SDK**: 24 (Android 7.0)
- **Target SDK**: 34 (Android 14)
- **Build System**: Gradle with Kotlin DSL

### Key Features
- Fullscreen landscape mode for immersive experience
- Custom Canvas drawing for analog stopwatch
- AlarmManager integration for precise alarm triggering
- Notification system with custom channels
- Haptic feedback throughout the app
- Material Design components
- Fragment-based architecture with ViewPager2

### Permissions
- `VIBRATE` - For haptic feedback and alarm vibration
- `POST_NOTIFICATIONS` - For alarm notifications
- `SCHEDULE_EXACT_ALARM` - For precise alarm scheduling
- `WAKE_LOCK` - To wake device for alarms
- `FOREGROUND_SERVICE` - For timer service

## Installation

### Option 1: Direct APK Install (Recommended)
1. Download **[MyClock.apk](https://github.com/Aarush47/MyTime/raw/main/MyClock.apk)** on your Android device
2. Enable "Install from Unknown Sources" in your device settings
3. Open the downloaded APK file
4. Follow the installation prompts
5. Grant necessary permissions when prompted

### Option 2: Build from Source
1. Clone the repository:
```bash
git clone https://github.com/Aarush47/MyTime.git
cd MyTime
```

2. Open the project in Android Studio

3. Build and run:
```bash
./gradlew assembleDebug
./gradlew installDebug
```

## APK Location

Pre-built APK is available in two locations:
- **Root directory**: `MyClock.apk` (easy access)
- **Build output**: `app/build/outputs/apk/debug/app-debug.apk`

## App Interface

The app features a **horizontal landscape layout** optimized for immersive viewing:
- Fullscreen display with swipe-to-reveal system bars
- Dark theme throughout for comfortable viewing
- Split-screen stopwatch design (stopwatch on left, lap records on right)
- Intuitive navigation with bottom tabs
- Clean, modern Material Design UI

## License

This project is available for personal and educational use.

## Author

Built with ❤️ using Android Studio and Kotlin
