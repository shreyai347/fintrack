import 'package:fintrack/generated/database/app_database.dart';

import '../model/budget_model.dart';

abstract class BudgetRepository {
  Stream<List<BudgetModel>> watchByMonth(String monthYear);

  Future<List<BudgetModel>> snapshotForMonth(String monthYear);

  Future<Map<int, double>> limitsByCategory(String monthYear);

  Future<BudgetModel?> getByCategory(int categoryId, String monthYear);

  Future<int> upsert(BudgetsCompanion companion);

  Future<bool> update(BudgetsCompanion companion);

  Future<double> getTotalBudget(String monthYear);

  Future<void> ensureMonthSeeded(String monthYear);

  Future<void> clearAllBudgetsAndReseedCurrentMonth();
}
