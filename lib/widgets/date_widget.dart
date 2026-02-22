// UI & LAYOUT AGENT - Visual/UI Expert
// Date display widget with Apple StandBy aesthetic

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/clock_provider.dart';

class DateWidget extends ConsumerWidget {
  const DateWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clockState = ref.watch(clockProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          clockState.getDayOfWeek().toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          clockState.getShortDate(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
