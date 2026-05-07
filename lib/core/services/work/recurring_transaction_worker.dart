import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'package:fintrack/generated/database/app_database.dart';

class RecurringTransactionWorker {
  DateTime _addCalendarMonth(DateTime from) {
    var y = from.year;
    var m = from.month + 1;
    if (m > 12) {
      m = 1;
      y++;
    }
    final lastDay = DateTime(y, m + 1, 0).day;
    final d = from.day > lastDay ? lastDay : from.day;
    return DateTime(y, m, d, from.hour, from.minute, from.second,
        from.millisecond, from.microsecond);
  }

  DateTime _nextDueAfter(RecurringRule rule) {
    final from = rule.nextDueDate;
    switch (rule.frequency) {
      case 'daily':
        return from.add(const Duration(days: 1));
      case 'weekly':
        return from.add(const Duration(days: 7));
      default:
        return _addCalendarMonth(from);
    }
  }

  Future<void> processRecurringTransactions(AppDatabase db) async {
    final now = DateTime.now();
    final due = await (db.select(db.recurringRules)
          ..where((r) =>
              r.isActive.equals(true) &
              r.nextDueDate.isSmallerOrEqualValue(now)))
        .get();

    var generated = 0;
    for (final rule in due) {
      final template = await (db.select(db.transactions)
            ..where((t) => t.recurringRuleId.equals(rule.id))
            ..orderBy([(t) => OrderingTerm.asc(t.date)])
            ..limit(1))
          .getSingleOrNull();
      if (template == null) continue;

      await db.transaction(() async {
        await db.into(db.transactions).insert(
              TransactionsCompanion.insert(
                amount: template.amount,
                categoryId: template.categoryId,
                note: Value(template.note),
                date: rule.nextDueDate,
                receiptPath: const Value.absent(),
                isRecurring: const Value(true),
                recurringRuleId: Value(rule.id),
              ),
            );
        final nextDue = _nextDueAfter(rule);
        await (db.update(db.recurringRules)..where((r) => r.id.equals(rule.id)))
            .write(
          RecurringRulesCompanion(
            nextDueDate: Value(nextDue),
            lastGeneratedDate: Value(DateTime.now()),
          ),
        );
      });
      generated++;
    }
    debugPrint('RecurringTransactionWorker: generated $generated transaction(s)');
  }
}
