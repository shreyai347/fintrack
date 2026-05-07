import 'package:fintrack/features/transactions/model/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TransactionModel copyWith', () {
    final t = TransactionModel(
      id: 1,
      amount: -50,
      categoryId: 2,
      note: 'coffee',
      date: DateTime(2026, 5, 1),
      receiptPath: null,
      isRecurring: false,
      recurringRuleId: null,
      createdAt: DateTime(2026, 5, 1),
    );
    final u = t.copyWith(note: 'tea');
    expect(u.amount, -50);
    expect(u.categoryId, 2);
    expect(u.note, 'tea');

    final v = t.copyWith(amount: 100);
    expect(v.amount, 100);
    expect(v.note, 'coffee');
  });

  test('expense sign', () {
    final expense = TransactionModel(
      id: 1,
      amount: -20,
      categoryId: 1,
      note: null,
      date: DateTime(2026, 5, 1),
      receiptPath: null,
      isRecurring: false,
      recurringRuleId: null,
      createdAt: DateTime(2026, 5, 1),
    );
    expect(expense.amount < 0, isTrue);
  });
}
