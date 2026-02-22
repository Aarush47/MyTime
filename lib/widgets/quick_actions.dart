// UI & LAYOUT AGENT - Visual/UI Expert
// Quick action buttons for Timer, Alarm, Calendar

import 'package:flutter/material.dart';
import '../screens/timer_screen.dart';
import '../screens/alarm_screen.dart';
import '../screens/calendar_screen.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickActionButton(
          icon: Icons.timer_outlined,
          label: 'Timer',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TimerScreen()),
            );
          },
        ),
        _QuickActionButton(
          icon: Icons.alarm_outlined,
          label: 'Alarm',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AlarmScreen()),
            );
          },
        ),
        _QuickActionButton(
          icon: Icons.calendar_today_outlined,
          label: 'Calendar',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarScreen()),
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.9),
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
