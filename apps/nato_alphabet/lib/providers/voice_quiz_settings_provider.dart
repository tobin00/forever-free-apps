import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_mode_provider.dart';

const _kVoiceQuizEnabledKey = 'voice_quiz_enabled';

class VoiceQuizSettingsNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(_kVoiceQuizEnabledKey) ?? false;
  }

  void setEnabled(bool enabled) {
    state = enabled;
    ref.read(sharedPreferencesProvider).setBool(_kVoiceQuizEnabledKey, enabled);
  }
}

final voiceQuizEnabledProvider =
    NotifierProvider<VoiceQuizSettingsNotifier, bool>(VoiceQuizSettingsNotifier.new);
