// TIMER & ALARM AGENT - State & Background Logic
// Timer screen with countdown and controls

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timer_provider.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);

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
          'Timer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              
              // Timer display
              if (timerState.status != TimerStatus.idle) ...[
                // Circular progress indicator
                SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background circle
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: CircularProgressIndicator(
                          value: timerState.progress,
                          strokeWidth: 8,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF9F0A),
                          ),
                        ),
                      ),
                      // Time text
                      Text(
                        timerState.getFormattedTime(),
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text(
                  '00:00',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w200,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
              
              const Spacer(),
              
              // Quick timer buttons
              if (timerState.status == TimerStatus.idle) ...[
                const Text(
                  'QUICK TIMERS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _QuickTimerButton(
                      label: '1 min',
                      onTap: () => ref.read(timerProvider.notifier).start(60),
                    ),
                    _QuickTimerButton(
                      label: '5 min',
                      onTap: () => ref.read(timerProvider.notifier).start(300),
                    ),
                    _QuickTimerButton(
                      label: '10 min',
                      onTap: () => ref.read(timerProvider.notifier).start(600),
                    ),
                    _QuickTimerButton(
                      label: '15 min',
                      onTap: () => ref.read(timerProvider.notifier).start(900),
                    ),
                    _QuickTimerButton(
                      label: '30 min',
                      onTap: () => ref.read(timerProvider.notifier).start(1800),
                    ),
                    _QuickTimerButton(
                      label: '1 hour',
                      onTap: () => ref.read(timerProvider.notifier).start(3600),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 40),
              
              // Control buttons
              if (timerState.status != TimerStatus.idle) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (timerState.status == TimerStatus.running)
                      _ControlButton(
                        icon: Icons.pause,
                        label: 'Pause',
                        onTap: () => ref.read(timerProvider.notifier).pause(),
                      ),
                    if (timerState.status == TimerStatus.paused)
                      _ControlButton(
                        icon: Icons.play_arrow,
                        label: 'Resume',
                        onTap: () => ref.read(timerProvider.notifier).resume(),
                      ),
                    const SizedBox(width: 20),
                    _ControlButton(
                      icon: Icons.stop,
                      label: 'Reset',
                      color: Colors.red,
                      onTap: () => ref.read(timerProvider.notifier).reset(),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickTimerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickTimerButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFF9F0A).withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFF9F0A).withOpacity(0.5),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFF9F0A),
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? const Color(0xFFFF9F0A);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: buttonColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: buttonColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: buttonColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
