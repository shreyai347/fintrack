// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FinTrack Pro';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get dashboardHeyBuddy => 'Hey buddy';

  @override
  String dashboardHeyName(Object name) {
    return 'Hey, $name';
  }

  @override
  String get transactions => 'Transactions';

  @override
  String get addTransaction => 'New transaction';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get budget => 'Budget';

  @override
  String get settings => 'Settings';

  @override
  String get totalSpent => 'Total spent';

  @override
  String get budgetLeft => 'left';

  @override
  String get budgetLabel => 'Budget';

  @override
  String get dailyAvg => 'Daily avg';

  @override
  String get transactionCount => 'Transactions';

  @override
  String get recentTransactions => 'Recent';

  @override
  String get seeAll => 'See all';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get noTransactionsSub => 'Tap + to add your first one';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get amount => 'Amount';

  @override
  String get type => 'Type';

  @override
  String get category => 'Category';

  @override
  String get note => 'Note';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get notePlaceholder => 'Add a note...';

  @override
  String get date => 'Date';

  @override
  String get recurring => 'Recurring';

  @override
  String get recurringNone => 'None';

  @override
  String get recurringDaily => 'Daily';

  @override
  String get recurringWeekly => 'Weekly';

  @override
  String get recurringMonthly => 'Monthly';

  @override
  String get recurringInfo =>
      'This will repeat the transaction automatically at the selected frequency.';

  @override
  String get recurringInfoTitle => 'Recurring info';

  @override
  String get tapToEdit => 'tap to edit';

  @override
  String get attachReceipt => 'Tap to open camera';

  @override
  String get attachReceiptSub => 'Optional — scan your receipt';

  @override
  String get receiptPhotoTitle => 'Receipt photo';

  @override
  String get receiptNotFound => 'Receipt not found';

  @override
  String get skipStep => 'or skip this step';

  @override
  String get retake => 'Retake';

  @override
  String get usePhoto => 'Use photo';

  @override
  String get save => 'Save';

  @override
  String get saveTransaction => 'Save ✓';

  @override
  String get next => 'Next →';

  @override
  String get back => '← Back';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteConfirm => 'Delete this transaction?';

  @override
  String get deleteConfirmSub => 'This action cannot be undone.';

  @override
  String get transactionAdded => 'Transaction saved';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get transactionUpdated => 'Transaction updated';

  @override
  String get undoDelete => 'Undo';

  @override
  String get overallSpent => 'Overall spent';

  @override
  String get byCategory => 'By category';

  @override
  String get almostFull => 'Almost full';

  @override
  String get overBudget => 'Over budget!';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get newLimit => 'New limit';

  @override
  String get saveBudget => 'Save';

  @override
  String get budgetUpdated => 'Budget updated';

  @override
  String get limitBelowSpent =>
      'Limit cannot be less than amount already spent';

  @override
  String get used => 'used';

  @override
  String get currentLimit => 'Current limit';

  @override
  String get weeklySpending => 'Weekly spending';

  @override
  String get monthlyComparison => 'This month vs last month';

  @override
  String get tapToFlip => 'tap card to flip';

  @override
  String get insight => 'INSIGHT';

  @override
  String get addBudget => 'Add budget';

  @override
  String get addBudgetHint => 'Per category';

  @override
  String get flipThisMonth => 'This month';

  @override
  String get flipLastMonth => 'Last month';

  @override
  String get flipVsLastMonth => 'vs last month';

  @override
  String get donutTopLabel => 'top';

  @override
  String get donutTapHint => 'Tap a slice or row to see the amount spent.';

  @override
  String donutMoreCount(int count) {
    return '+$count more';
  }

  @override
  String get donutSeeAllTransactions => 'See all transactions';

  @override
  String get donutCategoryExpenses => 'Expenses this month';

  @override
  String get donutOpenDetail => 'Tap a row for details';

  @override
  String get donutOthersDetail =>
      'Details for combined \"Others\" are in the full transaction list.';

  @override
  String get chartOthers => 'Others';

  @override
  String get exportAsCSV => 'Export as CSV';

  @override
  String get exportAsJSON => 'Export as JSON';

  @override
  String get qrSummary => 'QR Summary';

  @override
  String get exportReady => 'Export ready';

  @override
  String get excelSheets => 'Opens in Excel / Sheets';

  @override
  String get fullBackup => 'Full data backup';

  @override
  String get quickShare => 'Quick share snapshot';

  @override
  String get scanToView => 'Scan to view summary';

  @override
  String get shareSummary => 'Share';

  @override
  String get biometricLock => 'Biometric lock';

  @override
  String get biometricSub => 'Face ID / Fingerprint';

  @override
  String get biometricNotAvailable =>
      'Biometric authentication not available on this device';

  @override
  String get authFailed => 'Authentication failed';

  @override
  String get authRequired => 'Authentication required';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get exportData => 'Export data';

  @override
  String get backupRestore => 'Backup & restore';

  @override
  String get backupComingSoon => 'Coming soon';

  @override
  String get clearAllData => 'Clear all data';

  @override
  String get clearAllDataSub => 'Requires biometric';

  @override
  String get clearConfirmTitle => 'Clear all data?';

  @override
  String get clearConfirmSub =>
      'This will permanently delete all transactions and reset budgets.';

  @override
  String get clearSuccess => 'All data cleared';

  @override
  String get security => 'SECURITY';

  @override
  String get appearance => 'APPEARANCE';

  @override
  String get data => 'DATA';

  @override
  String get retry => 'Retry';

  @override
  String get error => 'Something went wrong';

  @override
  String get cameraPermissionRequired => 'Camera permission required';

  @override
  String get openSettings => 'Open settings';

  @override
  String get alignReceipt => 'Align receipt within frame';

  @override
  String get navHome => 'Home';

  @override
  String get navTxns => 'Txns';

  @override
  String get navAddTransaction => 'Add';

  @override
  String get navBudget => 'Budget';

  @override
  String get navMore => 'More';

  @override
  String get navExport => 'Export';

  @override
  String get budgetViewOnlyPast => 'Past months are view only.';

  @override
  String get getStarted => 'Get started';

  @override
  String get addFirstTransaction => 'Add a transaction';

  @override
  String get addFirstTransactionSub => 'Tap + below';

  @override
  String get setBudget => 'Set a budget';

  @override
  String get setBudgetSub => 'Budget screen';

  @override
  String get scanReceipt => 'Scan a receipt';

  @override
  String get scanReceiptSub => 'Camera ready';

  @override
  String get spendingChart => 'Spending chart';

  @override
  String get noData => 'No data yet';

  @override
  String get recurringThisMonth => 'Recurring this month';

  @override
  String get splashTagline =>
      'Track your expenses offline—private, simple, always in your pocket.';

  @override
  String get validationAmountRequired => 'Enter an amount';

  @override
  String get validationAmountInvalid => 'Enter a valid number';

  @override
  String get transactionsSaved => 'Saved';

  @override
  String get transactionsSalaryMissing =>
      'Salary category is not available. Try updating the app.';

  @override
  String get transactionsStepAmount => 'Amount';

  @override
  String get transactionsStepCategory => 'Category';

  @override
  String get fieldDate => 'Date';

  @override
  String get fieldRecurring => 'Recurring';

  @override
  String get fieldType => 'Type';

  @override
  String get transactionsListFallbackTitle => 'Transaction';

  @override
  String get transactionsEmptyTitle => 'No transactions yet';

  @override
  String get transactionsEmptySubtitle => 'Tap + to add your first one';

  @override
  String get transactionsHelpTitle => 'Understanding transactions';

  @override
  String get transactionsHelpSpendingTitle => 'Spending';

  @override
  String get transactionsHelpSpendingBody =>
      'Spending records money going out — purchases, bills, and day-to-day expenses. Each entry is negative in your totals and counts toward budgets and category breakdowns.';

  @override
  String get transactionsHelpIncomeTitle => 'Income & salary';

  @override
  String get transactionsHelpIncomeBody =>
      'Income is money coming in (for example salary). Salary is a category used for regular pay so you can separate it from one-off income. Income appears as positive amounts and is not treated as \"spent\".';

  @override
  String get transactionsHelpRecurringTitle => 'Recurring';

  @override
  String get transactionsHelpRecurringBody =>
      'A recurring transaction repeats on a schedule you pick (daily, weekly, or monthly). The app can use this to remind you or generate future entries. Turn it off anytime to make the line a one-time transaction.';

  @override
  String get transactionNotFound => 'Transaction not found';

  @override
  String get transactionDetailTitle => 'Transaction details';

  @override
  String get transactionDetailType => 'Type';

  @override
  String get transactionDetailAmount => 'Amount';

  @override
  String get transactionDetailCategory => 'Category';

  @override
  String get transactionDetailDate => 'Date';

  @override
  String get transactionDetailRecurring => 'Recurring';

  @override
  String get transactionDetailYes => 'Yes';

  @override
  String get transactionDetailNo => 'No';

  @override
  String get transactionDetailNote => 'Note';

  @override
  String get transactionDetailReceiptAttached => 'Receipt attached';

  @override
  String get transactionDetailViewReceipt => 'Receipt';

  @override
  String get viewReceipt => 'View receipt';

  @override
  String get transactionsRetry => 'Retry';

  @override
  String get profileSection => 'Profile';

  @override
  String get yourName => 'Your name';

  @override
  String get nameNotSetHint => 'Not set yet';

  @override
  String get displayNameHint => 'What should we call you?';

  @override
  String get exportDataSubtitle => 'CSV / JSON / QR';

  @override
  String get backupRestoreSubtitle => 'Import JSON';

  @override
  String get dashboardAlertCriticalBody =>
      'Budget nearly exhausted. Review amounts.';

  @override
  String get dashboardAlertWarningBody =>
      'You are approaching your budget limit.';

  @override
  String get dashboardAlertRemaining => 'remaining';

  @override
  String get dashboardAlertOver => 'over budget';

  @override
  String get dashboardAlertUsed => 'used';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get placeholderSubtitle => 'Coming in a later phase.';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryBills => 'Bills';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categoryOther => 'Other';
}
