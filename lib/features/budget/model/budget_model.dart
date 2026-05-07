import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import 'package:fintrack/generated/database/app_database.dart';

class BudgetModel {
  const BudgetModel({
    required this.id,
    required this.categoryId,
    required this.monthYear,
    required this.limitAmount,
    required this.spentAmount,
    required this.createdAt,
  });

  final int id;
  final int categoryId;
  final String monthYear;
  final double limitAmount;
  final double spentAmount;
  final DateTime createdAt;

  double get usedPercent =>
      limitAmount <= 0 ? 0 : (spentAmount / limitAmount).clamp(0.0, double.infinity);

  bool get isOverWarning => usedPercent >= 0.60;

  bool get isCritical => usedPercent >= 0.85;

  bool get isOverBudget => spentAmount > limitAmount;

  double get remaining => limitAmount - spentAmount;

  String get monthYearDisplay {
    final p = monthYear.split('-');
    if (p.length != 2) return monthYear;
    final y = int.tryParse(p[0]);
    final m = int.tryParse(p[1]);
    if (y == null || m == null) return monthYear;
    return DateFormat.yMMMM('en').format(DateTime(y, m, 1));
  }

  factory BudgetModel.fromDrift(Budget row, double spentAmount) {
    return BudgetModel(
      id: row.id,
      categoryId: row.categoryId,
      monthYear: row.monthYear,
      limitAmount: row.limitAmount,
      spentAmount: spentAmount,
      createdAt: row.createdAt,
    );
  }

  BudgetsCompanion toCompanion({bool includeId = false}) {
    return BudgetsCompanion(
      id: includeId ? Value(id) : const Value.absent(),
      categoryId: Value(categoryId),
      monthYear: Value(monthYear),
      limitAmount: Value(limitAmount),
      createdAt: Value(createdAt),
    );
  }
}
