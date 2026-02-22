// TIMER & ALARM AGENT - State & Background Logic
// Alarm tab with minimal dark interface

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timer_provider.dart';

class AlarmTab extends ConsumerWidget {
  const AlarmTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmState = ref.watch(alarmProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ALARMS',
                    style: TextStyle(
                      fontSize: 13,
                      letterSpacing: 2,
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => _showAddAlarmDialog(context, ref),
                  ),
                ],
              ),
            ),
            
            // Alarms list
            Expanded(
              child: alarmState.alarms.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.alarm_off,
                            size: 48,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No alarms',
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
                      itemCount: alarmState.alarms.length,
                      itemBuilder: (context, index) {
                        final alarm = alarmState.alarms[index];
                        return _AlarmItem(
                          alarm: alarm,
                          onToggle: () {
                            ref.read(alarmProvider.notifier).toggleAlarm(alarm.id);
                          },
                          onDelete: () {
                            ref.read(alarmProvider.notifier).removeAlarm(alarm.id);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAlarmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Alarm', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Coming soon!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _AlarmItem extends StatelessWidget {
  final Alarm alarm;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _AlarmItem({
    required this.alarm,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: alarm.isEnabled
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: alarm.isEnabled
              ? Colors.white.withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alarm.getFormattedTime(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    color: alarm.isEnabled ? Colors.white : Colors.white38,
                  ),
                ),
                if (alarm.label.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    alarm.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: alarm.isEnabled,
            onChanged: (_) => onToggle(),
            activeColor: Colors.white,
            inactiveThumbColor: Colors.white38,
            inactiveTrackColor: Colors.white.withOpacity(0.1),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: Colors.white38,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
