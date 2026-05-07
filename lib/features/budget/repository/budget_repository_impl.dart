import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/utils/date_formatter.dart';
import 'package:fintrack/generated/database/app_database.dart';

import '../model/budget_model.dart';
import 'budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> ensureMonthSeeded(String monthYear) async {
    final countExp = _db.budgets.id.count();
    final q = _db.selectOnly(_db.budgets)
      ..addColumns([countExp])
      ..where(_db.budgets.monthYear.equals(monthYear));
    final row = await q.getSingle();
    if ((row.read(countExp) ?? 0) > 0) return;
    final cats = await _db.select(_db.categories).get();
    await _db.batch((b) {
      for (final c in cats) {
        b.insert(
          _db.budgets,
          BudgetsCompanion.insert(
            categoryId: c.id,
            monthYear: monthYear,
            limitAmount: 0,
          ),
        );
      }
    });
  }

  (DateTime, DateTime) _monthBounds(String monthYear) {
    final p = monthYear.split('-');
    final y = int.parse(p[0]);
    final m = int.parse(p[1]);
    final from = DateTime(y, m, 1);
    final end = DateTime(y, m + 1, 0);
    return (from, DateFormatter.endOfDay(end));
  }

  Future<Map<int, double>> _spentByCategoryForMonth(String monthYear) async {
    final range = _monthBounds(monthYear);
    final rows = await _db.customSelect(
      '''
      SELECT category_id AS cid, SUM(amount) AS total
      FROM transactions
      WHERE amount < 0 AND date >= ? AND date <= ?
      GROUP BY category_id
      ''',
      variables: [Variable<DateTime>(range.$1), Variable<DateTime>(range.$2)],
    ).get();
    final map = <int, double>{};
    for (final row in rows) {
      final id = row.read<int>('cid');
      final total = row.read<num>('total').toDouble();
      map[id] = total.abs();
    }
    return map;
  }

  Future<List<BudgetModel>> _mapRows(
    List<Budget> rows,
    String monthYear,
  ) async {
    final spent = await _spentByCategoryForMonth(monthYear);
    return [
      for (final r in rows)
        BudgetModel.fromDrift(r, spent[r.categoryId] ?? 0),
    ]..sort((a, b) => b.spentAmount.compareTo(a.spentAmount));
  }

  @override
  Future<List<BudgetModel>> snapshotForMonth(String monthYear) async {
    final rows = await (_db.select(_db.budgets)
          ..where((b) => b.monthYear.equals(monthYear)))
        .get();
    return _mapRows(rows, monthYear);
  }

  @override
  Stream<List<BudgetModel>> watchByMonth(String monthYear) {
    return Stream<List<BudgetModel>>.multi((controller) {
      Future<void> emit() async {
        try {
          controller.add(await snapshotForMonth(monthYear));
        } catch (e, st) {
          controller.addError(e, st);
        }
      }

      final subB = (_db.select(_db.budgets)
            ..where((b) => b.monthYear.equals(monthYear)))
          .watch()
          .listen((_) => emit());

      final subT = _db.select(_db.transactions).watch().listen((_) => emit());

      emit();

      controller.onCancel = () {
        subB.cancel();
        subT.cancel();
      };
    });
  }

  @override
  Future<Map<int, double>> limitsByCategory(String monthYear) async {
    final rows = await (_db.select(_db.budgets)
          ..where((b) => b.monthYear.equals(monthYear)))
        .get();
    return {for (final r in rows) r.categoryId: r.limitAmount};
  }

  @override
  Future<BudgetModel?> getByCategory(int categoryId, String monthYear) async {
    final row = await (_db.select(_db.budgets)
          ..where(
            (b) =>
                b.categoryId.equals(categoryId) &
                b.monthYear.equals(monthYear),
          ))
        .getSingleOrNull();
    if (row == null) return null;
    final spent = await _spentByCategoryForMonth(monthYear);
    return BudgetModel.fromDrift(row, spent[categoryId] ?? 0);
  }

  @override
  Future<int> upsert(BudgetsCompanion companion) async {
    if (!companion.categoryId.present ||
        !companion.monthYear.present ||
        !companion.limitAmount.present) {
      throw ArgumentError('categoryId, monthYear, limitAmount required');
    }
    final cid = companion.categoryId.value;
    final my = companion.monthYear.value;
    final lim = companion.limitAmount.value;
    await _db.into(_db.budgets).insert(
          BudgetsCompanion.insert(
            categoryId: cid,
            monthYear: my,
            limitAmount: lim,
          ),
          mode: InsertMode.insertOrReplace,
        );
    final row = await (_db.select(_db.budgets)
          ..where((b) => b.categoryId.equals(cid) & b.monthYear.equals(my)))
        .getSingle();
    return row.id;
  }

  @override
  Future<bool> update(BudgetsCompanion companion) async {
    if (!companion.id.present) return false;
    final id = companion.id.value;
    final n = await (_db.update(_db.budgets)..where((b) => b.id.equals(id)))
        .write(companion);
    return n > 0;
  }

  @override
  Future<void> clearAllBudgetsAndReseedCurrentMonth() async {
    await _db.delete(_db.budgets).go();
    final n = DateTime.now();
    final my = '${n.year}-${n.month.toString().padLeft(2, '0')}';
    await ensureMonthSeeded(my);
  }

  @override
  Future<double> getTotalBudget(String monthYear) async {
    final sum = _db.budgets.limitAmount.sum();
    final q = _db.selectOnly(_db.budgets)
      ..addColumns([sum])
      ..where(_db.budgets.monthYear.equals(monthYear));
    final row = await q.getSingle();
    return row.read(sum) ?? 0;
  }
}

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(ref.watch(appDatabaseProvider));
});
