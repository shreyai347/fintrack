import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/core/utils/category_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(bottom: BorderSide(color: divider, width: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6, right: 10),
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(label, style: TextStyle(fontSize: 14, color: muted)),
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '${cat == null ? '—' : localizedCategoryName(l10n, cat.name)} · ${DateFormatter.formatDisplay(w.selectedDate)}',
                style: TextStyle(fontSize: 13, color: hint),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: input,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: 0.5),
            ),
            child: Column(
              children: [
                recapRow(
                  l10n.transactionsStepAmount,
                  Text(
                    CurrencyFormatter.format(w.parsedAmount),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                ),
                recapRow(
                  l10n.fieldType,
                  Text(
                    w.isExpense
                        ? l10n.expense
                        : l10n.income,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: w.isExpense
                          ? (dark ? AppColors.expense : AppColors.expenseLight)
                          : (dark ? AppColors.income : AppColors.incomeLight),
                    ),
                  ),
                ),
                recapRow(
                  l10n.transactionsStepCategory,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (cat != null) ...[
                        CategoryIcon(
                            category: cat, size: 20, iconColor: primary),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        cat == null ? '—' : localizedCategoryName(l10n, cat.name),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),
                recapRow(
                  l10n.fieldDate,
                  Text(
                    DateFormatter.formatDisplay(w.selectedDate),
                    style: TextStyle(
                      fontSize: 15,
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
          Text(l10n.noteOptional, style: TextStyle(fontSize: 14, color: hint)),
          const SizedBox(height: 8),
          TextField(
            controller: noteController,
            onChanged: notifier.setNote,
            maxLines: 3,
            maxLength: 200,
            style: TextStyle(fontSize: 16, color: primary),
            decoration: InputDecoration(
              filled: true,
              fillColor: input,
              counterText: '',
              hintText: l10n.notePlaceholder,
              hintStyle: TextStyle(color: hint, fontSize: 15),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: border, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: border, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: accent, width: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
