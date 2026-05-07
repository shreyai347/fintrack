import 'package:drift/drift.dart';

import 'package:fintrack/generated/database/app_database.dart' as db;
typedef TransactionEntry = db.Transaction;

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.note,
    required this.date,
    required this.receiptPath,
    required this.isRecurring,
    required this.recurringRuleId,
    required this.createdAt,
  });

  final int id;
  final double amount;
  final int categoryId;
  final String? note;
  final DateTime date;
  final String? receiptPath;
  final bool isRecurring;
  final int? recurringRuleId;
  final DateTime createdAt;

  factory TransactionModel.fromDrift(TransactionEntry entry) {
    return TransactionModel(
      id: entry.id,
      amount: entry.amount,
      categoryId: entry.categoryId,
      note: entry.note,
      date: entry.date,
      receiptPath: entry.receiptPath,
      isRecurring: entry.isRecurring,
      recurringRuleId: entry.recurringRuleId,
      createdAt: entry.createdAt,
    );
  }

  TransactionModel copyWith({
    int? id,
    double? amount,
    int? categoryId,
    String? note,
    DateTime? date,
    String? receiptPath,
    bool? isRecurring,
    int? recurringRuleId,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      date: date ?? this.date,
      receiptPath: receiptPath ?? this.receiptPath,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringRuleId: recurringRuleId ?? this.recurringRuleId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  db.TransactionsCompanion toCompanion({bool forUpdate = false}) {
    return db.TransactionsCompanion(
      id: forUpdate ? Value(id) : const Value.absent(),
      amount: Value(amount),
      categoryId: Value(categoryId),
      note: Value(note),
      date: Value(date),
      receiptPath: Value(receiptPath),
      isRecurring: Value(isRecurring),
      recurringRuleId: Value(recurringRuleId),
      createdAt: forUpdate ? Value(createdAt) : const Value.absent(),
    );
  }
}
