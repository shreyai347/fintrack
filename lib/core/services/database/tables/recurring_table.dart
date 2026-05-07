import 'package:drift/drift.dart';

class RecurringRules extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get frequency => text()();

  DateTimeColumn get nextDueDate => dateTime()();

  DateTimeColumn get lastGeneratedDate => dateTime().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  String get tableName => 'recurring_rules';
}
