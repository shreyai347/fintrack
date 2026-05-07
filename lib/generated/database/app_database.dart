import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/services/database/tables/budget_table.dart';
import '../../core/services/database/tables/category_table.dart';
import '../../core/services/database/tables/export_metadata_table.dart';
import '../../core/services/database/tables/recurring_table.dart';
import '../../core/services/database/tables/transaction_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Categories, RecurringRules, Transactions, ExportMetadata, Budgets])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await customStatement('PRAGMA foreign_keys = ON;');
          await m.createAll();
          await _seedDefaultCategories();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(budgets);
          }
          if (from < 4) {
            await (delete(categories)..where((c) => c.name.equals('Salary')))
                .go();
          }
          if (from < 5) {
            await _ensureSalaryCategory();
            await _removeTravelCategory();
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );

  Future<void> _seedDefaultCategories() async {
    final rows = <CategoriesCompanion>[
      CategoriesCompanion.insert(
        name: 'Food',
        iconCodePoint: 0xe533,
        colorHex: '#F87171',
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        name: 'Transport',
        iconCodePoint: 0xe531,
        colorHex: '#60A5FA',
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        name: 'Shopping',
        iconCodePoint: 0xe59c,
        colorHex: '#A78BFA',
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        name: 'Bills',
        iconCodePoint: 0xe237,
        colorHex: '#FBBF24',
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        name: 'Health',
        iconCodePoint: 0xe3f5,
        colorHex: '#34D399',
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        name: 'Entertainment',
        iconCodePoint: 0xe40d,
        colorHex: '#F472B6',
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        name: 'Salary',
        iconCodePoint: 0xe263,
        colorHex: '#4ADE80',
        isDefault: const Value(true),
      ),
      CategoriesCompanion.insert(
        name: 'Other',
        iconCodePoint: 0xe5c4,
        colorHex: '#9CA3AF',
        isDefault: const Value(true),
      ),
    ];

    await batch((b) {
      for (final row in rows) {
        b.insert(categories, row);
      }
    });
  }

  Future<void> _ensureSalaryCategory() async {
    final existing = await (select(categories)
          ..where((c) => c.name.equals('Salary')))
        .getSingleOrNull();
    if (existing != null) return;
    await into(categories).insert(
      CategoriesCompanion.insert(
        name: 'Salary',
        iconCodePoint: 0xe263,
        colorHex: '#4ADE80',
        isDefault: const Value(true),
      ),
    );
  }

  Future<void> _removeTravelCategory() async {
    final travel = await (select(categories)
          ..where((c) => c.name.equals('Travel')))
        .getSingleOrNull();
    if (travel == null) return;
    final other = await (select(categories)
          ..where((c) => c.name.equals('Other')))
        .getSingleOrNull();
    if (other != null) {
      await (update(transactions)
            ..where((t) => t.categoryId.equals(travel.id)))
          .write(TransactionsCompanion(categoryId: Value(other.id)));
    }
    await (delete(categories)..where((c) => c.id.equals(travel.id))).go();
  }
}


final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw StateError('appDatabaseProvider must be overridden in main');
});

Future<File> _databaseFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File(p.join(dir.path, 'fintrack.db'));
}

QueryExecutor openFintrackConnection() {
  return LazyDatabase(() async {
    final file = await _databaseFile();
    return NativeDatabase.createInBackground(file);
  });
}

Future<AppDatabase> openFintrackDatabase() async {
  AppDatabase open() => AppDatabase(openFintrackConnection());

  var db = open();
  try {
    final row = await db.customSelect('PRAGMA integrity_check').getSingle();
    final result = row.read<String>('integrity_check');
    if (result.toLowerCase() != 'ok') {
      throw StateError(result);
    }
  } catch (_) {
    await db.close();
    final file = await _databaseFile();
    if (await file.exists()) await file.delete();
    db = open();
    await db.customSelect('PRAGMA integrity_check').getSingle();
  }
  return db;
}
