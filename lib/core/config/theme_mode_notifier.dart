import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage/preferences_service.dart';

final themeModeNotifierProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return _fromRaw(ref.read(preferencesServiceProvider).getThemeMode());
  }

  Future<void> setThemeModePreference(String mode) async {
    await ref.read(preferencesServiceProvider).setThemeMode(mode);
    state = _fromRaw(mode);
  }

  ThemeMode _fromRaw(String raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
