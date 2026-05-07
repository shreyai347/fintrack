import 'package:fintrack/features/transactions/model/category_model.dart';

CategoryModel? categoryById(List<CategoryModel> list, int? id) {
  if (id == null) return null;
  for (final c in list) {
    if (c.id == id) return c;
  }
  return null;
}

bool excludeSalaryCategory(CategoryModel c) => c.name != 'Salary';

String formatAmountDisplay(String raw) {
  if (raw.isEmpty) return '0';
  return raw;
}
