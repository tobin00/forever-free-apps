import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks which NATO word is currently playing (null = nothing playing).
/// Manages a single shared AudioPlayer so only one clip plays at a time.
class AudioNotifier extends Notifier<String?> {
  late final AudioPlayer _player;

  @override
  String? build() {
    _player = AudioPlayer();
    ref.onDispose(_player.dispose);
    _player.onPlayerComplete.listen((_) => state = null);
    return null;
  }

  /// Play the audio for [word], or stop it if it's already playing.
  Future<void> toggle(String word) async {
    if (state == word) {
      await _player.stop();
      state = null;
    } else {
      await _player.stop();
      state = word;
      // AssetSource path is relative to the assets/ directory in pubspec
      final assetPath = 'audio/${word.toLowerCase()}.wav';
      await _player.play(AssetSource(assetPath));
    }
  }

  Future<void> stop() async {
    await _player.stop();
    state = null;
  }
}

final audioProvider =
    NotifierProvider<AudioNotifier, String?>(AudioNotifier.new);
