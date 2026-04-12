import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../data/nato_alphabet.dart';

enum VoiceQuizStatus {
  /// STT not yet initialized (first load after enabling).
  initializing,

  /// Ready — waiting for user to tap the mic button.
  idle,

  /// Mic is active, listening for speech.
  listening,

  /// Recognised word matched the expected NATO word.
  correct,

  /// Recognised word did not match.
  incorrect,

  /// Listening ended with no recognisable speech.
  noSpeech,

  /// Microphone permission was denied.
  permissionDenied,
}

class VoiceQuizState {
  final List<String> shuffledLetters;
  final int currentIndex;
  final VoiceQuizStatus status;

  /// The word(s) the recogniser heard — shown on incorrect / correct feedback.
  final String? heardWord;

  const VoiceQuizState({
    required this.shuffledLetters,
    required this.currentIndex,
    required this.status,
    this.heardWord,
  });

  bool get isComplete => currentIndex >= shuffledLetters.length;
  String? get currentLetter => isComplete ? null : shuffledLetters[currentIndex];
  String? get currentNatoWord =>
      currentLetter == null ? null : NatoData.lookup[currentLetter];

  /// 1-based progress counter.
  int get progress => min(currentIndex + 1, shuffledLetters.length);
  int get total => shuffledLetters.length;

  VoiceQuizState copyWith({
    List<String>? shuffledLetters,
    int? currentIndex,
    VoiceQuizStatus? status,
    String? heardWord,
    bool clearHeardWord = false,
  }) {
    return VoiceQuizState(
      shuffledLetters: shuffledLetters ?? this.shuffledLetters,
      currentIndex: currentIndex ?? this.currentIndex,
      status: status ?? this.status,
      heardWord: clearHeardWord ? null : (heardWord ?? this.heardWord),
    );
  }

  static VoiceQuizState initial() {
    final letters = NatoData.entries.map((e) => e.letter).toList()..shuffle(Random());
    return VoiceQuizState(
      shuffledLetters: letters,
      currentIndex: 0,
      status: VoiceQuizStatus.initializing,
    );
  }
}

// ---------------------------------------------------------------------------
// Recognised-word aliases.
// Speech engines often return common English spellings instead of the official
// NATO spellings (e.g. "alpha" for "alfa", "juliet" for "juliett").
// ---------------------------------------------------------------------------
const _aliases = <String, List<String>>{
  'A': ['alfa', 'alpha'],
  'C': ['charlie', 'charley'],
  'J': ['juliett', 'juliet'],
  'X': ['x-ray', 'x ray', 'xray', 'ex-ray', 'ex ray'],
};

bool _isMatch(String letter, String heard) {
  final expected = NatoData.lookup[letter]?.toLowerCase() ?? '';
  if (heard == expected) return true;
  final alts = _aliases[letter];
  return alts != null && alts.contains(heard);
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class VoiceQuizNotifier extends Notifier<VoiceQuizState> {
  final _speech = SpeechToText();

  @override
  VoiceQuizState build() {
    ref.onDispose(() {
      _speech.cancel();
    });
    // Kick off async init without blocking build().
    Future.microtask(_init);
    return VoiceQuizState.initial();
  }

  // -------------------------------------------------------------------------
  // Initialisation
  // -------------------------------------------------------------------------

  Future<void> _init() async {
    try {
      final available = await _speech.initialize(
        onError: _onError,
        onStatus: _onStatus,
      );
      if (!available) {
        state = state.copyWith(status: VoiceQuizStatus.permissionDenied);
      } else {
        state = state.copyWith(status: VoiceQuizStatus.idle);
      }
    } catch (_) {
      // Platform channel not available (e.g. in unit tests).
      state = state.copyWith(status: VoiceQuizStatus.permissionDenied);
    }
  }

  // -------------------------------------------------------------------------
  // Public API
  // -------------------------------------------------------------------------

  Future<void> startListening() async {
    if (state.status == VoiceQuizStatus.listening) return;
    if (state.isComplete) return;

    state = state.copyWith(status: VoiceQuizStatus.listening, clearHeardWord: true);

    await _speech.listen(
      onResult: _onResult,
      listenFor: const Duration(seconds: 6),
      pauseFor: const Duration(seconds: 2),
      partialResults: false,
      cancelOnError: true,
      onDevice: true, // use on-device recognition when available (privacy)
    );
  }

  Future<void> cancelListening() async {
    await _speech.cancel();
    if (state.status == VoiceQuizStatus.listening) {
      state = state.copyWith(status: VoiceQuizStatus.idle, clearHeardWord: true);
    }
  }

  void next() {
    if (state.isComplete) return;
    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      status: VoiceQuizStatus.idle,
      clearHeardWord: true,
    );
  }

  void restart() {
    final letters = NatoData.entries.map((e) => e.letter).toList()..shuffle(Random());
    state = VoiceQuizState(
      shuffledLetters: letters,
      currentIndex: 0,
      status: VoiceQuizStatus.idle,
      heardWord: null,
    );
  }

  // -------------------------------------------------------------------------
  // STT callbacks
  // -------------------------------------------------------------------------

  void _onResult(SpeechRecognitionResult result) {
    if (!result.finalResult) return;

    final heard = result.recognizedWords.toLowerCase().trim();

    if (heard.isEmpty) {
      state = state.copyWith(status: VoiceQuizStatus.noSpeech, clearHeardWord: true);
      return;
    }

    final letter = state.currentLetter;
    if (letter == null) return;

    if (_isMatch(letter, heard)) {
      state = state.copyWith(status: VoiceQuizStatus.correct, heardWord: heard);
    } else {
      state = state.copyWith(status: VoiceQuizStatus.incorrect, heardWord: heard);
    }
  }

  void _onStatus(String status) {
    // When the engine finishes without calling onResult (e.g. silence timeout),
    // treat it as no speech detected.
    if (status == 'done' && state.status == VoiceQuizStatus.listening) {
      state = state.copyWith(status: VoiceQuizStatus.noSpeech, clearHeardWord: true);
    }
  }

  void _onError(dynamic error) {
    if (state.status == VoiceQuizStatus.listening) {
      state = state.copyWith(status: VoiceQuizStatus.noSpeech, clearHeardWord: true);
    }
  }
}

final voiceQuizProvider =
    NotifierProvider<VoiceQuizNotifier, VoiceQuizState>(VoiceQuizNotifier.new);
