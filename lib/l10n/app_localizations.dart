import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FinTrack Pro'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @dashboardHeyBuddy.
  ///
  /// In en, this message translates to:
  /// **'Hey buddy'**
  String get dashboardHeyBuddy;

  /// No description provided for @dashboardHeyName.
  ///
  /// In en, this message translates to:
  /// **'Hey, {name}'**
  String dashboardHeyName(Object name);

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get addTransaction;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get totalSpent;

  /// No description provided for @budgetLeft.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get budgetLeft;

  /// No description provided for @budgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budgetLabel;

  /// No description provided for @dailyAvg.
  ///
  /// In en, this message translates to:
  /// **'Daily avg'**
  String get dailyAvg;

  /// No description provided for @transactionCount.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionCount;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentTransactions;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactions;

  /// No description provided for @noTransactionsSub.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first one'**
  String get noTransactionsSub;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @notePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add a note...'**
  String get notePlaceholder;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @recurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurring;

  /// No description provided for @recurringNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get recurringNone;

  /// No description provided for @recurringDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get recurringDaily;

  /// No description provided for @recurringWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get recurringWeekly;

  /// No description provided for @recurringMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get recurringMonthly;

  /// No description provided for @recurringInfo.
  ///
  /// In en, this message translates to:
  /// **'This will repeat the transaction automatically at the selected frequency.'**
  String get recurringInfo;

  /// No description provided for @recurringInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring info'**
  String get recurringInfoTitle;

  /// No description provided for @tapToEdit.
  ///
  /// In en, this message translates to:
  /// **'tap to edit'**
  String get tapToEdit;

  /// No description provided for @attachReceipt.
  ///
  /// In en, this message translates to:
  /// **'Tap to open camera'**
  String get attachReceipt;

  /// No description provided for @attachReceiptSub.
  ///
  /// In en, this message translates to:
  /// **'Optional — scan your receipt'**
  String get attachReceiptSub;

  /// No description provided for @receiptPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt photo'**
  String get receiptPhotoTitle;

  /// No description provided for @receiptNotFound.
  ///
  /// In en, this message translates to:
  /// **'Receipt not found'**
  String get receiptNotFound;

  /// No description provided for @skipStep.
  ///
  /// In en, this message translates to:
  /// **'or skip this step'**
  String get skipStep;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @usePhoto.
  ///
  /// In en, this message translates to:
  /// **'Use photo'**
  String get usePhoto;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save ✓'**
  String get saveTransaction;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next →'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'← Back'**
  String get back;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this transaction?'**
  String get deleteConfirm;

  /// No description provided for @deleteConfirmSub.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteConfirmSub;

  /// No description provided for @transactionAdded.
  ///
  /// In en, this message translates to:
  /// **'Transaction saved'**
  String get transactionAdded;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// No description provided for @transactionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Transaction updated'**
  String get transactionUpdated;

  /// No description provided for @undoDelete.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoDelete;

  /// No description provided for @overallSpent.
  ///
  /// In en, this message translates to:
  /// **'Overall spent'**
  String get overallSpent;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get byCategory;

  /// No description provided for @almostFull.
  ///
  /// In en, this message translates to:
  /// **'Almost full'**
  String get almostFull;

  /// No description provided for @overBudget.
  ///
  /// In en, this message translates to:
  /// **'Over budget!'**
  String get overBudget;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @newLimit.
  ///
  /// In en, this message translates to:
  /// **'New limit'**
  String get newLimit;

  /// No description provided for @saveBudget.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveBudget;

  /// No description provided for @budgetUpdated.
  ///
  /// In en, this message translates to:
  /// **'Budget updated'**
  String get budgetUpdated;

  /// No description provided for @limitBelowSpent.
  ///
  /// In en, this message translates to:
  /// **'Limit cannot be less than amount already spent'**
  String get limitBelowSpent;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get used;

  /// No description provided for @currentLimit.
  ///
  /// In en, this message translates to:
  /// **'Current limit'**
  String get currentLimit;

  /// No description provided for @weeklySpending.
  ///
  /// In en, this message translates to:
  /// **'Weekly spending'**
  String get weeklySpending;

  /// No description provided for @monthlyComparison.
  ///
  /// In en, this message translates to:
  /// **'This month vs last month'**
  String get monthlyComparison;

  /// No description provided for @tapToFlip.
  ///
  /// In en, this message translates to:
  /// **'tap card to flip'**
  String get tapToFlip;

  /// No description provided for @insight.
  ///
  /// In en, this message translates to:
  /// **'INSIGHT'**
  String get insight;

  /// No description provided for @addBudget.
  ///
  /// In en, this message translates to:
  /// **'Add budget'**
  String get addBudget;

  /// No description provided for @addBudgetHint.
  ///
  /// In en, this message translates to:
  /// **'Per category'**
  String get addBudgetHint;

  /// No description provided for @flipThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get flipThisMonth;

  /// No description provided for @flipLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get flipLastMonth;

  /// No description provided for @flipVsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'vs last month'**
  String get flipVsLastMonth;

  /// No description provided for @donutTopLabel.
  ///
  /// In en, this message translates to:
  /// **'top'**
  String get donutTopLabel;

  /// No description provided for @donutTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a slice or row to see the amount spent.'**
  String get donutTapHint;

  /// No description provided for @donutMoreCount.
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String donutMoreCount(int count);

  /// No description provided for @donutSeeAllTransactions.
  ///
  /// In en, this message translates to:
  /// **'See all transactions'**
  String get donutSeeAllTransactions;

  /// No description provided for @donutCategoryExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses this month'**
  String get donutCategoryExpenses;

  /// No description provided for @donutOpenDetail.
  ///
  /// In en, this message translates to:
  /// **'Tap a row for details'**
  String get donutOpenDetail;

  /// No description provided for @donutOthersDetail.
  ///
  /// In en, this message translates to:
  /// **'Details for combined \"Others\" are in the full transaction list.'**
  String get donutOthersDetail;

  /// No description provided for @chartOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get chartOthers;

  /// No description provided for @exportAsCSV.
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get exportAsCSV;

  /// No description provided for @exportAsJSON.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get exportAsJSON;

  /// No description provided for @qrSummary.
  ///
  /// In en, this message translates to:
  /// **'QR Summary'**
  String get qrSummary;

  /// No description provided for @exportReady.
  ///
  /// In en, this message translates to:
  /// **'Export ready'**
  String get exportReady;

  /// No description provided for @excelSheets.
  ///
  /// In en, this message translates to:
  /// **'Opens in Excel / Sheets'**
  String get excelSheets;

  /// No description provided for @fullBackup.
  ///
  /// In en, this message translates to:
  /// **'Full data backup'**
  String get fullBackup;

  /// No description provided for @quickShare.
  ///
  /// In en, this message translates to:
  /// **'Quick share snapshot'**
  String get quickShare;

  /// No description provided for @scanToView.
  ///
  /// In en, this message translates to:
  /// **'Scan to view summary'**
  String get scanToView;

  /// No description provided for @shareSummary.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareSummary;

  /// No description provided for @biometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric lock'**
  String get biometricLock;

  /// No description provided for @biometricSub.
  ///
  /// In en, this message translates to:
  /// **'Face ID / Fingerprint'**
  String get biometricSub;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication not available on this device'**
  String get biometricNotAvailable;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authFailed;

  /// No description provided for @authRequired.
  ///
  /// In en, this message translates to:
  /// **'Authentication required'**
  String get authRequired;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिंदी'**
  String get languageHindi;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get exportData;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get backupRestore;

  /// No description provided for @backupComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get backupComingSoon;

  /// No description provided for @clearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get clearAllData;

  /// No description provided for @clearAllDataSub.
  ///
  /// In en, this message translates to:
  /// **'Requires biometric'**
  String get clearAllDataSub;

  /// No description provided for @clearConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all data?'**
  String get clearConfirmTitle;

  /// No description provided for @clearConfirmSub.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all transactions and reset budgets.'**
  String get clearConfirmSub;

  /// No description provided for @clearSuccess.
  ///
  /// In en, this message translates to:
  /// **'All data cleared'**
  String get clearSuccess;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'SECURITY'**
  String get security;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get appearance;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'DATA'**
  String get data;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get cameraPermissionRequired;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @alignReceipt.
  ///
  /// In en, this message translates to:
  /// **'Align receipt within frame'**
  String get alignReceipt;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTxns.
  ///
  /// In en, this message translates to:
  /// **'Txns'**
  String get navTxns;

  /// No description provided for @navAddTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get navAddTransaction;

  /// No description provided for @navBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get navBudget;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @navExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get navExport;

  /// No description provided for @budgetViewOnlyPast.
  ///
  /// In en, this message translates to:
  /// **'Past months are view only.'**
  String get budgetViewOnlyPast;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @addFirstTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add a transaction'**
  String get addFirstTransaction;

  /// No description provided for @addFirstTransactionSub.
  ///
  /// In en, this message translates to:
  /// **'Tap + below'**
  String get addFirstTransactionSub;

  /// No description provided for @setBudget.
  ///
  /// In en, this message translates to:
  /// **'Set a budget'**
  String get setBudget;

  /// No description provided for @setBudgetSub.
  ///
  /// In en, this message translates to:
  /// **'Budget screen'**
  String get setBudgetSub;

  /// No description provided for @scanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan a receipt'**
  String get scanReceipt;

  /// No description provided for @scanReceiptSub.
  ///
  /// In en, this message translates to:
  /// **'Camera ready'**
  String get scanReceiptSub;

  /// No description provided for @spendingChart.
  ///
  /// In en, this message translates to:
  /// **'Spending chart'**
  String get spendingChart;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get noData;

  /// No description provided for @recurringThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Recurring this month'**
  String get recurringThisMonth;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Track your expenses offline—private, simple, always in your pocket.'**
  String get splashTagline;

  /// No description provided for @validationAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get validationAmountRequired;

  /// No description provided for @validationAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get validationAmountInvalid;

  /// No description provided for @transactionsSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get transactionsSaved;

  /// No description provided for @transactionsSalaryMissing.
  ///
  /// In en, this message translates to:
  /// **'Salary category is not available. Try updating the app.'**
  String get transactionsSalaryMissing;

  /// No description provided for @transactionsStepAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transactionsStepAmount;

  /// No description provided for @transactionsStepCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get transactionsStepCategory;

  /// No description provided for @fieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldDate;

  /// No description provided for @fieldRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get fieldRecurring;

  /// No description provided for @fieldType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fieldType;

  /// No description provided for @transactionsListFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transactionsListFallbackTitle;

  /// No description provided for @transactionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get transactionsEmptyTitle;

  /// No description provided for @transactionsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first one'**
  String get transactionsEmptySubtitle;

  /// No description provided for @transactionsHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Understanding transactions'**
  String get transactionsHelpTitle;

  /// No description provided for @transactionsHelpSpendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get transactionsHelpSpendingTitle;

  /// No description provided for @transactionsHelpSpendingBody.
  ///
  /// In en, this message translates to:
  /// **'Spending records money going out — purchases, bills, and day-to-day expenses. Each entry is negative in your totals and counts toward budgets and category breakdowns.'**
  String get transactionsHelpSpendingBody;

  /// No description provided for @transactionsHelpIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Income & salary'**
  String get transactionsHelpIncomeTitle;

  /// No description provided for @transactionsHelpIncomeBody.
  ///
  /// In en, this message translates to:
  /// **'Income is money coming in (for example salary). Salary is a category used for regular pay so you can separate it from one-off income. Income appears as positive amounts and is not treated as \"spent\".'**
  String get transactionsHelpIncomeBody;

  /// No description provided for @transactionsHelpRecurringTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get transactionsHelpRecurringTitle;

  /// No description provided for @transactionsHelpRecurringBody.
  ///
  /// In en, this message translates to:
  /// **'A recurring transaction repeats on a schedule you pick (daily, weekly, or monthly). The app can use this to remind you or generate future entries. Turn it off anytime to make the line a one-time transaction.'**
  String get transactionsHelpRecurringBody;

  /// No description provided for @transactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Transaction not found'**
  String get transactionNotFound;

  /// No description provided for @transactionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction details'**
  String get transactionDetailTitle;

  /// No description provided for @transactionDetailType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get transactionDetailType;

  /// No description provided for @transactionDetailAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transactionDetailAmount;

  /// No description provided for @transactionDetailCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get transactionDetailCategory;

  /// No description provided for @transactionDetailDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transactionDetailDate;

  /// No description provided for @transactionDetailRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get transactionDetailRecurring;

  /// No description provided for @transactionDetailYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get transactionDetailYes;

  /// No description provided for @transactionDetailNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get transactionDetailNo;

  /// No description provided for @transactionDetailNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get transactionDetailNote;

  /// No description provided for @transactionDetailReceiptAttached.
  ///
  /// In en, this message translates to:
  /// **'Receipt attached'**
  String get transactionDetailReceiptAttached;

  /// No description provided for @transactionDetailViewReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get transactionDetailViewReceipt;

  /// No description provided for @viewReceipt.
  ///
  /// In en, this message translates to:
  /// **'View receipt'**
  String get viewReceipt;

  /// No description provided for @transactionsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get transactionsRetry;

  /// No description provided for @profileSection.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileSection;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @nameNotSetHint.
  ///
  /// In en, this message translates to:
  /// **'Not set yet'**
  String get nameNotSetHint;

  /// No description provided for @displayNameHint.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get displayNameHint;

  /// No description provided for @exportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'CSV / JSON / QR'**
  String get exportDataSubtitle;

  /// No description provided for @backupRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import JSON'**
  String get backupRestoreSubtitle;

  /// No description provided for @dashboardAlertCriticalBody.
  ///
  /// In en, this message translates to:
  /// **'Budget nearly exhausted. Review amounts.'**
  String get dashboardAlertCriticalBody;

  /// No description provided for @dashboardAlertWarningBody.
  ///
  /// In en, this message translates to:
  /// **'You are approaching your budget limit.'**
  String get dashboardAlertWarningBody;

  /// No description provided for @dashboardAlertRemaining.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get dashboardAlertRemaining;

  /// No description provided for @dashboardAlertOver.
  ///
  /// In en, this message translates to:
  /// **'over budget'**
  String get dashboardAlertOver;

  /// No description provided for @dashboardAlertUsed.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get dashboardAlertUsed;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @placeholderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Coming in a later phase.'**
  String get placeholderSubtitle;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get categoryBills;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
