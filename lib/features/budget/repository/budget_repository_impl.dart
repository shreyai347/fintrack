import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/utils/date_formatter.dart';
import 'package:fintrack/generated/database/app_database.dart';

import '../model/budget_model.dart';
import 'budget_repository.dart';

/// Canonical `YYYY-MM` (month always two digits) for stable queries and keys.
String normalizeBudgetMonthYear(String raw) {
  final parts = raw.trim().split('-');
  if (parts.length != 2) return raw;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (y == null || m == null || m < 1 || m > 12) return raw;
  return '$y-${m.toString().padLeft(2, '0')}';
}

class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._db);

  final AppDatabase _db;

  /// Income category: not shown in budget UI and excluded from budget totals.
  Future<Set<int>> _salaryCategoryIds() async {
    final rows = await (_db.select(_db.categories)
          ..where((c) => c.name.equals('Salary')))
        .get();
    return {for (final r in rows) r.id};
  }

  @override
  Future<void> ensureMonthSeeded(String monthYear) async {
    final my = normalizeBudgetMonthYear(monthYear);
    final countExp = _db.budgets.id.count();
    final q = _db.selectOnly(_db.budgets)
      ..addColumns([countExp])
      ..where(_db.budgets.monthYear.equals(my));
    final row = await q.getSingle();
    if ((row.read(countExp) ?? 0) > 0) return;
    final cats = await _db.select(_db.categories).get();
    await _db.batch((b) {
      for (final c in cats) {
        if (c.name == 'Salary') continue;
        b.insert(
          _db.budgets,
          BudgetsCompanion.insert(
            categoryId: c.id,
            monthYear: my,
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
    final my = normalizeBudgetMonthYear(monthYear);
    final range = _monthBounds(my);
    final rows = await _db.customSelect(
      '''
      SELECT category_id AS cid, CAST(SUM(amount) AS REAL) AS total
      FROM transactions
      WHERE amount < 0 AND date >= ? AND date <= ?
      GROUP BY category_id
      ''',
      variables: [Variable<DateTime>(range.$1), Variable<DateTime>(range.$2)],
    ).get();
    final map = <int, double>{};
    for (final row in rows) {
      final id = row.read<int>('cid');
      final total = row.read<double>('total');
      map[id] = total.abs();
    }
    return map;
  }

  Future<List<BudgetModel>> _mapRows(
    List<Budget> rows,
    String monthYear,
  ) async {
    final spent = await _spentByCategoryForMonth(monthYear);
    final skip = await _salaryCategoryIds();
    return [
      for (final r in rows)
        if (!skip.contains(r.categoryId))
          BudgetModel.fromDrift(r, spent[r.categoryId] ?? 0),
    ]..sort((a, b) => b.spentAmount.compareTo(a.spentAmount));
  }

  @override
  Future<List<BudgetModel>> snapshotForMonth(String monthYear) async {
    final my = normalizeBudgetMonthYear(monthYear);
    final rows = await (_db.select(_db.budgets)
          ..where((b) => b.monthYear.equals(my)))
        .get();
    return _mapRows(rows, my);
  }

  @override
  Stream<List<BudgetModel>> watchByMonth(String monthYear) {
    final my = normalizeBudgetMonthYear(monthYear);
    return Stream<List<BudgetModel>>.multi((controller) {
      var emitGeneration = 0;

      Future<void> emit() async {
        final gen = ++emitGeneration;
        try {
          final snap = await snapshotForMonth(my);
          if (gen != emitGeneration || controller.isClosed) return;
          controller.add(snap);
        } catch (e, st) {
          if (!controller.isClosed) controller.addError(e, st);
        }
      }

      final subB = (_db.select(_db.budgets)
            ..where((b) => b.monthYear.equals(my)))
          .watch()
          .listen((_) => emit());

      final subT = _db.select(_db.transactions).watch().listen((_) => emit());

      scheduleMicrotask(emit);

      controller.onCancel = () {
        subB.cancel();
        subT.cancel();
      };
    });
  }

  @override
  Future<Map<int, double>> limitsByCategory(String monthYear) async {
    final my = normalizeBudgetMonthYear(monthYear);
    final skip = await _salaryCategoryIds();
    final rows = await (_db.select(_db.budgets)
          ..where((b) => b.monthYear.equals(my)))
        .get();
    return {
      for (final r in rows)
        if (!skip.contains(r.categoryId)) r.categoryId: r.limitAmount,
    };
  }

  @override
  Future<BudgetModel?> getByCategory(int categoryId, String monthYear) async {
    final my = normalizeBudgetMonthYear(monthYear);
    final row = await (_db.select(_db.budgets)
          ..where(
            (b) =>
                b.categoryId.equals(categoryId) &
                b.monthYear.equals(my),
          ))
        .getSingleOrNull();
    if (row == null) return null;
    final spent = await _spentByCategoryForMonth(my);
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
    final my = normalizeBudgetMonthYear(companion.monthYear.value);
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
    final my = normalizeBudgetMonthYear(monthYear);
    final skip = await _salaryCategoryIds();
    final rows = await (_db.select(_db.budgets)
          ..where((b) => b.monthYear.equals(my)))
        .get();
    var total = 0.0;
    for (final r in rows) {
      if (skip.contains(r.categoryId)) continue;
      total += r.limitAmount;
    }
    return total;
  }
}

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(ref.watch(appDatabaseProvider));
});
