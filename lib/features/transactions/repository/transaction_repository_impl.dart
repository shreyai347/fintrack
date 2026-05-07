import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/utils/date_formatter.dart';
import 'package:fintrack/generated/database/app_database.dart';

import '../model/transaction_model.dart';
import 'transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<TransactionModel>> watchAll() {
    return (_db.select(_db.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch()
        .map((rows) => rows.map(TransactionModel.fromDrift).toList());
  }

  @override
  Future<List<TransactionModel>> getAll() async {
    final rows = await (_db.select(_db.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
    return rows.map(TransactionModel.fromDrift).toList();
  }

  @override
  Stream<List<TransactionModel>> watchByDateRange(DateTime from, DateTime to) {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateFormatter.endOfDay(to);
    return (_db.select(_db.transactions)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch()
        .map((rows) => rows.map(TransactionModel.fromDrift).toList());
  }

  @override
  Future<TransactionModel?> getById(int id) async {
    final row = await (_db.select(_db.transactions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : TransactionModel.fromDrift(row);
  }

  @override
  Future<int> add(TransactionsCompanion companion) async {
    return _db.transaction(() async {
      return _db.into(_db.transactions).insert(companion);
    });
  }

  @override
  Future<int> addRecurringRule(RecurringRulesCompanion companion) async {
    return _db.transaction(() async {
      return _db.into(_db.recurringRules).insert(companion);
    });
  }

  @override
  Future<bool> update(TransactionsCompanion companion) async {
    final id = companion.id.present ? companion.id.value : null;
    if (id == null) return false;
    return _db.transaction(() async {
      final n = await (_db.update(_db.transactions)
            ..where((t) => t.id.equals(id)))
          .write(companion);
      return n > 0;
    });
  }

  @override
  Future<int> delete(int id) async {
    return _db.transaction(() async {
      return (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
    });
  }

  @override
  Future<int> countTransactionsBetween(DateTime from, DateTime to) async {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateFormatter.endOfDay(to);
    final countExp = _db.transactions.id.count();
    final q = _db.selectOnly(_db.transactions)
      ..addColumns([countExp])
      ..where(_db.transactions.date.isBiggerOrEqualValue(start) &
          _db.transactions.date.isSmallerOrEqualValue(end));
    final row = await q.getSingle();
    return row.read(countExp) ?? 0;
  }

  @override
  Future<double> getTotalSpent(DateTime from, DateTime to) async {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateFormatter.endOfDay(to);
    final sum = _db.transactions.amount.sum();
    final q = _db.selectOnly(_db.transactions)
      ..addColumns([sum])
      ..where(
        _db.transactions.date.isBiggerOrEqualValue(start) &
            _db.transactions.date.isSmallerOrEqualValue(end) &
            _db.transactions.amount.isSmallerThanValue(0),
      );
    final row = await q.getSingle();
    final v = row.read(sum) ?? 0;
    return v.abs();
  }

  @override
  Future<double> getTotalIncome(DateTime from, DateTime to) async {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateFormatter.endOfDay(to);
    final sum = _db.transactions.amount.sum();
    final q = _db.selectOnly(_db.transactions)
      ..addColumns([sum])
      ..where(
        _db.transactions.date.isBiggerOrEqualValue(start) &
            _db.transactions.date.isSmallerOrEqualValue(end) &
            _db.transactions.amount.isBiggerThanValue(0),
      );
    final row = await q.getSingle();
    return row.read(sum) ?? 0;
  }

  @override
  Future<void> deleteAllTransactionsAndRecurringRules() async {
    await _db.transaction(() async {
      await _db.delete(_db.transactions).go();
      await _db.delete(_db.recurringRules).go();
    });
  }

  @override
  Future<Map<int, double>> getSpentByCategory(DateTime from, DateTime to) async {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateFormatter.endOfDay(to);
    final rows = await _db.customSelect(
      '''
      SELECT category_id AS cid, SUM(amount) AS total
      FROM transactions
      WHERE amount < 0 AND date >= ? AND date <= ?
      GROUP BY category_id
      ''',
      variables: [
        Variable<DateTime>(start),
        Variable<DateTime>(end),
      ],
    ).get();
    final map = <int, double>{};
    for (final row in rows) {
      final id = row.read<int>('cid');
      final total = row.read<num>('total').toDouble();
      map[id] = total.abs();
    }
    return map;
  }
}

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(ref.watch(appDatabaseProvider));
});
