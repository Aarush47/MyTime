// CALENDAR AGENT - Date & Data Handling
// Calendar tab with minimal dark interface

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calendar_provider.dart';

class CalendarTab extends ConsumerWidget {
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);
    final todayEvents = calendarState.getTodayEvents();

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Date header
            Text(
              'TODAY',
              style: TextStyle(
                fontSize: 13,
                letterSpacing: 2,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              calendarState.getMonthDay(),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            
            Text(
              calendarState.getDayName(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Events list
            Expanded(
              child: todayEvents.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_available,
                            size: 48,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No events today',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: todayEvents.length,
                      itemBuilder: (context, index) {
                        final event = todayEvents[index];
                        return _EventItem(event: event);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventItem extends StatelessWidget {
  final CalendarEvent event;

  const _EventItem({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.getFormattedTime(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (event.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    event.description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
