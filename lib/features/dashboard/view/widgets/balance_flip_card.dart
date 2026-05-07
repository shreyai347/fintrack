import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fintrack/core/config/app_routes.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 120),
                  child: Text(
                    '${l10n.totalSpent} — ${widget.monthLabel}',
                    style: TextStyle(color: muted, fontSize: 13),
                  ),
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
                      TextSpan(
                          text: '${l10n.budgetLabel} $budget · '),
                      TextSpan(
                        text: CurrencyFormatter.format(left),
                        style: TextStyle(
                            color: leftColor, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: ' ${l10n.budgetLeft}',
                        style: TextStyle(
                            color: leftColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                BudgetProgressBar(widget.summary.budgetUsedPercent, height: 5),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Tooltip(
              message: l10n.addBudget,
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.budget);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          (dark ? AppColors.accentDark : AppColors.accentLight)
                              .withValues(alpha: 0.22),
                          (dark ? AppColors.accentDark : AppColors.accentLight)
                              .withValues(alpha: 0.08),
                        ],
                      ),
                      border: Border.all(
                        color: (dark ? AppColors.accentDark : AppColors.accentLight)
                            .withValues(alpha: 0.4),
                        width: 1,
                      ),
                      boxShadow: dark
                          ? null
                          : [
                              BoxShadow(
                                color: (dark
                                        ? AppColors.accentDark
                                        : AppColors.accentLight)
                                    .withValues(alpha: 0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.savings_outlined,
                            size: 22,
                            color: dark
                                ? AppColors.accentDark
                                : AppColors.accentLight,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.addBudget,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                  color: dark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                              Text(
                                l10n.addBudgetHint,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: muted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              l10n.monthlyComparison,
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
                        l10n.flipThisMonth,
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
                        l10n.flipLastMonth,
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
                '$arrow $pct% ${l10n.flipVsLastMonth}',
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
