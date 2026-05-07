import 'package:drift/drift.dart';

class ExportMetadata extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get exportType => text()();

  DateTimeColumn get exportedAt => dateTime()();

  IntColumn get recordCount => integer()();

  @override
  String get tableName => 'export_metadata';
}
