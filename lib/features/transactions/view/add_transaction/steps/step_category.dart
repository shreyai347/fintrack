import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/core/utils/category_localizations.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/widgets/category_icon.dart';

import '../../../viewmodel/transaction_provider.dart';
import '../add_transaction_utils.dart';
import '../step_scroll.dart';

class AddTransactionStepCategory extends ConsumerWidget {
  const AddTransactionStepCategory({super.key, required this.dark});

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
    final amtCol = w.isExpense
        ? (dark ? AppColors.expense : AppColors.expenseLight)
        : (dark ? AppColors.income : AppColors.incomeLight);
    final cats = ref.watch(categoriesProvider);

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
                w.isExpense
                    ? l10n.expense
                    : l10n.income,
                style: TextStyle(fontSize: 13, color: amtCol),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(l10n.category, style: TextStyle(fontSize: 13, color: hint)),
          const SizedBox(height: 12),
          cats.when(
            data: (list) => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: list
                  .where(excludeSalaryCategory)
                  .map((c) {
                final sel = w.selectedCategoryId == c.id;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => notifier.selectCategory(c.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 14),
                      decoration: BoxDecoration(
                        color: sel
                            ? accent.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: sel ? accent : border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CategoryIcon(
                            category: c,
                            size: 24,
                            iconColor: sel ? accent : muted,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            localizedCategoryName(l10n, c.name),
                            style: TextStyle(
                              color: sel ? accent : muted,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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
}
