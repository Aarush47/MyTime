// TIMER & ALARM AGENT - State & Background Logic
// Handles countdown timer, alarm scheduling, and lifecycle management

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Timer state
enum TimerStatus { idle, running, paused, completed }

class TimerState {
  final int totalSeconds;
  final int remainingSeconds;
  final TimerStatus status;

  TimerState({
    this.totalSeconds = 0,
    this.remainingSeconds = 0,
    this.status = TimerStatus.idle,
  });

  TimerState copyWith({
    int? totalSeconds,
    int? remainingSeconds,
    TimerStatus? status,
  }) {
    return TimerState(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
    );
  }

  String getFormattedTime() {
    final hours = remainingSeconds ~/ 3600;
    final minutes = (remainingSeconds % 3600) ~/ 60;
    final seconds = remainingSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    if (totalSeconds == 0) return 0.0;
    return 1.0 - (remainingSeconds / totalSeconds);
  }
}

/// Timer notifier
class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;

  TimerNotifier() : super(TimerState());

  /// Start timer with duration in seconds
  void start(int seconds) {
    _timer?.cancel();
    state = TimerState(
      totalSeconds: seconds,
      remainingSeconds: seconds,
      status: TimerStatus.running,
    );
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      } else {
        timer.cancel();
        state = state.copyWith(status: TimerStatus.completed);
      }
    });
  }

  /// Pause the timer
  void pause() {
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  /// Resume the timer
  void resume() {
    if (state.status == TimerStatus.paused && state.remainingSeconds > 0) {
      state = state.copyWith(status: TimerStatus.running);
      _startCountdown();
    }
  }

  /// Reset the timer
  void reset() {
    _timer?.cancel();
    state = TimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Alarm state
class AlarmState {
  final List<Alarm> alarms;

  AlarmState({this.alarms = const []});

  AlarmState copyWith({List<Alarm>? alarms}) {
    return AlarmState(alarms: alarms ?? this.alarms);
  }
}

class Alarm {
  final String id;
  final TimeOfDay time;
  final String label;
  final bool isEnabled;
  final List<int> repeatDays; // 1=Monday, 7=Sunday

  Alarm({
    required this.id,
    required this.time,
    this.label = '',
    this.isEnabled = true,
    this.repeatDays = const [],
  });

  Alarm copyWith({
    String? id,
    TimeOfDay? time,
    String? label,
    bool? isEnabled,
    List<int>? repeatDays,
  }) {
    return Alarm(
      id: id ?? this.id,
      time: time ?? this.time,
      label: label ?? this.label,
      isEnabled: isEnabled ?? this.isEnabled,
      repeatDays: repeatDays ?? this.repeatDays,
    );
  }

  String getFormattedTime() {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});
}

/// Alarm notifier
class AlarmNotifier extends StateNotifier<AlarmState> {
  AlarmNotifier() : super(AlarmState());

  void addAlarm(Alarm alarm) {
    state = state.copyWith(alarms: [...state.alarms, alarm]);
  }

  void removeAlarm(String id) {
    state = state.copyWith(
      alarms: state.alarms.where((a) => a.id != id).toList(),
    );
  }

  void toggleAlarm(String id) {
    state = state.copyWith(
      alarms: state.alarms
          .map((a) => a.id == id ? a.copyWith(isEnabled: !a.isEnabled) : a)
          .toList(),
    );
  }

  void updateAlarm(Alarm alarm) {
    state = state.copyWith(
      alarms: state.alarms.map((a) => a.id == alarm.id ? alarm : a).toList(),
    );
  }
}

/// Providers
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});

final alarmProvider = StateNotifierProvider<AlarmNotifier, AlarmState>((ref) {
  return AlarmNotifier();
});
