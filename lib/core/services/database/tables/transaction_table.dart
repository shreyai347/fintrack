import 'package:drift/drift.dart';

import 'category_table.dart';
import 'recurring_table.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get amount => real()();

  IntColumn get categoryId => integer().references(
        Categories,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get note => text().nullable()();

  DateTimeColumn get date => dateTime()();

  TextColumn get receiptPath => text().nullable()();

  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();

  IntColumn get recurringRuleId => integer().nullable().references(
        RecurringRules,
        #id,
      )();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'transactions';
}
