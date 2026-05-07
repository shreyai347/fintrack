import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/features/dashboard/view/widgets/budget_progress_bar.dart';

import '../../viewmodel/budget_state.dart';

class OverallBudgetCard extends StatelessWidget {
  const OverallBudgetCard({super.key, required this.loaded});

  final BudgetLoaded loaded;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final card = dark ? AppColors.cardDark : AppColors.cardLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final title = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final p = loaded.overallPercent.clamp(0.0, 1.0);
    Color badgeColor;
    if (p < 0.60) {
      badgeColor = dark ? AppColors.income : AppColors.incomeLight;
    } else if (p <= 0.85) {
      badgeColor = dark ? AppColors.accentDark : AppColors.accentLight;
    } else {
      badgeColor = dark ? AppColors.expense : AppColors.expenseLight;
    }
    if (loaded.overallPercent > 1.0) {
      badgeColor = dark ? AppColors.expense : AppColors.expenseLight;
    }
    final pctLabel =
        '${(loaded.overallPercent * 100).clamp(0, 999).round()}% ${AppStrings.used}';

    final borderSide = loaded.isCritical
        ? Border.all(
            color: (dark ? AppColors.expense : AppColors.expenseLight)
                .withValues(alpha: 0.55),
            width: 1.2,
          )
        : Border.all(color: border, width: 0.5);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: borderSide,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.overallSpent,
                  style: TextStyle(color: muted, fontSize: 13),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pctLabel,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${CurrencyFormatter.format(loaded.totalSpent)} / ${CurrencyFormatter.format(loaded.totalBudget)}',
            style: TextStyle(
              color: title,
              fontWeight: FontWeight.w800,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 14),
          BudgetProgressBar(loaded.overallPercent, height: 5),
        ],
      ),
    );
  }
}
