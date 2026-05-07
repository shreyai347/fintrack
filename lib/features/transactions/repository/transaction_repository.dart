import 'package:fintrack/generated/database/app_database.dart';

import '../model/transaction_model.dart';

abstract class TransactionRepository {
  Stream<List<TransactionModel>> watchAll();

  Future<List<TransactionModel>> getAll();

  Stream<List<TransactionModel>> watchByDateRange(DateTime from, DateTime to);

  Future<TransactionModel?> getById(int id);

  Future<int> add(TransactionsCompanion companion);

  /// Inserts a recurring rule row (used before [add] when the user picks a schedule).
  Future<int> addRecurringRule(RecurringRulesCompanion companion);

  Future<bool> update(TransactionsCompanion companion);

  Future<int> delete(int id);

  Future<int> countTransactionsBetween(DateTime from, DateTime to);

  Future<double> getTotalSpent(DateTime from, DateTime to);

  Future<double> getTotalIncome(DateTime from, DateTime to);

  Future<Map<int, double>> getSpentByCategory(DateTime from, DateTime to);

  Future<void> deleteAllTransactionsAndRecurringRules();
}
