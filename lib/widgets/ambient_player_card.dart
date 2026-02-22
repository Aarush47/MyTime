// MUSIC & AMBIENT SOUND AGENT - UX + Media
// Ambient player card with minimal controls

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/music_provider.dart';

class AmbientPlayerCard extends ConsumerWidget {
  const AmbientPlayerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicState = ref.watch(musicProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.nightlight_round,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'AMBIENT SOUNDS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (musicState.currentTrack != null) ...[
            // Currently playing track
            Row(
              children: [
                Text(
                  musicState.currentTrack!.icon,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        musicState.currentTrack!.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        musicState.isPlaying ? 'Playing' : 'Paused',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    musicState.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    size: 40,
                  ),
                  color: const Color(0xFFFF9F0A),
                  onPressed: () {
                    ref.read(musicProvider.notifier).togglePlayPause();
                  },
                ),
              ],
            ),
          ] else ...[
            // Track selection
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: MusicNotifier.availableTracks.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final track = MusicNotifier.availableTracks[index];
                  return _AmbientTrackButton(
                    track: track,
                    onTap: () {
                      ref.read(musicProvider.notifier).play(track);
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AmbientTrackButton extends StatelessWidget {
  final AudioTrack track;
  final VoidCallback onTap;

  const _AmbientTrackButton({
    required this.track,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              track.icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              track.name,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
