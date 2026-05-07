import 'package:fintrack/l10n/app_localizations.dart';

String localizedCategoryName(AppLocalizations l, String dbName) {
  switch (dbName) {
    case 'Food':
      return l.categoryFood;
    case 'Transport':
      return l.categoryTransport;
    case 'Shopping':
      return l.categoryShopping;
    case 'Bills':
      return l.categoryBills;
    case 'Health':
      return l.categoryHealth;
    case 'Entertainment':
      return l.categoryEntertainment;
    case 'Salary':
      return l.categorySalary;
    case 'Other':
      return l.categoryOther;
    default:
      return dbName;
  }
}
