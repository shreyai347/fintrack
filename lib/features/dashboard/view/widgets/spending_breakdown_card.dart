import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/widgets/category_icon.dart';

import '../../../transactions/model/category_model.dart';
import '../../model/dashboard_summary_model.dart';
import 'budget_progress_bar.dart';

class SpendingBreakdownCard extends StatelessWidget {
  const SpendingBreakdownCard({
    super.key,
    required this.summary,
    required this.categories,
  });

  final DashboardSummary summary;
  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final card = dark ? AppColors.cardDark : AppColors.cardLight;
    final titleC = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;

    CategoryModel? cat(int id) {
      for (final c in categories) {
        if (c.id == id) return c;
      }
      return null;
    }

    final entries = summary.spentByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = entries.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.dashboardByCategory,
            style: TextStyle(
              color: titleC,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          ...top.map((e) {
            final c = cat(e.key);
            final budget = summary.budgetByCategory[e.key] ?? 1;
            final raw = budget > 0 ? e.value / budget : 0.0;
            final pctDisplay = (raw * 100).round();
            Color pctColor;
            if (raw < 0.60) {
              pctColor = dark ? AppColors.income : AppColors.incomeLight;
            } else if (raw <= 0.85) {
              pctColor = dark ? AppColors.accentDark : AppColors.accentLight;
            } else {
              pctColor = dark ? AppColors.expense : AppColors.expenseLight;
            }
            final almost = raw >= 0.85;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: c?.color ?? muted,
                          shape: BoxShape.circle,
                        ),
                        child: c != null
                            ? CategoryIcon(
                                category: c,
                                size: 14,
                                iconColor: AppColors.onVivid,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          c?.name ?? '—',
                          style: TextStyle(color: titleC, fontSize: 14),
                        ),
                      ),
                      Text(
                        '$pctDisplay%',
                        style: TextStyle(
                          color: pctColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  BudgetProgressBar(raw, height: 4),
                  if (almost)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        AppStrings.almostFull,
                        style: TextStyle(
                          color: dark ? AppColors.expense : AppColors.expenseLight,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
