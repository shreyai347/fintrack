import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/generated/database/app_database.dart';

import '../model/category_model.dart';
import 'category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<CategoryModel>> watchAll() {
    return (_db.select(_db.categories)..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch()
        .map((rows) => rows.map(CategoryModel.fromDrift).toList());
  }

  @override
  Future<List<CategoryModel>> getAll() async {
    final rows = await (_db.select(_db.categories)
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
    return rows.map(CategoryModel.fromDrift).toList();
  }

  @override
  Future<CategoryModel?> getById(int id) async {
    final row = await (_db.select(_db.categories)
          ..where((c) => c.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : CategoryModel.fromDrift(row);
  }

  @override
  Future<int> add(CategoriesCompanion companion) async {
    return _db.transaction(() async {
      return _db.into(_db.categories).insert(companion);
    });
  }

  @override
  Future<bool> update(CategoriesCompanion companion) async {
    final id = companion.id.present ? companion.id.value : null;
    if (id == null) return false;
    return _db.transaction(() async {
      final n = await (_db.update(_db.categories)..where((c) => c.id.equals(id)))
          .write(companion);
      return n > 0;
    });
  }

  @override
  Future<int> delete(int id) async {
    return _db.transaction(() async {
      return (_db.delete(_db.categories)..where((c) => c.id.equals(id))).go();
    });
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(ref.watch(appDatabaseProvider));
});
