import 'package:workmanager/workmanager.dart';

import 'package:fintrack/generated/database/app_database.dart';
import 'package:fintrack/core/services/work/recurring_transaction_worker.dart';

const String recurringTransactionTaskName = 'recurring_transaction_task';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == recurringTransactionTaskName) {
      final db = await openFintrackDatabase();
      try {
        await RecurringTransactionWorker().processRecurringTransactions(db);
      } finally {
        await db.close();
      }
    }
    return Future<bool>.value(true);
  });
}

Future<void> registerWorkManagerTasks() async {
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    '1',
    recurringTransactionTaskName,
    frequency: const Duration(hours: 24),
    constraints: Constraints(
      networkType: NetworkType.notRequired,
    ),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}
