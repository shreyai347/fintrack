import 'package:fintrack/core/services/export/csv_export_service.dart';
import 'package:fintrack/features/transactions/model/category_model.dart';
import 'package:fintrack/features/transactions/model/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buildCsvRows headers and amounts', () {
    final cats = [
      CategoryModel(
        id: 1,
        name: 'Food',
        iconCodePoint: 1,
        colorHex: '#fff',
        isDefault: true,
        createdAt: DateTime(2026, 1, 1),
      ),
    ];
    final txs = [
      TransactionModel(
        id: 1,
        amount: -100,
        categoryId: 1,
        note: 'lunch',
        date: DateTime(2026, 5, 7),
        receiptPath: '/r.jpg',
        isRecurring: false,
        recurringRuleId: null,
        createdAt: DateTime(2026, 5, 7),
      ),
      TransactionModel(
        id: 2,
        amount: 500,
        categoryId: 1,
        note: 'gift',
        date: DateTime(2026, 5, 6),
        receiptPath: null,
        isRecurring: false,
        recurringRuleId: null,
        createdAt: DateTime(2026, 5, 6),
      ),
    ];
    final rows = buildCsvRows(txs, cats);
    expect(rows[0][0], 'Date');
    expect(rows[0][5], 'Receipt');
    final expenseRow = rows[1];
    expect(expenseRow[3], '-100.0');
    expect(expenseRow[4], 'Expense');
    final incomeRow = rows[2];
    expect(incomeRow[3], '500.0');
    expect(incomeRow[4], 'Income');
  });
}
