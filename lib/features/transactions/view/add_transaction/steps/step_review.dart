import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/utils/date_formatter.dart';
import 'package:fintrack/core/widgets/category_icon.dart';

import '../../../viewmodel/transaction_provider.dart';
import '../add_transaction_utils.dart';
import '../step_scroll.dart';

class AddTransactionStepReview extends ConsumerWidget {
  const AddTransactionStepReview({
    super.key,
    required this.dark,
    required this.noteController,
  });

  final bool dark;
  final TextEditingController noteController;

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
    final divider =
        dark ? AppColors.dividerDark : AppColors.dividerLight;
    final input = dark ? AppColors.inputDark : AppColors.inputLight;
    final muted =
        dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final cats = ref.watch(categoriesProvider);
    final cat = cats.when(
      data: (l) => categoryById(l, w.selectedCategoryId),
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
                        CategoryIcon(
                            category: cat, size: 12, iconColor: primary),
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
            controller: noteController,
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
