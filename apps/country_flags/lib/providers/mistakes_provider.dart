import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the set of ISO codes the user has answered incorrectly.
/// Accumulates from all quiz modes (Multiple Choice, Tricky Flags, Typing, Custom).
/// The Mistakes Quiz always uses Multiple Choice format regardless of origin.
class MistakesNotifier extends Notifier<Set<String>> {
  static const _key = 'mistakes';

  @override
  Set<String> build() {
    _loadFromPrefs();
    return {};
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    state = Set<String>.from(list);
  }

  /// Records a wrong answer. No-op if the ISO code is already in the list.
  Future<void> addMistake(String isoCode) async {
    if (!state.contains(isoCode)) {
      state = {...state, isoCode};
      await _persist();
    }
  }

  /// Removes a correct answer from the mistakes list.
  Future<void> removeMistake(String isoCode) async {
    if (state.contains(isoCode)) {
      state = state.difference({isoCode});
      await _persist();
    }
  }

  /// Clears all mistakes (not currently exposed in UI but useful for testing).
  Future<void> clearAll() async {
    state = {};
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, state.toList());
  }
}

final mistakesProvider = NotifierProvider<MistakesNotifier, Set<String>>(
  MistakesNotifier.new,
);
