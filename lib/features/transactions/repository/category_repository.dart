import 'package:fintrack/generated/database/app_database.dart';

import '../model/category_model.dart';

abstract class CategoryRepository {
  Stream<List<CategoryModel>> watchAll();

  Future<List<CategoryModel>> getAll();

  Future<CategoryModel?> getById(int id);

  Future<int> add(CategoriesCompanion companion);

  Future<bool> update(CategoriesCompanion companion);

  Future<int> delete(int id);
}
