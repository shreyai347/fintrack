import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/database/app_database.dart';
import 'core/services/storage/preferences_service.dart';
import 'core/services/work/work_manager_registration.dart';
import 'fintrack_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final preferencesService = PreferencesService(prefs);

  try {
    await registerWorkManagerTasks();
  } catch (e) {
    debugPrint('WorkManager registration failed: $e');
  }

  final db = await openFintrackDatabase();

  runApp(
    ProviderScope(
      overrides: [
        preferencesServiceProvider.overrideWithValue(preferencesService),
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const FintrackApp(),
    ),
  );
}
