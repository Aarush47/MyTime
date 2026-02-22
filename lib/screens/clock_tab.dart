// UI & LAYOUT AGENT - Visual/UI Expert
// Clock tab with flip clock design

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/clock_provider.dart';
import '../widgets/flip_clock_digit.dart';

class ClockTab extends ConsumerWidget {
  const ClockTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clockState = ref.watch(clockProvider);
    final time = clockState.getTimeString();
    final parts = time.split(':');

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            
            // Date display
            Text(
              clockState.getDateString().toUpperCase(),
              style: GoogleFonts.openSans(
                fontSize: 13,
                letterSpacing: 2,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Flip clock display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hours
                FlipClockDigit(
                  value: parts[0].length == 2 ? parts[0][0] : '0',
                  size: 70,
                ),
                const SizedBox(width: 8),
                FlipClockDigit(
                  value: parts[0].length == 2 ? parts[0][1] : parts[0][0],
                  size: 70,
                ),
                
                // Colon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Minutes
                FlipClockDigit(
                  value: parts[1][0],
                  size: 70,
                ),
                const SizedBox(width: 8),
                FlipClockDigit(
                  value: parts[1][1],
                  size: 70,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Seconds and AM/PM
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  clockState.getSeconds(),
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    letterSpacing: 3,
                    color: Colors.white.withOpacity(0.4),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(width: 16),
                // Always show AM/PM in 12-hour mode
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    clockState.getPeriod(),
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            
            const Spacer(flex: 3),
            
            // Format toggle
            TextButton(
              onPressed: () {
                ref.read(clockProvider.notifier).toggle24HourFormat();
              },
              child: Text(
                clockState.is24HourFormat ? 'Switch to 12h' : 'Switch to 24h',
                style: GoogleFonts.openSans(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
