import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/core/widgets/category_icon.dart';
import 'package:fintrack/core/utils/category_localizations.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/features/dashboard/view/widgets/budget_progress_bar.dart';
import 'package:fintrack/features/transactions/model/category_model.dart';

import '../../model/budget_model.dart';
import 'edit_budget_sheet.dart';

class BudgetCategoryTile extends StatelessWidget {
  const BudgetCategoryTile({
    super.key,
    required this.budget,
    required this.category,
    required this.canEdit,
  });

  final BudgetModel budget;
  final CategoryModel category;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final title = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final scaffold = dark ? AppColors.scaffoldDark : AppColors.scaffoldLight;
    final pctValue = (budget.usedPercent * 100).round();
    Color pctColor;
    if (budget.usedPercent < 0.60) {
      pctColor = dark ? AppColors.income : AppColors.incomeLight;
    } else if (budget.usedPercent <= 0.85) {
      pctColor = dark ? AppColors.accentDark : AppColors.accentLight;
    } else {
      pctColor = dark ? AppColors.expense : AppColors.expenseLight;
    }
    if (budget.isOverBudget) {
      pctColor = dark ? AppColors.expense : AppColors.expenseLight;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: scaffold.withValues(alpha: 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: canEdit
              ? () {
                  EditBudgetSheet.show(
                    context,
                    budget: budget,
                    category: category,
                    canEdit: canEdit,
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: category.color,
                        shape: BoxShape.circle,
                      ),
                      child: CategoryIcon(
                        category: category,
                        size: 14,
                        iconColor: AppColors.onVivid,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        localizedCategoryName(l10n, category.name),
                        style: TextStyle(
                          color: title,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      '$pctValue%',
                      style: TextStyle(
                        color: pctColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                BudgetProgressBar(budget.usedPercent, height: 4),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${CurrencyFormatter.format(budget.spentAmount)} / ${CurrencyFormatter.format(budget.limitAmount)}',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                    ),
                    if (budget.isCritical && !budget.isOverBudget)
                      Text(
                        l10n.almostFull,
                        style: TextStyle(
                          color: dark ? AppColors.expense : AppColors.expenseLight,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
                if (budget.isOverBudget)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        l10n.overBudget,
                        style: TextStyle(
                          color: dark ? AppColors.expense : AppColors.expenseLight,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
