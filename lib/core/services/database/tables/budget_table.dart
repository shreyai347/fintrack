import 'package:drift/drift.dart';

import 'category_table.dart';

class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get categoryId => integer().references(
        Categories,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get monthYear => text()();

  RealColumn get limitAmount => real()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {categoryId, monthYear},
      ];

  @override
  String get tableName => 'budgets';
}
