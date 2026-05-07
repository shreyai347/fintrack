import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/core/utils/category_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
      data: (list) {
        final raw = categoryById(list, w.selectedCategoryId)?.name;
        if (raw == null) return '—';
        return localizedCategoryName(l10n, raw);
      },
      loading: () => '—',
      error: (_, _) => '—',
    );

    Widget freqChip(String value, String label) {
      final sel = w.recurringFrequency == value;
      return Expanded(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => notifier.setRecurringFrequency(value),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    sel ? accent.withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: sel ? accent : border),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '$catName · ${w.isExpense ? l10n.expense : l10n.income}',
                style: TextStyle(fontSize: 13, color: amtCol),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(l10n.fieldDate, style: TextStyle(fontSize: 13, color: hint)),
          const SizedBox(height: 8),
          Material(
            color: input,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
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
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border, width: 0.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormatter.formatDisplay(w.selectedDate),
                        style: TextStyle(color: primary, fontSize: 17),
                      ),
                    ),
                    Text('📅', style: TextStyle(color: accent, fontSize: 22)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(l10n.fieldRecurring,
              style: TextStyle(fontSize: 13, color: hint)),
          const SizedBox(height: 10),
          Row(
            children: [
              freqChip('none', l10n.recurringNone),
              const SizedBox(width: 8),
              freqChip('daily', l10n.recurringDaily),
              const SizedBox(width: 8),
              freqChip('weekly', l10n.recurringWeekly),
              const SizedBox(width: 8),
              freqChip('monthly', l10n.recurringMonthly),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            decoration: BoxDecoration(
              color: input,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.recurringInfoTitle,
                  style: TextStyle(fontSize: 13, color: hint),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.recurringInfo,
                  style: TextStyle(fontSize: 13, height: 1.35, color: muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
