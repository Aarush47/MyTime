// CLOCK LOGIC AGENT - Logic Specialist
// Handles time updates, formatting, and efficient clock state management

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Clock state model
class ClockState {
  final DateTime currentTime;
  final bool is24HourFormat;

  ClockState({
    required this.currentTime,
    this.is24HourFormat = false,
  });

  ClockState copyWith({
    DateTime? currentTime,
    bool? is24HourFormat,
  }) {
    return ClockState(
      currentTime: currentTime ?? this.currentTime,
      is24HourFormat: is24HourFormat ?? this.is24HourFormat,
    );
  }

  /// Get formatted time string
  String getTimeString() {
    if (is24HourFormat) {
      return DateFormat('HH:mm').format(currentTime);
    } else {
      return DateFormat('h:mm').format(currentTime);
    }
  }

  /// Get period (AM/PM) for 12-hour format
  String getPeriod() {
    return DateFormat('a').format(currentTime);
  }

  /// Get seconds
  String getSeconds() {
    return DateFormat('ss').format(currentTime);
  }

  /// Get full date string
  String getDateString() {
    return DateFormat('EEEE, MMMM d').format(currentTime);
  }

  /// Get short date
  String getShortDate() {
    return DateFormat('MMM d').format(currentTime);
  }

  /// Get day of week
  String getDayOfWeek() {
    return DateFormat('EEEE').format(currentTime);
  }
}

/// Clock state notifier - manages time updates
class ClockNotifier extends StateNotifier<ClockState> {
  Timer? _timer;

  ClockNotifier()
      : super(ClockState(
          currentTime: DateTime.now(),
          is24HourFormat: false, // Default to 12-hour format
        )) {
    _startClock();
  }

  /// Start the clock timer (updates every second)
  void _startClock() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(currentTime: DateTime.now());
    });
  }

  /// Toggle between 12-hour and 24-hour format
  void toggle24HourFormat() {
    state = state.copyWith(is24HourFormat: !state.is24HourFormat);
  }

  /// Set time format
  void setTimeFormat(bool is24Hour) {
    state = state.copyWith(is24HourFormat: is24Hour);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Provider for clock state
final clockProvider = StateNotifierProvider<ClockNotifier, ClockState>((ref) {
  return ClockNotifier();
});
