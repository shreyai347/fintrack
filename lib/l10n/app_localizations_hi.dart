// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'FinTrack Pro';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get goodMorning => 'शुभ प्रभात';

  @override
  String get goodAfternoon => 'शुभ अपराह्न';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get dashboardHeyBuddy => 'अरे दोस्त';

  @override
  String dashboardHeyName(Object name) {
    return 'नमस्ते, $name';
  }

  @override
  String get transactions => 'लेनदेन';

  @override
  String get addTransaction => 'नया लेनदेन';

  @override
  String get editTransaction => 'लेनदेन संपादित करें';

  @override
  String get budget => 'बजट';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get totalSpent => 'कुल खर्च';

  @override
  String get budgetLeft => 'बचा';

  @override
  String get budgetLabel => 'बजट';

  @override
  String get dailyAvg => 'दैनिक औसत';

  @override
  String get transactionCount => 'लेनदेन';

  @override
  String get recentTransactions => 'हाल का';

  @override
  String get seeAll => 'सब देखें';

  @override
  String get noTransactions => 'अभी कोई लेनदेन नहीं';

  @override
  String get noTransactionsSub => '+ दबाएं पहला जोड़ने के लिए';

  @override
  String get income => 'आय';

  @override
  String get expense => 'खर्च';

  @override
  String get amount => 'राशि';

  @override
  String get type => 'प्रकार';

  @override
  String get category => 'श्रेणी';

  @override
  String get note => 'नोट';

  @override
  String get noteOptional => 'नोट (वैकल्पिक)';

  @override
  String get notePlaceholder => 'नोट जोड़ें...';

  @override
  String get date => 'तारीख';

  @override
  String get recurring => 'आवर्ती';

  @override
  String get recurringNone => 'कोई नहीं';

  @override
  String get recurringDaily => 'दैनिक';

  @override
  String get recurringWeekly => 'साप्ताहिक';

  @override
  String get recurringMonthly => 'मासिक';

  @override
  String get recurringInfo =>
      'चुनी गई आवृत्ति पर यह लेनदेन स्वचालित रूप से दोहराएगा।';

  @override
  String get recurringInfoTitle => 'आवर्ती जानकारी';

  @override
  String get tapToEdit => 'संपादित करें';

  @override
  String get attachReceipt => 'कैमरा खोलने के लिए टैप करें';

  @override
  String get attachReceiptSub => 'वैकल्पिक — रसीद स्कैन करें';

  @override
  String get receiptPhotoTitle => 'रसीद फोटो';

  @override
  String get receiptNotFound => 'रसीद नहीं मिली';

  @override
  String get skipStep => 'या यह चरण छोड़ें';

  @override
  String get retake => 'फिर से लें';

  @override
  String get usePhoto => 'फोटो उपयोग करें';

  @override
  String get save => 'सहेजें';

  @override
  String get saveTransaction => 'सहेजें ✓';

  @override
  String get next => 'आगे →';

  @override
  String get back => '← पीछे';

  @override
  String get delete => 'हटाएं';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get deleteConfirm => 'यह लेनदेन हटाएं?';

  @override
  String get deleteConfirmSub => 'यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get transactionAdded => 'लेनदेन सहेजा गया';

  @override
  String get transactionDeleted => 'लेनदेन हटाया गया';

  @override
  String get transactionUpdated => 'लेनदेन अपडेट हुआ';

  @override
  String get undoDelete => 'पूर्ववत';

  @override
  String get overallSpent => 'कुल खर्च';

  @override
  String get byCategory => 'श्रेणी अनुसार';

  @override
  String get almostFull => 'लगभग भर गया';

  @override
  String get overBudget => 'बजट से अधिक!';

  @override
  String get editBudget => 'बजट संपादित करें';

  @override
  String get newLimit => 'नई सीमा';

  @override
  String get saveBudget => 'सहेजें';

  @override
  String get budgetUpdated => 'बजट अपडेट हुआ';

  @override
  String get limitBelowSpent => 'सीमा खर्च की गई राशि से कम नहीं हो सकती';

  @override
  String get used => 'उपयोग';

  @override
  String get currentLimit => 'वर्तमान सीमा';

  @override
  String get weeklySpending => 'साप्ताहिक खर्च';

  @override
  String get monthlyComparison => 'इस माह बनाम पिछले माह';

  @override
  String get tapToFlip => 'पलटने के लिए टैप करें';

  @override
  String get insight => 'अंतर्दृष्टि';

  @override
  String get addBudget => 'बजट जोड़ें';

  @override
  String get addBudgetHint => 'प्रति श्रेणी';

  @override
  String get flipThisMonth => 'इस माह';

  @override
  String get flipLastMonth => 'पिछला माह';

  @override
  String get flipVsLastMonth => 'पिछले माह से';

  @override
  String get donutTopLabel => 'शीर्ष';

  @override
  String get donutTapHint => 'राशि देखने के लिए स्लाइस या पंक्ति टैप करें।';

  @override
  String donutMoreCount(int count) {
    return '+$count और';
  }

  @override
  String get donutSeeAllTransactions => 'सभी लेनदेन देखें';

  @override
  String get donutCategoryExpenses => 'इस माह के खर्च';

  @override
  String get donutOpenDetail => 'विवरण के लिए पंक्ति टैप करें';

  @override
  String get donutOthersDetail => '\"अन्य\" का विवरण पूर्ण लेनदेन सूची में है।';

  @override
  String get chartOthers => 'अन्य';

  @override
  String get exportAsCSV => 'CSV में निर्यात';

  @override
  String get exportAsJSON => 'JSON में निर्यात';

  @override
  String get qrSummary => 'QR सारांश';

  @override
  String get exportReady => 'निर्यात तैयार';

  @override
  String get excelSheets => 'Excel / Sheets में खुलता है';

  @override
  String get fullBackup => 'पूरा डेटा बैकअप';

  @override
  String get quickShare => 'त्वरित साझा करें';

  @override
  String get scanToView => 'सारांश देखने के लिए स्कैन करें';

  @override
  String get shareSummary => 'साझा करें';

  @override
  String get biometricLock => 'बायोमेट्रिक लॉक';

  @override
  String get biometricSub => 'Face ID / फिंगरप्रिंट';

  @override
  String get biometricNotAvailable => 'इस डिवाइस पर बायोमेट्रिक उपलब्ध नहीं है';

  @override
  String get authFailed => 'प्रमाणीकरण विफल';

  @override
  String get authRequired => 'प्रमाणीकरण आवश्यक';

  @override
  String get theme => 'थीम';

  @override
  String get themeLight => 'हल्का';

  @override
  String get themeDark => 'गहरा';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get language => 'भाषा';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get exportData => 'डेटा निर्यात करें';

  @override
  String get backupRestore => 'बैकअप और पुनर्स्थापना';

  @override
  String get backupComingSoon => 'जल्द आ रहा है';

  @override
  String get clearAllData => 'सभी डेटा साफ़ करें';

  @override
  String get clearAllDataSub => 'बायोमेट्रिक आवश्यक';

  @override
  String get clearConfirmTitle => 'सभी डेटा साफ़ करें?';

  @override
  String get clearConfirmSub =>
      'यह सभी लेनदेन स्थायी रूप से हटा देगा और बजट रीसेट करेगा।';

  @override
  String get clearSuccess => 'सभी डेटा साफ़ हो गया';

  @override
  String get security => 'सुरक्षा';

  @override
  String get appearance => 'दिखावट';

  @override
  String get data => 'डेटा';

  @override
  String get retry => 'पुनः प्रयास';

  @override
  String get error => 'कुछ गलत हो गया';

  @override
  String get cameraPermissionRequired => 'कैमरा अनुमति आवश्यक है';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get alignReceipt => 'रसीद फ्रेम के अंदर रखें';

  @override
  String get navHome => 'होम';

  @override
  String get navTxns => 'लेनदेन';

  @override
  String get navAddTransaction => 'जोड़ें';

  @override
  String get navBudget => 'बजट';

  @override
  String get navMore => 'अधिक';

  @override
  String get navExport => 'निर्यात';

  @override
  String get budgetViewOnlyPast => 'पिछले महीने केवल देखने के लिए हैं';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get addFirstTransaction => 'लेनदेन जोड़ें';

  @override
  String get addFirstTransactionSub => 'नीचे + दबाएं';

  @override
  String get setBudget => 'बजट सेट करें';

  @override
  String get setBudgetSub => 'बजट स्क्रीन';

  @override
  String get scanReceipt => 'रसीद स्कैन करें';

  @override
  String get scanReceiptSub => 'कैमरा तैयार है';

  @override
  String get spendingChart => 'खर्च चार्ट';

  @override
  String get noData => 'अभी कोई डेटा नहीं';

  @override
  String get recurringThisMonth => 'इस माह आवर्ती';

  @override
  String get splashTagline =>
      'अपने खर्च को ऑफलाइन ट्रैक करें—निजी, आसान, हमेशा आपकी जेब में।';

  @override
  String get validationAmountRequired => 'राशि दर्ज करें';

  @override
  String get validationAmountInvalid => 'मान्य संख्या दर्ज करें';

  @override
  String get transactionsSaved => 'सहेजा गया';

  @override
  String get transactionsSalaryMissing =>
      'सैलरी श्रेणी उपलब्ध नहीं। ऐप अपडेट करके देखें।';

  @override
  String get transactionsStepAmount => 'राशि';

  @override
  String get transactionsStepCategory => 'श्रेणी';

  @override
  String get fieldDate => 'तारीख';

  @override
  String get fieldRecurring => 'आवर्ती';

  @override
  String get fieldType => 'प्रकार';

  @override
  String get transactionsListFallbackTitle => 'लेनदेन';

  @override
  String get transactionsEmptyTitle => 'अभी कोई लेनदेन नहीं';

  @override
  String get transactionsEmptySubtitle => '+ दबाएं पहला जोड़ने के लिए';

  @override
  String get transactionsHelpTitle => 'लेनदेन समझें';

  @override
  String get transactionsHelpSpendingTitle => 'खर्च';

  @override
  String get transactionsHelpSpendingBody =>
      'खर्च वह धन है जो बाहर जाता है—खरीदारी, बिल और रोज़मर्रा के खर्च। हर प्रविष्टि कुल में ऋणात्मक होती है और बजट व श्रेणी विभाजन में गिनी जाती है।';

  @override
  String get transactionsHelpIncomeTitle => 'आय और सैलरी';

  @override
  String get transactionsHelpIncomeBody =>
      'आय अंदर आने वाला धन है (जैसे सैलरी)। सैलरी श्रेणी नियमित वेतन के लिए है ताकि एक बार की आय से अलग रख सकें। आय धनात्मक दिखती है और \"खर्च\" नहीं मानी जाती।';

  @override
  String get transactionsHelpRecurringTitle => 'आवर्ती';

  @override
  String get transactionsHelpRecurringBody =>
      'आवर्ती लेनदेन आपकी चुनी अवधि (दैनिक, साप्ताहिक या मासिक) पर दोहराता है। ऐप अनुस्मारक या भविष्य की प्रविष्टियाँ बना सकता है। बंद करने पर यह एक बार का लेनदेन बन जाता है।';

  @override
  String get transactionNotFound => 'लेनदेन नहीं मिला';

  @override
  String get transactionDetailTitle => 'लेनदेन विवरण';

  @override
  String get transactionDetailType => 'प्रकार';

  @override
  String get transactionDetailAmount => 'राशि';

  @override
  String get transactionDetailCategory => 'श्रेणी';

  @override
  String get transactionDetailDate => 'तारीख';

  @override
  String get transactionDetailRecurring => 'आवर्ती';

  @override
  String get transactionDetailYes => 'हाँ';

  @override
  String get transactionDetailNo => 'नहीं';

  @override
  String get transactionDetailNote => 'नोट';

  @override
  String get transactionDetailReceiptAttached => 'रसीद संलग्न';

  @override
  String get transactionDetailViewReceipt => 'रसीद';

  @override
  String get viewReceipt => 'रसीद देखें';

  @override
  String get transactionsRetry => 'पुनः प्रयास';

  @override
  String get profileSection => 'प्रोफ़ाइल';

  @override
  String get yourName => 'आपका नाम';

  @override
  String get nameNotSetHint => 'अभी सेट नहीं';

  @override
  String get displayNameHint => 'हम आपको क्या बुलाएँ?';

  @override
  String get exportDataSubtitle => 'CSV / JSON / QR';

  @override
  String get backupRestoreSubtitle => 'JSON आयात';

  @override
  String get dashboardAlertCriticalBody => 'बजट लगभग समाप्त। राशियाँ देखें।';

  @override
  String get dashboardAlertWarningBody => 'आप बजट सीमा के करीब हैं।';

  @override
  String get dashboardAlertRemaining => 'शेष';

  @override
  String get dashboardAlertOver => 'बजट से अधिक';

  @override
  String get dashboardAlertUsed => 'उपयोग';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get placeholderSubtitle => 'यह बाद के चरण में आएगा।';

  @override
  String get categoryFood => 'भोजन';

  @override
  String get categoryTransport => 'परिवहन';

  @override
  String get categoryShopping => 'खरीदारी';

  @override
  String get categoryBills => 'बिल';

  @override
  String get categoryHealth => 'स्वास्थ्य';

  @override
  String get categoryEntertainment => 'मनोरंजन';

  @override
  String get categorySalary => 'वेतन';

  @override
  String get categoryOther => 'अन्य';
}
