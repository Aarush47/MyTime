// UI & LAYOUT AGENT - Visual/UI Expert
// Large digital clock display with smooth animations

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/clock_provider.dart';

class ClockWidget extends ConsumerWidget {
  const ClockWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clockState = ref.watch(clockProvider);

    return GestureDetector(
      onTap: () {
        ref.read(clockProvider.notifier).toggle24HourFormat();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main time display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time
              Text(
                clockState.getTimeString(),
                style: const TextStyle(
                  fontSize: 92,
                  fontWeight: FontWeight.w200,
                  letterSpacing: -2,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              
              if (!clockState.is24HourFormat) ...[
                const SizedBox(width: 8),
                // AM/PM indicator
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    clockState.getPeriod(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 4),
          
          // Seconds display
          Text(
            clockState.getSeconds(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              letterSpacing: 4,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
