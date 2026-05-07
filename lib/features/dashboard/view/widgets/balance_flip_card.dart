import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';

import '../../model/dashboard_summary_model.dart';
import 'budget_progress_bar.dart';

class BalanceFlipCard extends StatefulWidget {
  const BalanceFlipCard({
    super.key,
    required this.summary,
    required this.monthLabel,
  });

  final DashboardSummary summary;
  final String monthLabel;

  @override
  State<BalanceFlipCard> createState() => _BalanceFlipCardState();
}

class _BalanceFlipCardState extends State<BalanceFlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _anim = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_c.isCompleted) {
      _c.reverse();
    } else {
      _c.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          final angle = _anim.value * math.pi;
          final isFront = angle < math.pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront ? _front(context) : _back(context),
          );
        },
      ),
    );
  }

  Widget _front(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final card = dark ? AppColors.cardDark : AppColors.cardLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final title = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final budget = CurrencyFormatter.format(widget.summary.budgetLimit);
    final left = widget.summary.budgetLimit - widget.summary.totalSpent;
    final leftColor = left >= 0
        ? (dark ? AppColors.income : AppColors.incomeLight)
        : (dark ? AppColors.expense : AppColors.expenseLight);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.dashboardTotalSpentPrefix} — ${widget.monthLabel}',
            style: TextStyle(color: muted, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Text(
            CurrencyFormatter.format(widget.summary.totalSpent),
            style: TextStyle(
              color: title,
              fontWeight: FontWeight.w800,
              fontSize: 32,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(color: muted, fontSize: 13),
              children: [
                TextSpan(text: '${AppStrings.dashboardBudgetLabel} $budget · '),
                TextSpan(
                  text: CurrencyFormatter.format(left),
                  style: TextStyle(color: leftColor, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ' ${AppStrings.dashboardBudgetLeftSuffix}',
                  style: TextStyle(color: leftColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          BudgetProgressBar(widget.summary.budgetUsedPercent, height: 5),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final card = dark ? AppColors.cardDark : AppColors.cardLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final title = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final tint = (dark ? AppColors.accentDark : AppColors.accentLight)
        .withValues(alpha: 0.15);

    final cur = widget.summary.totalSpent;
    final prev = widget.summary.previousMonthSpent;
    final change = prev <= 0 ? 0.0 : (cur - prev) / prev;
    final spentLess = cur < prev;
    final badgeColor = spentLess
        ? (dark ? AppColors.income : AppColors.incomeLight)
        : (dark ? AppColors.expense : AppColors.expenseLight);
    final arrow = spentLess ? '↓' : '↑';
    final pct = (change.abs() * 100).toStringAsFixed(0);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Color.alphaBlend(tint, card),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.dashboardFlipCompare,
              style: TextStyle(color: muted, fontSize: 13),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.dashboardFlipThisMonth,
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(cur),
                        style: TextStyle(
                          color: title,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.dashboardFlipLastMonth,
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(prev),
                        style: TextStyle(
                          color: title,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$arrow $pct% ${AppStrings.dashboardFlipVsLastMonth}',
                style: TextStyle(
                  color: badgeColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
