abstract final class CategoryIconAssets {
  static const Map<String, String> _byName = {
    'Food': 'assets/burger.png',
    'Transport': 'assets/car.png',
    'Shopping': 'assets/shopping.png',
    'Salary': 'assets/salary.png',
    'Bills': 'assets/bill.png',
    'Health': 'assets/medicine.png',
    'Entertainment': 'assets/entarinement.png',
    'Other': 'assets/others.png',
  };

  static String? pathForCategoryName(String name) => _byName[name];
}
