// MUSIC & AMBIENT SOUND AGENT - UX + Media
// Handles ambient sound playback with minimal controls

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Audio track model
class AudioTrack {
  final String id;
  final String name;
  final String assetPath;
  final String icon;

  const AudioTrack({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.icon,
  });
}

/// Music state
enum PlaybackState { stopped, playing, paused }

class MusicState {
  final AudioTrack? currentTrack;
  final PlaybackState playbackState;
  final double volume;

  MusicState({
    this.currentTrack,
    this.playbackState = PlaybackState.stopped,
    this.volume = 0.5,
  });

  MusicState copyWith({
    AudioTrack? currentTrack,
    PlaybackState? playbackState,
    double? volume,
  }) {
    return MusicState(
      currentTrack: currentTrack ?? this.currentTrack,
      playbackState: playbackState ?? this.playbackState,
      volume: volume ?? this.volume,
    );
  }

  bool get isPlaying => playbackState == PlaybackState.playing;
  bool get isPaused => playbackState == PlaybackState.paused;
  bool get isStopped => playbackState == PlaybackState.stopped;
}

/// Music notifier
class MusicNotifier extends StateNotifier<MusicState> {
  MusicNotifier() : super(MusicState());

  /// Available ambient tracks
  static const List<AudioTrack> availableTracks = [
    AudioTrack(
      id: 'rain',
      name: 'Rain',
      assetPath: 'assets/sounds/rain.mp3',
      icon: '🌧️',
    ),
    AudioTrack(
      id: 'ocean',
      name: 'Ocean Waves',
      assetPath: 'assets/sounds/ocean.mp3',
      icon: '🌊',
    ),
    AudioTrack(
      id: 'forest',
      name: 'Forest',
      assetPath: 'assets/sounds/forest.mp3',
      icon: '🌲',
    ),
    AudioTrack(
      id: 'whitenoise',
      name: 'White Noise',
      assetPath: 'assets/sounds/whitenoise.mp3',
      icon: '📻',
    ),
    AudioTrack(
      id: 'fireplace',
      name: 'Fireplace',
      assetPath: 'assets/sounds/fireplace.mp3',
      icon: '🔥',
    ),
  ];

  /// Play a track
  void play(AudioTrack track) {
    state = state.copyWith(
      currentTrack: track,
      playbackState: PlaybackState.playing,
    );
    // TODO: Implement actual audio playback with audioplayers package
  }

  /// Pause playback
  void pause() {
    if (state.isPlaying) {
      state = state.copyWith(playbackState: PlaybackState.paused);
      // TODO: Pause audio player
    }
  }

  /// Resume playback
  void resume() {
    if (state.isPaused) {
      state = state.copyWith(playbackState: PlaybackState.playing);
      // TODO: Resume audio player
    }
  }

  /// Stop playback
  void stop() {
    state = state.copyWith(
      playbackState: PlaybackState.stopped,
      currentTrack: null,
    );
    // TODO: Stop and dispose audio player
  }

  /// Toggle play/pause
  void togglePlayPause() {
    if (state.isPlaying) {
      pause();
    } else if (state.isPaused) {
      resume();
    }
  }

  /// Set volume (0.0 to 1.0)
  void setVolume(double volume) {
    state = state.copyWith(volume: volume.clamp(0.0, 1.0));
    // TODO: Update audio player volume
  }
}

/// Provider
final musicProvider = StateNotifierProvider<MusicNotifier, MusicState>((ref) {
  return MusicNotifier();
});
