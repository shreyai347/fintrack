import 'package:fintrack/features/dashboard/model/dashboard_summary_model.dart';
import 'package:fintrack/features/transactions/model/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

DashboardSummary _s({
  required double totalSpent,
  required double budgetLimit,
}) {
  return DashboardSummary(
    totalSpent: totalSpent,
    totalIncome: 0,
    budgetLimit: budgetLimit,
    transactionCount: 0,
    dailyAverage: 0,
    spentByCategory: const {},
    budgetByCategory: const {},
    recentTransactions: const <TransactionModel>[],
    previousMonthSpent: 0,
  );
}

void main() {
  test('budgetUsedPercent and warning flags', () {
    final s = _s(totalSpent: 24850, budgetLimit: 40000);
    expect(s.budgetUsedPercent, closeTo(0.62125, 1e-9));
    expect(s.isOverWarning, isTrue);
    expect(s.isCritical, isFalse);

    final low = _s(totalSpent: 20000, budgetLimit: 40000);
    expect(low.isOverWarning, isFalse);
    expect(low.isCritical, isFalse);

    final crit = _s(totalSpent: 34000, budgetLimit: 40000);
    expect(crit.isCritical, isTrue);
  });
}
