# Clock App - Flutter

A modern clock application with flip-style animations, featuring Clock, Timer, Alarm, and Calendar tabs.

## Features

- 🕐 **Flip Clock** - Beautiful animated flip digits with 12-hour AM/PM format
- ⏱️ **Timer** - Quick presets and circular progress indicator
- ⏰ **Alarm** - Manage multiple alarms
- 📅 **Calendar** - View today's events
- 🎨 **Dark Minimal UI** - Clean interface with Open Sans font

## To Run This Flutter App

### Option 1: Android Studio
1. Open Android Studio
2. Open this folder: `/Users/aarush/Downloads/MyClock`
3. Wait for Gradle sync and Flutter dependencies to download
4. Click Run (▶️) button
5. Select your device/emulator

### Option 2: VS Code
1. Open this folder in VS Code
2. Install Flutter extension
3. Open Terminal and run: `flutter pub get`
4. Press F5 or click Run → Start Debugging
5. Select your device

### Option 3: Command Line (if Flutter is installed)
```bash
cd /Users/aarush/Downloads/MyClock
flutter pub get
flutter run
```

## Important Notes

⚠️ This is a **Flutter app** (not the old Android Kotlin app). 

The app uses:
- Flutter SDK
- Riverpod for state management  
- Google Fonts (Open Sans)
- Flip clock animations

## UI Preview

- **Clock Tab**: Large flip-style digits with AM/PM indicator
- **Timer Tab**: Circular progress with quick presets
- **Alarm Tab**: List of alarms with toggle switches
- **Calendar Tab**: Today's events in clean cards

All tabs use a dark (#0a0a0a) background with white text.
