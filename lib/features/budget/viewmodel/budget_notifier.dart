import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/generated/database/app_database.dart';

import '../model/budget_model.dart';
import '../repository/budget_repository_impl.dart';
import 'budget_state.dart';

class BudgetNotifier extends Notifier<BudgetState> {
  StreamSubscription<List<BudgetModel>>? _sub;
  String? _monthYear;

  static String formatMonthYear(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}';

  @override
  BudgetState build() {
    _monthYear = normalizeBudgetMonthYear(
      _monthYear ?? formatMonthYear(DateTime.now()),
    );
    ref.onDispose(() => _sub?.cancel());
    _attachStream();
    return const BudgetLoading();
  }

  void _attachStream() {
    final my = _monthYear!;
    _sub?.cancel();
    unawaited(_bind(my));
  }

  Future<void> _bind(String monthYear) async {
    await ref.read(budgetRepositoryProvider).ensureMonthSeeded(monthYear);
    _sub = ref.read(budgetRepositoryProvider).watchByMonth(monthYear).listen(
          (budgets) {
            final totalBudget =
                budgets.fold<double>(0, (a, b) => a + b.limitAmount);
            final totalSpent =
                budgets.fold<double>(0, (a, b) => a + b.spentAmount);
            state = BudgetLoaded(
              budgets: budgets,
              totalBudget: totalBudget,
              totalSpent: totalSpent,
              monthYear: monthYear,
            );
          },
          onError: (Object e, StackTrace stackTrace) {
            state = BudgetError('$e');
          },
        );
  }

  Future<void> changeMonth(String monthYear) async {
    _monthYear = normalizeBudgetMonthYear(monthYear);
    state = const BudgetLoading();
    _attachStream();
  }

  Future<void> updateLimit(int categoryId, double newLimit) async {
    final my = normalizeBudgetMonthYear(
      _monthYear ?? formatMonthYear(DateTime.now()),
    );
    await ref.read(budgetRepositoryProvider).upsert(
          BudgetsCompanion.insert(
            categoryId: categoryId,
            monthYear: my,
            limitAmount: newLimit,
          ),
        );
  }

  Future<void> refresh() async {
    try {
      final my = normalizeBudgetMonthYear(
        _monthYear ?? formatMonthYear(DateTime.now()),
      );
      await ref.read(budgetRepositoryProvider).ensureMonthSeeded(my);
      final list =
          await ref.read(budgetRepositoryProvider).snapshotForMonth(my);
      final totalBudget =
          list.fold<double>(0, (a, b) => a + b.limitAmount);
      final totalSpent =
          list.fold<double>(0, (a, b) => a + b.spentAmount);
      state = BudgetLoaded(
        budgets: list,
        totalBudget: totalBudget,
        totalSpent: totalSpent,
        monthYear: my,
      );
    } catch (e) {
      state = BudgetError('$e');
    }
  }
}
