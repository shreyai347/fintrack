import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/config/app_routes.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/utils/date_formatter.dart';
import 'package:fintrack/core/widgets/category_icon.dart';
import 'package:fintrack/generated/database/app_database.dart';

import '../model/category_model.dart';
import '../model/recurring_transaction_model.dart';
import '../repository/transaction_repository_impl.dart';
import '../viewmodel/transaction_provider.dart';

Future<void> showAddTransactionSheet(BuildContext context, WidgetRef ref) async {
  ref.read(addTransactionWizardProvider.notifier).reset();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final h = MediaQuery.sizeOf(ctx).height;
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          height: h * 0.95,
          decoration: BoxDecoration(
            color: Theme.of(ctx).scaffoldBackgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: const AddTransactionSheet(),
        ),
      );
    },
  );
}

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showAddTransactionSheet(context, ref);
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  late final PageController _pageController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AddTransactionSheetState>(
      addTransactionWizardProvider,
      (prev, next) {
        if (prev?.currentStep != next.currentStep) {
          _pageController.animateToPage(
            next.currentStep,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (next.currentStep == 4 &&
            (_noteController.text != next.note ||
                (prev?.currentStep != 4 && next.currentStep == 4))) {
          _noteController.value = TextEditingValue(
            text: next.note,
            selection: TextSelection.collapsed(offset: next.note.length),
          );
        }
      },
    );

    final w = ref.watch(addTransactionWizardProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHandle(dark),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStepHeader(context, w.currentStep, dark),
              const SizedBox(height: 10),
              _buildStepPills(w.currentStep, dark),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStep1(context, w, dark),
              _buildStep2(context, w, dark),
              _buildStep3(context, w, dark),
              _buildStep4(context, w, dark),
              _buildStep5(context, w, dark),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            MediaQuery.viewInsetsOf(context).bottom + 16,
          ),
          child: _buildBottomActions(context, w, dark),
        ),
      ],
    );
  }

  bool _excludeSalaryCategory(CategoryModel c) => c.name != 'Salary';

  Widget _wrapStep(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                child,
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    AddTransactionSheetState w,
    bool dark,
  ) {
    final notifier = ref.read(addTransactionWizardProvider.notifier);
    final accent = dark ? AppColors.accentDark : AppColors.accentLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final step = w.currentStep;

    final bool nextEnabled;
    final String nextLabel;
    final VoidCallback? onPrimary;
    if (step == 0) {
      nextEnabled = w.parsedAmount > 0;
      nextLabel = 'Next →';
      onPrimary = nextEnabled ? notifier.nextStep : null;
    } else if (step == 1) {
      nextEnabled = w.selectedCategoryId != null;
      nextLabel = 'Next →';
      onPrimary = nextEnabled ? notifier.nextStep : null;
    } else if (step == 2 || step == 3) {
      nextEnabled = true;
      nextLabel = 'Next →';
      onPrimary = notifier.nextStep;
    } else if (step == 4) {
      nextEnabled = true;
      nextLabel = 'Save ✓';
      onPrimary = () => _persistTransaction(context);
    } else {
      nextEnabled = false;
      nextLabel = 'Next →';
      onPrimary = null;
    }

    Widget primaryButton() {
      return Material(
        color: nextEnabled
            ? accent
            : (dark ? AppColors.inputDark : AppColors.inputLight),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPrimary,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text(
              nextLabel,
              style: TextStyle(
                color: nextEnabled ? AppColors.onVivid : muted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    if (step == 0) {
      return primaryButton();
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: muted,
              side: BorderSide(color: border),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: notifier.prevStep,
            child: const Text('← Back'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(flex: 2, child: primaryButton()),
      ],
    );
  }

  Future<void> _persistTransaction(BuildContext context) async {
    final w = ref.read(addTransactionWizardProvider);
    final double parsed = w.parsedAmount;
    if (parsed <= 0 || w.selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.validationAmountRequired)),
      );
      return;
    }
    final double amountForDb = w.isExpense
        ? -parsed.toDouble().abs()
        : parsed.toDouble().abs();
    final FrequencyType? recurring = switch (w.recurringFrequency) {
      'daily' => FrequencyType.daily,
      'weekly' => FrequencyType.weekly,
      'monthly' => FrequencyType.monthly,
      _ => null,
    };
    final repo = ref.read(transactionRepositoryProvider);
    try {
      int? ruleId;
      if (recurring != null) {
        ruleId = await repo.addRecurringRule(
          RecurringRulesCompanion.insert(
            frequency: recurring.name,
            nextDueDate: w.selectedDate,
            isActive: const Value(true),
          ),
        );
      }
      final companion = TransactionsCompanion.insert(
        amount: amountForDb,
        categoryId: w.selectedCategoryId!,
        note: Value(_noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim()),
        date: w.selectedDate,
        receiptPath: Value(w.receiptPath),
        isRecurring: Value(recurring != null),
        recurringRuleId: Value<int?>(ruleId),
      );
      await ref.read(transactionNotifierProvider.notifier).addTransaction(
            companion,
          );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.transactionsSaved)),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }

  Widget _buildHandle(bool dark) {
    return Center(
      child: Container(
        width: 32,
        height: 3,
        margin: const EdgeInsets.only(top: 10, bottom: 14),
        decoration: BoxDecoration(
          color: dark ? AppColors.borderDark : AppColors.borderLight,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context, int step, bool dark) {
    final primary =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hint = dark ? AppColors.textHintDark : AppColors.textHintLight;
    return Row(
      children: [
        Text(
          'New transaction',
          style: TextStyle(
            color: primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          '${step + 1} / 5',
          style: TextStyle(color: hint, fontSize: 8),
        ),
      ],
    );
  }

  Widget _buildStepPills(int currentStep, bool dark) {
    final accent = dark ? AppColors.accentDark : AppColors.accentLight;
    final inactive =
        dark ? AppColors.borderDark : AppColors.borderLight;
    return Row(
      children: List.generate(5, (i) {
        final active = i <= currentStep;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 4 ? 4 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              decoration: BoxDecoration(
                color: active ? accent : inactive,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStep1(
    BuildContext context,
    AddTransactionSheetState w,
    bool dark,
  ) {
    final notifier = ref.read(addTransactionWizardProvider.notifier);
    final accent = dark ? AppColors.accentDark : AppColors.accentLight;
    final primary =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hint = dark ? AppColors.textHintDark : AppColors.textHintLight;
    final input = dark ? AppColors.inputDark : AppColors.inputLight;
    final border =

        dark ? AppColors.borderDark : AppColors.borderLight;
    final muted =
        dark ? AppColors.textMutedDark : AppColors.textMutedLight;

    Color expSelFg() => dark ? AppColors.expense : AppColors.expenseLight;
    Color incSelFg() => dark ? AppColors.income : AppColors.incomeLight;

    Widget typeChip({
      required String label,
      required bool selected,
      required bool expense,
      required VoidCallback onTap,
    }) {
      final selC = expense ? expSelFg() : incSelFg();
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
            decoration: BoxDecoration(
              color: selected
                  ? selC.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? selC : border,
                width: 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? selC : muted,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    Widget numKey(String ch, VoidCallback onTap, {Color? fg}) {
      return Material(
        color: input,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border, width: 0.5),
            ),
            child: Text(
              ch,
              style: TextStyle(
                color: fg ?? primary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return _wrapStep(
      Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            typeChip(
              label: AppStrings.transactionsAmountExpense,
              selected: w.isExpense,
              expense: true,
              onTap: () => notifier.setExpense(true),
            ),
            const SizedBox(width: 10),
            typeChip(
              label: AppStrings.transactionsAmountIncome,
              selected: !w.isExpense,
              expense: false,
              onTap: () => notifier.setExpense(false),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('₹', style: TextStyle(fontSize: 18, color: hint)),
            const SizedBox(width: 6),
            Text(
              _displayAmountPretty(w.amountString),
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            'tap to edit',
            style: TextStyle(fontSize: 8, color: accent),
          ),
        ),
        const SizedBox(height: 14),
        Column(
          children: [
            Row(
              children: [
                Expanded(child: numKey('1', () => notifier.appendDigit('1'))),
                const SizedBox(width: 6),
                Expanded(child: numKey('2', () => notifier.appendDigit('2'))),
                const SizedBox(width: 6),
                Expanded(child: numKey('3', () => notifier.appendDigit('3'))),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(child: numKey('4', () => notifier.appendDigit('4'))),
                const SizedBox(width: 6),
                Expanded(child: numKey('5', () => notifier.appendDigit('5'))),
                const SizedBox(width: 6),
                Expanded(child: numKey('6', () => notifier.appendDigit('6'))),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(child: numKey('7', () => notifier.appendDigit('7'))),
                const SizedBox(width: 6),
                Expanded(child: numKey('8', () => notifier.appendDigit('8'))),
                const SizedBox(width: 6),
                Expanded(child: numKey('9', () => notifier.appendDigit('9'))),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(child: numKey('.', notifier.appendDot)),
                const SizedBox(width: 6),
                Expanded(
                    child: numKey('0', () => notifier.appendDigit('0'))),
                const SizedBox(width: 6),
                Expanded(
                  child: numKey(
                    '⌫',
                    notifier.backspace,
                    fg: accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    );
  }

  String _displayAmountPretty(String raw) {
    if (raw.isEmpty) return '0';
    return raw;
  }

  Widget _buildStep2(
    BuildContext context,
    AddTransactionSheetState w,
    bool dark,
  ) {
    final notifier = ref.read(addTransactionWizardProvider.notifier);
    final primary =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hint = dark ? AppColors.textHintDark : AppColors.textHintLight;
    final accent = dark ? AppColors.accentDark : AppColors.accentLight;
    final border =
        dark ? AppColors.borderDark : AppColors.borderLight;
    final muted =
        dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final amtCol =
        w.isExpense ? (dark ? AppColors.expense : AppColors.expenseLight) : (dark ? AppColors.income : AppColors.incomeLight);
    final cats = ref.watch(categoriesProvider);

    return _wrapStep(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Column(
          children: [
            Text(
              CurrencyFormatter.format(w.parsedAmount),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              w.isExpense
                  ? AppStrings.transactionsAmountExpense
                  : AppStrings.transactionsAmountIncome,
              style: TextStyle(fontSize: 8, color: amtCol),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Category', style: TextStyle(fontSize: 8, color: hint)),
        const SizedBox(height: 8),
        cats.when(
          data: (list) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: list
                .where(_excludeSalaryCategory)
                .map((c) {
              final sel = w.selectedCategoryId == c.id;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => notifier.selectCategory(c.id),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: sel
                          ? accent.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel ? accent : border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CategoryIcon(
                          category: c,
                          size: 16,
                          iconColor: sel ? accent : muted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          c.name,
                          style: TextStyle(
                            color: sel ? accent : muted,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e', style: TextStyle(color: primary)),
        ),
      ],
      ),
    );
  }

  CategoryModel? _catById(List<CategoryModel> list, int? id) {
    if (id == null) return null;
    for (final c in list) {
      if (c.id == id) return c;
    }
    return null;
  }

  Widget _buildStep3(
    BuildContext context,
    AddTransactionSheetState w,
    bool dark,
  ) {
    final notifier = ref.read(addTransactionWizardProvider.notifier);
    final primary =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hint = dark ? AppColors.textHintDark : AppColors.textHintLight;
    final accent = dark ? AppColors.accentDark : AppColors.accentLight;
    final border =
        dark ? AppColors.borderDark : AppColors.borderLight;
    final muted =
        dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final input = dark ? AppColors.inputDark : AppColors.inputLight;
    final amtCol =
        w.isExpense ? (dark ? AppColors.expense : AppColors.expenseLight) : (dark ? AppColors.income : AppColors.incomeLight);
    final cats = ref.watch(categoriesProvider);
    final catName = cats.when(
      data: (l) => _catById(l, w.selectedCategoryId)?.name ?? '—',
      loading: () => '—',
      error: (_, _) => '—',
    );

    Widget freqChip(String value, String label) {
      final sel = w.recurringFrequency == value;
      return Expanded(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => notifier.setRecurringFrequency(value),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    sel ? accent.withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: sel ? accent : border),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8,
                  color: sel ? accent : muted,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return _wrapStep(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Column(
          children: [
            Text(
              CurrencyFormatter.format(w.parsedAmount),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '$catName · ${w.isExpense ? AppStrings.transactionsAmountExpense : AppStrings.transactionsAmountIncome}',
              style: TextStyle(fontSize: 8, color: amtCol),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(AppStrings.fieldDate, style: TextStyle(fontSize: 8, color: hint)),
        const SizedBox(height: 6),
        Material(
          color: input,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: w.selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (ctx, child) {
                  return Theme(
                    data: Theme.of(ctx).copyWith(
                      colorScheme: dark
                          ? ColorScheme.dark(
                              primary: accent,
                              onPrimary: AppColors.onVivid,
                              surface: AppColors.cardDark,
                            )
                          : ColorScheme.light(
                              primary: accent,
                              onPrimary: AppColors.onVivid,
                              surface: AppColors.cardLight,
                            ),
                    ),
                    child: child!,
                  );
                },
              );
              if (d != null) notifier.setDate(d);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 11),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border, width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      DateFormatter.formatDisplay(w.selectedDate),
                      style: TextStyle(color: primary, fontSize: 12),
                    ),
                  ),
                  Text('📅', style: TextStyle(color: accent, fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(AppStrings.fieldRecurring,
            style: TextStyle(fontSize: 8, color: hint)),
        const SizedBox(height: 8),
        Row(
          children: [
            freqChip('none', AppStrings.transactionsRecurringNone),
            const SizedBox(width: 6),
            freqChip('daily', AppStrings.transactionsRecurringDaily),
            const SizedBox(width: 6),
            freqChip('weekly', AppStrings.transactionsRecurringWeekly),
            const SizedBox(width: 6),
            freqChip('monthly', AppStrings.transactionsRecurringMonthly),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: input,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recurring info',
                style: TextStyle(fontSize: 8, color: hint),
              ),
              const SizedBox(height: 4),
              Text(
                'Set to repeat this transaction automatically at the selected frequency.',
                style: TextStyle(fontSize: 8.5, color: muted),
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildStep4(
    BuildContext context,
    AddTransactionSheetState w,
    bool dark,
  ) {
    final notifier = ref.read(addTransactionWizardProvider.notifier);
    final primary =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hint = dark ? AppColors.textHintDark : AppColors.textHintLight;
    final border =
        dark ? AppColors.borderDark : AppColors.borderLight;
    final cats = ref.watch(categoriesProvider);
    final catName = cats.when(
      data: (l) => _catById(l, w.selectedCategoryId)?.name ?? '—',
      loading: () => '—',
      error: (_, _) => '—',
    );

    return _wrapStep(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Column(
          children: [
            Text(
              CurrencyFormatter.format(w.parsedAmount),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '$catName · ${DateFormatter.formatDisplay(w.selectedDate)}',
              style: TextStyle(fontSize: 8, color: hint),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text('Receipt photo', style: TextStyle(fontSize: 8, color: hint)),
        const SizedBox(height: 8),
        if (w.receiptPath == null)
          _ReceiptTapArea(
            dark: dark,
            onTap: () async {
              final path = await Navigator.of(context).pushNamed<String?>(
                AppRoutes.receiptCamera,
              );
              if (path != null) notifier.setReceiptPath(path);
            },
          )
        else
          _ReceiptAttached(
            path: w.receiptPath!,
            onClear: () => notifier.setReceiptPath(null),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Divider(color: border, thickness: 0.5)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'or skip this step',
                style: TextStyle(fontSize: 8, color: hint),
              ),
            ),
            Expanded(child: Divider(color: border, thickness: 0.5)),
          ],
        ),
      ],
      ),
    );
  }

  Widget _buildStep5(
    BuildContext context,
    AddTransactionSheetState w,
    bool dark,
  ) {
    final notifier = ref.read(addTransactionWizardProvider.notifier);
    final primary =
        dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hint = dark ? AppColors.textHintDark : AppColors.textHintLight;
    final accent = dark ? AppColors.accentDark : AppColors.accentLight;
    final border =
        dark ? AppColors.borderDark : AppColors.borderLight;
    final divider =
        dark ? AppColors.dividerDark : AppColors.dividerLight;
    final input = dark ? AppColors.inputDark : AppColors.inputLight;
    final muted =
        dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final cats = ref.watch(categoriesProvider);
    final cat = cats.when(
      data: (l) => _catById(l, w.selectedCategoryId),
      loading: () => null,
      error: (_, _) => null,
    );

    Widget recapRow(String label, Widget value, {bool last = false}) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(bottom: BorderSide(color: divider, width: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 4, right: 8),
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(label, style: TextStyle(fontSize: 9, color: muted)),
            ),
            value,
          ],
        ),
      );
    }

    return _wrapStep(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Column(
          children: [
            Text(
              CurrencyFormatter.format(w.parsedAmount),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '${cat?.name ?? '—'} · ${DateFormatter.formatDisplay(w.selectedDate)}',
              style: TextStyle(fontSize: 8, color: hint),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: input,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 0.5),
          ),
          child: Column(
            children: [
              recapRow(
                AppStrings.transactionsStepAmount,
                Text(
                  CurrencyFormatter.format(w.parsedAmount),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ),
              recapRow(
                AppStrings.fieldType,
                Text(
                  w.isExpense
                      ? AppStrings.transactionsAmountExpense
                      : AppStrings.transactionsAmountIncome,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: w.isExpense
                        ? (dark ? AppColors.expense : AppColors.expenseLight)
                        : (dark ? AppColors.income : AppColors.incomeLight),
                  ),
                ),
              ),
              recapRow(
                AppStrings.transactionsStepCategory,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (cat != null) ...[
                      CategoryIcon(category: cat, size: 12, iconColor: primary),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      cat?.name ?? '—',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
              recapRow(
                AppStrings.fieldDate,
                Text(
                  DateFormatter.formatDisplay(w.selectedDate),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                last: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text('Note (optional)', style: TextStyle(fontSize: 8, color: hint)),
        const SizedBox(height: 6),
        TextField(
          controller: _noteController,
          onChanged: notifier.setNote,
          maxLines: 2,
          maxLength: 200,
          style: TextStyle(fontSize: 10, color: primary),
          decoration: InputDecoration(
            filled: true,
            fillColor: input,
            counterText: '',
            hintText: 'Add a note...',
            hintStyle: TextStyle(color: hint, fontSize: 10),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: border, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: border, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: accent, width: 0.5),
            ),
          ),
        ),
      ],
      ),
    );
  }
}

class _ReceiptTapArea extends StatelessWidget {
  const _ReceiptTapArea({required this.dark, required this.onTap});

  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final input = dark ? AppColors.inputDark : AppColors.inputLight;
    final border =
        dark ? AppColors.borderDark : AppColors.borderLight;
    final accent = dark ? AppColors.accentDark : AppColors.accentLight;
    final hint = dark ? AppColors.textHintDark : AppColors.textHintLight;

    return CustomPaint(
      painter: _DashedBorderPainter(color: border, radius: 12),
      child: Material(
        color: input,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.camera_alt_outlined, size: 28, color: accent),
                const SizedBox(height: 8),
                Text(
                  'Tap to open camera',
                  style: TextStyle(
                    fontSize: 10,
                    color: accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Optional — scan your receipt',
                  style: TextStyle(fontSize: 8, color: hint),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        const dash = 4.0;
        const gap = 3.0;
        final len = (d + dash > metric.length) ? metric.length - d : dash;
        final e = metric.extractPath(d, d + len);
        canvas.drawPath(e, paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ReceiptAttached extends StatelessWidget {
  const _ReceiptAttached({required this.path, required this.onClear});

  final String path;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: File(path).exists(),
      builder: (context, snap) {
        if (snap.data != true) {
          return Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppStrings.receiptNotFound,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          );
        }
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(path),
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: AppColors.expense,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onClear,
                  child: const SizedBox(
                    width: 16,
                    height: 16,
                    child: Icon(Icons.close, size: 9, color: AppColors.onVivid),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
