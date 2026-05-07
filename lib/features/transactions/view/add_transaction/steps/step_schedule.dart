import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/utils/date_formatter.dart';

import '../../../viewmodel/transaction_provider.dart';
import '../add_transaction_utils.dart';
import '../step_scroll.dart';

class AddTransactionStepSchedule extends ConsumerWidget {
  const AddTransactionStepSchedule({super.key, required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = ref.watch(addTransactionWizardProvider);
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
    final amtCol = w.isExpense
        ? (dark ? AppColors.expense : AppColors.expenseLight)
        : (dark ? AppColors.income : AppColors.incomeLight);
    final cats = ref.watch(categoriesProvider);
    final catName = cats.when(
      data: (l) => categoryById(l, w.selectedCategoryId)?.name ?? '—',
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

    return AddTransactionStepScroll(
      child: Column(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 9, horizontal: 11),
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
}
