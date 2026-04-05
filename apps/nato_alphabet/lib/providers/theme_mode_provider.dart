import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeModeKey = 'theme_mode';

/// Provides the SharedPreferences instance.
/// Overridden at startup in main.dart after awaiting SharedPreferences.getInstance().
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider not overridden'),
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final index = prefs.getInt(_kThemeModeKey) ?? ThemeMode.system.index;
    return ThemeMode.values[index];
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    ref.read(sharedPreferencesProvider).setInt(_kThemeModeKey, mode.index);
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
