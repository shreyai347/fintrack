import 'package:fintrack/features/budget/model/budget_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  test('BudgetModel getters', () {
    final b = BudgetModel(
      id: 1,
      categoryId: 1,
      monthYear: '2026-05',
      limitAmount: 100,
      spentAmount: 65,
      createdAt: DateTime(2026, 5, 1),
    );
    expect(b.usedPercent, closeTo(0.65, 1e-9));
    expect(b.isOverWarning, isTrue);
    expect(b.isCritical, isFalse);

    final crit = BudgetModel(
      id: 1,
      categoryId: 1,
      monthYear: '2026-05',
      limitAmount: 100,
      spentAmount: 90,
      createdAt: DateTime(2026, 5, 1),
    );
    expect(crit.isCritical, isTrue);

    final over = BudgetModel(
      id: 1,
      categoryId: 1,
      monthYear: '2026-05',
      limitAmount: 100,
      spentAmount: 150,
      createdAt: DateTime(2026, 5, 1),
    );
    expect(over.isOverBudget, isTrue);
    expect(over.remaining, -50);

    expect(b.monthYearDisplay, 'May 2026');
  });
}
