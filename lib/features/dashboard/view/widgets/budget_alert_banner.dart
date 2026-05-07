import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';

import '../../model/dashboard_summary_model.dart';

class BudgetAlertBanner extends StatelessWidget {
  const BudgetAlertBanner({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    if (!summary.isOverWarning) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final left = summary.budgetLimit - summary.totalSpent;
    final pct = (summary.budgetUsedPercent * 100).round();
    final leftStr = CurrencyFormatter.format(left.abs());

    if (summary.isCritical) {
      final bg = AppColors.expense.withValues(alpha: dark ? 0.22 : 0.12);
      final body = left >= 0
          ? '$pct% ${l10n.dashboardAlertUsed}. $leftStr ${l10n.dashboardAlertRemaining}. ${l10n.dashboardAlertCriticalBody}'
          : '$pct% ${l10n.dashboardAlertUsed}. $leftStr ${l10n.dashboardAlertOver}. ${l10n.dashboardAlertCriticalBody}';
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: dark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor:
                  AppColors.error.withValues(alpha: dark ? 0.35 : 0.2),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.error,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                body,
                style: TextStyle(
                  color: dark ? AppColors.expense : AppColors.expenseLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final amber = AppColors.warning;
    final bg = amber.withValues(alpha: dark ? 0.18 : 0.12);
    final body = left >= 0
        ? '$pct% ${l10n.dashboardAlertUsed}. $leftStr ${l10n.dashboardAlertRemaining}. ${l10n.dashboardAlertWarningBody}'
        : '$pct% ${l10n.dashboardAlertUsed}. $leftStr ${l10n.dashboardAlertOver}. ${l10n.dashboardAlertWarningBody}';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: dark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: amber.withValues(alpha: 0.25),
            child: Icon(Icons.notifications_outlined, color: amber, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              body,
              style: TextStyle(
                color: amber,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
