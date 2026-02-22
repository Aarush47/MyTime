// TIMER & ALARM AGENT - State & Background Logic
// Timer tab with minimal dark interface

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timer_provider.dart';

class TimerTab extends ConsumerWidget {
  const TimerTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Title
            Text(
              'TIMER',
              style: TextStyle(
                fontSize: 13,
                letterSpacing: 2,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
            
            const Spacer(flex: 2),
            
            // Timer display
            if (timerState.status != TimerStatus.idle)
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Progress ring
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: CircularProgressIndicator(
                        value: timerState.progress,
                        strokeWidth: 3,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    // Time
                    Text(
                      timerState.getFormattedTime(),
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                '00:00',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w200,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            
            const Spacer(flex: 3),
            
            // Quick timer buttons
            if (timerState.status == TimerStatus.idle) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _TimerButton('1 min', () => ref.read(timerProvider.notifier).start(60)),
                    _TimerButton('5 min', () => ref.read(timerProvider.notifier).start(300)),
                    _TimerButton('10 min', () => ref.read(timerProvider.notifier).start(600)),
                    _TimerButton('15 min', () => ref.read(timerProvider.notifier).start(900)),
                    _TimerButton('30 min', () => ref.read(timerProvider.notifier).start(1800)),
                    _TimerButton('1 hour', () => ref.read(timerProvider.notifier).start(3600)),
                  ],
                ),
              ),
            ],
            
            // Control buttons
            if (timerState.status != TimerStatus.idle) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (timerState.status == TimerStatus.running)
                    _ControlButton(
                      'Pause',
                      Icons.pause,
                      () => ref.read(timerProvider.notifier).pause(),
                    ),
                  if (timerState.status == TimerStatus.paused)
                    _ControlButton(
                      'Resume',
                      Icons.play_arrow,
                      () => ref.read(timerProvider.notifier).resume(),
                    ),
                  const SizedBox(width: 16),
                  _ControlButton(
                    'Reset',
                    Icons.stop,
                    () => ref.read(timerProvider.notifier).reset(),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _TimerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TimerButton(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ControlButton(this.label, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
