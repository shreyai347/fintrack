abstract final class AppStrings {
  static const String appTitle = 'FinTrack Pro';

  static const String splashLoading = 'Loading…';

  static const String navDashboard = 'Dashboard';
  static const String navTransactions = 'Transactions';
  static const String navHome = 'Home';
  static const String navTxns = 'Txns';
  static const String navAdd = 'Add';
  static const String navAddTransaction = 'Add transaction';
  static const String navEditTransaction = 'Edit transaction';
  static const String navBudget = 'Budget';
  static const String navReceiptCamera = 'Receipt camera';
  static const String navSettings = 'Settings';
  static const String navExport = 'Export';

  static const String placeholderSubtitle = 'Coming in a later phase.';
  static const String today = 'Today';
  static const String yesterday = 'Yesterday';

  static const String validationAmountRequired = 'Enter an amount';
  static const String validationAmountInvalid = 'Enter a valid number';
  static const String validationAmountNonPositive = 'Amount must be greater than zero';
  static const String validationNoteTooLong = 'Note is too long';

  static const String transactionsListFallbackTitle = 'Transaction';
  static const String transactionsSelectCategory = 'Select a category';
  static const String transactionsRetry = 'Retry';
  static const String transactionsDeleted = 'Transaction deleted';
  static const String transactionsUndo = 'Undo';
  static const String transactionsAmountExpense = 'Expense';
  static const String transactionsAmountIncome = 'Income';
  static const String transactionsStepAmount = 'Amount';
  static const String transactionsStepCategory = 'Category';
  static const String transactionsStepSchedule = 'Schedule';
  static const String transactionsStepReceipt = 'Receipt';
  static const String transactionsStepNotes = 'Notes';
  static const String fieldDate = 'Date';
  static const String fieldRecurring = 'Recurring';
  static const String fieldType = 'Type';
  static const String transactionsAttachReceipt = 'Attach receipt';
  static const String transactionsReceiptMissing = 'Receipt file not found';
  static const String transactionsSave = 'Save';
  static const String transactionsSaved = 'Saved';
  static const String transactionsRecurringNone = 'None';
  static const String transactionsRecurringDaily = 'Daily';
  static const String transactionsRecurringWeekly = 'Weekly';
  static const String transactionsRecurringMonthly = 'Monthly';
  static const String transactionsNewTitle = 'New transaction';
  static const String transactionsEditTitle = 'Edit transaction';
  static const String transactionsDelete = 'Delete';
  static const String transactionsDeleteConfirmTitle = 'Delete transaction?';
  static const String transactionsDeleteConfirmBody =
      'This transaction will be removed from your list.';
  static const String transactionsSalaryMissing =
      'Salary category is not available. Try updating the app.';
  static const String transactionsCancel = 'Cancel';
  static const String transactionNotFound = 'Transaction not found';
  static const String transactionDetailTitle = 'Transaction details';
  static const String transactionDetailAmount = 'Amount';
  static const String transactionDetailCategory = 'Category';
  static const String transactionDetailDate = 'Date';
  static const String transactionDetailType = 'Type';
  static const String transactionDetailRecurring = 'Recurring';
  static const String transactionDetailYes = 'Yes';
  static const String transactionDetailNo = 'No';
  static const String transactionDetailNote = 'Note';
  static const String transactionDetailReceiptAttached = 'Receipt attached';

  static const String transactionsHelpTitle = 'Understanding transactions';
  static const String transactionsHelpSpendingTitle = 'Spending';
  static const String transactionsHelpSpendingBody =
      'Spending records money going out — purchases, bills, and day‑to‑day expenses. '
      'Each entry is negative in your totals and counts toward budgets and category breakdowns.';
  static const String transactionsHelpIncomeTitle = 'Income & salary';
  static const String transactionsHelpIncomeBody =
      'Income is money coming in (for example salary). Salary is a category used for '
      'regular pay so you can separate it from one‑off income. Income appears as positive '
      'amounts and is not treated as “spent”.';
  static const String transactionsHelpRecurringTitle = 'Recurring';
  static const String transactionsHelpRecurringBody =
      'A recurring transaction repeats on a schedule you pick (daily, weekly, or monthly). '
      'The app can use this to remind you or generate future entries. Turn it off anytime '
      'to make the line a one‑time transaction.';
  static const String transactionsEmptyTitle = 'No transactions yet';
  static const String transactionsEmptySubtitle = 'Tap + to add your first one';
  static const String chartOthers = 'Others';
  static const String dashboardGoodMorning = 'Good morning';
  static const String dashboardDemoUser = 'Rahul';
  static const String dashboardSeeAll = 'See all';
  static const String dashboardSectionRecent = 'Recent';
  static const String dashboardWeeklySpending = 'Weekly spending';
  static const String dashboardByCategory = 'By category';
  static const String dashboardStatDailyAvg = 'Daily avg';
  static const String dashboardStatTransactions = 'Transactions';
  static const String dashboardRetry = 'Retry';
  static const String dashboardTotalSpentPrefix = 'Total spent';
  static const String dashboardAddBudget = 'Add budget';
  static const String dashboardAddBudgetHint = 'Per category';
  static const String dashboardBudgetLabel = 'Budget';
  static const String dashboardBudgetLeftSuffix = 'left';
  static const String dashboardFlipCompare = 'This month vs last month';
  static const String dashboardFlipThisMonth = 'This month';
  static const String dashboardFlipLastMonth = 'Last month';
  static const String dashboardFlipVsLastMonth = 'vs last month';
  static const String dashboardDonutTopLabel = 'top';
  static const String dashboardDonutTapHint =
      'Tap a slice or row to see the amount spent.';
  static const String dashboardDonutSeeAllTransactions =
      'See all transactions';
  static const String dashboardDonutCategoryExpenses = 'Expenses this month';
  static const String dashboardDonutOpenDetail = 'Tap a row for details';
  static const String dashboardDonutOthersDetail =
      'Details for combined "Others" are in the full transaction list.';
  static const String dashboardErrorGeneric = 'Something went wrong';
  static const String dashboardAlertCriticalBody =
      'Budget nearly exhausted. Review amounts.';
  static const String dashboardAlertWarningBody =
      'You are approaching your budget limit.';
  static const String dashboardAlertRemaining = 'remaining';
  static const String dashboardAlertOver = 'over budget';
  static const String dashboardAlertUsed = 'used';
  static const String navMore = 'More';
  static const String receiptCameraSimulate = 'Use placeholder image path';

  static const String budgetScreen = 'Budget';
  static const String overallSpent = 'Overall spent';
  static const String byCategory = 'By category';
  static const String almostFull = 'Almost full';
  static const String overBudget = 'Over budget!';
  static const String editBudget = 'Edit budget';
  static const String newLimit = 'New limit';
  static const String saveBudget = 'Save';
  static const String budgetUpdated = 'Budget updated';
  static const String limitBelowSpent =
      'Limit cannot be less than amount already spent';
  static const String used = 'used';
  static const String currentLimit = 'Current limit';
  static const String budgetViewOnlyPast = 'Past months are view only.';

  static const String cameraPermissionRequired = 'Camera permission required';
  static const String openSettings = 'Open settings';
  static const String alignReceipt = 'Align receipt within frame';
  static const String retake = 'Retake';
  static const String usePhoto = 'Use photo';
  static const String attachReceipt = 'Attach receipt';
  static const String receiptNotFound = 'Receipt not found';
  static const String exportAsCSV = 'Export as CSV';
  static const String exportAsJSON = 'Export as JSON';
  static const String qrSummary = 'QR Summary';
  static const String exportReady = 'Export ready';
  static const String scanToView = 'Scan to view summary';
  static const String excelSheets = 'Opens in Excel / Sheets';
  static const String fullBackup = 'Full data backup';
  static const String quickShare = 'Quick share snapshot';
  static const String shareSummary = 'Share';
}
