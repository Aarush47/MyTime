// UI & LAYOUT AGENT - Visual/UI Expert
// Main StandBy clock screen with Apple-inspired design

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/clock_provider.dart';
import '../widgets/clock_widget.dart';
import '../widgets/date_widget.dart';
import '../widgets/quick_actions.dart';
import '../widgets/ambient_player_card.dart';

class StandByScreen extends ConsumerWidget {
  const StandByScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.grey.shade900.withOpacity(0.3),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date at top
                const DateWidget(),
                
                const Spacer(flex: 2),
                
                // Main clock display (centered)
                const Center(
                  child: ClockWidget(),
                ),
                
                const Spacer(flex: 3),
                
                // Ambient player card
                const AmbientPlayerCard(),
                
                const SizedBox(height: 20),
                
                // Quick actions at bottom
                const QuickActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
