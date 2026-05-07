import '../../transactions/model/transaction_model.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.totalSpent,
    required this.totalIncome,
    required this.budgetLimit,
    required this.transactionCount,
    required this.dailyAverage,
    required this.spentByCategory,
    required this.budgetByCategory,
    required this.recentTransactions,
    required this.previousMonthSpent,
  });

  final double totalSpent;
  final double totalIncome;
  final double budgetLimit;
  final int transactionCount;
  final double dailyAverage;
  final Map<int, double> spentByCategory;
  final Map<int, double> budgetByCategory;
  final List<TransactionModel> recentTransactions;
  final double previousMonthSpent;

  double get budgetUsedPercent =>
      budgetLimit <= 0 ? 0 : (totalSpent / budgetLimit).clamp(0.0, double.infinity);

  bool get isOverWarning => budgetUsedPercent >= 0.60;

  bool get isCritical => budgetUsedPercent >= 0.85;

  DashboardSummary copyWith({
    double? totalSpent,
    double? totalIncome,
    double? budgetLimit,
    int? transactionCount,
    double? dailyAverage,
    Map<int, double>? spentByCategory,
    Map<int, double>? budgetByCategory,
    List<TransactionModel>? recentTransactions,
    double? previousMonthSpent,
  }) {
    return DashboardSummary(
      totalSpent: totalSpent ?? this.totalSpent,
      totalIncome: totalIncome ?? this.totalIncome,
      budgetLimit: budgetLimit ?? this.budgetLimit,
      transactionCount: transactionCount ?? this.transactionCount,
      dailyAverage: dailyAverage ?? this.dailyAverage,
      spentByCategory: spentByCategory ?? this.spentByCategory,
      budgetByCategory: budgetByCategory ?? this.budgetByCategory,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      previousMonthSpent: previousMonthSpent ?? this.previousMonthSpent,
    );
  }
}
