import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/services/storage/preferences_service.dart';

final localeNotifierProvider =
    NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final code = ref.read(preferencesServiceProvider).getLanguageCode();
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  Future<void> setLanguageCode(String code) async {
    await ref.read(preferencesServiceProvider).setLanguageCode(code);
    state = Locale(code);
  }
}
