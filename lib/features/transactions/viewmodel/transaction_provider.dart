import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/utils/currency_formatter.dart';

import '../model/category_model.dart';
import '../model/recurring_transaction_model.dart';
import '../model/transaction_model.dart';
import '../repository/category_repository_impl.dart';
import '../repository/transaction_repository_impl.dart';
import 'transaction_notifier.dart';
import 'transaction_state.dart';

final transactionNotifierProvider =
    NotifierProvider<TransactionNotifier, TransactionState>(
  TransactionNotifier.new,
);

final categoriesProvider = StreamProvider<List<CategoryModel>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchAll();
});

final transactionByIdProvider =
    FutureProvider.family<TransactionModel?, int>((ref, id) async {
  return ref.watch(transactionRepositoryProvider).getById(id);
});

class TransactionWizardState {
  const TransactionWizardState({
    this.step = 0,
    this.amountRaw = '',
    this.isExpense = true,
    this.categoryId,
    required this.date,
    this.recurring,
    this.receiptPath,
    this.note = '',
    this.editingId,
    this.baseline,
  });

  final int step;
  final String amountRaw;
  final bool isExpense;
  final int? categoryId;
  final DateTime date;
  final FrequencyType? recurring;
  final String? receiptPath;
  final String note;
  final int? editingId;
  final TransactionModel? baseline;

  factory TransactionWizardState.initial() =>
      TransactionWizardState(date: DateTime.now());

  factory TransactionWizardState.fromModel(TransactionModel m) {
    return TransactionWizardState(
      amountRaw: _stripTrailingDot(m.amount.abs().toString()),
      isExpense: m.amount < 0,
      categoryId: m.categoryId,
      date: m.date,
      recurring: m.isRecurring ? FrequencyType.monthly : null,
      receiptPath: m.receiptPath,
      note: m.note ?? '',
      editingId: m.id,
      baseline: m,
    );
  }

  static String _stripTrailingDot(String s) {
    if (s.endsWith('.0')) return s.substring(0, s.length - 2);
    return s;
  }

  TransactionWizardState copyWith({
    int? step,
    String? amountRaw,
    bool? isExpense,
    int? categoryId,
    DateTime? date,
    FrequencyType? recurring,
    bool clearRecurring = false,
    String? receiptPath,
    bool clearReceipt = false,
    String? note,
    int? editingId,
    bool clearEditing = false,
    TransactionModel? baseline,
  }) {
    return TransactionWizardState(
      step: step ?? this.step,
      amountRaw: amountRaw ?? this.amountRaw,
      isExpense: isExpense ?? this.isExpense,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      recurring: clearRecurring ? null : (recurring ?? this.recurring),
      receiptPath: clearReceipt ? null : (receiptPath ?? this.receiptPath),
      note: note ?? this.note,
      editingId: clearEditing ? null : (editingId ?? this.editingId),
      baseline: baseline ?? this.baseline,
    );
  }
}

class TransactionWizardNotifier extends Notifier<TransactionWizardState> {
  @override
  TransactionWizardState build() => TransactionWizardState.initial();

  void reset() => state = TransactionWizardState.initial();

  void load(TransactionModel m) => state = TransactionWizardState.fromModel(m);

  void setStep(int step) => state = state.copyWith(step: step);

  void setAmountRaw(String raw) =>
      state = state.copyWith(amountRaw: CurrencyFormatter.formatInput(raw));

  void appendDigit(String d) {
    final next = state.amountRaw + d;
    state = state.copyWith(amountRaw: CurrencyFormatter.formatInput(next));
  }

  void appendDot() {
    if (state.amountRaw.contains('.')) return;
    state = state.copyWith(amountRaw: '${state.amountRaw}.');
  }

  void deleteDigit() {
    if (state.amountRaw.isEmpty) return;
    state = state.copyWith(
      amountRaw: state.amountRaw.substring(0, state.amountRaw.length - 1),
    );
  }

  void toggleExpense(bool v) => state = state.copyWith(isExpense: v);

  void selectCategory(int id) => state = state.copyWith(categoryId: id);

  void setDate(DateTime d) => state = state.copyWith(date: d);

  void setRecurring(FrequencyType? f) => f == null
      ? state = state.copyWith(clearRecurring: true)
      : state = state.copyWith(recurring: f);

  void setReceiptPath(String? path) => path == null
      ? state = state.copyWith(clearReceipt: true)
      : state = state.copyWith(receiptPath: path);

  void setNote(String n) => state = state.copyWith(note: n);
}

final transactionWizardProvider =
    NotifierProvider<TransactionWizardNotifier, TransactionWizardState>(
  TransactionWizardNotifier.new,
);

class AddTransactionSheetState {
  const AddTransactionSheetState({
    this.currentStep = 0,
    this.amountString = '',
    this.isExpense = true,
    this.selectedCategoryId,
    required this.selectedDate,
    this.recurringFrequency = 'none',
    this.receiptPath,
    this.note = '',
  });

  final int currentStep;
  final String amountString;
  final bool isExpense;
  final int? selectedCategoryId;
  final DateTime selectedDate;
  final String recurringFrequency;
  final String? receiptPath;
  final String note;

  double get parsedAmount => double.tryParse(amountString) ?? 0.0;

  AddTransactionSheetState copyWith({
    int? currentStep,
    String? amountString,
    bool? isExpense,
    int? selectedCategoryId,
    bool clearSelectedCategory = false,
    DateTime? selectedDate,
    String? recurringFrequency,
    String? receiptPath,
    bool clearReceipt = false,
    String? note,
  }) {
    return AddTransactionSheetState(
      currentStep: currentStep ?? this.currentStep,
      amountString: amountString ?? this.amountString,
      isExpense: isExpense ?? this.isExpense,
      selectedCategoryId: clearSelectedCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      selectedDate: selectedDate ?? this.selectedDate,
      recurringFrequency: recurringFrequency ?? this.recurringFrequency,
      receiptPath: clearReceipt ? null : (receiptPath ?? this.receiptPath),
      note: note ?? this.note,
    );
  }
}

class AddTransactionWizardNotifier extends Notifier<AddTransactionSheetState> {
  static int lastStepIndex(bool isExpense) => isExpense ? 4 : 3;

  static int stepCount(bool isExpense) => isExpense ? 5 : 4;

  @override
  AddTransactionSheetState build() =>
      AddTransactionSheetState(selectedDate: DateTime.now());

  void reset() =>
      state = AddTransactionSheetState(selectedDate: DateTime.now());

  static int? _salaryCategoryId(List<CategoryModel>? categories) {
    if (categories == null) return null;
    for (final c in categories) {
      if (c.name == 'Salary') return c.id;
    }
    return null;
  }

  /// Advances from the amount step. Returns false if income flow cannot resolve
  /// a Salary category.
  bool advanceFromAmount({required List<CategoryModel>? categories}) {
    final w = state;
    if (w.parsedAmount <= 0) return false;
    if (w.isExpense) {
      state = w.copyWith(currentStep: 1);
      return true;
    }
    final sid = _salaryCategoryId(categories);
    if (sid == null) return false;
    state = w.copyWith(selectedCategoryId: sid, currentStep: 1);
    return true;
  }

  void advanceStep() {
    final w = state;
    final last = lastStepIndex(w.isExpense);
    if (w.currentStep >= last) return;
    state = w.copyWith(currentStep: w.currentStep + 1);
  }

  void prevStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void appendDigit(String d) {
    var s = state.amountString;
    final parts = s.split('.');
    if (!s.contains('.')) {
      if (parts[0].length >= 10) return;
    } else if (parts.length == 2 && parts[1].length >= 2) {
      return;
    }
    if (s == '0' && d != '.') {
      s = d;
    } else {
      s += d;
    }
    state = state.copyWith(amountString: s);
  }

  void appendDot() {
    if (state.amountString.contains('.')) return;
    final s = state.amountString.isEmpty ? '0' : state.amountString;
    state = state.copyWith(amountString: '$s.');
  }

  void backspace() {
    final s = state.amountString;
    if (s.isEmpty) return;
    state = state.copyWith(amountString: s.substring(0, s.length - 1));
  }

  void setExpense(bool v) {
    if (v == state.isExpense) return;
    state = state.copyWith(
      isExpense: v,
      clearSelectedCategory: true,
      currentStep: 0,
    );
  }

  void selectCategory(int id) =>
      state = state.copyWith(selectedCategoryId: id);

  void setDate(DateTime d) => state = state.copyWith(selectedDate: d);

  void setRecurringFrequency(String f) =>
      state = state.copyWith(recurringFrequency: f);

  void setReceiptPath(String? p) {
    state = p == null
        ? state.copyWith(clearReceipt: true)
        : state.copyWith(receiptPath: p);
  }

  void setNote(String n) => state = state.copyWith(note: n);
}

final addTransactionWizardProvider =
    NotifierProvider<AddTransactionWizardNotifier, AddTransactionSheetState>(
  AddTransactionWizardNotifier.new,
);
