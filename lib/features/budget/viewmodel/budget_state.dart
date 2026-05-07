import '../model/budget_model.dart';

sealed class BudgetState {
  const BudgetState();
}

class BudgetInitial extends BudgetState {
  const BudgetInitial();
}

class BudgetLoading extends BudgetState {
  const BudgetLoading();
}

class BudgetLoaded extends BudgetState {
  const BudgetLoaded({
    required this.budgets,
    required this.totalBudget,
    required this.totalSpent,
    required this.monthYear,
  });

  final List<BudgetModel> budgets;
  final double totalBudget;
  final double totalSpent;
  final String monthYear;

  double get overallPercent =>
      totalBudget <= 0 ? 0 : totalSpent / totalBudget;

  bool get isOverWarning => overallPercent >= 0.60;

  bool get isCritical => overallPercent >= 0.85;
}

class BudgetError extends BudgetState {
  const BudgetError(this.message);
  final String message;
}
