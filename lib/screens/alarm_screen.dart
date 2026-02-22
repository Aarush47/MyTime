// TIMER & ALARM AGENT - State & Background Logic
// Alarm management screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timer_provider.dart';

class AlarmScreen extends ConsumerWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmState = ref.watch(alarmProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Alarms',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFFF9F0A)),
            onPressed: () => _showAddAlarmDialog(context, ref),
          ),
        ],
      ),
      body: alarmState.alarms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alarm_off,
                    size: 64,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No alarms set',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add an alarm',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alarmState.alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarmState.alarms[index];
                return _AlarmCard(
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
    );
  }

  void _showAddAlarmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Add Alarm',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Alarm functionality coming soon!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFFFF9F0A)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _AlarmCard({
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
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: alarm.isEnabled
              ? const Color(0xFFFF9F0A).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
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
                    color: alarm.isEnabled ? Colors.white : Colors.white54,
                  ),
                ),
                if (alarm.label.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    alarm.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
                if (alarm.repeatDays.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _getRepeatDaysText(alarm.repeatDays),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: alarm.isEnabled,
            onChanged: (_) => onToggle(),
            activeColor: const Color(0xFFFF9F0A),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.red.withOpacity(0.7),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  String _getRepeatDaysText(List<int> days) {
    if (days.length == 7) return 'Every day';
    if (days.isEmpty) return 'Once';

    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days.map((d) => dayNames[d - 1]).join(', ');
  }
}
