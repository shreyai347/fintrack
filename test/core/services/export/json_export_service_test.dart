import 'package:fintrack/core/services/export/json_export_service.dart';
import 'package:fintrack/features/transactions/model/category_model.dart';
import 'package:fintrack/features/transactions/model/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buildJsonPayload shape', () {
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
        amount: -10,
        categoryId: 1,
        note: 'n',
        date: DateTime(2026, 5, 7),
        receiptPath: null,
        isRecurring: false,
        recurringRuleId: null,
        createdAt: DateTime(2026, 5, 7),
      ),
    ];
    final at = DateTime(2026, 5, 7, 10, 0);
    final m = buildJsonPayload(txs, cats, '1.0.0', at);
    expect(m.containsKey('exportedAt'), isTrue);
    expect(m['transactions'], isA<List>());
    expect((m['transactions'] as List).length, 1);
    final row = (m['transactions'] as List).first as Map<String, dynamic>;
    expect(row.containsKey('date'), isTrue);
    expect(row.containsKey('category'), isTrue);
    expect(row.containsKey('amount'), isTrue);
    expect(row.containsKey('type'), isTrue);
  });
}
