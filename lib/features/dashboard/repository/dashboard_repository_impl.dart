import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/utils/date_formatter.dart';
import 'package:fintrack/features/budget/repository/budget_repository.dart';
import 'package:fintrack/features/budget/repository/budget_repository_impl.dart';
import 'package:fintrack/generated/database/app_database.dart';

import '../../transactions/model/transaction_model.dart';
import '../model/chart_data_model.dart';
import '../model/dashboard_summary_model.dart';
import 'dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._db, this._budgets);

  final AppDatabase _db;
  final BudgetRepository _budgets;

  String _monthYear(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}';

  @override
  Future<DashboardSummary> getSummary(DateTime from, DateTime to) async {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateFormatter.endOfDay(to);

    final spentF = _totalSpent(start, end);
    final incomeF = _totalIncome(start, end);
    final byCatF = _spentByCategory(start, end);
    final countF = _countTransactions(start, end);
    final recentF = _recentSnapshots(5);
    final prevF = getPreviousMonthSpent();
    final monthYear = _monthYear(from);
    final budgetMapF = _budgets.limitsByCategory(monthYear);
    final budgetTotalF = _budgets.getTotalBudget(monthYear);

    final results = await Future.wait([
      spentF,
      incomeF,
      byCatF,
      countF,
      recentF,
      prevF,
      budgetMapF,
      budgetTotalF,
    ]);

    final totalSpent = results[0] as double;
    final totalIncome = results[1] as double;
    final spentByCategory = results[2] as Map<int, double>;
    final transactionCount = results[3] as int;
    final recentTransactions = results[4] as List<TransactionModel>;
    final previousMonthSpent = results[5] as double;
    final budgetByCategory = results[6] as Map<int, double>;
    final budgetLimit = results[7] as double;

    final days = to.difference(start).inDays + 1;
    final dailyAverage = days > 0 ? totalSpent / days : 0.0;

    return DashboardSummary(
      totalSpent: totalSpent,
      totalIncome: totalIncome,
      budgetLimit: budgetLimit,
      transactionCount: transactionCount,
      dailyAverage: dailyAverage,
      spentByCategory: spentByCategory,
      budgetByCategory: budgetByCategory,
      recentTransactions: recentTransactions,
      previousMonthSpent: previousMonthSpent,
    );
  }

  @override
  Stream<List<TransactionModel>> watchRecentTransactions(int limit) {
    return (_db.select(_db.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(limit))
        .watch()
        .map((rows) => rows.map(TransactionModel.fromDrift).toList());
  }

  @override
  Future<double> getPreviousMonthSpent() async {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, 1);
    final endPrev = thisMonth.subtract(const Duration(days: 1));
    final startPrev = DateTime(endPrev.year, endPrev.month, 1);
    return _totalSpent(startPrev, DateFormatter.endOfDay(endPrev));
  }

  @override
  Future<List<WeeklyBarData>> getWeeklyBreakdown(DateTime month) async {
    final y = month.year;
    final m = month.month;
    final lastDay = DateTime(y, m + 1, 0).day;
    final ranges = [
      (1, 7),
      (8, 14),
      (15, 21),
      (22, lastDay),
    ];
    final now = DateTime.now();
    var currentBucket = 0;
    if (now.year == y && now.month == m) {
      final d = now.day;
      if (d <= 7) {
        currentBucket = 0;
      } else if (d <= 14) {
        currentBucket = 1;
      } else if (d <= 21) {
        currentBucket = 2;
      } else {
        currentBucket = 3;
      }
    }

    final out = <WeeklyBarData>[];
    for (var i = 0; i < 4; i++) {
      final r = ranges[i];
      final from = DateTime(y, m, r.$1);
      final to = DateTime(y, m, r.$2);
      final amt = await _totalSpent(from, DateFormatter.endOfDay(to));
      out.add(WeeklyBarData(
        weekLabel: 'W${i + 1}',
        amount: amt,
        isCurrentWeek: i == currentBucket,
      ));
    }
    return out;
  }

  Future<double> _totalSpent(DateTime from, DateTime to) async {
    final sum = _db.transactions.amount.sum();
    final q = _db.selectOnly(_db.transactions)
      ..addColumns([sum])
      ..where(
        _db.transactions.date.isBiggerOrEqualValue(from) &
            _db.transactions.date.isSmallerOrEqualValue(to) &
            _db.transactions.amount.isSmallerThanValue(0),
      );
    final row = await q.getSingle();
    final v = row.read(sum) ?? 0;
    return v.abs();
  }

  Future<double> _totalIncome(DateTime from, DateTime to) async {
    final sum = _db.transactions.amount.sum();
    final q = _db.selectOnly(_db.transactions)
      ..addColumns([sum])
      ..where(
        _db.transactions.date.isBiggerOrEqualValue(from) &
            _db.transactions.date.isSmallerOrEqualValue(to) &
            _db.transactions.amount.isBiggerThanValue(0),
      );
    final row = await q.getSingle();
    return row.read(sum) ?? 0;
  }

  Future<Map<int, double>> _spentByCategory(DateTime from, DateTime to) async {
    final rows = await _db.customSelect(
      '''
      SELECT category_id AS cid, SUM(amount) AS total
      FROM transactions
      WHERE amount < 0 AND date >= ? AND date <= ?
      GROUP BY category_id
      ''',
      variables: [Variable<DateTime>(from), Variable<DateTime>(to)],
    ).get();
    final map = <int, double>{};
    for (final row in rows) {
      final id = row.read<int>('cid');
      final total = row.read<num>('total').toDouble();
      map[id] = total.abs();
    }
    return map;
  }

  Future<int> _countTransactions(DateTime from, DateTime to) async {
    final countExp = _db.transactions.id.count();
    final q = _db.selectOnly(_db.transactions)
      ..addColumns([countExp])
      ..where(_db.transactions.date.isBiggerOrEqualValue(from) &
          _db.transactions.date.isSmallerOrEqualValue(to));
    final row = await q.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<List<TransactionModel>> _recentSnapshots(int limit) async {
    final rows = await (_db.select(_db.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(limit))
        .get();
    return rows.map(TransactionModel.fromDrift).toList();
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  ref.watch(budgetRepositoryProvider);
  return DashboardRepositoryImpl(
    ref.watch(appDatabaseProvider),
    ref.watch(budgetRepositoryProvider),
  );
});
