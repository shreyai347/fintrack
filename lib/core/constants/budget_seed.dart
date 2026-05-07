/// Default monthly limits (₹) for seeded categories. Kept in sync with DB seed.
abstract final class BudgetSeed {
  static const Map<String, double> limitsByCategoryName = {
    'Food': 10000,
    'Transport': 5000,
    'Shopping': 10000,
    'Bills': 5000,
    'Health': 5000,
    'Entertainment': 5000,
    'Travel': 5000,
    'Other': 5000,
  };

  static double limitForCategoryName(String name) =>
      limitsByCategoryName[name] ?? 5000;
}
