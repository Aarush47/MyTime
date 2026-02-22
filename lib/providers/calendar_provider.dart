// CALENDAR AGENT - Date & Data Handling
// Manages calendar data, date calculations, and simple agenda

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Calendar event model
class CalendarEvent {
  final String id;
  final String title;
  final DateTime dateTime;
  final String? description;
  final bool isAllDay;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.dateTime,
    this.description,
    this.isAllDay = false,
  });

  String getFormattedTime() {
    if (isAllDay) return 'All day';
    return DateFormat('h:mm a').format(dateTime);
  }

  bool isToday() {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }
}

/// Calendar state
class CalendarState {
  final DateTime selectedDate;
  final List<CalendarEvent> events;

  CalendarState({
    required this.selectedDate,
    this.events = const [],
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    List<CalendarEvent>? events,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      events: events ?? this.events,
    );
  }

  /// Get events for today
  List<CalendarEvent> getTodayEvents() {
    final now = DateTime.now();
    return events.where((event) {
      return event.dateTime.year == now.year &&
          event.dateTime.month == now.month &&
          event.dateTime.day == now.day;
    }).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  /// Get events for selected date
  List<CalendarEvent> getEventsForDate(DateTime date) {
    return events.where((event) {
      return event.dateTime.year == date.year &&
          event.dateTime.month == date.month &&
          event.dateTime.day == date.day;
    }).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  /// Get day name
  String getDayName() {
    return DateFormat('EEEE').format(selectedDate);
  }

  /// Get month and day
  String getMonthDay() {
    return DateFormat('MMMM d').format(selectedDate);
  }

  /// Get day number
  String getDayNumber() {
    return DateFormat('d').format(selectedDate);
  }
}

/// Calendar notifier
class CalendarNotifier extends StateNotifier<CalendarState> {
  CalendarNotifier()
      : super(CalendarState(
          selectedDate: DateTime.now(),
          events: _getDemoEvents(),
        ));

  /// Add a new event
  void addEvent(CalendarEvent event) {
    state = state.copyWith(
      events: [...state.events, event],
    );
  }

  /// Remove an event
  void removeEvent(String id) {
    state = state.copyWith(
      events: state.events.where((e) => e.id != id).toList(),
    );
  }

  /// Select a date
  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  /// Get demo events for testing
  static List<CalendarEvent> _getDemoEvents() {
    final now = DateTime.now();
    return [
      CalendarEvent(
        id: '1',
        title: 'Morning Meeting',
        dateTime: DateTime(now.year, now.month, now.day, 9, 0),
        description: 'Team sync',
      ),
      CalendarEvent(
        id: '2',
        title: 'Lunch Break',
        dateTime: DateTime(now.year, now.month, now.day, 12, 30),
        isAllDay: false,
      ),
      CalendarEvent(
        id: '3',
        title: 'Project Review',
        dateTime: DateTime(now.year, now.month, now.day, 15, 0),
        description: 'Q1 review meeting',
      ),
    ];
  }
}

/// Provider
final calendarProvider =
    StateNotifierProvider<CalendarNotifier, CalendarState>((ref) {
  return CalendarNotifier();
});
