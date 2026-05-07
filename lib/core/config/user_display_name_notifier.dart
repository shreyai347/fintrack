import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/services/storage/preferences_service.dart';

final userDisplayNameNotifierProvider =
    NotifierProvider<UserDisplayNameNotifier, String>(
  UserDisplayNameNotifier.new,
);

class UserDisplayNameNotifier extends Notifier<String> {
  @override
  String build() {
    return ref.read(preferencesServiceProvider).getUserDisplayName();
  }

  Future<void> setName(String raw) async {
    final name = raw.trim();
    await ref.read(preferencesServiceProvider).setUserDisplayName(name);
    state = name;
  }
}
